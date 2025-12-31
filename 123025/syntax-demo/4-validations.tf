
variable "class_mode" {
  description = "How the class is delivered"
  type        = string

  validation {
    condition     = contains(["in_person", "online"], var.class_mode)
    error_message = "class_mode must be either \"in_person\" or \"online\"."
  }
}

variable "student_count" {
  description = "Number of students enrolled"
  type        = number

  validation {
    condition     = var.student_count >= 1
    error_message = "student_count must be at least 1."
  }
}

variable "class_duration_minutes" {
  description = "Length of the class in minutes"
  type        = number
  #default = 90

  validation {
    condition     = var.class_duration_minutes >= 30 && var.class_duration_minutes <= 180
    error_message = "class_duration_minutes must be between 30 and 180."
  }
}
