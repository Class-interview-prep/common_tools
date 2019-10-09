provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.tiller_version}"
  service_account = "tiller"
  kubernetes {
  }
}

data "template_file" "ingress_controller_values" {
  template = "${file("helm-ingress-controller/ingress-controller/values.yaml")}"

  vars {
    clusterSubDomain = "fuchicorp.com"
  }
}

resource "local_file" "ingress_controller_helm_chart_values" {
  content  = "${trimspace(data.template_file.ingress_controller_values.rendered)}"
  filename = "helm-ingress-controller/.cache/ingress_controller_values.yaml"
}

## Deploy ingress controller
resource "helm_release" "ingress_controller" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]
  values = [
    "${data.template_file.ingress_controller_values.rendered}"
  ]

  name      = "fuchicorp-ingress-controller"
  chart     = "./helm-ingress-controller/ingress-controller"
  namespace = "${var.namespace}"
}
