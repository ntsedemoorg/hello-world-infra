data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}
