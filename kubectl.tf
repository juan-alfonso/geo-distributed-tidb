#Apply the tidb CRDs
resource "kubectl_manifest" "tidb_crds_1" {
  provider = kubectl.tidb_1
  for_each = local.crd_docs_map

  # Each `each.value` is one YAML document (string) without the '---' separators.
  yaml_body = each.value

  server_side_apply = true
  force_conflicts    = true
}

resource "kubectl_manifest" "tidb_crds_2" {
  provider = kubectl.tidb_2
  for_each = local.crd_docs_map

  # Each `each.value` is one YAML document (string) without the '---' separators.
  yaml_body = each.value

  server_side_apply = true
  force_conflicts    = true
}

resource "kubectl_manifest" "tidb_crds_3" {
  provider = kubectl.tidb_3
  for_each = local.crd_docs_map

  # Each `each.value` is one YAML document (string) without the '---' separators.
  yaml_body = each.value

  server_side_apply = true
  force_conflicts    = true
}

#Apply Kuma mesh config
resource "kubectl_manifest" "kuma_mesh" {
  provider = kubectl.kuma_global_cp
  yaml_body = <<YAML
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  meshServices:
    mode: Exclusive
  mtls:
    enabledBackend: ca-1
    backends:
      - name: ca-1
        type: builtin
        mode: PERMISSIVE
        dpCert:
          rotation:
            expiration: 1d
        conf:
          caCert:
            RSAbits: 2048
            expiration: 10y
YAML

  depends_on = [ helm_release.kuma_global_cp ]
}

resource "kubectl_manifest" "kuma_mesh_traffic_permission" {
  provider = kubectl.kuma_global_cp
  yaml_body = <<YAML
apiVersion: kuma.io/v1alpha1
kind: MeshTrafficPermission
metadata:
  name: allow-all
  namespace: kuma-system
  labels:
    kuma.io/mesh: default
spec:
  from:
  - targetRef:
      kind: Mesh
    default:
      action: Allow
YAML

  depends_on = [ helm_release.kuma_global_cp ]
}

resource "kubectl_manifest" "kuma_hostnamegenerator_headless" {
  provider = kubectl.kuma_global_cp
  yaml_body = <<YAML
apiVersion: kuma.io/v1alpha1
kind: HostnameGenerator
metadata:
  annotations:
    kuma.io/display-name: synced-headless-kube-mesh-service-without-zone
  labels:
    k8s.kuma.io/namespace: kuma-system
    kuma.io/mesh: ''
  name: synced-headless-kube-mesh-service-without-zone
  namespace: kuma-system
spec:
  selector:
    meshService:
      matchLabels:
        k8s.kuma.io/is-headless-service: 'true'
        kuma.io/env: kubernetes
        kuma.io/origin: global
  template: >-
    {{ label "statefulset.kubernetes.io/pod-name" }}.{{ label
    "k8s.kuma.io/service-name" }}.{{ .Namespace }}.svc.cluster.local
YAML

  depends_on = [ helm_release.kuma_global_cp ]
}

resource "kubectl_manifest" "kuma_hostnamegenerator_clusterip" {
  provider = kubectl.kuma_global_cp
  yaml_body = <<YAML
apiVersion: kuma.io/v1alpha1
kind: HostnameGenerator
metadata:
  annotations:
    kuma.io/display-name: synced-headless-kube-mesh-service-as-clusterip
  labels:
    k8s.kuma.io/namespace: kuma-system
    kuma.io/mesh: ''
  name: synced-headless-kube-mesh-service-as-clusterip
  namespace: kuma-system
spec:
  selector:
    meshService:
      matchLabels:
        k8s.kuma.io/is-headless-service: 'true'
        kuma.io/env: kubernetes
        kuma.io/origin: global
  template: >-
    {{ label "k8s.kuma.io/service-name" }}.{{ .Namespace }}.svc.cluster.local
YAML

  depends_on = [ helm_release.kuma_global_cp ]
}




