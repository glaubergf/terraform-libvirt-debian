/*NOTAS:

  NOTA 1: Caso ha3a um erro similar como por exemplo:

    Error: "...Could not open '/opt/kvm/pool1/debian-qcow2': Permission denied"
    Error: "error creating libvirt domain: internal error: process exited while connecting to monitor: ..."

  Deverá habiltar a linha descomentando-a deixando com o valor como 'security_driver = none' no arquivo '/etc/libvirt/qemu.conf'.
  Em seguida deverá ser reiniciado o deamon 'libvirtd'.
  Fonte: https://stackoverflow.com/questions/63984912/coreos-image-fails-to-load-ignition-file-via-libvirt-permission-denied/70563027#70563027

  ==============

  NOTA 2: Qual é o nome de usuário padrão nas imagens de nuvem do Debian?

  O nome de usuário padrão difere com base no ambiente de nuvem. Por favor, ve3a https://wiki.debian.org/Cloud/SystemsComparison 
  para mais informações. A autenticação é feita por meio da chave ssh instalada pelo cloud-init. 
  Não há senha. Essas contas podem se tornar root executando (sem necessidade de senha):
  $ sudo -i
  Fonte: https://wiki.debian.org/Cloud

  ==============

  NOTA 3: Video YouTube Terraform com KVM/Libvirt
  Fonte: https://www.youtube.com/watch?v=u36PQD2n1vU&ab_channel=SavantTecnologia

  ==============

  More references:
  https://blog.ruanbekker.com/blog/2020/10/08/using-the-libvirt-provisioner-with-terraform-for-kvm/
  https://www.desgehtfei.net/en/quick-start-kvm-libvirt-vms-with-terraform-and-ansible-part-1-2/
  https://github.com/dmacvicar/terraform-provider-libvirt
  https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs
  https://blog.stephane-robert.info/post/terraform-provider-libvirt/
  https://blog.stephane-robert.info/post/terraform-libvirt-resize-image/
*/

provider "libvirt" {
  uri = "qemu:///system"
  #uri = "qemu+ssh://root@192.168.121.200/system"
}

resource "libvirt_pool" "debian" {
  name = "debian"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_volume" "debian-base" {
  name   = "debian-base"
  source = var.debian_11_qcow2_url
  pool   = libvirt_pool.debian.name
  format = "qcow2"
}

resource "libvirt_volume" "debian-qcow2" {
  name           = "debian-qcow2"
  base_volume_id = libvirt_volume.debian-base.id
  pool           = libvirt_pool.debian.name
  size           = var.vm_vol_size.size
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.yml")
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.yml")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.debian.name
}

resource "libvirt_domain" "domain-debian" {
  name   = var.vm_hostname
  memory = var.vm_memory
  vcpu   = var.vm_cpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  cpu {
    mode = "host-passthrough"
  }

  autostart = true

  disk {
    volume_id = libvirt_volume.debian-qcow2.id
    scsi      = "true"
  }

  network_interface {
    network_name   = "libvirt"
    wait_for_lease = true
    hostname       = var.vm_hostname
    addresses      = var.vm_ip
    mac            = var.vm_mac.mac
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  connection {
    type                = "ssh"
    user                = var.ssh_username
    host                = libvirt_domain.domain-debian.network_interface[0].addresses[0]
    private_key         = file(var.ssh_private_key)
    bastion_host        = var.vm_hostname
    bastion_user        = var.vm_user
    bastion_private_key = file("~/.ssh/id_rsa")
    timeout             = "1m"
  }
}
