data "template_file" "user_data" {
  template = file("./cloud-config.yaml")
}

resource "digitalocean_droplet" "k8s-master" {
  image = "ubuntu-20-04-x64"
  name = "sandbox-k8s-master"
  region = "fra1"
  size = "s-2vcpu-4gb-amd"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = data.template_file.user_data.rendered
}

resource "ansible_host" "k8s-master" {
    inventory_hostname = digitalocean_droplet.k8s-master.ipv4_address
    groups = ["k8s_master"]
    vars = {
      ansible_user = "root"
      ansible_port =  "1983"
      ansible_ssh_private_key_file = "~/.ssh/terraform"
    }
}
