terraform {
  required_version = ">= 1.9.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "mrlabied-dev/api-rm1-0a51-p1-openshiftapps-com:6443/mrlabied"
  insecure       = true
}

variable "namespace_name" {
  description = "Existing OpenShift Developer Sandbox namespace"
  type        = string
  default     = "mrlabied-dev"
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "fastapi-config6"
    namespace = var.namespace_name
  }

  data = {
    APP_NAME    = "fastapi-starter"
    ENVIRONMENT = "production"
  }
}