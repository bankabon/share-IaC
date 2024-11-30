module "vm" {
    source = "../modules"
    name = "test"
    node = "pve1"
    iso_module = "iso:iso"
    iso = "ubuntu-22.04.3-server.iso"

    cpu = "2"
    memory = "2048"
    disk = 32
  
}