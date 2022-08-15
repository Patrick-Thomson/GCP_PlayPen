terraform {
  backend "remote" {
    organization = "lbg-cloud-platform"

    workspaces {
      name = var.workspace_id
    }
  }
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"    
    }
  }
}


provider "google" {
  #credentials = file("firstKey.json")
  region  = var.gcp_region
  project = var.project_id
 
}

data "google_compute_zones" "available_zones" {}

resource "google_compute_address" "static" {
  name = "apache"
}

resource "google_compute_network" "default" {
  name = var.network_name
}


##Create a small vm and install apache
resource "google_compute_instance" "apache" {
  name = "apache"
  zone = data.google_compute_zones.available_zones.names[0]
  tags =  ["allow-http"]

  machine_type = "e2-micro"

boot_disk {
  initialize_params {
    image ="ubuntu-os-cloud/ubuntu-1804-bionic-v20220712" 
  }

}

network_interface {
  network = google_compute_network.default.id
  access_config {
   # nat_ip = google_compute_address.static.address
  }
}

  ##add a startup script to install apache
  metadata_startup_script = file("startup_script.sh")
}


##Create firewal using tag
resource "google_compute_firewall" "allow_http" {
  name = "allow-http-rule"
  network = google_compute_network.default.id

  allow {
    ports = ["80"]
    protocol= "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-http"]

  priority = 1000
  
}

output "public_ip_address" {
  value = google_compute_address.static.address
}
