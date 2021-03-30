# [default] Oregon resources
provider "aws" {
    region = "us-west-2"
}

# HK resources
provider "aws" {
    region = "ap-east-1"
    alias = "hk"
}

# algo
data aws_instance "algo" {
    instance_id = "i-05d3da7fc45b12af4"
}

data aws_instance "charm_dot_io" {
    instance_id = "i-0dc76eb4d9c9055be"
}

data aws_instance "binance-bot" {
    instance_id = "i-0ced1c4c823548e0c"

    provider = aws.hk
}