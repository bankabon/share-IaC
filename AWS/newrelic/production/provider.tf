provider "newrelic" {
  account_id = var.account_id
  api_key    = var.api_key
  region     = "US"
}

#terraform cloud側で変数定義済み