variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pool1"
}

variable "debian_11_qcow2_url" {
  description = "debian 11 bullseye image"
  default     = "https://cloud.debian.org/images/cloud/bullseye/20220328-962/debian-11-generic-amd64-20220328-962.qcow2"
  #fonte da imagem: https://cloud.debian.org/images/cloud/
}

variable "vm_hostname" {
  description = "hostname of vm"
  default     = "tf-kvm-zabbix"
}

variable "vm_vol_size" {
  description = "size of vm disc"
  default     = { disksize = "10737418240" } # in byte is 10737418240 == 10 GB 
}

variable "vm_memory" {
  description = "vm memory available"
  default     = "2048"
}

variable "vm_cpu" {
  description = "vm cpus available"
  default     = "2"
}

/*variable "vm_ip" {
  description = "ip of vm"
  default     = ["192.168.121.200"]
*/

variable "ssh_username" {
  description = "the ssh user to use"
  default     = "mcnd2"
}

variable "ssh_private_key" {
  description = "the private key to use"
  default     = "~/.ssh/debiandesk_id_rsa"
}