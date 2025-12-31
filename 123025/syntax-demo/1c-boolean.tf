variable "is_recorded" {
  description = "A simple boolean variable"
  type        = bool
  default     = true
}

variable "this_is_false" {
  description = "A simple boolean variable"
  type        = bool
  default     = false
}

output "bool_entire_variable" {
  value = var.is_recorded
}

output "bool_conditional_example" {
  value = var.is_recorded ? "This class is recorded." : "This class is not recorded."
}

/*
if var.is_recorded equals true:
    value = "This class is recorded."
else:
    value = "This class is not recorded."
*/
