locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  environment  = var.environment
  region       = var.aws_region
  tags         = local.common_tags
}

#module "data" {
#  source       = "./modules/data"
#  project_name = var.project_name
#  environment  = var.environment
#  region       = var.aws_region
#  tags         = local.common_tags
#}
#
module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  environment        = var.environment
  region             = var.aws_region
  tags               = local.common_tags
  subnet_ids         = module.network.public_subnet_ids
  lab_role_name      = var.eks_lab_role_name
  node_instance_type = var.eks_node_instance_type
  node_desired_size  = var.eks_node_desired_size
  node_min_size      = var.eks_node_min_size
  node_max_size      = var.eks_node_max_size
}

module "rds_auth" {
  source                = "./modules/rds"
  project_name          = var.project_name
  environment           = var.environment
  tags                  = local.common_tags
  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = module.network.vpc_cidr_block
  private_subnet_ids    = module.network.private_subnet_ids
  instance_name         = "auth"
  database_name         = "authdb"
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  master_username       = var.rds_master_username
}

module "rds_flag" {
  source                = "./modules/rds"
  project_name          = var.project_name
  environment           = var.environment
  tags                  = local.common_tags
  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = module.network.vpc_cidr_block
  private_subnet_ids    = module.network.private_subnet_ids
  instance_name         = "flag"
  database_name         = "flagsdb"
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  master_username       = var.rds_master_username
}

module "rds_analytics" {
  source                = "./modules/rds"
  project_name          = var.project_name
  environment           = var.environment
  tags                  = local.common_tags
  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = module.network.vpc_cidr_block
  private_subnet_ids    = module.network.private_subnet_ids
  instance_name         = "analytics"
  database_name         = "analyticsdb"
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  master_username       = var.rds_master_username
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
  hash_key   = var.dynamodb_hash_key
  tags       = local.common_tags
}

module "redis" {
  source             = "./modules/redis"
  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
  vpc_id             = module.network.vpc_id
  vpc_cidr_block     = module.network.vpc_cidr_block
  private_subnet_ids = module.network.private_subnet_ids
  node_type          = var.redis_node_type
}

module "sqs" {
  source                     = "./modules/sqs"
  project_name               = var.project_name
  environment                = var.environment
  queue_name                 = var.sqs_queue_name
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  message_retention_seconds  = var.sqs_message_retention_seconds
  tags                       = local.common_tags
}

module "ecr_auth" {
  source               = "./modules/ecr"
  project_name         = var.project_name
  environment          = var.environment
  service_name         = "auth"
  image_tag_mutability = var.ecr_image_tag_mutability
  tags                 = local.common_tags
}

module "ecr_flag" {
  source               = "./modules/ecr"
  project_name         = var.project_name
  environment          = var.environment
  service_name         = "flag"
  image_tag_mutability = var.ecr_image_tag_mutability
  tags                 = local.common_tags
}

module "ecr_targeting" {
  source               = "./modules/ecr"
  project_name         = var.project_name
  environment          = var.environment
  service_name         = "targeting"
  image_tag_mutability = var.ecr_image_tag_mutability
  tags                 = local.common_tags
}

module "ecr_evaluation" {
  source               = "./modules/ecr"
  project_name         = var.project_name
  environment          = var.environment
  service_name         = "evaluation"
  image_tag_mutability = var.ecr_image_tag_mutability
  tags                 = local.common_tags
}

module "ecr_analytics" {
  source               = "./modules/ecr"
  project_name         = var.project_name
  environment          = var.environment
  service_name         = "analytics"
  image_tag_mutability = var.ecr_image_tag_mutability
  tags                 = local.common_tags
}

module "argocd" {
  source        = "./modules/argocd"
  chart_version = var.argocd_chart_version
  depends_on    = [module.eks]
}
