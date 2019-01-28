#!/bin/bash
TFPATH=~/DevOps/alvicsam_infra/terraform/stage
cd $TFPATH

get_vm_ip(){
        ip=`terraform output $1`
        echo $ip
}

APP_IP=$(get_vm_ip "app_external_ip")
DB_IP=$(get_vm_ip "db_external_ip")
DB_INT_IP=$(get_vm_ip "db_internal_ip")

echo -e {
echo -e     "\t\"app\": {"
echo -e       "\t\t \"hosts\": [\"appserver\"],"
echo -e        "\t\t\"vars\": {"
echo -e            "\t\t\t\"ansible_host\": \"$APP_IP\""
echo -e        " \t\t}"
echo -e    "\t},"
echo -e    "\t\"db\": {"
echo -e        "\t\t\"hosts\": [\"dbserver\"],"
echo -e       "\t\t \"vars\": {"
echo -e           "\t\t\t \"ansible_host\": \"$DB_IP\""
echo -e        "\t\t}"
echo -e   "\t },"
echo -e     "\t\"_meta\": {"
echo -e        "\t\t\"hostvars\": {"
echo -e         "\t\t\t\"appserver\": {"
echo -e                "\t\t\t\t\"db_host\":\"$DB_INT_IP\""
echo -e	"\t\t\t}"
echo -e	"\t\t}"
echo -e	"\t}"
echo -e }

