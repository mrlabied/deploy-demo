terraform {
  required_version = ">= 1.9.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
  }
}

# Utilise automatiquement le fichier ~/.kube/config généré dans le runner GitHub Actions
provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "namespace_name" {
  description = "Namespace dédié à l'application FastAPI"
  type        = string
  default     = "fastapi-ns"
}

resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = var.namespace_name
    labels = {
      managed-by = "terraform"
      env        = "production"
    }
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "fastapi-config"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  data = {
    APP_NAME    = "fastapi-starter"
    ENVIRONMENT = "production"
  }
}