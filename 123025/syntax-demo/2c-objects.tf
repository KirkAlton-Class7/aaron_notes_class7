variable "instructor" {
  description = "An object with a few fields"
  type = object({
    name       = string
    class  = number
    loves_brisket  = bool
  })
  default = {
    name      = "Rob"
    class = 3  # I think?
    loves_brisket = true 
  }
}

output "object_entire_variable" {
  value = var.instructor
}

output "object_attribute_access" {
  value = var.instructor.name
}

