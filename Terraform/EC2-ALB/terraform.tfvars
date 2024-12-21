regions = {
  prod = "us-east-1"
}
environment = {
  prod = {
    region        = "us-east-1"
    profile       = "One2N"
    ami           = "ami-01816d07b1128cd2d"
    instance_type = "t2.micro"

    user_data = <<-EOF
    #!/bin/bash
    cd /tmp
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl status amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker

    sudo yum update -y
    sudo yum install -y python3 python3-pip unzip docker aws-cli git
    cd /
    git clone https://github.com/Dhirva/AWS-ALB-S3-Terraform.git
    cd AWS-ALB-S3-Terraform
    echo "S3_BUCKET_NAME=$(aws ssm get-parameter --name '/prod/S3_BUCKET_NAME' --with-decryption --region us-east-1 --query 'Parameter.Value' --output text)" >> .env
    echo "AWS_REGION=$(aws ssm get-parameter --name '/prod/AWS_REGION' --with-decryption --region us-east-1 --query 'Parameter.Value' --output text)" >> .env
    
    sudo docker build -t your-app-name .

    sudo docker run -d -p 5000:5000 --name your-container-name your-app-name  
    EOF

    key_name = "my-new-key"
    alb_config = {
      http_tcp_listeners = [
        {
          port               = 80
          protocol           = "HTTP"
          target_group_index = 0
          action_type        = "redirect"
          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }
        },
      ]
      https_listener_rules = [
        {
          https_listener_index = 0
          priority             = 1
          actions = [
            {
              type             = "forward"
              target_group_arn = 0
            }
          ]
          conditions = [{
            path_patterns = ["/"]
            }
          ]
        }
      ]

      https_listeners = [
        {
          port               = 443
          protocol           = "HTTPS"
          ssl_policy         = "ELBSecurityPolicy-2016-08"
          certificate_arn    = "arn:aws:acm:us-east-1:943621111361:certificate/752c910f-350c-4edb-8001-4a2f25b3cac5"
          target_group_index = 0
          action_type        = "forward"
        },
      ]

      target_groups = [
        {
          name             = "phoenix-prod-s3-server"
          backend_protocol = "HTTP"
          backend_port     = 5000
          target_type      = "instance"
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/health"
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 5
            protocol            = "HTTP"
          }
        }
    ] }
    sg_config = {
      ingress_cidr_blocks = ["0.0.0.0/0"]
      ingress_rules       = ["http-80-tcp"]
      ingress_with_cidr_blocks = [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = "0.0.0.0/0"
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = "0.0.0.0/0"
        },
        {
          from_port   = 5000
          to_port     = 5000
          protocol    = "tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]

      egress_with_cidr_blocks = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = -1
          cidr_blocks = "0.0.0.0/0"
        },
      ]
    }
  }
}
