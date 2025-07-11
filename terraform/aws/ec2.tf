data "template_file" "startup" {
  template = file("./templates/startup.sh.tpl")
}

resource "aws_key_pair" "ssh-keys" {
  key_name   = "${var.project}-ssh-keys"
  public_key = file("./templates/public-key.pub")
}

resource "aws_instance" "ssh_host" {
  # ami           = "ami-089146c5626baa6bf" # Ubuntu 22.04 eu-north-1
  ami           = "ami-05ec1e5f7cfe5ef59" # Ubuntu 22.04 us-east-1

  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh-keys.key_name

  subnet_id              = aws_subnet.public-subnet-c.id
  vpc_security_group_ids = [aws_security_group.default.id]
  user_data              = data.template_file.startup.rendered
}

output "ssh_host" {
  value = aws_instance.ssh_host.public_ip
}
