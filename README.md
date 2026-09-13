# Fase 3 - Terraform

Infrastructure as Code (IaC) project for the FIAP Pos Tech Phase 3 project.

## Objetivo

Provisionar a infraestrutura AWS necessária para o projeto utilizando Terraform.

A infraestrutura será organizada em três camadas principais:

1. Network
2. Data, Messaging and ECR
3. Kubernetes / EKS

## Argo CD

O módulo `modules/argocd` instala o chart oficial `argo-cd` no namespace
`argocd`, após o EKS e seu node group. O chart está fixado em `10.9.0`
(Argo CD `v3.5.2`); altere `argocd_chart_version` para atualizar.
O provider Helm usa o endpoint e o certificado do EKS e obtém tokens pela
AWS CLI, respeitando `aws_region` e `aws_profile`.

### Instalação e atualização

Pré-requisitos: Terraform, AWS CLI e credenciais com acesso ao EKS e permissão
para instalar recursos Kubernetes, incluindo CRDs e RBAC de escopo de cluster.
O executor precisa alcançar o endpoint do EKS.

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

O Terraform aguarda os componentes ficarem prontos, com timeout de 15 minutos
e rollback em caso de falha. A instalação usa o modo padrão sem alta
disponibilidade, adequado ao ambiente de laboratório. O serviço é `ClusterIP`,
com TLS e acesso local por port-forward; não cria Load Balancer público.

### Acesso

Atualize o kubeconfig para evitar usar o endpoint de um cluster antigo:

```bash
aws eks update-kubeconfig --region us-east-1 --name fiap-fase3-dev-cluster
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

Abra https://localhost:8080 e aceite o certificado autoassinado.
Usuário inicial: `admin`. Em outro terminal, consulte a senha inicial:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode
```

Troque a senha após o primeiro login. A senha não é exportada pelo Terraform.
Ajuste nome, região e `--profile` nos comandos conforme o ambiente.

### Verificação e ciclo de vida

```bash
kubectl -n argocd get pods
helm list -n argocd
terraform plan
```

Os repositórios e Applications GitOps são configurados separadamente; a instalação
não inicia sincronizações de aplicações. Gerencie atualizações pelo Terraform
para evitar divergência com o estado. Ao destruir o ambiente, mantenha o EKS
acessível até o Helm remover a instalação. CRDs e namespace podem permanecer
após a desinstalação conforme as políticas do chart/Helm.

Referências: [chart oficial](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
e [provider Helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs).

## NGINX Ingress

O módulo `modules/ingress_nginx` instala o chart comunitário `ingress-nginx`
fixado em `4.15.1`, com duas réplicas e classe `nginx`. A escolha preserva os
Ingress existentes e as annotations `nginx.ingress.kubernetes.io/*`, incluindo
o rewrite de `/auth`. O projeto comunitário foi aposentado em março de 2026;
seu uso foi mantido para compatibilidade neste laboratório.

A instalação cria um Network Load Balancer público nas subnets públicas, com
portas TCP 80 e 443 e tags compartilhadas. O NLB gera custo adicional na AWS.
Os Ingress existentes passam a expor suas rotas pelo NLB. HTTPS requer configurar
certificados TLS nos Ingress; o certificado padrão do controller é autoassinado.

Use `terraform init`, `terraform plan -out=tfplan` e `terraform apply tfplan`
para instalar ou atualizar. Altere `ingress_nginx_chart_version` para mudar a
versão. O Helm aguarda até 15 minutos e faz rollback se a instalação falhar.

```bash
kubectl -n ingress-nginx get pods,svc
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller
kubectl get ingress -A
kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Mantenha o EKS acessível durante a remoção pelo Terraform, para que o Helm possa
remover o Service e o Kubernetes possa excluir o NLB. Não gerencie a mesma
release pelo Argo CD ou por instalações Helm manuais.

## Metrics Server e HPA

O módulo `modules/eks` instala o add-on `metrics-server` após o node group.
A versão `v0.9.0-eksbuild.10` está fixada em `metrics_server_addon_version` e
foi validada para Kubernetes 1.36. Confira a compatibilidade dessa versão
antes de atualizar o cluster.

O add-on fornece CPU e memória pela API `metrics.k8s.io`, permitindo que os HPA
existentes calculem suas réplicas. As primeiras amostras podem levar alguns
ciclos de coleta. Os workloads precisam declarar requests de CPU para HPA
baseado em utilização percentual. A configuração dos HPA permanece no GitOps.

```bash
kubectl get apiservice v1beta1.metrics.k8s.io
kubectl -n kube-system get deployment metrics-server
kubectl top nodes
kubectl top pods -A
kubectl get hpa -A
```

Referência: [Metrics Server no EKS](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html).
