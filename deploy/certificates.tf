###
# Root Certificate
# 
# Self-signed certificate that is used to sign client certificates along. Root certificate
# is later sent to the MQTT broker head in Event Grid for client verification.
###

resource "tls_private_key" "root_ca_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "root_ca_cert" {
  private_key_pem = tls_private_key.root_ca_key.private_key_pem
  allowed_uses = [
    "crl_signing", "client_auth", "cert_signing", "digital_signature", "content_commitment",
    "key_encipherment", "key_agreement", "email_protection"
  ]

  subject {
    common_name = var.egmq_client_root_ca_subject_common_name
  }

  # Configurable validity window. Renewing certs requires a different process to produce new certs
  # and distributed them among client devices.
  validity_period_hours = 8076
  # CA certificate required for bothing signing certs and also, required for MQTT CA Certificates.
  is_ca_certificate    = true
  set_authority_key_id = true
  set_subject_key_id   = true
}

data "tls_certificate" "root_ca_cert_pem" {
  content = tls_self_signed_cert.root_ca_cert.cert_pem
}

# Output certificates to directory for later use for sample clients.
resource "local_sensitive_file" "root_ca_key_pem" {
  filename = "../out/localrootca.key"
  content  = tls_private_key.root_ca_key.private_key_pem
}

# Output certificates to directory for later use for sample clients.
resource "local_sensitive_file" "root_ca_cert_pem" {
  filename = "../out/localrootca.pem"
  content  = tls_self_signed_cert.root_ca_cert.cert_pem
}

###
# Client Certificates
# 
# Certificates signed by the root CA above, distributed to sample client applications.
###

resource "tls_private_key" "local_client" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "local_client" {
  private_key_pem = tls_private_key.local_client.private_key_pem
  subject {
    common_name = var.egmq_client_local_ca_subject_common_name
  }
}

resource "tls_locally_signed_cert" "local_client" {
  allowed_uses = [
    "crl_signing", "client_auth", "digital_signature", "content_commitment",
    "key_encipherment", "key_agreement", "email_protection"
  ]
  ca_cert_pem        = tls_self_signed_cert.root_ca_cert.cert_pem
  ca_private_key_pem = tls_private_key.root_ca_key.private_key_pem
  cert_request_pem   = tls_cert_request.local_client.cert_request_pem

  # Configurable validity window. Renewing certs requires a different process to produce new certs
  # and distributed them among client devices.
  validity_period_hours = 8076
  is_ca_certificate     = false
}

# Output certificates to directory for later use for sample clients.
resource "local_sensitive_file" "local_client_key_pem" {
  filename = "../out/localca.key"
  content  = tls_private_key.local_client.private_key_pem
}

# Output certificates to directory for later use for sample clients.
resource "local_sensitive_file" "local_client_cert_pem" {
  filename = "../out/localca.pem"
  content  = tls_locally_signed_cert.local_client.cert_pem
}