resource "aws_route" "nat_gateway" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = aws_instance.nat_ec2.primary_network_interface_id

  lifecycle {
    prevent_destroy = false
  }
}