terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.52.0"
    }
  }

  backend "s3" {
    region = "eu-west-1"
    bucket = "89137732723-eu-west-1-state"    
    key    = "hello-world-infra/state.tfstate"   
  }
}
