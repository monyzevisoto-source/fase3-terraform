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
