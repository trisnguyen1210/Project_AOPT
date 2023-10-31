#!/usr/bin/python
# -*- coding: UTF-8 -*
# Code by HieuND16

from optparse import OptionParser
import requests
import json
import time
import random
import datetime
import sys
import os.path
import string
import re
import aopt_CPN_delete_address
from macpath import split
import mysql.connector
from mysql.connector import cursor
import aopt_add_ip_bk_chuyen_phap_nhan

url_read_account = 'http://localhost:8888/daml/account/read_test'
url_write_account = 'http://localhost:8888/daml/account/write_test'
url_read_address = 'http://localhost:8888/daml/address/read_test'
url_write_address = 'http://localhost:8888/daml/address/write_test'
url_write_address_hcm = 'http://localhost:8888/daml/address/write/hcm'
url_write_address_hni = 'http://localhost:8888/daml/address/write/hni'
url_read_siptrunk = 'http://localhost:8888/daml/siptrunk/read_test'
url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write_test'
url_read_ruleset = 'http://localhost:8888/daml/ruleset/read_test'
url_write_ruleset = 'http://localhost:8888/daml/ruleset/write_test'

pattern = r"(\d+\.\d+\.\d+\.\d+(\:?)\w+\-?\w+)"
list_trunk = []

def split_response(response):
    pattern_response = r"{(.*)}.{(.*)}"

    response_hcm = ""
    response_hni = ""

    response_hcm = re.search(pattern_response, response).group(1)
    response_hni = re.search(pattern_response, response).group(2)

    return response_hcm, response_hni


def run(value, payload):
    headers = {'content-type': 'application/json'}
    #time.sleep(1)
    result = requests.post('http://localhost:8888/daml/' + value + '/write_test', data=payload)
    response = result.text
    #print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml Config " + value + " OK"
        return True
    else:
        print "Daml Config " + value + " NOK"
        return False

def validate_ip(ip):
    a = ip.split('.')
    if len(a) != 4:
        return False
    for x in a:
        if not x.isdigit():
            return False
        i = int(x)
        if i < 0 or i > 255:
            return False
    return True

def Get_AccountFromAccountName(acc_name):
    list_Account = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query =("SELECT ACCOUNT_NAME FROM account WHERE ACCOUNT_NAME like '" + acc_name + "%'")
    #print query
    time.sleep(1)
    cur.execute(query)
    for (AccountName) in cur:
        #print("Account Name : {}".format(AccountName))
        stringAccount = str(AccountName)
        tmpAccount = stringAccount[(stringAccount.find("'"))+1 : (stringAccount.rfind("'"))]
        list_Account.append(tmpAccount)
    cur.close()
    cnx.close()
    #print "list acc", list_Account
    return list_Account


def get_type_number(number):
    if number[0:3] == "028":
        type_number = "HCM"
    elif number[0:3] == "024":
        type_number = "HNI"
    elif number[0:4] == "0236":
        type_number = "DNG"
    elif number[0:4] == "0274":
        type_number = "BDG"
    elif number[0:4] == "0225":
        type_number = "HPG"
    elif number[0:4] == "0237":
        type_number = "THA"
    elif number[0:4] == "0238":
        type_number = "NAN"
    elif number[0:4] == "0258":
        type_number = "KHA"
    elif number[0:4] == "0251":
        type_number = "DNI"
    elif number[0:4] == "0254":
        type_number = "VTU"
    elif number[0:4] == "0292":
        type_number = "CTO"
    elif number[0:4] == "0296":
        type_number = "AGG"
    elif number[0:4] == "0297":
        type_number = "KGG"
    elif number[0:4] == "0203":
        type_number = "QNH"
    elif number[0:4] == "0204":
        type_number = "BGG"
    elif number[0:4] == "0205":
        type_number = "LSN"
    elif number[0:4] == "0206":
        type_number = "CBG"
    elif number[0:4] == "0207":
        type_number = "TQG"
    elif number[0:4] == "0208":
        type_number = "TNN"
    elif number[0:4] == "0209":
        type_number = "BKN"
    elif number[0:4] == "0210":
        type_number = "PTO"
    elif number[0:4] == "0211":
        type_number = "VPC"
    elif number[0:4] == "0212":
        type_number = "SLA"
    elif number[0:4] == "0213":
        type_number = "LCU"
    elif number[0:4] == "0214":
        type_number = "LCI"
    elif number[0:4] == "0215":
        type_number = "DBN"
    elif number[0:4] == "0216":
        type_number = "YBI"
    elif number[0:4] == "0218":
        type_number = "HBH"
    elif number[0:4] == "0219":
        type_number = "HAG"
    elif number[0:4] == "0220":
        type_number = "HDG"
    elif number[0:4] == "0221":
        type_number = "HYN"
    elif number[0:4] == "0222":
        type_number = "BNH"
    elif number[0:4] == "0226":
        type_number = "HNM"
    elif number[0:4] == "0227":
        type_number = "TBH"
    elif number[0:4] == "0228":
        type_number = "NDH"
    elif number[0:4] == "0229":
        type_number = "NBH"
    elif number[0:4] == "0232":
        type_number = "QBH"
    elif number[0:4] == "0233":
        type_number = "QTI"
    elif number[0:4] == "0234":
        type_number = "TTH"
    elif number[0:4] == "0235":
        type_number = "QNM"
    elif number[0:4] == "0239":
        type_number = "HTH"
    elif number[0:4] == "0252":
        type_number = "BTN"
    elif number[0:4] == "0255":
        type_number = "QNI"
    elif number[0:4] == "0256":
        type_number = "BDH"
    elif number[0:4] == "0257":
        type_number = "PYN"
    elif number[0:4] == "0259":
        type_number = "NTN"
    elif number[0:4] == "0260":
        type_number = "KTM"
    elif number[0:4] == "0261":
        type_number = "DNO"
    elif number[0:4] == "0262":
        type_number = "DLK"
    elif number[0:4] == "0263":
        type_number = "LDG"
    elif number[0:4] == "0269":
        type_number = "GLI"
    elif number[0:4] == "0270":
        type_number = "VLG"
    elif number[0:4] == "0271":
        type_number = "BPC"
    elif number[0:4] == "0272":
        type_number = "LAN"
    elif number[0:4] == "0273":
        type_number = "TGG"
    elif number[0:4] == "0275":
        type_number = "BTE"
    elif number[0:4] == "0276":
        type_number = "TNH"
    elif number[0:4] == "0277":
        type_number = "DTP"
    elif number[0:4] == "0290":
        type_number = "CMU"
    elif number[0:4] == "0291":
        type_number = "BLU"
    elif number[0:4] == "0293":
        type_number = "HGG"
    elif number[0:4] == "0294":
        type_number = "TVH"
    elif number[0:4] == "0299":
        type_number = "STG"
    elif number[0:4] == "1800":
        type_number = "1800"
    elif number[0:4] == "1900":
        type_number = "1900"
    return type_number

def add_account(value, payload):
    headers = {'content-type': 'application/json'}

    result = requests.post('http://localhost:8888/daml/' + value + '/write_test', data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml Add Account is OK"
        return True
    else:
        print "Daml Add Account is NOK"
        return False

def add_address_account(account, number, blocked, time_now, type):
    xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}

    if type.upper() == "SIP TRUNK":
        url = url_write_address
        result = requests.post(url, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print "DAML Add Address OK"
            return True
        else:
            print "DAML Add Address NOK"
            return False
    elif type.upper() == "SIP ACCOUNT":
        check_side = get_type_number(number)
        sideHNI = ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]
        sideHCM = ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNO","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH"]
        side1x00 = ["1800","1900"]
        if check_side in sideHNI:
            url = url_write_address_hni
            xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>sipacchni.ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
        elif check_side in sideHCM:
            url = url_write_address_hcm
            xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''       
        else:
            if account[0:2] == "HN":
                url = url_write_address_hni
                xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>sipacchni.ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
            elif account[0:2] == "SG":
                url = url_write_address_hcm
                xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''

        result = requests.post(url, data=payload)
        response = result.text
        if "status=ok" in response:
            print "DAML Add Address OK"
            return True
        else:
            print "DAML Add Address NOK"
            return False


def check_add(number):
    headers = {'content-type': 'application/json'}
    try:
        xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_read_address, data=payload)
        response = result.text
        # print response
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        global get_account_add_hcm
        global get_account_add_hni

        if "ok" in response_hcm and "ok" in response_hni:
            print "Daml Read Address OK"
            if number in response_hcm: # dau so da ton tai
                #print "True"
                get_account_add_hcm = response_hcm[response_hcm.find("<account>") + 9:response_hcm.find("</account>")]
            elif number in response_hni:
                get_account_add_hni = response_hni[response_hni.find("<account>") + 9:response_hni.find("</account>")]
                return True
            else:                       # dau so khong ton tai
                #print "False"
                return False
        else:
            print "Daml Read Address is NOK"
            return False
    except requests.exceptions.RequestException as error:
        print error
        return 0


def check_acc(account):
    headers = {'content-type': 'application/json'}
    try:
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        #time.sleep(1)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        #print response
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        global get_account
        get_account = response_hcm[response_hcm.find("<account>") + 9:response_hcm.find("</account>")]

        global get_info, get_ip
        get_info = response_hcm[response_hcm.find("<info>") + 6:response_hcm.find("</info>")]
        get_ip_all = get_info[get_info.find("IP-") + 3:get_info.rfind("_")]
        if get_ip_all.count("_") == 0:
            get_ip = get_ip_all
        else:
            get_ip = get_ip_all[0:get_ip_all.find("_")]

        if "status=ok" in response_hcm:
            print "Daml Read Account OK"
            if account in response_hcm and account in response_hni:  # neu acc ton tai
                if "<validUntil>" not in response_hcm:   # neu acc ko bi disable
                    return True
                else:   # neu acc bi disable
                    return False
            else:       # neu acc ko ton tai
                return False
        else:
            print "Daml Read Account is NOK"
            return False
    except requests.exceptions.RequestException as error:
        print error
        return 0


def check_account(account):
    headers = {'content-type': 'application/json'}
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    global valueMax

    if "valueMax" in response_hcm:
        get_valueMax = response_hcm[response_hcm.find("<valueMax>") + 10:response_hcm.find("</valueMax>")]
    else:
        get_valueMax = "0.0"

    valueMax = float(get_valueMax)
    valueMax = str(valueMax).replace(".0", "")

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "\nDaml check account OK"
        if account in response_hcm:
            return True
        else:
            return False
    else:
        print "Daml check account NOK"
        return False


def check_siptrunk(ip_KHG, port_KHG):
    global list_trunkname
    list_IP_in = []
    list_trunkname = []
    cpe_contact = "sip:" + ip_KHG + ":" + port_KHG
    print "CPE_Contact:", cpe_contact
    list_IP_in.append(cpe_contact)
    list_trunkname = Get_TrunkNameFromCpeContact(list_IP_in)
    if list_trunkname == []:
        return True
    else:
        return False

def Get_TrunkNameFromCpeContact(list_IP_in):#Lay danh sach trunk IP tu cpe contact
    list_trunkname = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    for ip in list_IP_in:
        query =("SELECT NAME FROM siptrunk WHERE SIP_CONTACT like '" + ip + "%'")
        #query = ("select * from siptrunk where SIP_CONTACT = 'sip:1.1.1.140:5060'")
        #print query
        time.sleep(1)
        cur.execute(query)
        for (sip_contact) in cur:
            #print("Account Name : {}".format(sip_contact))
            string_SIP_Contact = str(sip_contact)
            tmpSIPContact = string_SIP_Contact[(string_SIP_Contact.find("'"))+1 : (string_SIP_Contact.rfind("'"))]
            list_trunkname.append(tmpSIPContact)
    cur.close()
    cnx.close()
    return list_trunkname

def check_map_siptrunk_account(account, list_trunk):
    xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML check Account SIP Trunk Map OK"
        lst_result = []
        for i in range(len(list_trunk)):
            # print list_trunk[i]
            if list_trunk[i] in response_hcm:
                lst_result.append("OK")
            else:
                lst_result.append("NOK")

        if "NOK" in lst_result:
            return False
        else:
            return True
    else:
        print "DAML check Account SIP Trunk Map is NOK"
        return False


def xmlSipTrunk(sipTrunkName, sipTrunk_info, ip_KHG, port_KHG, host, sbc_Name, weight):
    print "Creating XML SIP Trunk:"
    print "SIP Trunk Name:", sipTrunkName
    print "SIP Trunk Info:", sipTrunk_info
    print "IP:", ip_KHG
    print "Port:", port_KHG
    print "Host:", host
    print "SBC:", sbc_Name
    print "Weight:", weight
    if sbc_Name == "SBC-HCM" or sbc_Name == "SG":
        route1 = "sip:172.28.0.78:5060"
        route2 = ""
        if host == "Public":
            route2 = "sip:118.69.114.182:5060"
        elif host == "MPLS":
            route2 = "sip:118.69.114.166:5060"
    if sbc_Name == "SBC-HNI" or sbc_Name == "HN":
        route1 = "sip:172.28.0.12:5060"
        if host == "Public":
            route2 = "sip:118.69.115.150:5060"
        elif host == "MPLS":
            route2 = "sip:118.69.115.134:5060"

    xmlData_SIPTrunk = '''<daml command="create"><sipTrunk><name>''' + sipTrunkName + '''</name><info>''' + sipTrunk_info + '''</info><sipContact>sip:''' + ip_KHG + ''':''' + port_KHG + '''</sipContact><route1>''' + route1 + '''</route1><route2>''' + route2 + '''</route2><q>''' + weight + '''</q><userAgent>Dialogic</userAgent><endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth><group>System</group></sipTrunk></daml>'''
    return xmlData_SIPTrunk

def add_siptrunk(xmlData):
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_siptrunk, data = payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print response
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML Add Trunk IP is OK"
        return True
    else:
        print "DAML Add Trunk IP is NOK"
        return False

def user_rand(y):
    return "".join(random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") for x in range(y))


def pass_rand(y):
    return "".join(
        random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}()") for x in range(y))


def goto(linenum):
    global line
    line = linenum


def timenow():
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now


def shortname(name_khg):
    shortname = ""
    list_remove = ["Tnhh", "Cty", "Va", "-", "&", ".", "(", ")", "Ltd", "Co.,Ltd.", "Vpdd", "TmDv"]
    list_remove_2 = ["Cong Ty", "Co Phan", "Mtv", "Tai TpHcm", "Tai TpHCM", "Tai HCM", "Ho Chi Minh", "Ha Noi",
                     "Da Nang", "Cp", "Giao Duc Dao Tao", "Duoc Pham", "Ho Kinh Doanh", "Thuong Mai", "San Xuat",
                     "Xuat Khau", "Dau Tu", "Phat Trien", "Bat Dong San", "Cong Nghe", "Dich Vu", "Thuong Mai",
                     "Chi Nhanh", "Tu Van", "Nha Hang", "Mot Thanh Vien", "Van Phong Dai Dien", "Tai Thanh Pho",
                     "Trach Nhiem Huu Han", "Ky Thuat", "Da Khoa Quoc Te", "Truong Mam Non", "Ltd",
                     "Chi Nhanh Ho Chi Minh", "Chi Nhanh Ha Noi", "Giao Nhan Van Chuyen", "Phong Kham Quoc Te",
                     "Benh Vien Da Khoa"]

    if ("Viet Nam") or ("Xuat Nhap Khau") in name_khg:
        name_khg = name_khg.replace("Viet Nam", "VN")
        name_khg = name_khg.replace("Xuat Nhap Khau", "XNK")

    amount = name_khg.count(" ") + 1
    list_word = []
    for i in range(amount):
        word = str(name_khg.split(" ")[i].strip())
        # print word
        list_word.append(word)

    for x in list_word:
        if x in list_remove:
            list_word.remove(x)
            # print list_word
    for y in list_word:
        shortname = shortname + " " + y
    # print shortname
    # print len(list_remove_2)
    for z in range(len(list_remove_2)):
        if list_remove_2[z] in shortname:
            shortname = shortname.replace(list_remove_2[z], "")
    shortname = shortname.replace(" ", "")
    return shortname

def remove_siptrunk_account(account, siptrunkname):
    xmlData = '''<daml command="delete"><accountSipTrunkMap account="''' + account + '''" sipTrunk="''' + siptrunkname + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(1)
   #print "xmlData:", xmlData
    #print "payload:", payload
    result = requests.post(url_write_siptrunk, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print response
    if "ok" in response_hcm and "ok" in response_hni:
        print "DAML remove Account SIP Trunk Map " + siptrunkname + " OK"
        return True
    else:
        print "DAML remove Account SIP Trunk Map " + siptrunkname + "NOK"
        return False


def check_number(account):
    headers = {'content-type': 'application/json'}
    try:
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        #time.sleep(1)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        # print response
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        response_org = response_hcm

        global get_number
        get_number = []

        if "/number" in response_hcm:
            count_number = response_hcm.count("/number")
        else:
            count_number = 0
            # print count_number

        for i in range(count_number):
            a = response_hcm.find("<number>")
            b = response_hcm.find("</number>")
            number = response_hcm[a + 8:response_hcm.find("</number>")]
            # print number
            get_number.append(number)
            response_hcm = response_hcm[b + 9:]
            # print response

        if "ok" in response_org:
            # print "Daml OK"
            if get_number != "":
                return True
            else:
                return False
        else:
            print "Daml Fail"
            return False
    except requests.exceptions.RequestException as error:
        print error
        return 0

def check_acc_status(account):
    headers = {'content-type': 'application/json'}
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "ok" in response_hcm and "ok" in response_hni:
        print "DAMl check status account OK"
        if account in response_hcm and account in response_hni: # neu acc ton tai
            if "<validUntil>" in response_hcm or "<validUntil>" in response_hni:  # neu acc bi disable
                print "Account " + account + " disabled"
                return "NOK"
            else:  # neu acc khong bi disable
                if account[10:12] == "18" or account[10:12] == "19":
                    return "OK"
                else:
                    if "Block : All Outgoing International Calls" in response_hcm or "Block : All Outgoing International Calls" in response_hni:
                        return "OK"
                    else: # Khong khoa QT
                        print "Account " + account + " khong co Ruleset khoa quoc te"
                        return "NOK"
        else: # neu acc ko ton tai
            print "Account " + account + " khong ton tai"
            return "NOK"
    else:
        print "DAML check status account NOK"
        return "Fail"

def add_new_account(new_account, info, tenant, routingTable, pricelist, username, password, ruleset, time_now, maliciousCallerId, sysAccountTopStop):
    print "Account:", new_account
    print "Info:", info
    print "Tenant:", tenant
    print "Routing table:", routingTable
    print "Pricelist:", pricelist
    print "username:", username
    print "Pass:", password
    print "Ruleset:", ruleset
    print "Time:", time_now
    print "Malicious:", maliciousCallerId
    #print "TopStop:", sysAccountTopStop

    xmlData = '''<daml command="write"><account><accountName>''' + new_account + '''</accountName><info>''' + info + '''</info><maxChannels>500</maxChannels><tenant>''' + tenant + '''</tenant><routingTable>''' + routingTable + '''</routingTable><pricelist>''' + pricelist + '''</pricelist><username>''' + username + '''</username><password>''' + password + '''</password><emergencyLocation>LOC Default</emergencyLocation>''' + ruleset + '''<validAfter>''' + time_now + '''</validAfter><sendAoc>false</sendAoc> <specialArrangement>false</specialArrangement><alarmOnExpiry>false</alarmOnExpiry><maliciousCallerId>''' + maliciousCallerId + '''</maliciousCallerId><useMediaServer>false</useMediaServer><sendingHoldStream>false</sendingHoldStream><sysAccountTopStop>''' + sysAccountTopStop + '''</sysAccountTopStop></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #response_hcm = result.text
    #print "hcm:", response_hcm
    #time_now_hni = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    #xmlData_hni = '''<daml command="write"><account><accountName>''' + new_account + '''</accountName><info>''' + info + '''</info><maxChannels>200</maxChannels><tenant>''' + tenant + '''</tenant><routingTable>''' + routingTable + '''</routingTable><pricelist>''' + pricelist + '''</pricelist><username>''' + username + '''</username><password>''' + password + '''</password><emergencyLocation>LOC Default</emergencyLocation>''' + ruleset + '''<validAfter>''' + time_now_hni + '''</validAfter><sendAoc>false</sendAoc> <specialArrangement>false</specialArrangement><alarmOnExpiry>false</alarmOnExpiry><maliciousCallerId>''' + maliciousCallerId + '''</maliciousCallerId><useMediaServer>false</useMediaServer><sendingHoldStream>false</sendingHoldStream><sysAccountTopStop>''' + sysAccountTopStop + '''</sysAccountTopStop></account></daml>'''
    #payload_hni = {"XmlData": xmlData_hni, "UserRequest": "AOPT"}
    #result = requests.post(url_write_account_hni, data=payload_hni)
    #response_hni = result.text
    #print "hni:", response_hni
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML Add account OK"
        return True
    else:
        print "DAML Add account NOK"
        return False

def delete_account(account):
    headers = {'content-type': 'application/json'}
    xmlData = '''<daml command="delete"> <account> <accountName>''' + account + '''</accountName> </account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(1)
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    if "ok" in response_hcm and "ok" in response_hni:
        print "\nDaml delete account OK"
        return True
    else:
        print "Daml delete account NOK"
        return False


def read_list_old_code():
    lst_province = []
    with open("/home/administrator/aopt/list_code_province_fpt.csv", "r") as f:
        for line in f:
            province = str(line.split(",")[0].strip())
            code_new = str(line.split(",")[1].strip())
            code_old = str(line.split(",")[2].strip())
            lst_province.append([province, code_new, code_old])
        f.close()
    return lst_province


def add_account_inside(shd, account, amount, list_phone):
    # headers = {'Content-type': 'text/html'}
    print "Insert inside: ", shd, "|", account, "|", amount, "|", list_phone
    try:
        areacode = ""
        list_province = read_list_old_code()
        for province in list_province:
            name = province[0]
            code_new = province[1]
            code_old = province[2]
            if account[10:13] == name:
                areacode = code_old

        if areacode == "":
            if account[10:13] == "180":
                areacode = "1800"
                amount = "0"
            elif account[10:13] == "190":
                areacode = "1900"
                amount = "0"
        for i in range(60):
            jsondata = '''{"TypeRequest":"I", "Contract": "''' + shd + '''","UserRequest": "Tool","ListAccount": [{"AccountName": "''' + account + '''", "Amount": "''' + amount + '''", "AreaCode": "''' + areacode + '''", "ListPhoneNumber": "{''' + list_phone + '''}"}]}'''
            payload = {"jsondata": jsondata}
            # print payload
            time.sleep(10)
            result = requests.post('http://ftmsapi.fpt.net/ivoice/dam/api/accountareanet/sync-acc', data=payload)
            response = result.text
            # print result.status_code
            # print response

            if "Success" in response:
                print "DAML Add Account Inside OK"
                temp = True
                break
            elif "Fail" in response:
                print "DAML Add Account Inside NOK"
                print response
                temp = False
                break
            elif "Request again after 10 s" in response:
                temp = False

        if temp == True:
            return True
        else:
            return False

    except requests.exceptions.RequestException as error:
        print error
        return 0


def update_account_inside(shd, account, list_phone):
    # headers = {'content-type': 'application/json'}
    print "Update inside: ", shd, "|", account, "|", list_phone
    try:
        #if account[10:14] == "1800":
            #amount = "0"
        #elif account[10:14] == "1900":
            #amount = "0"
        for i in range(60):
            jsondata = '''{"TypeRequest":"U", "Contract": "''' + shd + '''","UserRequest": "Tool","ListAccount": [{"AccountName": "''' + account + '''","ListPhoneNumber": "{''' + list_phone + '''}"}]}'''
            payload = {"jsondata": jsondata}
            #print "payload:", payload
            time.sleep(10)
            result = requests.post('http://ftmsapi.fpt.net/ivoice/dam/api/accountareanet/sync-acc', data=payload)
            response = result.text
            #print response

            if "Success" in response:
                print "DAML Update Account Inside OK"
                temp = True
                break
            elif "Fail" in response:
                print "DAML Update Account Inside NOK"
                print response
                temp = False
                break
            elif "Request again after 10 s" in response:
                print response
                temp = False

        if temp == True:
            return True
        else:
            return False

    except requests.exceptions.RequestException as error:
        print error
        return 0


def sync_account_inside(shd, account):
    amount = ""
    list_phone = ""
    global get_number, valueMax

    if check_number(account):
        # print get_number
        for i in range(len(get_number)):
            number = get_number[i]
            if i == len(get_number) - 1:
                list_phone = list_phone + number
            else:
                list_phone = list_phone + number + ","
            # print number
    # print list_phone

    if check_account(account):
        amount = valueMax
        # print amount

    if update_account_inside(shd, account, list_phone) == False:  # func update khong nhap han muc vao
        print "Update Account Inside unsuccessfully. Try to add account on inside"
        if add_account_inside(shd, account, amount, list_phone):
            print "Insert Account to Inside Successfully"
            return True
        else:
            print "Insert Account to Inside Unsuccessfully"
            c_list.write(timenow() + "," + shd + "," + account + "," + amount + "," + list_phone + "\n")
            return False
    else:
        print "Update Account Inside Successfully"
        return True

def check_input(shd,name_KHG,type_KHG,number_list,valueMax,ip_KHG,port_KHG,host_IP,ip_KHG_BK1,port_bk1,host_IP_BK1,ip_KHG_BK2,port_bk2,host_IP_BK2):
    if ((shd != "") and (name_KHG != "") and (type_KHG != "") and (number_list != "") and (valueMax != "")):
        if type_KHG.upper() == "SIP ACCOUNT":
            result = True
        elif (type_KHG.upper() == "SIP TRUNK"):
            if (ip_KHG != ""):
                if ((port_KHG != "") and (host_IP != "")):
                    print "IP Main not null"
                    result = True
                    if (ip_KHG_BK1 != ""):
                        if ((port_bk1 != "") and (host_IP_BK1 != "")):
                            print "IP BK1 not null"
                            result = True
                            if (ip_KHG_BK2 != ""):
                                if ((port_bk2 != "") and (host_IP_BK2 != "")):
                                    print "IP BK2 not null"
                                    result = True
                                else:
                                    print "Port va Loai port IP BK2 chua ton tai"
                                    result = False
                        else:
                            print "Port va Loai port IP BK1 chua ton tai"
                            result = False
                else:
                    print "Port va Loai port IP Main chua ton tai"
                    result = False
        else:
            print "Loai KHG khong phai la SIP TRUNK / SIP ACCOUNT"
    else:
        result = False
    return result

def create_sipTrunkName(shd, ip, port, ip_type, ip_host):
    print "Creating SIP Trunk Name"
    sipTrunkName_1 = ""
    sipTrunkName_2 = ""

    if shd[0:2] == "SG":
        sbc_main = "SBC-HCM"
        sbc_backup = "SBC-HNI"
    elif shd[0:2] == "HN":
        sbc_main = "SBC-HNI"
        sbc_backup = "SBC-HCM"
    else:
        sbc_main = "SBC-HCM"
        sbc_backup = "SBC-HNI"

    if ip_host == "Public":
        ip_host = "Pub"
    else:
        ip_host = ip_host

    if port == "5060":
        if ip_type == "Primary":
            sipTrunkName_1 = ip + "_Pri_" + ip_host + "_" + sbc_main
            sipTrunkName_2 = ip + "_Pri_" + ip_host + "_" + sbc_backup
        elif ip_type == "Backup":
            sipTrunkName_1 = ip + "_BK_" + ip_host + "_" + sbc_main
            sipTrunkName_2 = ip + "_BK_" + ip_host + "_" + sbc_backup
    else:
        if sbc_main == "SBC-HCM":
            sbc_1 = "SG"
        else:
            sbc_1 = "HN"
        if sbc_backup == "SBC-HCM":
            sbc_2 = "SG"
        else:
            sbc_2 = "HN"

        if ip_type == "Primary":
            sipTrunkName_1 = ip + ":" + port + "_Pr_" + ip_host + "_" + sbc_1
            sipTrunkName_2 = ip + ":" + port + "_Pr_" + ip_host + "_" + sbc_2
        elif ip_type == "Backup":
            sipTrunkName_1 = ip + ":" + port + "_BK_" + ip_host + "_" + sbc_1
            sipTrunkName_2 = ip + ":" + port + "_BK_" + ip_host + "_" + sbc_2

    print "SIP Trunk Name 1 :", sipTrunkName_1, " has been created"
    print "SIP Trunk Name 2 :", sipTrunkName_2, " has been created"

    if len(sipTrunkName_1) > 32 or len(sipTrunkName_2) > 32:
        print "Fail. SIP Trunk Name too long (max 32 characters)"

    sipTrunkName = [sipTrunkName_1, sipTrunkName_2]
    print "List sip trunk name:", sipTrunkName
    return sipTrunkName


def create_sipTrunkInfo(shd, name_KHG, ip_KHG, port_KHG, type, host):
    if shd[0:2] == "SG":
        sbc_main = "SBC-HCM"
        sbc_backup = "SBC-HNI"
    elif shd[0:2] == "HN":
        sbc_main = "SBC-HNI"
        sbc_backup = "SBC-HCM"
    else:
        sbc_main = "SBC-HCM"
        sbc_backup = "SBC-HNI"

    if host == "Public":
        host = "Pub"
    else:
        host = "MPLS"

    if type == "Primary":
        type = "Pri"
    else:
        type = "BK"

    sipTrunk_info1 = "SIP Trunk Profile " + shd + " " + name_KHG + " IP-" + ip_KHG + ":" + str(port_KHG) + "_" + type + "_" + host + "_" + sbc_main
    sipTrunk_info2 = "SIP Trunk Profile " + shd + " " + name_KHG + " IP-" + ip_KHG + ":" + str(port_KHG) + "_" + type + "_" + host + "_" + sbc_backup

    list_siptrunkinfo = [sipTrunk_info1, sipTrunk_info2]
    return list_siptrunkinfo

def check_acc_siptrunk_map(account):
    xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_siptrunk, data = payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML check Account SIP Trunk Map OK"
        if account in response_hcm and account in response_hni:
            print "Account ", account, " is SIP Trunk"
            return "SIP Trunk"
        elif (account in response_hcm and account not in response_hni) or (account not in response_hcm and account in response_hni):
            print "Configuration does not match"
            return "Fail"
        elif account not in response_hcm and account not in response_hni:
            print "Account ", account, " is SIP Account"
            return "SIP Account"
    else:
        print "DAML check Account SIP Trunk Map is NOK"
        return "Fail"

def map_siptrunk_account(account, sipTrunkName):
    xmlData = '''<daml command="create"><accountSipTrunkMap account="''' + account + '''" sipTrunk="''' + sipTrunkName + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_siptrunk, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML Map SIP Trunk to Account is OK"
        return True
    else:
        print "DAML Map SIP Trunk to Account is NOK"
        return False

def main():
    f_out = open("/home/administrator/aopt/logs/aopt_chuyen_phap_nhan.log", "a+")
    f_list = open("/home/administrator/aopt/logs/aopt_chuyen_phap_nhan_ok.csv", "a+")
    global c_list
    c_list = open("/home/administrator/aopt/logs/update_acc_inside_fail.csv", "a+")
    parser = OptionParser()

    # parser.add_option("--pc", "--parentcontract", dest="shd", type="string", help="So Hop Dong cha")
    parser.add_option("-c", "--contract", dest="shd", type="string", help="So Hop Dong")
    parser.add_option("-k", "--name", dest="name_KHG", type="string", help="Ten KHG")
    parser.add_option("-n", "--number_list", dest="number_list", type="string", help="Number (1,2,3)")
    parser.add_option("-t", "--type_khg", dest="type_KHG", type="string", help="Loai dich vu: SIP Trunk | SIP Account")
    parser.add_option("--ip1", dest="ip_KHG", type="string", help="IP Main")
    parser.add_option("--ip1p", dest="port_KHG", type="string", help="Port IP Main")
    parser.add_option("--ip1t", "--ip1_type", dest="host_IP", type="string", help="Host IP Main")
    parser.add_option("--ip2", dest="ip_KHG_BK1", type="string", help="IP BK1")
    parser.add_option("--ip2p", dest="port_bk1", type="string", help="Port IP BK1")
    parser.add_option("--ip2t", "--ip2_type", dest="host_IP_BK1", type="string", help="Host IP BK1")
    parser.add_option("--ip3", dest="ip_KHG_BK2", type="string", help="IP BK2")
    parser.add_option("--ip3p", dest="port_bk2", type="string", help="Port IP BK2")
    parser.add_option("--ip3t", "--ip3_type", dest="host_IP_BK2", type="string", help="Host IP BK2")
    parser.add_option("--med", dest="ip_media", type="string", help="IP Media")
    parser.add_option("--port", dest="port_media", type="string", help="Port IP Media")
    parser.add_option("--type", "--type", dest="type_media", type="string", help="Loai IP Media")

    parser.add_option("--destnum", "--destnum", dest="number_FW", type="string", help="Number FW")
    parser.add_option("--desttype", "--desttype", dest="type_FW", type="string", help="Loai FW")
    parser.add_option("-d", dest="time_FW", type="string", help="Time FW")
    parser.add_option("--internum", dest="internum", type="string", help="So trung gian")
    parser.add_option("-p", dest="prefix", type="string", help="Prefix")
    parser.add_option("-v", dest="valueMax", type="string", help="Han muc su dung", default="2000000")
    parser.add_option("--ivr", dest="ivr", type="string", help="IVR")
    parser.add_option("--ivr1", dest="ivr_1", type="string", help="IVR thong bao cuoc")
    parser.add_option("--max", dest="max_call", type="string", help="Max call")
    parser.add_option("--inter", dest="international_call", type="string", help="Goi quoc te")
    parser.add_option("--highcost", dest="allow_highcost", type="string", help="Goi quoc te gia cao")
    parser.add_option("--code", dest="highcost_code", type="string", help="Ma quoc te gia cao")
    # parser.add_option("--parent", dest="parent_max_value", type="string", help="Han muc hop dong cha")

    (options, args) = parser.parse_args()

    # Check for required options
    if (options.type_KHG == "SIP Trunk") or (options.type_KHG == "SIP TRUNK"):
        for option in ('shd', 'name_KHG', 'number_list', 'ip_KHG', 'port_KHG'):
            if (options.ip_KHG == "None") or (options.ip_KHG == ""):
                print 'Gia tri IP_Main chua duoc nhap vao'
            if not getattr(options, option):
                print 'Gia tri %s chua duoc nhap vao' % option
                parser.print_help()
                sys.exit()
    else:
        for option in ('shd', 'name_KHG', 'number_list', 'valueMax'):
            if not getattr(options, option):
                print 'Gia tri %s chua duoc nhap vao' % option
                parser.print_help()
                sys.exit()

    shd = options.shd
    name_KHG = options.name_KHG
    number_list = options.number_list
    type_KHG = options.type_KHG

    ip_KHG_BK1 = options.ip_KHG_BK1
    ip_KHG_BK2 = options.ip_KHG_BK2

    port_KHG = options.port_KHG
    port_bk1 = options.port_bk1
    port_bk2 = options.port_bk2

    if type_KHG.upper() == "SIP TRUNK":
        if options.ip_KHG != "":
            ip_KHG = options.ip_KHG
        else:
            out_put = "IP KHG chua duoc nhap"
        host_IP = options.host_IP
        ip_KHG = ip_KHG.replace(" ", "")
        if (options.ip_KHG_BK1!= ""):
            ip_KHG_BK1 = options.ip_KHG_BK1
            host_IP_BK1 = options.host_IP_BK1
            port_bk1 = options.port_bk1
            ip_KHG_BK1 = str(ip_KHG_BK1).replace(" ", "")
            ip_KHG_BK2 = options.ip_KHG_BK2
        else:
            ip_KHG_BK1 = ""
            port_bk1 = ""
            host_IP_BK1 = ""

        if (options.ip_KHG_BK2 != ""):
            host_IP_BK2 = options.host_IP_BK2
            port_bk2 = options.port_bk2
            ip_KHG_BK2 = str(ip_KHG_BK2).replace(" ", "")
        else:
            ip_KHG_BK2 = ""
            port_bk2 = ""
            host_IP_BK2 = ""

    else:
        ip_KHG = ""
        ip_KHG_BK1 = ""
        ip_KHG_BK2 = ""
        host_IP = ""
        host_IP_BK1 = ""
        host_IP_BK2 = ""

    if (options.ip_KHG_BK1== "None") or (options.ip_KHG_BK1== "") or (options.ip_KHG_BK1== "--ip2t"):
        host_IP_BK1 = ""
    if (options.ip_KHG_BK2 == "None") or (options.ip_KHG_BK2 == "") or (options.ip_KHG_BK2 == "--ip3t"):
        host_IP_BK2 = ""

    if (options.host_IP == "ip_type"):
        host_IP = ""
    elif (options.host_IP_BK1== "ip_type"):
        host_IP_BK1 = ""
    elif (options.host_IP_BK2 == "ip_type"):
        host_IP_BK2 = ""
    '''
    #Check input co phai format IP khong
    if validate_ip(ip_KHG):
        print "Input IP Main is valid"
    else:
        print "Input IP Main is not valid"
        sys.exit()

    if validate_ip(ip_KHG_BK1):
        print "Input IP BK1 is valid"
    else:
        print "Input IP BK1 is not valid"
        sys.exit()

    if validate_ip(ip_KHG_BK2):
        print "Input IP BK2 is valid"
    else:
        print "Input IP BK2 is not valid"
        sys.exit()
    '''
    #number_FW = options.number_FW
    #type_FW = options.type_FW
    #time_FW = options.time_FW
    valueMax = options.valueMax
    # parentValueMax = options.parent_max_value
    shd = shd.replace(" ", "")

    number_list = number_list.replace(" ", "")

    if "&" in name_KHG:
        name_KHG = name_KHG.replace("&", "")
    if "<" in name_KHG:
        name_KHG = name_KHG.replace("<", "")
    if ">" in name_KHG:
        name_KHG = name_KHG.replace(">", "")
    if "-" in name_KHG:
        name_KHG = name_KHG.replace("-", "")

    name_khg = name_KHG.title()
    name_KHG = shortname(name_khg)

    #type_IP_BK1= "Public"
    #type_IP_BK2 = "Public"


    print "Check Input..."
    print shd,name_KHG,type_KHG,number_list,valueMax,ip_KHG,port_KHG,host_IP,ip_KHG_BK1,port_bk1,host_IP_BK1,ip_KHG_BK2,port_bk2,host_IP_BK2
    if (check_input(shd,name_KHG,type_KHG,number_list,valueMax,ip_KHG,port_KHG,host_IP,ip_KHG_BK1,port_bk1,host_IP_BK1,ip_KHG_BK2,port_bk2,host_IP_BK2)==True):
        print "Input OK"

        print "*** Cau hinh Chuyen phap nhan qua ***"
        print "Input:"
        if type_KHG.upper() == "SIP TRUNK":
            print "Hop dong:", shd
            # print "Hop dong con:",contract
            print "Ten KHG:", name_KHG
            print "Number:", number_list
            print "Loai dich vu:", type_KHG
            print "IP Main: " + str(ip_KHG) + ", port IP main: " + str(port_KHG) + ", loai IP main: " + host_IP
            print "IP BK1: " + str(ip_KHG_BK1) + ", port IP BK1: " + str(port_bk1) + ", loai IP BK1: " + host_IP_BK1
            print "IP BK2: " + str(ip_KHG_BK2) + ", port IP BK2: " + str(port_bk2) + ", loai IP BK2: " + host_IP_BK2
            print "Han muc su dung cua dau so:", valueMax
            # print "Han muc su dung cua HD cha:",parentValueMax
        else:
            print "Hop dong:", shd
            # print "Hop dong con:",contract
            print "Ten KHG:", name_KHG
            print "Number:", number_list
            print "Loai dich vu:", type_KHG
            print "Han muc su dung cua dau so:", valueMax
            # print "Han muc su dung cua HD cha:",parentValueMax
        print

        print "Start time:", timenow()
        print
        print "Checking..."
        f_out.write(timenow() + " # Start # Cau hinh Chuyen phap nhan qua: " + shd + "," + name_KHG + "," + number_list + "," + type_KHG + "," + ip_KHG + "," + port_KHG + "," + host_IP + "," + ip_KHG_BK1 + "," + port_bk1 + "," + host_IP_BK1 + "," + ip_KHG_BK2 + "," + port_bk2 + "," + host_IP_BK2 + "," + valueMax + "\n")
        if type_KHG.upper() == "SIP TRUNK":
            f_out.write(
                timenow() + " Input: " + shd + "," + name_KHG + "," + number_list + "," + type_KHG + "," + ip_KHG + "," + host_IP + "," + str(
                    ip_KHG_BK1) + "," + host_IP_BK1+ "," + str(ip_KHG_BK2) + "," + host_IP_BK2 + "," + valueMax + "\n")
        else:
            f_out.write(
                timenow() + " Input: " + shd + "," + name_KHG + "," + number_list + "," + type_KHG + "," + valueMax + "\n")

        list_fail = []
        out_put = ""
        number = ""
        num_max = 0
        num_max = number_list.count(",") + 1
        # print num_max
        for n in range(num_max):
            time.sleep(1)
            if num_max == 0:
                break
            number = str(number_list.split(",")[n].strip())
            # print number
            if aopt_CPN_delete_address.delete(n, number):
                type_number = get_type_number(number)
                acc_name = shd + "_" + type_number
                print "Looking for all accounts with account name", acc_name
                acc_list = Get_AccountFromAccountName(acc_name)
                acc_list = sorted(acc_list)  # sort lai theo thu tu
                temp_list = acc_list[:]
                print "Checking list of current available accounts", temp_list

                done = False
                for x in range(len(
                        temp_list)):  # Tim account cung cau hinh, neu cung cau hinh thi add vao account do, khong co thi tao account khac
                    acc = temp_list[x]
                    print "\nCheck account", acc
                    status = check_acc_status(acc)
                    if status == "OK":  # neu account ton tai va khong bi disable thi tim account cung cau hinh va add vao
                        if type_number == "1900" or type_number == "1800":
                            blocked = "true"
                        else:
                            blocked = "false"
                        time_now = timenow()

                        if type_KHG.upper() == "SIP TRUNK":
                            list_newsiptrunk = []
                            status_check_sipacc_siptrunk = check_acc_siptrunk_map(acc)
                            if status_check_sipacc_siptrunk == "SIP Trunk":  # neu account la SIP Trunk
                                type = "Primary"
                                list_new_sipTrunkName = create_sipTrunkName(shd, ip_KHG, port_KHG, type, host_IP)
                                for p in range(len(list_new_sipTrunkName)):
                                    list_newsiptrunk.append(list_new_sipTrunkName[p])
                                if check_map_siptrunk_account(acc,
                                                              list_newsiptrunk):  # neu account cau hinh giong trunk IP
                                    print "Account " + acc + " is available"
                                    if add_address_account(acc, number, blocked, time_now, type_KHG):
                                        print "Add address " + number + " to " + acc + " OK"
                                        done = True
                                        f_out.write(
                                            timenow() + " Number: " + number + " has been added to account " + acc + "\n")
                                        print "Output: OK"

                                        if ((ip_KHG_BK1 != "") and (
                                                host_IP_BK1 != "")):  # neu co IP BK1 thi add them vao account
                                            print "Adding IP Backup 1"
                                            account = acc
                                            ip_bk = ip_KHG_BK1
                                            port_bk = port_bk1
                                            host_ip_bk = host_IP_BK1
                                            aopt_add_ip_bk_chuyen_phap_nhan.add_ip_bk_to_account(account, name_KHG, ip_bk,
                                                                                               port_bk, host_ip_bk)
                                        if ((ip_KHG_BK2 != "") and (
                                                host_IP_BK2 != "")):  # neu co IP BK2 thi add them vao account
                                            print "Adding IP Backup 2"
                                            account = acc
                                            ip_bk = ip_KHG_BK2
                                            port_bk = port_bk2
                                            host_ip_bk = host_IP_BK2
                                            aopt_add_ip_bk_chuyen_phap_nhan.add_ip_bk_to_account(account, name_KHG, ip_bk,
                                                                                               port_bk, host_ip_bk)

                                        # Update Inside
                                        if sync_account_inside(shd, acc):
                                            f_out.write(
                                                timenow() + " Cap nhat Inside: " + shd + ", " + acc + " OK" + '\n')
                                            print "Output: OK"
                                        else:
                                            f_out.write(
                                                timenow() + " Cap nhat Inside: " + shd + ", " + acc + " NOK" + '\n')
                                        break  # thoat khoi for
                                    else:
                                        print "Add address " + number + " to " + acc + " NOK"
                                        list_fail.append(number)
                                        done = False
                                        print "Output: Fail"
                                else:  # neu account khong cau hinh cung trunk IP thi tim account moi +1
                                    print "Account " + acc + " does not have the same Trunk IP"
                                    done = False
                            elif status_check_sipacc_siptrunk == "Fail":  # neu acc khong dong bo giua 2 site hoac read fail
                                print "Output: Fail"
                                # list_fail.append(number)

                        elif type_KHG.upper() == "SIP ACCOUNT":
                            status_check_sipacc_siptrunk = check_acc_siptrunk_map(acc)
                            if status_check_sipacc_siptrunk == "SIP Account":  # neu acc la SIP Account thi add vao
                                if add_address_account(acc, number, blocked, time_now, type_KHG):
                                    print "Add " + number + " to " + acc + " OK"
                                    f_out.write(
                                        timenow() + " Number: " + number + " has been added to account " + acc + "\n")
                                    # Update Inside
                                    if sync_account_inside(shd, acc):
                                        f_out.write(timenow() + " Cap nhat Inside: " + shd + ", " + acc + " OK" + '\n')
                                        print "Output: OK"
                                    else:
                                        f_out.write(timenow() + " Cap nhat Inside: " + shd + ", " + acc + " NOK" + '\n')
                                    done = True
                                    break
                                else:
                                    print "Add address " + number + " to " + acc + " NOK"
                                    list_fail.append(number)
                                    print "Output: Fail"
                            elif status_check_sipacc_siptrunk == "Fail":
                                print "Output: Fail"
                                list_fail.append(number)
                    elif status == "NOK":  # neu account bi disable
                        print acc, " is not approriate. Try another account"
                        done = False
                    elif status == "Fail":  # neu daml check account fail
                        print "DAML Fail"
                        done = False

                if done == False:  # neu cac account trong list tren ko co acc nao thoa thi tao acc moi
                    print "\nCan not find any available account. Creating new account"
                    x = 0
                    stop = False
                    while x < 100:
                        if x == 0:
                            new_account = shd + "_" + type_number
                        else:
                            new_account = shd + "_" + type_number + "_" + str(x)
                        print "\nCheck account", new_account
                        print "Acc list:", acc_list
                        if new_account in acc_list:
                            print "Account " + new_account + " is in unavailable accounts list"
                            x += 1
                            if x == 100:
                                print "Out of range"
                                print "Output:Fail"
                                break
                        elif new_account not in acc_list:
                            print "Account " + new_account + " is not in unavailable accounts list. Creating new account..."
                            password = pass_rand(19)
                            if type_KHG.upper() == "SIP TRUNK":  # neu yeu cau trien khai SIP Trunk
                                username = user_rand(19)
                                checksiptrunk = check_siptrunk(ip_KHG,
                                                               port_KHG)  # kiem tra IP va port da ton tai tren he thong chua
                                if checksiptrunk == False:  # neu ip va port da ton tai thi kiem tra host va loai ket noi
                                    print "IP " + ip_KHG + ":" + port_KHG + " da ton tai"
                                    print "Kiem tra host va loai ket noi "
                                    type = "Primary"
                                    list_new_sipTrunkName = create_sipTrunkName(shd, ip_KHG, port_KHG, type,
                                                                                host_IP)  # Tao SIP Trunk Name IP Primary moi de check
                                    for j in range(len(list_new_sipTrunkName)):
                                        if list_new_sipTrunkName[j] in list_trunkname:  # Neu dung host IP va loai ket noi thi add vao list de add vao account
                                            print "SIP Trunk da ton tai:", list_new_sipTrunkName[j]
                                            list_newsiptrunk = list_new_sipTrunkName
                                        else:  # Neu khong dung host IP va loai ket noi thi stop vi trung ip va port
                                            print "Stop do trung IP va Port nhung khong dung host"
                                            stop = True  # để khỏi xuống làm tiếp
                                            x = 100  # thoat khoi while
                                            if number not in list_fail:
                                                list_fail.append(number)
                                            print "Output: Fail"
                                            break
                                else:  # Neu IP va port chua ton tai thi tao trunk IP moi
                                    print "IP " + ip_KHG + ":" + port_KHG + " chua ton tai"
                                    type = "Primary"
                                    weight_main = '1000'
                                    weight_bk = '0'
                                    if shd[0:2] == "SG":
                                        sbc_main = "SBC-HCM"
                                        sbc_backup = "SBC-HNI"
                                    elif shd[0:2] == "HN":
                                        sbc_main = "SBC-HNI"
                                        sbc_backup = "SBC-HCM"
                                    else:
                                        sbc_main = "SBC-HCM"
                                        sbc_backup = "SBC-HNI"

                                    list_new_sipTrunkName = create_sipTrunkName(shd, ip_KHG, port_KHG, type, host_IP)
                                    list_new_sipTrunkInfo = create_sipTrunkInfo(shd, name_KHG, ip_KHG, port_KHG,
                                                                                "Primary", host_IP)
                                    xmlDataSIPTrunk1 = xmlSipTrunk(list_new_sipTrunkName[0], list_new_sipTrunkInfo[0],
                                                                   ip_KHG, port_KHG, host_IP, sbc_main, weight_main)
                                    xmlDataSIPTrunk2 = xmlSipTrunk(list_new_sipTrunkName[1], list_new_sipTrunkInfo[1],
                                                                   ip_KHG, port_KHG, host_IP, sbc_backup, weight_bk)
                                    xmlDataSIPTrunk = [xmlDataSIPTrunk1, xmlDataSIPTrunk2]

                                    print "List new sip trunk name:", list_new_sipTrunkName
                                    for k in range(len(list_new_sipTrunkName)):  # Tao SIP Trunk
                                        status = add_siptrunk(xmlDataSIPTrunk[k])
                                        if status:  # Neu tao SIP Trunk thanh cong
                                            print "-> Create new sip trunk " + list_new_sipTrunkName[k] + " OK\n"
                                            f_out.write(timenow() + " SIP Trunk: " + list_new_sipTrunkName[
                                                k] + " is created \n")
                                        else:  # Neu tao SIP trunk fail
                                            print "-> Create new sip trunk " + list_new_sipTrunkName[k] + " NOK\n"
                                            print "Output: Fail"
                                        list_newsiptrunk = list_new_sipTrunkName

                                if ip_KHG_BK1 == "":
                                    info = "SIP Trunking Account " + name_KHG + " " + new_account + " IP-" + ip_KHG + "_" + host_IP
                                elif ((ip_KHG_BK1 != "") and (host_IP_BK1 != "")):
                                    info = "SIP Trunking Account " + name_KHG + " " + new_account + " IP-" + ip_KHG + "_" + host_IP + " BK-" + ip_KHG_BK1 + "_" + host_IP_BK1

                            elif type_KHG.upper() == "SIP ACCOUNT":  # neu yeu cau trien khai SIP Account
                                username = number
                                info = "SIP Account Register " + name_KHG + " " + new_account

                            if stop == False:
                                print "Account " + new_account + " dose not exist. Add new account ", new_account

                                if type_number == "1800":
                                    tenant = "FPT-1900"
                                else:
                                    tenant = "FPT-" + type_number

                                if type_number == "1900" or type_number == "1800":
                                    sysAccountTopStop = ""
                                    routingTable = ""
                                    pricelist = ""
                                    ruleset = "<ruleset>1900-1800 : Block All Outgoing</ruleset>"
                                    blocked = "true"
                                    maliciousCallerId = "false"
                                else:
                                    sysAccountTopStop = '''<valueMax>''' + valueMax + '''</valueMax><alarmLevel>0.9</alarmLevel><dailyMax>0.0</dailyMax><monthlyReset>true</monthlyReset><dailyReset>false</dailyReset>'''
                                    routingTable = "Route to PSTN"
                                    pricelist = tenant
                                    ruleset = "<ruleset>Block : All Outgoing International Calls</ruleset><ruleset>Block : International Call - High Cost</ruleset>"
                                    blocked = "false"
                                    maliciousCallerId = "true"

                                time_now = timenow()
                                if add_new_account(new_account, info, tenant, routingTable, pricelist, username,
                                                   password, ruleset, time_now, maliciousCallerId, sysAccountTopStop):
                                    print "Add account " + new_account + " OK"
                                    f_out.write(timenow() + " Account: " + new_account + " has been added" + "\n")
                                    if add_address_account(new_account, number, blocked, time_now, type_KHG):
                                        print "Add " + number + " to " + new_account + " OK"
                                        f_out.write(
                                            timenow() + " Number: " + number + " has been aldded to account " + new_account + "\n")
                                        if type_KHG.upper() == "SIP TRUNK":  # neu yeu cau la SIP Trunk thi add trunk vao account
                                            print "list trunk:", list_newsiptrunk
                                            for y in range(len(list_newsiptrunk)):
                                                if map_siptrunk_account(new_account, list_newsiptrunk[y]):
                                                    print "Map trunk IP " + list_newsiptrunk[
                                                        y] + " to " + new_account + " OK"
                                                    print "Output: OK"
                                                    f_out.write(timenow() + " IP Trunk: " + list_newsiptrunk[
                                                        y] + " has been added to account " + new_account + "\n")
                                                else:
                                                    print "Map trunk IP " + list_newsiptrunk[
                                                        y] + " to " + new_account + " NOK"
                                                    if number not in list_fail:
                                                        list_fail.append(number)
                                                    print "Output: Fail"
                                            if ((ip_KHG_BK1 != "") and (
                                                    host_IP_BK1 != "")):  # neu co IP BK1 thi add them vao account
                                                print "Adding IP Backup 1"
                                                account = new_account
                                                ip_bk = ip_KHG_BK1
                                                port_bk = port_bk1
                                                host_ip_bk = host_IP_BK1
                                                aopt_add_ip_bk_chuyen_phap_nhan.add_ip_bk_to_account(account, name_KHG,
                                                                                                   ip_bk, port_bk,
                                                                                                   host_ip_bk)
                                            if ((ip_KHG_BK2 != "") and (
                                                    host_IP_BK2 != "")):  # neu co IP BK2 thi add them vao account
                                                print "Adding IP Backup 2"
                                                account = new_account
                                                ip_bk = ip_KHG_BK2
                                                port_bk = port_bk2
                                                host_ip_bk = host_IP_BK2
                                                aopt_add_ip_bk_chuyen_phap_nhan.add_ip_bk_to_account(account, name_KHG,
                                                                                                   ip_bk, port_bk,
                                                                                                   host_ip_bk)
                                        # Update Inside
                                        if sync_account_inside(shd, new_account):
                                            f_out.write(
                                                timenow() + " Cap nhat Inside: " + shd + ", " + new_account + " OK" + '\n')
                                            print "Output: OK"
                                        else:
                                            f_out.write(
                                                timenow() + " Cap nhat Inside: " + shd + ", " + new_account + " NOK" + '\n')
                                        x = 100  # de chut nua thoat khoi while
                                    else:
                                        print "Add address " + number + " to " + new_account + " NOK"
                                        if number not in list_fail:
                                            list_fail.append(number)
                                        print "Output: Fail"
                                        x = 100
                                else:
                                    print "Add account " + new_account + " NOK"
                                    if number not in list_fail:
                                        list_fail.append(number)
                                    print "Output: Fail"
                                    break
            else:
                print "Failed to delete number"
                list_fail.append(number)

        print "Done"
        print "\nEnd time:", timenow()
        if list_fail != []:
            print "List fail:", list_fail
            print "Output: Fail"
        else:
            print "Output: OK"
        f_out.write(timenow() + " # End # Cau hinh Chuyen phap nhan: " + shd + "," + name_KHG + "," + number_list + "," + type_KHG + "," + ip_KHG + "," + port_KHG + "," + host_IP + "," + ip_KHG_BK1 + "," + port_bk1 + "," + host_IP_BK1 + "," + ip_KHG_BK2 + "," + port_bk2 + "," + host_IP_BK2 + "," + valueMax + "\n")
        f_out.close()
    else:
        print "Input not valid !"

if __name__ == "__main__":
    main()
