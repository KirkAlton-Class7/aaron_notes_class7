variable "topics" {
  description = "A list of strings"
  type        = list(string)
  default     = ["variables", "outputs", "validation", "Lizzo"]
}

variable "easy_reader_list" {
  description = "A list of strings"
  type        = list(any)
  default = [
    "variables",
    true,
    20,
    "Lizzo",
  ]
}

output "list_entire_variable" {
  value = var.topics
}

output "list_index_access" {
  value = var.topics[0] # "variables"
}

############

variable "list_of_lists" {
  type = list(list(any))
  default = [
    [1, 2, 3],
    ["a", "b", "c"]
  ]
}

output "list_of_list" {
  value = var.list_of_lists
}

output "list_of_list_splat" {
  value = var.list_of_lists[*][1]
}

/*
contains(list, value): Checks if a specified value exists within a given list or set and returns true or false.
element(list, index): Retrieves a single element from a list using its index.
length(list): Returns the number of elements in a list, map, or set.
concat(list1, list2, ...): Combines two or more lists into a single list.
sort(list): Sorts the elements of a list in ascending order. When converting from a set where order is not guaranteed, using sort(tolist(...)) ensures a consistent, deterministic order.
*/