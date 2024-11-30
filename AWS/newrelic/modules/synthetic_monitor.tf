# New Relic Syntheticsのモニター
resource "newrelic_synthetics_monitor" "monitor" {
  status           = "ENABLED"
  name             = var.name
  period           = "EVERY_MINUTE"
  uri              = var.url
  type             = "SIMPLE"
  locations_public = ["AWS_AP_NORTHEAST_1"]

  tag {
    key    = "tags.Name"
    values = ["${var.tag}"]
  }
}