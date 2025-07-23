#!/bin/bash#!/bin/bash

md5() {
    echo -n "$1" | md5sum | cut -d ' ' -f 1
}

response_headers=$(curl -X POST \
  http://192.168.32.1/goform/goform_set_cmd_process \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'Host: 192.168.32.1' \
  -H 'Origin: http://192.168.32.1' \
  -H 'Referer: http://192.168.32.1/index.html' \
  -H 'X-Requested-With: XMLHttpRequest' \
 --data 'isTest=false&goformId=LOGIN&password=0394EEA3799CCCC752A3B81D0D21979249F7984204C3AFD28207CFF6B7683F71' \
  -i)

cookie=$(echo "$response_headers" | grep -i '^Set-Cookie:' | sed -n 's/.*zwsd="\([^;]*\).*/\1/p')

unixTimestamp=$(date +%s)

get_data=$(curl -X POST \
  http://192.168.32.1/goform/goform_get_cmd_process \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Connection: keep-alive' \
  -H "$(echo 'Cookie: "zwsd="'"$cookie")" \
  -H 'Host: 192.168.32.1' \
  -H 'Origin: http://192.168.32.1' \
  -H 'Referer: http://192.168.32.1/index.html' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --data "isTest=false&cmd=wa_inner_version,cr_version,RD&multi_data=1&_=${unixTimestamp}"
)

get_rd=$(echo "$get_data" | jq -r -c '.RD')
get_wa_inner_version=$(echo "$get_data" | jq -r -c '.wa_inner_version')
get_cr_version=$(echo "$get_data" | jq -r -c '.cr_version')


prefix=$get_wa_inner_version$get_cr_version
md5_prefix=$(md5 "$prefix")
string=$md5_prefix$get_rd
md5_hash=$(md5 "$string")

#############  SEND REBOOT COMMAND  ######################################

curl -X POST \
  http://192.168.32.1/goform/goform_set_cmd_process \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Connection: keep-alive' \
  -H "$(echo 'Cookie: "zwsd="'"$cookie")" \
  -H 'Host: 192.168.32.1' \
  -H 'Origin: http://192.168.32.1' \
  -H 'Referer: http://192.168.32.1/index.html' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --data "isTest=false&goformId=REBOOT_DEVICE&AD=$md5_hash"


