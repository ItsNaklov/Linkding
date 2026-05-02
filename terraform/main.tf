terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "linkding" {
  metadata {
    name = "linkding"
  }
}

resource "kubernetes_deployment" "linkding" {
  metadata {
    name      = "linkding"
    namespace = kubernetes_namespace.linkding.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "linkding"
      }
    }
    template {
      metadata {
        labels = {
          app = "linkding"
        }
      }
      spec {
        container {
          name  = "linkding"
          image = "sissbruecker/linkding:latest"
          port {
            container_port = 9090
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "linkding" {
  metadata {
    name      = "linkding"
    namespace = kubernetes_namespace.linkding.metadata[0].name
  }
  spec {
    selector = {
      app = "linkding"
    }
    port {
      port        = 9090
      target_port = 9090
      node_port   = 30900
    }
    type = "NodePort"
  }
}
