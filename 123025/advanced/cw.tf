variable "log_retention_by_env" {
  description = "CloudWatch log retention by environment"
  type        = map(number)

  default = {
    dev  = 3
    test = 7
    prod = 30
  }
}


locals {
  log_retention_days = lookup(
    var.log_retention_by_env,
    var.environment,
    7
  )
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/aws/ec2/web"
  retention_in_days = local.log_retention_days
}
