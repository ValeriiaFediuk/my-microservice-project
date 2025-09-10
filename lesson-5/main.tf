module "s3_backend" {
  source = "./modules/s3-backend"                
  bucket_name = "terraform-state-bucket-fediuk-001"  
  table_name  = "terraform-locks"                
}

module "vpc" {
  source              = "./modules/vpc"           
  vpc_cidr_block      = "10.0.0.0/16"             
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]        
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         
  availability_zones  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]            
  vpc_name            = "vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name              
  subnet_ids    = module.vpc.public_subnets     
  instance_type = var.instance_type             
  desired_size  = 2                             
  max_size      = 3                             
  min_size      = 1                             
}

module "rds" {
  source        = "./modules/rds"
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}