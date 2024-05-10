resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc.id
  availability_zone = "${var.availability_zone}-1a"
  cidr_block = "10.0.0.0/18"
}
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc.id
  availability_zone = "${var.availability_zone}-1b"
  cidr_block = "10.0.64.0/18"
}
resource "aws_subnet" "subnet3" {
  vpc_id = aws_vpc.vpc.id
  availability_zone = "${var.availability_zone}-1c"
  cidr_block = "10.0.128.0/18"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name = "securit_group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
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

# EIP - Elastic IP
resource "aws_eip" "frontend-eip" {
  instance = aws_instance.app_server.id
}

# DNS and Hosted Zones configuration
resource "aws_route53_zone" "host_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "route_record" {
  zone_id = aws_route53_zone.host_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.lb_app.dns_name
    zone_id                = aws_lb.lb_app.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route_record_www" {
  zone_id = aws_route53_zone.host_zone.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.lb_app.dns_name
    zone_id                = aws_lb.lb_app.zone_id
    evaluate_target_health = false
  }
}