terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "b1g10uoej2sc4a2q2iii"
  folder_id = "b1ghogsb3rjondr2ektf"
  zone      = "ru-central1-a"
  
}
