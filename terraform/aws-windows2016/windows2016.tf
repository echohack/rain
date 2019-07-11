data "template_file" "winrm_setup" {
  template = "${file("${path.module}/../templates/winrm_setup.txt.tpl")}"

  vars {
    random_string = "${random_string.random.result}"
  }
}

resource "aws_instance" "default" {
  connection = {
    type    = "winrm"
    password  = "${random_string.random.result}"
    agent     = "false"
    insecure  = true
    https     = false
  }

  ami                         = "${data.aws_ami.windows2016.id}"
  instance_type               = "m5.large"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.default.id}"
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]
  associate_public_ip_address = true
  ebs_optimized               = true
  user_data                   = "${template_file.winrm_setup.rendered}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${format("${var.aws_key_pair_name}_${random_id.random.hex}_windows2016", count.index + 1)}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }


  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "remote-exec" {
    connection = {
      type     = "winrm"
      password = "${random_string.random.result}"
      agent    = "false"
      insecure = true
      https    = false
    }

    inline = [
      "powershell.exe Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))",
      "powershell.exe C:/ProgramData/chocolatey/choco install habitat -y",
      "powershell.exe New-NetFirewallRule -DisplayName 'Habitat TCP' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9631,9638",
      "powershell.exe New-NetFirewallRule -DisplayName 'Habitat UDP' -Direction Inbound -Action Allow -Protocol UDP -LocalPort 9638",
    ]
  }

  provisioner "remote-exec" {
    connection = {
      type     = "winrm"
      password = "${random_string.random.result}"
      agent    = "false"
      insecure = true
      https    = false
    }
    inline = [
      "hab pkg install core/windows-service",
      "hab pkg exec core/window-service install",
      "hab svc load echohack/rain --channel unstable --strategy at-once"
    ]
  }
}
