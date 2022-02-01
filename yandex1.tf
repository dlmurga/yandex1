terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.68.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "dlmurga"
    region     = "us-east-1"
    key        = "yandex1.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}

provider "yandex" {
  service_account_key_file = "/root/yandex/key/key.json"
  cloud_id = "b1grueplacatchduatm0"
  folder_id = "b1ga9l1gdb6m45ek99hq"
  zone = "ru-central1-a"
}


resource "yandex_compute_instance" "vm1" {
  name     = "jenkins"
  boot_disk {
    initialize_params {
      size     = "15"
      image_id = "${var.image_id}"
    }
  }
  network_interface {
    nat       = true
    subnet_id = "${var.subnet_id}"
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    ssh-keys = "${var.user}:${file(${var.private_key})}"
  }
  provisioner "local-exec" {
    command = "echo '[${self.name}]' > ${self.name} && echo ${self.network_interface.0.nat_ip_address} >> ${self.name}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.user} -i ${self.name} --private-key ${var.private_key} ${self.name}.yml"
  }
}
resource "yandex_compute_instance" "vm2" {
  name     = "nexus"
  boot_disk {
    initialize_params {
      size     = "15"
      image_id = "${var.image_id}"
    }
  }
  network_interface {
    nat       = true
    subnet_id = "${var.subnet_id}"
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    ssh-keys = "${var.user}:${file(${var.private_key})}"
  }
  provisioner "local-exec" {
    command = "echo '[${self.name}]' > ${self.name} && echo ${self.network_interface.0.nat_ip_address} >> ${self.name}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.user} -i ${self.name} --private-key ${var.private_key} ${self.name}.yml"
  }
}

resource "yandex_compute_instance" "vm3" {
  name     = "app"
  boot_disk {
    initialize_params {
      size     = "15"
      image_id = "${var.image_id}"
    }
  }
  network_interface {
    nat       = true
    subnet_id = "${var.subnet_id}"
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    ssh-keys = "${var.user}:${file(${var.private_key})}"
  }
  provisioner "local-exec" {
    command = "echo '[${self.name}]' > ${self.name} && echo ${self.network_interface.0.nat_ip_address} >> ${self.name}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.user} -i ${self.name} --private-key ${var.private_key} ${self.name}.yml"
  }
}

output "internal_ip_address_vm_jenkins" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}

output "internal_ip_address_vm_nexus" {
  value = yandex_compute_instance.vm2.network_interface.0.ip_address
}

output "internal_ip_address_vm_app" {
  value = yandex_compute_instance.vm3.network_interface.0.ip_address
}

output "external_ip_address_vm_jenkins" {
  value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_nexus" {
  value = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_app" {
  value = yandex_compute_instance.vm3.network_interface.0.nat_ip_address
}