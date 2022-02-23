#!/bin/bash
while true
do
	ip_array=(
	#抓包获取校园网的ip，应该是
	192.168.2.179
	)
	cycle_num=0
	if [ $# -ge 1 ];then
	  expr $1 + 0 &>/dev/null
	  if [ $? -eq 0 ];then
		cycle_num=$1
	  else 
		logger "循环次数必须为正整数！"
	  fi
	else 
	  cycle_num=1
	fi
	for ((i=0;i<${cycle_num};i++))
	do
		for url in ${ip_array[@]}
		do 
		  echo "--------------------------"
		  ping -c 1 -W 5 $url
		  if [ $? -eq 0 ];then
			logger "你的手机在线，IP为 : ${url}" 
			#(一)检测是否是登录状态
			logger "【Dr.COM网页认证】开始定时检测"
			curl http://172.16.47.2/> drcom.html
			check_status=`grep "Dr.COMWebLoginID_0.htm" drcom.html`
			if [[ $check_status != "" ]]
			then
				#尚未登录
				logger "【Dr.COM网页认证】上网登录窗尚未登录"
				curl -L http://172.16.47.2/> drcom.html
				ip=`egrep -m 1 "172\.20\.([1-9][1-9]|[1-9][1-9][1-9])\.([1-9][1-9]|[1-9][1-9][1-9])" -o drcom.html`
				#md5_login2=%2C0%2C2018XXXXXX%7CXXXXXX; ip=${ip}' --data-raw 'DDDDD=%2C0%2C2018XXXXXX&upass=XXXXXX 下面的这个部分改成自己的
				#curl -X POST 'http://172.16.47.2:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=172.16.47.2&iTermType=1&wlanuserip=172.20.48.124&wlanacip=null&wlanacname=null&mac=00-00-00-00-00-00&ip=172.20.48.124&enAdvert=0&queryACIP=0&loginMethod=1'  -H 'Connection: keep-alive'  -H 'Cache-Control: max-age=0'  -H 'Upgrade-Insecure-Requests: 1'  -H 'Origin: http://172.16.47.2'  -H 'Content-Type: application/x-www-form-urlencoded'  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 Safari/537.36 Edg/89.0.774.45'  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'  -H 'Referer: http://172.16.47.2/'  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6'  -H 'Cookie: program=hzyz; vlan=0; ssid=null; areaID=null; ip=172.20.48.124; md5_login2=%2C0%2C2018XXXXXX%7CXXXXXX; PHPSESSID=8fa9ph48v9i9uu8letlritdgu2' --data-raw 'DDDDD=%2C0%2C2018xxxxxx&upass=xxxxxx&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=' --tlsv1.3 -o Sxinfo.txt
				curl -X POST "http://172.16.47.2:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=172.16.47.2&iTermType=1&wlanuserip=${ip}&wlanacip=null&wlanacname=null&mac=00-00-00-00-00-00&ip=${ip}&enAdvert=0&queryACIP=0&loginMethod=1" -H 'Connection: keep-alive'-H 'Cache-Control: max-age=0' 'Upgrade-Insecure-Requests: 1' -H 'Origin: http://172.16.47.2' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 Safari/537.36 Edg/89.0.774.45' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Referer: http://172.16.47.2/' -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' -H 'Cookie: program=hzyz; vlan=0; ssid=null; areaID=null; md5_login2=%2C0%2C2018XXXXXX%7CXXXXXX; ip=${ip}' --data-raw 'DDDDD=%2C0%2C2018XXXXXX&upass=XXXXXX&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login='  --tlsv1.3 -o Sxinfo.txt
					# 此处为你已修改完毕的curl
				logger "【Dr.COM网页认证】上网登录窗未登录，现已登录"
				curl -X POST 'http://www.pushplus.plus/send?token=ffc322e4a94b424384c4bebf163c0bc4' --data-binary '&title=路由器复活啦&content=主人路由器上线啦~&template=html&topic=JD666'
				curl -s "https://api.telegram.org/bot1606397581:AAGsbztb-5KT3xDiHz0btWmy-qaXmWMTgGE/sendMessage?chat_id=975169504" --data-binary "&text=【openwrt联网状态】当前路由器未联网，已执行登录。当前时间 ""`date`" &
				logger "【Dr.COM网页认证】已通过 Telegram Bot 发送当前时间"
			else
				#已经登录
				logger "【Dr.COM网页认证】上网登录窗之前已登录"
				#下面可使用推送渠道推送，个人感觉无用弃用
				#curl -s "https://api.telegram.org/bot1606397581:" --data-binary "&text=【openwrt联网状态】当前路由器之前已登录，无需执行登录。当前时间 ""`date`" &
				#logger "【Dr.COM网页认证】已通过 Telegram Bot 发送当前时间"
				sleep 240
			fi
			logger "【Dr.COM网页认证】结束定时检测"
		  else 
			logger "你的手机离线 ${url}"
			sleep 30
			
		  fi
		  echo "--------------------------"
		  echo ""
		done
	done
done