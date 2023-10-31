'''Author: TienNH17
Date: 1/08/2019
Description: Chuyen sip acc thanh sip trunk va nguoc lai, truong hop tach HD con
'''

#!/usr/bin/python
# -*- coding: UTF-8 -*

import requests
import json
import sys
import time
import random
import datetime
import string
from optparse import OptionParser, Option
import HTMLParser
from re import finditer
from macpath import split
import mysql.connector
from mysql.connector import cursor
import re


url_read_account = "http://localhost:8888/daml/account/read_test"
url_read_address = "http://localhost:8888/daml/address/read_test"
url_read_siptrunk = "http://localhost:8888/daml/siptrunk/read_test"
url_read_ruleset = "http://localhost:8888/daml/ruleset/read_test"
url_create_trunk = "http://localhost:8888/daml/siptrunk/write_test"
url_write_account = "http://localhost:8888/daml/account/write_test"
url_write_address = "http://localhost:8888/daml/address/write_test" 
url_write_ruleset = "http://localhost:8888/daml/ruleset/write_test"
hcm_url_read_account = "http://localhost:8888/daml/account/read/hcm"
hcm_url_read_address = "http://localhost:8888/daml/address/read/hcm"
hcm_url_read_siptrunk = "http://localhost:8888/daml/siptrunk/read/hcm"
hcm_url_read_ruleset = "http://localhost:8888/daml/ruleset/read/hcm"
hcm_url_create_trunk = "http://localhost:8888/daml/siptrunk/write/hcm"
hcm_url_write_account = "http://localhost:8888/daml/account/write/hcm"
hcm_url_write_address = "http://localhost:8888/daml/address/write/hcm"
hni_url_read_account = "http://localhost:8888/daml/account/read/hni"
hni_url_read_address = "http://localhost:8888/daml/address/read/hni"
hni_url_read_siptrunk = "http://localhost:8888/daml/siptrunk/read/hni"
hni_url_read_ruleset = "http://localhost:8888/daml/ruleset/read/hni"
hni_url_create_trunk = "http://localhost:8888/daml/siptrunk/write/hni"
hni_url_write_account = "http://localhost:8888/daml/account/write/hni"
hni_url_write_address = "http://localhost:8888/daml/address/write/hni"
url_read_siptrunk_cpe = "http://localhost:8888/daml/siptrunk/sipcontact/read"

def split_Response (response):
    listResponse = []
    if "ok" in response:
        regex = r"({.*}),({.*})"
        matches = re.search(regex, response)
        if matches :
            for group in matches.groups():
                listResponse.append(group)
            return listResponse
    else:
        print("Khong nhan duoc gia tri ")
        sys.exit

def timenow():
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now

def random_password(y):
    return "".join(random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}()") for x in range(y))

def isSipAccount(account):#
    try:
        xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_read_siptrunk,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[0]
        if "ok" in HCM_response and "ok" in HNI_response :
            if '''<sipTrunk>''' in HCM_response and '''<sipTrunk>''' in HNI_response:
                print "Account dang la SIP TRUNK " + account
                return False
            elif '''<sipTrunk>''' in HCM_response and '''<sipTrunk>''' not in HNI_response:
                print "Account khong dong bo tren he thong " + account
                sys.exit()
            elif '''<sipTrunk>''' not in HCM_response and '''<sipTrunk>''' in HNI_response:
                print "Account khong dong bo tren he thong " + account
                sys.exit()
            else:
                print "Account dang la SIP Acc " + account
                return True
        else:
            print "He thong tra ve khong dong bo "
            sys.exit()                
    except requests.exceptions.RequestException as error:
        print error
        return False
    
def Get_Account(number):#tra ve account chua number, chay tren AA-HCM de lay ca sip acc + sip trunk
    try:
        print "Getting Account contain Number..." + number +"\n"
        xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "aopt"}
        Account = ""
        result = requests.post(url_read_address,data = payload)
        response = result.text
        list_response = split_Response(response)
        hcm_response = list_response[0]
        hni_response = list_response[1]
        #print response
        if "ok" in response:
            if "<address>" in hcm_response:
                Account = hcm_response[hcm_response.rfind("<account>") + 9:hcm_response.find("</account>")]
                return Account
            if "<address>" in hni_response:
                Account = hni_response[hni_response.rfind("<account>") + 9:hni_response.find("</account>")]
                return Account
            else:
                print "Number incorrect, please check again this number " + number
                return Account
        else:
            print "Can not get Account for this number " + number 
    except requests.exceptions.RequestException as error:
        print error
        return Account
    
def GetInfo_Account(account):#tra lai list call forward cua account-thuc hien tren AA-HCM
    global tenant, routingTable, pricelist, listRuleset, maliciousCallerId, valueMax, khg_name, list_call_fw
    list_call_fw = []
    xmlData ='<daml command="read"><account><accountName>' + account + '</accountName></account></daml>'
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(1)
    result = requests.post(hcm_url_read_account, data = payload)
    response = result.text
    tenant = response[response.find("<tenant>")+8:response.rfind("</tenant>")]
    ruleset_reg = r"(<ruleset>)(.*)(\<\/ruleset>)"
    listRuleset = re.findall(ruleset_reg, response)
    pricelist = response[response.find("<pricelist>")+11:response.find("</pricelist>")]
    routingTable = response[response.find("<routingTable>")+14:response.find("</routingTable>")]
    maliciousCallerId = response[response.find("<maliciousCallerId>")+19:response.find("</maliciousCallerId>")]
    sysAccountTopStop = response[response.find("<sysAccountTopStop>")+19:response.find("</sysAccountTopStop>")]
    valueMax = sysAccountTopStop[sysAccountTopStop.find("<valueMax>")+10:sysAccountTopStop.find("</valueMax>")]
    info = response[response.find("<info>")+6:response.find("</info>")]
    khg_name = info[info.find("Register")+9:info.find(account)]
    call_fw = response[response.find("<callforward>"):response.rfind("<callForward>")]
    if "ok" in response:
        if "callForward" in response:
            arrayIndex = []
            for match in finditer("<callForward>|</callForward>", response):
               start =  match.start()
               end = match.end()
               arrayIndex.append(start)
               arrayIndex.append(end)
            k = 1
            for j in range(len(arrayIndex)):
                if k < len(arrayIndex):
                    callfw_tmp = response[arrayIndex[k]-13:arrayIndex[k+1]+14]
                    list_call_fw.append(callfw_tmp)
                    k = k+4
                else:
                    return list_call_fw
        else:    
            return list_call_fw

def exist_CallFW(account):#kiem tra co ton tai call forward tren account
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_cau_hinh_so_chu_truot.log", "a+")
    xmlData ='<daml command="read"><account><accountName>' + account + '</accountName></account></daml>'
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data = payload)
    response = result.text
    if "<callForward>" in response :
        print "Account da ton tai cau hinh call forward, xin chay tool bo call forward truoc !!! " + account
        f_out.write("Account da ton tai cau hinh call forward, xin chay tool Remove call forward truoc !!! \n")
        sys.exit()
    else:
        return False

def set_CallFW(account,anum,bnum,type_fw,priority):#set call forward cho account
    try:
        global f_out,list_call_fw
        list_call_fw = []
        f_out = open("/home/administrator/aopt/logs/aopt_cau_hinh_so_chu_truot.log", "a+")
        print "Setting so chu truot cho Account..." + account
        GetInfo_Account(account)
        content_CallFW = '''<callForward><suspended>false</suspended>   <delay>0</delay>   <propagateBusy>false</propagateBusy>   <parallelCall>false</parallelCall>   <alwaysRing>false</alwaysRing>   <earlyMedia>false</earlyMedia>   <lastDiversion>false</lastDiversion>   <reroute>false</reroute>   <destPattern>''' + anum + '''</destPattern>   <sourcePattern/>   <sourcePresentationPattern>UNDEFINED</sourcePresentationPattern>   <rejectPattern/>   <destReplace>''' + bnum + '''</destReplace>   <timePattern/>   <name> ''' + anum + ' to ' +  bnum + '''</name>   <priority>''' + priority + '''</priority>   <type>''' + type_fw + '''</type> </callForward>'''
        list_call_fw.append(content_CallFW)
        print "Dang cau hinh callforward " + anum + " to " + bnum + " type " + type_fw
        f_out.write("\nDang cau hinh callforward " + anum + " to " + bnum + " type " + type_fw)
        #print list_call_fw
        call_fw = ""
        for fw in list_call_fw:
            call_fw = call_fw + fw
        #print call_fw
        xmlData = '''<daml command="write"> <account>  <accountName>''' + account + '''</accountName> ''' + call_fw + ''' </account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "aopt", "TypeAarenet": "100"}
        result = requests.post(url_write_account,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        if "ok" in HCM_response and "ok" in HNI_response:
            print "Cau hinh thanh cong forward cho account : " + account
            f_out.write("\nCau hinh thanh cong callforward " + anum + " to " + bnum + " type " + type_fw  )
            return True
        else:
            print "Cau hinh that bai forward cho account : " + account
            f_out.write("\nCau hinh that bai callforward " + anum + " to " + bnum + " type " + type_fw )
            return False
            sys.exit()
    except requests.exceptions.RequestException as error:
        print error
        return False
    
  
if __name__ == "__main__" :
    
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_cau_hinh_so_chu_truot.log", "a+")
    parser = OptionParser()
    parser.add_option("--n0","--so_chu",dest="Main_number",type="string",help="so_chu_truot")
    parser.add_option("--n1","--list_so_phu",dest="list_so_phu",type="string",help="list_so_phu")
    (options, args) = parser.parse_args()
    
    list_so_phu = options.list_so_phu
    Main_number = options.Main_number
    Member_numbers = list_so_phu.split(",")
    
    All_Number = []
    All_Number.append(Main_number)
    All_Number = All_Number + Member_numbers    
    All_Account = []
    
    for num in All_Number:
        account = Get_Account(num)
        All_Account.append(account)
    
    for acc in All_Account : #Kiem tra Account co cau hinh forward truoc do hay ko
        if GetInfo_Account(acc) != "" :
            exist_CallFW(acc)
                          
    j = 0
    for i in range(len(All_Account)) :#thuc hien forward cho account cuoi cung voi account chu truot
        if i == len(All_Account)-1 :
            set_CallFW(All_Account[i], All_Number[i], All_Number[0], 'CFB', '1')
            set_CallFW(All_Account[i], All_Number[i], All_Number[0], 'CFF', '2')
        else:
            set_CallFW(All_Account[i], All_Number[i], All_Number[i+1], 'CFB', '1')
            set_CallFW(All_Account[i], All_Number[i], All_Number[i+1], 'CFF', '2')
    
    print "Output: OK \n"
    f_out.write("\nCau hinh thanh cong so chu truot cho Account: " + All_Account[0])
    f_out.write("-----------------------------------------------------------------\n")









