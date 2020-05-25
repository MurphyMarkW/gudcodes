resource "tls_private_key" "gudcodes" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "gudcodes" {
  key_algorithm   = tls_private_key.gudcodes.algorithm
  private_key_pem = tls_private_key.gudcodes.private_key_pem

  # Certificate expires after 48 hours.
  validity_period_hours = 48

  # Generate a new certificate if Terraform is run within 36
  # hours of the certificate's expiration time.
  early_renewal_hours = 36

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  dns_names = [
    digitalocean_domain.com.name,
    digitalocean_domain.dev.name,
  ]

  subject {
      common_name  = digitalocean_domain.io.name
      organization = "gudCodes"
  }
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.gudcodes.private_key_pem
  email_address   = "mark@gudcodes.dev"
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem

  common_name = digitalocean_domain.io.name

  subject_alternative_names = [
    digitalocean_domain.com.name,
    digitalocean_domain.dev.name,
  ]

  dns_challenge {
    provider = "digitalocean"

    config = {
      DO_AUTH_TOKEN = var.do_token
    }
  }
}
