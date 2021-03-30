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
resource aws_instance "algo" {
    instance_id = "i-05d3da7fc45b12af4"
}

resource aws_instance "charm_dot_io" {
    instance_id = "i-0dc76eb4d9c9055be"
}

resource aws_instance "binance-bot" {
    instance_id = "i-0ced1c4c823548e0c"

    provider = aws.hk
}