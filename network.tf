resource "yandex_vpc_network" "default" {
  name = "my-vpc-network"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

# Приватные подсети в разных зонах
resource "yandex_vpc_subnet" "private" {
  count          = 2
  name           = "private-subnet-${count.index}"
  zone           = var.web_server_zones[count.index]
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = [cidrsubnet("10.0.${count.index + 1}.0/24", 0, 0)]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# NAT-шлюз
resource "yandex_vpc_gateway" "nat_gateway" {
  name      = "nat-gateway"
  folder_id = var.folder_id

  shared_egress_gateway {}
}

# Таблица маршрутов для приватных подсетей
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.default.id
  folder_id  = var.folder_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

