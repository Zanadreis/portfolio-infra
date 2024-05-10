resource "aws_lb_target_group" "lb_tg_frontend" {
  name     = "lb-tg-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group" "lb_tg_backend" {
  name     = "lb-tg-backend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "lb_tg_attach_frontend" {
  target_group_arn = aws_lb_target_group.lb_tg_frontend.arn
  target_id        = aws_instance.app_server.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "lb_tg_attach_backend" {
  target_group_arn = aws_lb_target_group.lb_tg_backend.arn
  target_id        = aws_instance.app_server.id
  port             = 5000
}

resource "aws_security_group" "lb_sg" {
  name   = "lb_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "lb_app" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_listner" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_frontend.arn
  }
}

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = aws_lb_listener.lb_listner.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_backend.arn
  }

  condition {
    host_header {
      values = ["api.${var.domain_name}"]	
    }
  }
}
