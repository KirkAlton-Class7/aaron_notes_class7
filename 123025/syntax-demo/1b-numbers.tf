variable "max_students" {
  description = "A simple number variable"
  type        = number
  default     = 200
}

variable "float_example" {
  description = "A simple number variable"
  type        = number
  default     = 0.625
}

variable "signed_integer_example" {
  description = "A simple number variable"
  type        = number
  default     = -75
}

output "number_entire_variable" {
  value = var.max_students
}

output "simple_arithmetic" {
  value = var.max_students + 5
}

output "class_survivors" {
  value = var.max_students + var.signed_integer_example
}

output "make_a_number_positive" {
  value = abs(var.signed_integer_example)
}


