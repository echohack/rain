resource "aws_instance" "default" {
  connection {
    user        = var.ssh_user
    private_key = file(var.aws_key_pair_file)
    agent       = false
  }

  ami                         = data.aws_ami.centos.id
  instance_type               = "m5.large"
  key_name                    = var.aws_key_pair_name
  subnet_id                   = aws_subnet.default.id
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]
  associate_public_ip_address = true
  ebs_optimized               = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags = {
    Name      = format("${var.aws_key_pair_name}_${random_id.random.hex}")
    X-Contact = var.tag_contact
    X-Dept    = "Success Engineering"
    X-TTL     = var.tag_ttl
  }
}
