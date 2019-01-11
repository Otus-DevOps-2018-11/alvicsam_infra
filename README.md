# alvicsam_infra
alvicsam Infra repository

### ДЗ Знакомство с облачной инфраструктурой

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
