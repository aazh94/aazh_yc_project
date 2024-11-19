resource "yandex_compute_instance" "web_server" {
  count       = 2
  name        = "web-server-${count.index}"
  hostname    = "web-server-${count.index}"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      hostname: web-server-${count.index}
      fqdn: web-server-${count.index}.ru-central1.internal
    EOF
  }
}
