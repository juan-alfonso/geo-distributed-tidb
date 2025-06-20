variable "linode_token" {
  default = ""
  type = string
  sensitive   = true
}

variable "lke_worker_node_type" {
  description = "Instance type for worker nodes LKE pool"
  default = "g6-standard-2"
  type = string
}


variable "lke_worker_node_count" {
  description = "Number of nodes in worker pool"
  default     = 3
  type        = number
}


variable "lke_version" {
  description = "Kubernetes version"
  default     = 1.32
  type        = number
}

variable "region_lke_tidb_1" {
  description = "Default region to use for the tidb 1 cluster"
  default = ""
  type = string
}

variable "region_lke_tidb_2" {
  description = "Default region to use for the tidb 2 cluster"
  default = ""
  type = string
}

variable "region_lke_tidb_3" {
  description = "Default region to use for the tidb 3 cluster"
  default = ""
  type = string
}

variable "region_lke_kuma_global_cp" {
  description = "Default region to use for the kuma global cp cluster"
  default = ""
  type = string
}

variable "tidb_operator_crds_url" {
  description = "URL for the TiDB operator CRDs"
  default = "https://raw.githubusercontent.com/pingcap/tidb-operator/v1.6.1/manifests/crd.yaml"
  type = string
}

variable "kuma_version" {
  description = "Default kuma version"
  default = "2.10.0"
  type = string
}
