variable "course_type" {
  description = "A simple string variable"
  type        = string
  default     = "Terraform"
}

output "course_type" {
  value = var.course_type
}


#####################

variable "greeting" {
  description = "A simple string variable"
  type        = string
  default     = "Welcome to class"
}

output "greeting" {
  value = var.greeting
}

