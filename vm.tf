resource "aws_instance" "app_server" {
  ami     = "ami-07caf09b362be10b8"
  instance_type = "t2.micro"
  user_data = file("user_data.sh")
  key_name = aws_key_pair.key.key_name
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [ aws_security_group.security_group.id ]
}

# resource "aws_instance" "backend-server" {
#   ami     = "ami-07caf09b362be10b8"
#   instance_type = "t2.micro"
#   user_data = file("backend_script.sh")
#   key_name = aws_key_pair.key.key_name
#   subnet_id = aws_subnet.subnet.id
#   vpc_security_group_ids = [ aws_security_group.security_group.id ]
# } 