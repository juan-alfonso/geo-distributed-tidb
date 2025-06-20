#Create namespace of each k8s
resource "kubernetes_namespace" "tidb_namespace_1" {
  provider = kubernetes.tidb_1
  metadata {
    name = "tidb"

    labels = {
      # This label enables Kuma sidecar injection
      "kuma.io/sidecar-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "tidb_namespace_2" {
  provider = kubernetes.tidb_2
  metadata {
    name = "tidb"

    labels = {
      # This label enables Kuma sidecar injection
      "kuma.io/sidecar-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "tidb_namespace_3" {
  provider = kubernetes.tidb_3
  metadata {
    name = "tidb"

    labels = {
      # This label enables Kuma sidecar injection
      "kuma.io/sidecar-injection" = "enabled"
    }
  }
}

#Create TiDB cluster on each k8s
resource "kubectl_manifest" "tidb_cluster_1" {
  provider = kubectl.tidb_1
  yaml_body = <<YAML
apiVersion: pingcap.com/v1alpha1
kind: TidbCluster
metadata:
  name: cluster-${var.region_lke_tidb_1}
  namespace: tidb
spec:
  version: v8.5.0
  timezone: UTC
  pvReclaimPolicy: Delete
  enableDynamicConfiguration: true
  configUpdateStrategy: RollingUpdate
  acrossK8s: true
  clusterDomain: "cluster.local"
  discovery: {}
  pd:
    baseImage: pingcap/pd
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: |
      [replication]
      location-labels = ["region", "host"]
  tikv:
    baseImage: pingcap/tikv
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: {}
  tidb:
    baseImage: pingcap/tidb
    maxFailoverCount: 0
    replicas: 3
    service:
      type: ClusterIP
    config: {}
YAML

  depends_on = [ helm_release.tidb_1, kubernetes_namespace.tidb_namespace_1, helm_release.kuma_1 ]
}

#Wait for tidb-1 to be ready
resource "time_sleep" "wait_240_seconds" {
  depends_on = [kubectl_manifest.tidb_cluster_1]

  create_duration = "240s"
}

resource "kubectl_manifest" "tidb_cluster_2" {
  provider = kubectl.tidb_2
  yaml_body = <<YAML
apiVersion: pingcap.com/v1alpha1
kind: TidbCluster
metadata:
  name: cluster-${var.region_lke_tidb_2}
  namespace: tidb
spec:
  version: v8.5.0
  timezone: UTC
  pvReclaimPolicy: Delete
  enableDynamicConfiguration: true
  configUpdateStrategy: RollingUpdate
  acrossK8s: true
  clusterDomain: "cluster.local"
  cluster:
    name: "cluster-${var.region_lke_tidb_1}"
    namespace: "tidb"
  discovery: {}
  pd:
    baseImage: pingcap/pd
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: |
      [replication]
        location-labels = ["region", "host"]
  tikv:
    baseImage: pingcap/tikv
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: {}
  tidb:
    baseImage: pingcap/tidb
    maxFailoverCount: 0
    replicas: 3
    service:
      type: ClusterIP
    config: {}
YAML

  depends_on = [ time_sleep.wait_240_seconds, helm_release.tidb_2, kubectl_manifest.tidb_cluster_1, kubernetes_namespace.tidb_namespace_2 ]
}

resource "kubectl_manifest" "tidb_cluster_3" {
  provider = kubectl.tidb_3
  yaml_body = <<YAML
apiVersion: pingcap.com/v1alpha1
kind: TidbCluster
metadata:
  name: cluster-${var.region_lke_tidb_3}
  namespace: tidb
spec:
  version: v8.5.0
  timezone: UTC
  pvReclaimPolicy: Delete
  enableDynamicConfiguration: true
  configUpdateStrategy: RollingUpdate
  acrossK8s: true
  clusterDomain: "cluster.local"
  cluster:
    name: "cluster-${var.region_lke_tidb_1}"
    namespace: "tidb"
  discovery: {}
  pd:
    baseImage: pingcap/pd
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: |
      [replication]
        location-labels = ["region", "host"]
  tikv:
    baseImage: pingcap/tikv
    maxFailoverCount: 0
    replicas: 3
    requests:
      storage: "10Gi"
    config: {}
  tidb:
    baseImage: pingcap/tidb
    maxFailoverCount: 0
    replicas: 3
    service:
      type: ClusterIP
    config: {}
YAML

  depends_on = [ time_sleep.wait_240_seconds ,helm_release.tidb_3, kubectl_manifest.tidb_cluster_1, kubernetes_namespace.tidb_namespace_3 ]
}

#Create Tidb Dashboard in primary k8s cluster
resource "kubectl_manifest" "tidb_dashboard_cluster_1" {
  provider = kubectl.tidb_1
  yaml_body = <<YAML
apiVersion: pingcap.com/v1alpha1
kind: TidbDashboard
metadata:
  name: basic-dashboard
  namespace: tidb
spec:
  baseImage: pingcap/tidb-dashboard
  clusters:
    - name: cluster-${var.region_lke_tidb_1}
      namespace: tidb
      clusterDomain: "cluster.local"
  requests:
    storage: 10Gi
  env:
    - name: TIDB_OVERRIDE_ENDPOINT
      value: "cluster-${var.region_lke_tidb_1}-tidb.tidb.svc.cluster.local:4000"
    - name: TIDB_OVERRIDE_STATUS_ENDPOINT
      value: "cluster-${var.region_lke_tidb_1}-tidb.tidb.svc.cluster.local:10080"
YAML

  depends_on = [ time_sleep.wait_240_seconds, kubectl_manifest.tidb_cluster_1, kubernetes_namespace.tidb_namespace_1 ]
}