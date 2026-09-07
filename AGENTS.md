# Repository Guidelines

## Project Structure & Module Organization

This repository provisions the Phase 3 AWS platform with Terraform. Root files (`main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, and `versions.tf`) compose the environment and configure the AWS provider. Reusable infrastructure lives in `modules/`: `network`, `eks`, `rds`, `redis`, `dynamodb`, `sqs`, and `ecr`. Each module normally contains `main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf`. Keep resources within their owning module; expose only values needed by root or dependent modules through outputs.

## Build, Test, and Development Commands

Run commands from the repository root:

```bash
terraform init            # Download providers and initialize modules
terraform fmt -recursive  # Format all Terraform files
terraform validate        # Check configuration syntax and internal consistency
terraform plan -out=tfplan # Preview proposed AWS changes
terraform apply tfplan    # Apply a reviewed plan
```

Use a local `terraform.tfvars` or `-var` flags for environment-specific settings. Never commit state files, plans, credentials, or secret values. Confirm the selected AWS profile and region before applying.

## Coding Style & Naming Conventions

Use `terraform fmt` output: two-space indentation and aligned assignments. Name resources, variables, and outputs with descriptive `snake_case`; use module names such as `rds_auth` when composing service-specific instances. Include a `description` and explicit `type` for input variables where practical. Preserve the shared `Project`, `Environment`, and `ManagedBy` tagging pattern by passing `local.common_tags` into modules.

## Testing Guidelines

There is no automated test suite currently. Treat `terraform fmt -check -recursive` and `terraform validate` as required checks for every change. Run `terraform plan` with representative non-production values and review replacements, deletions, IAM changes, network exposure, and cost-impacting resources before requesting review.

## Commit & Pull Request Guidelines

History uses short imperative summaries and Conventional Commit-style prefixes (for example, `chore: initialize Terraform repository`); follow that format when appropriate. Keep commits focused by module or concern. Pull requests should state the infrastructure intent, affected modules and AWS resources, required variables or migration steps, and include the relevant sanitized `terraform plan` summary. Link the tracked issue when one exists; never include credentials, state, or sensitive plan output.
