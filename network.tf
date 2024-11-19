resource "yandex_vpc_network" "default" {
  name = "my-vpc-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Создаём NAT-шлюз
resource "yandex_vpc_gateway" "nat_gateway" {
  name    = "nat-gateway"
  folder_id = "b1ghogsb3rjondr2ektf"  # Замените на ваш идентификатор каталога

  shared_egress_gateway {}
}

# Таблица маршрутизации для приватной подсети через NAT-шлюз
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.default.id
  folder_id  = "b1ghogsb3rjondr2ektf"  # Замените на ваш идентификатор каталога

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
