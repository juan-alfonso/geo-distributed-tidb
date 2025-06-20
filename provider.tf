terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.41.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
    
  }
  required_version = ">= 1.0" 
}

# Configure the Linode Provider
provider "linode" {
   token = var.linode_token
}

#Configure kubernetes provider for each LKE cluster
provider "kubernetes" {
  alias                  = "tidb_1"
  host                   = local.kubeconfig_hcl_tidb_1.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_1.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_1.clusters[0].cluster.certificate-authority-data)
}

provider "kubernetes" {
  alias                  = "tidb_2"
  host                   = local.kubeconfig_hcl_tidb_2.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_2.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_2.clusters[0].cluster.certificate-authority-data)
}

provider "kubernetes" {
  alias                  = "tidb_3"
  host                   = local.kubeconfig_hcl_tidb_3.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_3.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_3.clusters[0].cluster.certificate-authority-data)
}

provider "kubernetes" {
  alias                  = "kuma_global_cp"
  host                   = local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_kuma_global_cp.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.certificate-authority-data)
}

# Configure Helm providers for each cluster
provider "helm" {
  alias = "tidb_1"
  kubernetes {
    host                   = local.kubeconfig_hcl_tidb_1.clusters[0].cluster.server
    token                  = local.kubeconfig_hcl_tidb_1.users[0].user.token
    cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_1.clusters[0].cluster.certificate-authority-data)
  }
}

provider "helm" {
  alias = "tidb_2"
  kubernetes {
    host                   = local.kubeconfig_hcl_tidb_2.clusters[0].cluster.server
    token                  = local.kubeconfig_hcl_tidb_2.users[0].user.token
    cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_2.clusters[0].cluster.certificate-authority-data)
  }
}

provider "helm" {
  alias = "tidb_3"
  kubernetes {
    host                   = local.kubeconfig_hcl_tidb_3.clusters[0].cluster.server
    token                  = local.kubeconfig_hcl_tidb_3.users[0].user.token
    cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_3.clusters[0].cluster.certificate-authority-data)
  }
}

provider "helm" {
  alias = "kuma_global_cp"
  kubernetes {
    host                   = local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.server
    token                  = local.kubeconfig_hcl_kuma_global_cp.users[0].user.token
    cluster_ca_certificate = base64decode(local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.certificate-authority-data)
  }
}

#configure provide kubectl
provider "kubectl" {
  alias = "tidb_1"
  host                   = local.kubeconfig_hcl_tidb_1.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_1.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_1.clusters[0].cluster.certificate-authority-data)
  load_config_file       = false

}

provider "kubectl" {
  alias = "tidb_2"
  host                   = local.kubeconfig_hcl_tidb_2.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_2.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_2.clusters[0].cluster.certificate-authority-data)
  load_config_file       = false
  
}

provider "kubectl" {
  alias = "tidb_3"
  host                   = local.kubeconfig_hcl_tidb_3.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_tidb_3.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_tidb_3.clusters[0].cluster.certificate-authority-data)
  load_config_file       = false
}

provider "kubectl" {
  alias = "kuma_global_cp"
  host                   = local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl_kuma_global_cp.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl_kuma_global_cp.clusters[0].cluster.certificate-authority-data)
  load_config_file       = false
}