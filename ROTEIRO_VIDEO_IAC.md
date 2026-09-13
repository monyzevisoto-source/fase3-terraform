# Roteiro de demonstração — IaC

Este roteiro cobre exclusivamente a parte de Infraestrutura como Código (IaC)
do Tech Challenge — Fase 3. A demonstração sugerida dura entre 6 e 9 minutos.

> **Pré-requisito obrigatório:** antes da gravação, configure e valide o backend
> remoto S3 do Terraform. O enunciado não permite manter o `terraform.tfstate`
> local. Não mostre credenciais, valores de `terraform.tfvars`, state ou senhas
> no vídeo.

## 1. Abertura e objetivo (30 segundos)

Apresente o repositório e explique:

> "Esta infraestrutura foi definida em Terraform para substituir a criação
> manual do ambiente ToggleMaster. O código está organizado em módulos para
> rede, EKS, bancos de dados, mensageria e repositórios de imagens."

Mostre a estrutura de diretórios:

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── modules/
    ├── network/
    ├── eks/
    ├── rds/
    ├── redis/
    ├── dynamodb/
    ├── sqs/
    └── ecr/
```

## 2. State remoto e variáveis (45 segundos)

Mostre a configuração do backend S3 após ela estar incluída no Terraform e
explique que o state é centralizado, não é versionado no Git e evita conflitos
entre execuções. Se o backend usar lockfile, mencione que ele impede alterações
concorrentes.

Mostre apenas as declarações de variáveis e destaque que configurações
dependentes do ambiente ficam em `terraform.tfvars`, arquivo que não deve ser
comitado. Não abra seu conteúdo se tiver valores sensíveis.

## 3. Módulos Terraform (2 a 3 minutos)

Percorra rapidamente `main.tf` e os módulos, relacionando cada bloco ao
requisito do desafio:

| Módulo | Demonstração | Requisito |
| --- | --- | --- |
| `network` | VPC, duas subnets públicas, duas privadas, Internet Gateway e rotas | Networking |
| `eks` | Cluster EKS e Managed Node Group | Kubernetes |
| `rds` | Três instâncias PostgreSQL: `auth`, `flag` e `targeting` | Bancos relacionais |
| `redis` | Replication Group ElastiCache Redis em subnets privadas | Cache |
| `dynamodb` | Tabela `ToggleMasterAnalytics` | Dados analíticos |
| `sqs` | Fila de eventos | Mensageria |
| `ecr` | Cinco repositórios: `auth`, `flag`, `targeting`, `evaluation` e `analytics` | Imagens dos microsserviços |

Para AWS Academy, destaque o data source da `LabRole` no módulo EKS:

> "Não criamos roles ou policies de IAM pelo Terraform. O cluster e o Node
> Group usam a `LabRole` existente, conforme a restrição do AWS Academy."

No módulo RDS, destaque `manage_master_user_password = true`:

> "A senha mestra não fica no código ou em arquivo texto; a AWS a gerencia no
> Secrets Manager."

## 4. Validação e plano (1 a 2 minutos)

No diretório raiz, execute:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
```

Explique o resultado do plano: ele permite revisar inclusões, alterações e
remoções antes de tocar na AWS. Não exiba valores sensíveis eventualmente
presentes no output.

Se o ambiente já estiver criado, execute um `terraform plan` sem mudanças e
explique que o resultado confirma a convergência entre código e infraestrutura.

## 5. Aplicação (30 segundos)

Se a aplicação for demonstrada ao vivo, execute somente após revisar o plano:

```bash
terraform apply tfplan
```

Explique que o comando usa o plano revisado. Caso o ambiente já exista, não é
necessário recriá-lo: mostre o plano convergente e siga para a evidência na AWS.

## 6. Evidências no Console AWS (2 a 3 minutos)

Mostre, nesta ordem, os recursos resultantes:

1. **VPC:** VPC criada, subnets públicas e privadas, Internet Gateway e route
   tables.
2. **EKS:** cluster e Managed Node Group em estado `Active`.
3. **RDS:** três instâncias PostgreSQL (`auth`, `flag` e `analytics`) sem acesso
   público.
4. **ElastiCache:** replication group Redis disponível.
5. **DynamoDB:** tabela `ToggleMasterAnalytics`.
6. **SQS:** fila de eventos.
7. **ECR:** os cinco repositórios dos microsserviços.

## 7. Encerramento (20 segundos)

Finalize com:

> "A infraestrutura é reproduzível por código, modularizada e validada pelo
> Terraform. O state remoto centraliza o controle das alterações, e os recursos
> exigidos para os cinco microsserviços foram provisionados na AWS."

## Checklist antes de gravar

- [ ] Backend S3 remoto configurado e `terraform init` concluído.
- [ ] `terraform fmt -check -recursive` concluído sem alterações.
- [ ] `terraform validate` concluído com sucesso.
- [ ] `terraform plan` revisado, sem dados sensíveis na tela.
- [ ] Recursos AWS disponíveis para demonstração no console.
- [ ] Nenhuma credencial, state, plano ou `terraform.tfvars` foi adicionado ao Git.
