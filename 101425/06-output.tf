# Outputs display important information after terraform apply

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "availability_zones" {
  description = "Availability zones used"
  value       = tolist(data.aws_availability_zones.available.names)
}
