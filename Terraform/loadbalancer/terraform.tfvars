regions = {
  prod = "us-east-1"
}
environment = {
  prod = {
    region  = "us-east-1"
    profile = "One2N"
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
            host_headers = ["s3.dev.example.com"]
            }
          ]
        }
      ]

      https_listeners = [
        {
          port               = 443
          protocol           = "HTTPS"
          ssl_policy         = "ELBSecurityPolicy-2016-08"
          certificate_arn    = "your arn here"
          target_group_index = 0
          action_type        = "forward"
        },
      ]

      target_groups = [
        {
          name             = "phoenix-prod-s3-service"
          backend_protocol = "HTTP"
          backend_port     = 8000
          target_type      = "ip"
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
      ingress_rules       = ["http-80-tcp", "https-443-tcp"]
      ingress_with_cidr_blocks = []

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
