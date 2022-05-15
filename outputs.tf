output "greenfield-vpc" {
  value       = google_compute_network.greenfield-vpc
}

output "greenfield-vpc_name" {
  value       = google_compute_network.greenfield-vpc.name
}

output "greenfield-vpc_id" {
  value       = google_compute_network.greenfield-vpc.id
}

output "greenfield-vpc_self_link" {
  value       = google_compute_network.greenfield-vpc.self_link
}

output "cluster_ca_certificate" {
    value = base64decode(local.cluster_ca_certificate)
}

output "cluster_name" {
    value = google_container_cluster.greenfield-cluster.name
}

output "cluster_id" {
    value = google_container_cluster.greenfield-cluster.id
}

output "endpoint" {
    value = google_container_cluster.greenfield-cluster.endpoint
}

output "host" {
    value = local.host
}

output "token" {
    value = data.google_client_config.provider.access_token
    sensitive = true
}

output "kube_config" {
    value = templatefile("./kubeconfig.yaml.tpl", {
        cluster_ca_certificate  = local.cluster_ca_certificate
        context                 = local.context
        endpoint                = local.endpoint
        token                   = data.google_client_config.provider.access_token
    })
    sensitive = true
}