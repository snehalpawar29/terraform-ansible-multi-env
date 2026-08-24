output "instance_public_ips" {
  description = "Instance Public Ips"
  value       = aws_instance.my_instance[*].public_ip
}
