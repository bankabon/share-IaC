module "main" {
  source = "../modules"

  name  = "test-google"
  url   = "https://www.google.com/?hl=ja"
  tag   = var.tags[0]
  #[0]testsite
}