output "load_balancer_ip" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address
}



output "web_server_private_ips" {
  value = [
    yandex_compute_instance.web_server[0].network_interface[0].ip_address,
    yandex_compute_instance.web_server[1].network_interface[0].ip_address,
  ]
}
