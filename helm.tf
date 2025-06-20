#Helm chart Kuma global CP
resource "helm_release" "kuma_global_cp" {
  provider = helm.kuma_global_cp
  name       = "kuma"
  repository = "https://kumahq.github.io/charts"
  chart      = "kuma"
  version = var.kuma_version
  create_namespace = true
  namespace = "kuma-system"

  values = [<<YAML
controlPlane:
  mode: global
YAML
  ]
}

#Helm chart Kuma-1
resource "helm_release" "kuma_1" {
  provider = helm.tidb_1
  name       = "kuma"
  repository = "https://kumahq.github.io/charts"
  chart      = "kuma"
  version = var.kuma_version
  create_namespace = true
  namespace = "kuma-system"

  values = [<<YAML
controlPlane:
  mode: zone
  zone: ${var.region_lke_tidb_1}
  kdsGlobalAddress: grpcs://${data.kubernetes_service.kuma_global_cp.status.0.load_balancer.0.ingress[0].ip}:5685
  tls:
    kdsZoneClient:
      skipVerify: true

ingress:
  enabled: true
YAML
  ]

  depends_on = [ helm_release.kuma_global_cp, data.kubernetes_service.kuma_global_cp ]
}

#Helm chart Kuma-2
resource "helm_release" "kuma_2" {
  provider = helm.tidb_2
  name       = "kuma"
  repository = "https://kumahq.github.io/charts"
  chart      = "kuma"
  version = var.kuma_version
  create_namespace = true
  namespace = "kuma-system"

  values = [<<YAML
controlPlane:
  mode: zone
  zone: ${var.region_lke_tidb_2}
  kdsGlobalAddress: grpcs://${data.kubernetes_service.kuma_global_cp.status.0.load_balancer.0.ingress[0].ip}:5685
  tls:
    kdsZoneClient:
      skipVerify: true

ingress:
  enabled: true
YAML
  ]

  depends_on = [ helm_release.kuma_global_cp, data.kubernetes_service.kuma_global_cp ]
}

#Helm chart Kuma-3
resource "helm_release" "kuma_3" {
  provider = helm.tidb_3
  name       = "kuma"
  repository = "https://kumahq.github.io/charts"
  chart      = "kuma"
  version = var.kuma_version
  create_namespace = true
  namespace = "kuma-system"

  values = [<<YAML
controlPlane:
  mode: zone
  zone: ${var.region_lke_tidb_3}
  kdsGlobalAddress: grpcs://${data.kubernetes_service.kuma_global_cp.status.0.load_balancer.0.ingress[0].ip}:5685
  tls:
    kdsZoneClient:
      skipVerify: true

ingress:
  enabled: true
YAML
  ]

  depends_on = [ helm_release.kuma_global_cp, data.kubernetes_service.kuma_global_cp ]
}


########################################

#Helm chart tidb 1
resource "helm_release" "tidb_1" {
  provider = helm.tidb_1
  name       = "tidb"
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  create_namespace = true
  namespace = "tidb-admin"
}

#Helm chart tidb 2
resource "helm_release" "tidb_2" {
  provider = helm.tidb_2
  name       = "tidb"
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  create_namespace = true
  namespace = "tidb-admin"
}

#Helm chart tidb 3
resource "helm_release" "tidb_3" {
  provider = helm.tidb_3
  name       = "tidb"
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  create_namespace = true
  namespace = "tidb-admin"
}

