provider "aws" {
  region = "eu-west-1"
}

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
    bucket = "891377327213-eu-west-1-state"    
    key    = "development/hello-world-api/state.tfstate"   
  }
}
