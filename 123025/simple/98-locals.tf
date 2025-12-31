# ===================================
# Local Values
# ===================================

locals {
  # Simple naming scheme: <project>-<environment>-<resource-type>
  name_prefix = "${var.project_name}-${var.environment}"
  # var.environment == "dev" ? "0.0.0.0/0" : "10.10.0.0/16"

}
