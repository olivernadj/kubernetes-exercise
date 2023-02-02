terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}

variable "region" {
  description = "DigitalOcean region"
  default = "fra1"
}
variable "droplet_image" {
  description = "DigitalOcean droplet image name"
  default = "ubuntu-20-04-x64"
}
variable "droplet_size" {
  description = "Droplet size for server"
  default = "s-1vcpu-2gb-amd"
}
variable private_networking {
  default = "false"
}

variable "do_token" {}

variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}