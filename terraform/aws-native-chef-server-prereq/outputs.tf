output "vpc" {
  value = "${aws_vpc.default.id}"
}

output "subnet1" {
  value = "${aws_subnet.default1.id}"
}

output "subnet2" {
  value = "${aws_subnet.default2.id}"
}

output "subnet3" {
  value = "${aws_subnet.default3.id}"
}

output "security_group" {
  value = "${aws_security_group.default.id}"
}