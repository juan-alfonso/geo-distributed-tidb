resource "linode_lke_cluster" "kuma_global_cp" {
    label       = "${var.region_lke_kuma_global_cp}-kuma-global-cp"
    k8s_version = var.lke_version
    region      = var.region_lke_kuma_global_cp
    tags        = ["app:tidb-geo-cluster"]
    
    pool {
        type  = "g6-standard-2"
        count = 2
    }
}

resource "linode_lke_cluster" "tidb_1" {
    label       = "${var.region_lke_tidb_1}-tidb-1"
    k8s_version = var.lke_version
    region      = var.region_lke_tidb_1
    tags        = ["app:tidb-geo-cluster"]

    control_plane {
      high_availability = true
    }
    
    pool {
        type  = var.lke_worker_node_type
        count = var.lke_worker_node_count
    }
}

resource "linode_lke_cluster" "tidb_2" {
    label       = "${var.region_lke_tidb_2}-tidb-2"
    k8s_version = var.lke_version
    region      = var.region_lke_tidb_2
    tags        = ["app:tidb-geo-cluster"]

    control_plane {
      high_availability = true
    }
    
    pool {
        type  = var.lke_worker_node_type
        count = var.lke_worker_node_count
        
    }
}

resource "linode_lke_cluster" "tidb_3" {
    label       = "${var.region_lke_tidb_3}-tidb-3"
    k8s_version = var.lke_version
    region      = var.region_lke_tidb_3
    tags        = ["app:tidb-geo-cluster"]

    control_plane {
      high_availability = true
    }
    
    pool {
        type  = var.lke_worker_node_type
        count = var.lke_worker_node_count
        
    }
}
