locals {
  cluster_ca_certificate = google_container_cluster.greenfield-cluster.master_auth[0].cluster_ca_certificate
  endpoint               = google_container_cluster.greenfield-cluster.endpoint
  context                = google_container_cluster.greenfield-cluster.name
  host                   = "https://${local.endpoint}"
}

data "google_client_config" "provider" {}

resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_service_account" "cluster-serviceaccount-new" {
account_id = "cluster-serviceaccount"
display_name = "Service Account For Terraform To Make GKE Cluster"
project = var.project_id
} 

resource "google_compute_network" "greenfield-vpc" {
  name                            = "${var.network_name}-${var.env_name}"
  project                         = var.project_id
  auto_create_subnetworks         = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "greenfield-subnet" {
  name 		= "${var.subnet_name}-public-${var.env_name}"
  project 	= var.project_id
  region  	= var.region
  network 	= google_compute_network.greenfield-vpc.self_link
  ip_cidr_range = var.subnet_cidr
  secondary_ip_range = [
  {
    range_name    = var.pod_range
    ip_cidr_range = var.pod_cidr
    },
    {
    range_name    = var.service_range
    ip_cidr_range = var.service_cidr
    },
    ]
}

resource "google_container_cluster" "greenfield-cluster" {
  name                = var.cluster_name
  location            = var.region
  project             = var.project_id
  remove_default_node_pool = true
  initial_node_count  = 1
  network             = google_compute_network.greenfield-vpc.name
  subnetwork          = google_compute_subnetwork.greenfield-subnet.name
  node_locations           = ["${var.region}-a"]  

  node_config {
    service_account = google_service_account.cluster-serviceaccount-new.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  networking_mode = "VPC_NATIVE"
  cluster_autoscaling {
    enabled = true
    auto_provisioning_defaults {
    service_account = google_service_account.cluster-serviceaccount-new.email
   }  
     resource_limits {
      resource_type = "cpu"
      maximum = 40
      minimum = 3
    }

  resource_limits {
      resource_type = "memory"
      maximum = 100
      minimum = 12
    }
}

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  
  release_channel {
      channel  = "REGULAR"
  }
  workload_identity_config {
    workload_pool     = "${var.project_id}.svc.id.goog"
  }
  ip_allocation_policy {}
  
  master_auth {
  client_certificate_config {
      issue_client_certificate = "true"
    }
  }
}

resource "google_container_node_pool" "greenfield-nodepool" {
  name              = "${var.cluster_name}nodepool"
  cluster           = google_container_cluster.greenfield-cluster.name
  location            = var.region
  initial_node_count  = 1
  project             = var.project_id
  management {
    auto_repair = true
    auto_upgrade = true
  }
 
  node_config {
    preemptible       = true
    machine_type      = "n1-standard-1"
    service_account = google_service_account.cluster-serviceaccount-new.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
  autoscaling {
    min_node_count = "${var.min_node_count}"
    max_node_count = "${var.max_node_count}"
  }
}
