module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name                   = "${var.product}-${local.environment}-ec2-server"
  ami                    = local.env_conf.ami
  instance_type          = local.env_conf.instance_type
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.vpc_details.private_subnets[0]

  user_data            = local.env_conf.user_data
  iam_instance_profile = aws_iam_instance_profile.profile.id

  tags = local.tags
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name              = "keypair"
  create_private_key    = true
  private_key_algorithm = "RSA"
  private_key_rsa_bits  = 4096
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name
  depends_on = [ module.ec2_instance ]
}

resource "aws_s3_bucket_policy" "public_read_only_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadOnlyAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.example_bucket.id}/*"
      }
    ]
  })
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.ec2_instance.id

  depends_on = [
    module.alb,
    module.ec2_instance
  ]
}