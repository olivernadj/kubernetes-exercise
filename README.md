# Provisioning kuberentes on DigitalOciean

This provision is setting up server environment for kuberentes on a Digital Ocean droplet. 

## Terraform commands
```bash
terraform init

terraform plan -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/terraform"
terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/terraform"
terraform state pull
```


## Ansible commands
```bash
export ANSIBLE_TF_DIR=../terraform/
ansible-galaxy collection install community.crypto
ansible-playbook -v k8s-master.yaml
```

## Resources for IP security
 - https://javapipe.com/blog/iptables-ddos-protection/
 - https://making.pusher.com/per-ip-rate-limiting-with-iptables/
 - https://github.com/retailnext/iptables_exporter
 - https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/

