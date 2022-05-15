variable "project_id" {  
default = "stellar-lock-347017"
type = string
}

variable "network_name" {
default = "greenfield-vpc"
}

variable "region" {
default = "us-central1"
type = string
}

variable "project_name" {
default = "greenfield-project"
type = string
}

variable "auto_create_subnetworks" {
type        = bool
default     = false
}

variable "subnet_cidr" {
default = "10.10.0.0/16"
type = string
}

variable "pod_range" {
default = "greenfield-pod"
type = string
}

variable "pod_cidr" {
default = "10.20.0.0/16"
type = string
}

variable "service_range" {
default = "greenfield-service"
type = string
}

variable "service_cidr" {
type = string
default = "10.30.0.0/16"
}

variable "env_name" {
default = "dev"
type = string
}

variable "subnet_name" {
default = "greenfield-subnet"
type = string
}


variable "cluster_name" {
default = "greenfield-gke-cluster"
type = string
}

variable "min_node_count" {
default = "1"
type = string
}

variable "max_node_count" {
default = "3"
type = string
}

variable "cluster-serviceaccount" {
default = "kubernetes-new"
type = string
}

variable "router_name" {
default = "greenfield-router"
type = string
}

variable "nat_name" {
default = "greenfield-nat"
type = string
}
