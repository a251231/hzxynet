# -*- coding: utf-8 -*-
import requests, json, base64, hashlib,random
import pymysql
import datetime
import time
from threading import Timer
class report:
    def __init__(self):
        self.usr = 'xxxxxxxxxx'  # 学号
        self.pwd = ''  # 填写密码md5加密过的
#         self.sckey = ''  # Server酱sckey
        #segment自行抓包
        self.segment = 1328616
        now = datetime.datetime.now()
        yestoday = datetime.datetime(2021,3,20)
        segday = (now-yestoday).days
        self.segment += segday
        # 定义一个session()的对象实体s来储存cookie
        self.s = requests.Session()
        self.a = ''
        self.headers = {
            "Host": "222.206.187.250",
            "Connection": "keep-alive",
            "Content-Length": "73",
            "Accept": "application/json, text/plain, */*",
            "Origin": "http://www.skalibrary.com",
            "User-Agent": "Mozilla/5.0 (Linux; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/77.0.3865.120 MQQBrowser/6.2 TBS/045513 Mobile Safari/537.36 MMWEBID/2771 MicroMessenger/8.0.1.1841(0x28000186) Process/tools WeChat/arm64 Weixin NetType/4G Language/zh_CN ABI/arm64",
            "Content-Type": "application/x-www-form-urlencoded;charset\u003dUTF-8",
            "X-Requested-With": "com.tencent.mm",
            "Referer": "http://www.skalibrary.com/",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q\u003d0.9,en-US;q\u003d0.8,en;q\u003d0.7"
        }
            # Server酱通知
    def server(self, text):
        requests.get('http://www.pushplus.plus/send?token=' + self.sckey + '&title=' + text +'&content=祝你生活愉快&template=html&topic=WYY')
    # 模拟登录
    def login(self):
        usr1 = "{\"LoginModel\":1,\"Service\":\"ANT\",\"UserName\":\"%s\"}" % self.usr
        log_url = "http://222.206.187.250/api.php/login"
        data = {
            'username': self.usr.encode().decode('utf-8'),
            'password': self.pwd.encode().decode('utf-8'),
            'from': 'mobile',
        }
        log_page = self.s.post(log_url, headers=self.headers, data=data).text
        # 获取access_token
        try:
            token = json.loads(log_page.strip())["data"]["_hash_"]["access_token"]
            print(token)
        except:
            self.server(self.usr+'密码错误')
            return
        # 更新header
        self.a=token
        self.s.headers.update({'access_token':token})
        print(self.segment)
        requests.get('http://www.pushplus.plus/send?token=' + self.sckey + '&title=' + token +'&content=祝你生活愉快&template=html&topic=jijiehao')
        # 报平安
    def save(self):
        re_url = "http://222.206.187.250/api.php/spaces/5213/book"
        data = {
            "access_token" : self.a.encode().decode('utf-8'),
            "userid" : self.usr.encode().decode('utf-8') ,
            "type" : "1" ,
            "id" : "5213" ,
            "segment" : self.segment,
        }
        # 报平安请求
        re_page = self.s.post(re_url, headers=self.headers, data=data).text

        try:
            decoded = json.loads(re_page.strip())["msg"]
            print(decoded)
            self.server(self.usr+decoded)
        except:
            self.server(self.usr+'seat off')
            return
def main():

        
    print('---------------------------------------')
    re = report()
    re.login()  # 登录
    re.save()
#    re.temp()

# 程序每天运行一下在不关闭后台的情况下
if __name__ == '__main__':
   while True:
        # 打印按指定格式排版的时间
        time2 = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print(time2)
        Timer(0, main, ()).start()
        time.sleep(60*60*24) # 间隔一天
