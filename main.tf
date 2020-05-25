data "digitalocean_region" "gudcodes" {
  slug = "sfo2"
}

resource "digitalocean_domain" "dev" {
  name = "gudcodes.dev"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_domain" "io" {
  name = "gudcodes.io"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_domain" "com" {
  name = "gudcodes.com"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_floating_ip" "gudcodes" {
  region = data.digitalocean_region.gudcodes.slug
}

resource "digitalocean_project" "gudcodes" {
  name        = "gudcodes"
  description = "gudCodes Development Project"
  purpose     = "Web Application(s)"
  environment = "Development"
  resources   = [
    # Top level domains.
    digitalocean_domain.com.urn,
    digitalocean_domain.dev.urn,
    digitalocean_domain.io.urn,
    # Floating IP.
    digitalocean_floating_ip.gudcodes.urn,
  ]
}
