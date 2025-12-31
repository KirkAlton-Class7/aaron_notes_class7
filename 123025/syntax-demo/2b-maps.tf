variable "room_numbers" {
  description = "A map of strings"
  type        = map(string)
  default = {
    class_crush = "lizzo"
    class_loves    = "terraform"
    class_fears = "Armageddon"
  }
}

output "map_entire_variable" {
  value = var.room_numbers
}

output "map_key_access" {
  value = var.room_numbers["class_loves"]
}


/*
keys(map) - return keys as list
values(map) - return values as list
length(map) - how many kv pairs return as number 
merge(map1, map2, ...) - combine two maps and return as single map
*/