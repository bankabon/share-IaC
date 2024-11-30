provider "proxmox" {
  pm_api_url = "<proxmox URL>"
  # 証明書の検証がが困難な場合は以下をコメントアウトする
  pm_tls_insecure = true
  pm_api_token_id = "<token name id>"
  pm_api_token_secret = "<api token>"

}