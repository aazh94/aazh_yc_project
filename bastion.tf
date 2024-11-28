resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
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
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      write_files:
        - path: /etc/sysctl.d/99-custom.conf
          content: |
            net.ipv4.ip_forward=1
      runcmd:
        - sysctl --system
        - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    EOF
  }
}
