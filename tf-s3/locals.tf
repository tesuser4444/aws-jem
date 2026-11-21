locals {
  prefix                  = "${var.project}-${var.environment}"
  is_critical_environment = var.environment == "prod" ? "yes" : "no"
  sufix                   = "${local.prefix}-sufix"
}