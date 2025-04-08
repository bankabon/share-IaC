resource "snowflake_warehouse" "warehouse" {
  name           = "${var.env}_${var.name}_WH"
  warehouse_size = "large"
  auto_suspend = 60
}