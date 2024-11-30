resource "proxmox_vm_qemu" "vm1" {
  name        = var.name
  target_node = var.node

  iso = "${var.iso_module}/${var.iso}"

  os_type = "cloud-init"
  cores   = var.cpu
  memory  = var.memory


  disk {
    size            = "${var.disk}G"
    storage         = "local-lvm"
    type            = "scsi"
  }

   network {
    model  = "virtio"
    bridge = "vmbr0"
  }


}