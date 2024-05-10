output "vm_ip" {
  value = aws_lb.lb_app.dns_name
}
# output "aws_lb_dns_name" {
#   value = aws_lb.lb_app.dns_name
# }