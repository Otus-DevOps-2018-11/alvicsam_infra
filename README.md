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
