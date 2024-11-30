terraform {
  required_providers {
    #  cloudflare = {
    #   source  = "cloudflare/cloudflare"
    #   version = "3.27.0"  # 必要なバージョンを指定
    # }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}