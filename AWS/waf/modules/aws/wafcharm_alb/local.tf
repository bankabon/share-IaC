locals {
  desc        = var.desc != null ? var.desc : var.name
  metric_name = var.metric_name != null ? var.metric_name : var.name
}