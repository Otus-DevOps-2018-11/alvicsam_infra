# alvicsam_infra
alvicsam Infra repository

### ДЗ №3 Знакомство с облачной инфраструктурой

Подключение в одну команду:  
```bash
eval $(ssh-agent -s) > /dev/null
ssh-add
ssh -At bastion_host_external_ip ssh 10.132.0.3
```

Подключение командой `ssh someinternalhost`:  

Создаем файл ~/.ssh/config со следующим содержимым:  
```bash
Host someinternalhost
    HostName 10.132.0.3
    User user
    ProxyCommand ssh user@bastion_host_external_ip nc %h 22 2> /dev/null
```
Подключаемся командой `ssh someinternalhost`

Подключение по vpn:  
bastion_IP = 35.241.140.83  
someinternalhost_IP = 10.132.0.3

### ДЗ №4 Основные сервисы GCP

testapp_IP = 34.76.57.31  
testapp_port = 9292

Запуск инстанса с использованием startup_script:  
```bash
gcloud compute instances create reddit-app\  
--boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
 --metadata-from-file startup-script=~/alvicsam_infra/install.sh 
```

Команда для создания правила firewall через cli:  
```bash
gcloud compute --project=infra-226319 firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```

### ДЗ №5 Работа с packer

Для создания immutable образа воспользоваться командой:
```bash
packer build -var 'project_id=infra-#######' -var 'source_image_family=reddit-base' immutable.json
```

### ДЗ №6 Работа с terraform. Часть 1.

Создан файл main.cf описывающий необходимые ресурсы для создания инстанса приложения.  
Создан файл outputs.tf для отображения нужных нам выходных переменных.  
Переменные описаны в файле variables.tf и заданы в файле terraform.tfvars.  
Применена конфигурация с помощью `terraform apply -auto-approve=true`

Для добавления нескольких ключей ssh в метаданные проекта необходимо создать ресурс:

```
resource "google_compute_project_metadata" "default" {
  metadata {
     ssh-keys = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser3:${file(var.public_key_path)}"
  }
}
```

Проблемы с добавлением нескольких ssh-keys через terraform и веб-морду:  
Terraform после `terraform apply` убирает все изменения, созданные вручную.  

### ДЗ №7 Работа с terraform. Часть 2.

 - Созданы новые образы с помощью packer
 - Файл main.tf разбит на несколько
 - Собраны модули
 - Изменен файервол
 - Созданы окружения
 - Для окружений введены дополнительные переменные именования вм
 - Создан bucket
 - Настроено хранение state в bucket, проверено

storage-bucket.tf:  
```
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name = ["alvic-73902-bucket-prod", "alvic-73902-bucket-stage"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
```

backend.tf (для stage):  
```
terraform {
  backend "gcs" {
    bucket  = "alvic-73902-bucket-stage"
    prefix  = "terraform/state"
  }
}
```
### ДЗ №8 Работа с ansible. Часть 1.

После выполнения `ansible app -m command -a 'rm -rf ~/reddit'` и запуска плейбука ansible вновь склонировал git репозиторий.
Запуск ansible со статическим json инвентори:
```bash
ansible all -i static_inventory.json -m ping
```
Запуск ansible с динамическим json инвентори:
```bash
ansible all -i inventory.sh -m ping
```
В случае динамического json файла группы хостов, чайлдов должны задаваться словарем. Также скрипт, создающий инвентори, должен поддерживать операторы --list и --host <hostname>
