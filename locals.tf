locals {
  #tidb-1 LKE
  kubeconfig_yaml_tidb_1 = base64decode(linode_lke_cluster.tidb_1.kubeconfig)
  kubeconfig_hcl_tidb_1  = yamldecode(local.kubeconfig_yaml_tidb_1)

  #tidb-2 LKE
  kubeconfig_yaml_tidb_2 = base64decode(linode_lke_cluster.tidb_2.kubeconfig)
  kubeconfig_hcl_tidb_2  = yamldecode(local.kubeconfig_yaml_tidb_2)

  #tidb-3 LKE
  kubeconfig_yaml_tidb_3 = base64decode(linode_lke_cluster.tidb_3.kubeconfig)
  kubeconfig_hcl_tidb_3  = yamldecode(local.kubeconfig_yaml_tidb_3)

  #kuma-global-cp LKE
  kubeconfig_yaml_kuma_global_cp = base64decode(linode_lke_cluster.kuma_global_cp.kubeconfig)
  kubeconfig_hcl_kuma_global_cp  = yamldecode(local.kubeconfig_yaml_kuma_global_cp)

  #TiDB CRDS
  # Split on the literal separator `---`.
  raw_docs = split("---", data.http.tidb_crds.response_body)

  # Trim whitespace from each doc and filter out empty strings
  crd_docs = [
    for doc in local.raw_docs :
    trimspace(doc)
    if length(trimspace(doc)) > 0
  ]

  # Map each document to a unique key, e.g. "doc0", "doc1", ...
  crd_docs_map = {
    for idx, doc in local.crd_docs :
    "doc${idx}" => doc
  }
}

#Retrieve LoadBalancer IP address
data "kubernetes_service" "kuma_global_cp" {
  provider = kubernetes.kuma_global_cp
  metadata {
    name = "kuma-global-zone-sync"
    namespace = "kuma-system"
  }

  depends_on = [ helm_release.kuma_global_cp ]
}

#tidb crds
data "http" "tidb_crds" {
  url = var.tidb_operator_crds_url
}
