## Before deploy ingress for each services it will make sure all services available
module "services_ingress" {
  source      = "fuchicorp/chart/helm"
  name        = "services-ingress-${var.deployment_environment}"
  environment = "${var.deployment_environment}"
  path        = "./main-helm"


  set {
    name  = "nexusport"
    value = "${var.nexus_service_port}"
  }

  set {
    name  = "vaultport"
    value = "${var.vault_service_port}"
  }

  set {
    name  = "repo_port"
    value = "${var.repo_port}"
  }

  set {
    name  = "email"
    value = "${var.email}"
  }

  set {
    name = "domain_name"
    value = "${var.google_domain_name}"
  }
}


