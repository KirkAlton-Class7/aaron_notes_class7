# Common conversions you’ll actually use in Terraform:

output "convert_number_to_string" {
  value = tostring(0.10000)
}

output "convert_string_to_number" {
  # tonumber() expects a numeric string
  value = tonumber("42")
}

# output "convert_list_to_set" {
#   value = toset(var.topics) # removes duplicates if any
# }

output "convert_map_values_to_list" {
  value = values(var.room_numbers)
}

output "convert_map_keys_to_list" {
  value = keys(var.room_numbers)
}

output "json_encode_object" {
  value = jsonencode(var.instructor)
}


