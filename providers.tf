terraform {
  backend "s3" {
    endpoint = "gudcodes-terraform.sfo2.digitaloceanspaces.com"
    region   = "sfo2"

    bucket = "prod"
    key    = "terraform.tfstate"

    force_path_style = true

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}


provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.do_access_id
  spaces_secret_key = var.do_secret_key
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

