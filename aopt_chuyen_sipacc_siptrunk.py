'''Author: PhongDT23
Date: 14/01/2019
Description: Chuyen sip acc thanh sip trunk va nguoc lai
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
from optparse import OptionParser
import HTMLParser
from re import finditer
from macpath import split
import mysql.connector
from mysql.connector import cursor
import re

#===============================================================================
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

#==========================================================================

url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write_test'
url_read_address_hcm = 'http://localhost:8888/daml/address/read/hcm'
url_write_address_hcm = 'http://localhost:8888/daml/address/write/hcm'
url_write_address_hni = 'http://localhost:8888/daml/address/write/hni'

pattern = r"(\d+\.\d+\.\d+\.\d+(\:?)\w+\-?\w+)"
#==============================================================================

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

ip_main = ""


def split_responses(response):
    pattern_response = r"{(.*)}.{(.*)}"

    response_hcm = ""
    response_hni = ""

    response_hcm = re.search(pattern_response, response).group(1)
    response_hni = re.search(pattern_response, response).group(2)

    return response_hcm, response_hni
#----------------------------------Kiem tra account-------------------------------------------------------------------------------------------   
def check_status_account(account):
    global temp
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    # for i in range(60):
    time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]
    global get_routingtable, get_info, get_username, get_pass, get_disable, get_pricelist, get_valueMax, get_ruleset

    get_call_inter = "No"
    get_high_cost = "No"

    get_routingtable = response_hcm[response_hcm.find("<routingTable>") + 14:response_hcm.find("</routingTable>")]
    get_routingtable = response_hni[response_hni.find("<routingTable>") + 14:response_hni.find("</routingTable>")]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        if account in response_hcm:
            # print "Read account is: ok "
            if "/username" in response_hcm:
                get_username = response_hcm[response_hcm.find("<username>") + 10:response_hcm.find("</username>")]
            else:
                get_username = ""

            if "/info" in response_hcm:
                get_info = response_hcm[response_hcm.find("<info>") + 6:response_hcm.find("</info>")]
            else:
                get_info = ""

            if "/validUntil" in response_hcm:
                get_disable = "Disable"
            else:
                get_disable = "Enable"
            return True
            # break
        elif account in response_hni:
            # print "Read account is: ok "
            if "/username" in response_hni:
                get_username = response_hni[response_hcm.find("<username>") + 10:response_hni.find("</username>")]
            else:
                get_username = ""

            if "/info" in response_hni:
                get_info = response_hni[response_hcm.find("<info>") + 6:response_hni.find("</info>")]
            else:
                get_info = ""

            if "/validUntil" in response_hni:
                get_disable = "Disable"
            else:
                get_disable = "Enable"
            return True
            # break
        else:
            # print "DAML read account is NOK. Can not find account in response"
            return False
            # break
            # temp = "not ok"
        # else:
        #     print "Request again after 10 s"
            # temp = "not ok"
    else:
        print ("Loi check status account")
#---------------------------------------Dem SDT trong account--------------------------------------------------------------------------------------   
def count_number(account):
    global temp
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    # for i in range(60):
    time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]
    global get_routingtable, get_info, get_username, get_pass, get_disable, get_pricelist, get_valueMax, get_ruleset

    if "/info" in response_hcm:
        get_info = response_hcm[response_hcm.find("<info>") + 6:response_hcm.find("</info>")]
    elif "/info" in response_hcm:
        get_info = response_hni[response_hni.find("<info>") + 6:response_hni.find("</info>")]
    else:
        get_info = ""

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        if account in response_hcm:
            num_min = response_hcm.count("<number>")
            if num_min == 0:
                return False
                # break
            else:
                print (num_min)
                return True
                # break
        elif account in response_hni:
            num_min = response_hni.count("<number>")
            if num_min == 0:
                return False
                # break
            else:
                print (num_min)
                return True
                # break
        else:
            print "DAML count_number is NOK."
        # else:
        #     print "Request again after 10 s"

#-----------------------------------------Kiem tra Trunk cua Account------------------------------------------------------------------------------------   
def check_trunk_account(account):
    xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(1)
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]

    global get_siptrunk, max_siptrunk, list_siptrunk
    a = response_hcm.find("<sipTrunk>")
    b = response_hcm.rfind("</sipTrunk>") + 11
    string_trunk = response_hcm[a:b]
    list_siptrunk = []
    max_siptrunk = 0
    for i in range(60):
        if "<sipTrunk>" in string_trunk:
            s = string_trunk.find("<sipTrunk>") + 10
            e = string_trunk.find("</sipTrunk>")
            siptrunkName = str(string_trunk[s:e])
            if siptrunkName != "":
                max_siptrunk += 1
            else:
                break
            list_siptrunk.append(siptrunkName)
            string_trunk = string_trunk[e + 10:b]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        # print "Daml OK"
        if account in response_hcm:
            return True
        else:
            return False
#----------------------------------------Kiem tra SIP Trunk Name-------------------------------------------------------------------------------------   
def check_siptrunk(siptrunkName):
    time.sleep(1)
    xmlData = '''<daml command="read"><sipTrunk name="''' + siptrunkName + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    # time.sleep(3)
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]

    global get_ip, get_host, get_weight
    get_ip = response_hcm[response_hcm.find("<sipContact>") + 16:response_hcm.find("</sipContact>")]
    get_host = response_hcm[response_hcm.find("<route2>") + 12:response_hcm.find("</route2>")]
    get_weight = response_hcm[response_hcm.find("<q>") + 3:response_hcm.find("</q>")]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        # print "Daml OK"
        if siptrunkName in response_hcm:
            return True
        else:
            return False
    #-------------------------------------Kiem tra IP Trunk cua Account----------------------------------------------------------------------------------------   
def check_trunk_ip(account):
    global type_KHG, ip_main, port_main, typeip_main, list_host, ip_bk1, port_bk1, typeip_bk1, ip_bk2, port_bk2, typeip_bk2
    time.sleep(1)
    if check_trunk_account(account):
        type_KHG = "SIP Trunk"
        list_iptrunk = ['', '', '']
        list_port = ['', '', '']
        list_typeip = ['', '', '']
        list_host = ['', '', '']
        for sipName in list_siptrunk:
            siptrunkName = sipName
            if check_siptrunk(siptrunkName):
                ip_sip = str(get_ip.split(":")[0].strip())
                port = str(get_ip.split(":")[1].strip())
                host = str(get_host.split(":")[0].strip())
                if ip_sip not in list_iptrunk:
                    if get_weight == "1000":
                        list_iptrunk[0] = ip_sip
                        list_port[0] = port
                        list_typeip[0] = check_host(host)
                        list_host[0] = host
                    elif (list_iptrunk[0] != "") and (list_iptrunk[1] == ""):
                        list_iptrunk[1] = ip_sip
                        list_port[1] = port
                        list_typeip[1] = check_host(host)
                        list_host[1] = host
                    elif (list_iptrunk[0] != "") and (list_iptrunk[2] == ""):
                        list_iptrunk[2] = ip_sip
                        list_port[2] = port
                        list_typeip[2] = check_host(host)
                        list_host[2] = host
                    elif (get_weight == "0") and (list_iptrunk[0] == "") and (list_iptrunk[1] == ""):
                        list_iptrunk[0] = ip_sip
                        list_port[0] = port
                        list_typeip[0] = check_host(host)
                        list_host[0] = host
                    elif (get_weight == "0") and (list_iptrunk[0] != "") and (list_iptrunk[1] == ""):
                        list_iptrunk[1] = ip_sip
                        list_port[1] = port
                        list_typeip[1] = check_host(host)
                        list_host[1] = host

                ip_main = list_iptrunk[0]
                port_main = list_port[0]
                if ip_main != "" and list_port != "":
                    break
                else:
                    print "Tool Fail"
                    break
            else:
                print "Fail: Khong lay duoc thong so IP"
    else:
        type_KHG = "SIP Account"
#------------------------------------------------Kiem tra host-----------------------------------------------------------------------------   
def check_host(value):
    if value in ['118.69.114.182', '118.69.115.150']:
        type_ip = 'Public'
    else:
        type_ip = 'MPLS'
    return type_ip
#-----------------------------------------------------------------------------------------------------------------------------   
def Create_SipTrunk(sipTrunkName,sipTrunk_info,ip_KHG,port_KHG,type_Connect,sbc_Type,sbc_Name):
                  
    if (sbc_Name == "SBC-HCM") or (sbc_Name == "SG"):
        route1 = "sip:172.28.0.78:5060"
        if type_Connect == "Pub":            
            route2 = "sip:118.69.114.182:5060"
        elif type_Connect == "MPLS":            
            route2 = "sip:118.69.114.166:5060"
    if (sbc_Name == "SBC-HNI") or (sbc_Name == "HN"):
        route1 = "sip:172.28.0.12:5060"
        if type_Connect == "Pub":            
            route2 = "sip:118.69.115.150:5060"
        elif type_Connect == "MPLS":            
            route2 = "sip:118.69.115.134:5060"
    if sbc_Type == "SBC-Main":    
        weight = "1000"        
    elif sbc_Type == "SBC-Backup":
        weight = "0"
    
    xmlData_SIPTrunk = '''<daml command="create"><sipTrunk><name>'''+sipTrunkName+'''</name><info>'''+sipTrunk_info+'''</info><sipContact>sip:'''+ip_KHG+''':'''+port_KHG+'''</sipContact><route1>'''+route1+'''</route1><route2>'''+route2+'''</route2><q>'''+weight+'''</q><userAgent>Dialogic</userAgent><endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth><group>System</group></sipTrunk></daml>'''
    return xmlData_SIPTrunk
#-----------------------------------------------Map sip trunk vao account------------------------------------------------------------------------------   
def map_siptrunk_account(account, sipTrunkName):
    xmlData = '''<daml command="create"><accountSipTrunkMap account="'''+account+'''" sipTrunk="'''+sipTrunkName+'''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_create_trunk, data = payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]
    #print response
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        return True
    else:
        return False
#---------------------------------------------Add sip trunk vao account--------------------------------------------------------------------------------   
def add_siptrunk(xmlData):
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_create_trunk, data = payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]
    #print response
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        #print "DAML Add SIP Trunk is OK"
        return True
    else:
        # print "DAML Add SIP Trunk is NOK"
        return False
#--------------------------------------------Delete number tren AAR---------------------------------------------------------------------------------   
def delete_address(number,type_khg,type_number):
    # print type_khg
    if type_khg == "SIP Trunk":
        xmlData = '''<daml command="delete"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_write_address, data=payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            # print "Daml OK"
            f_out.write( timenow() + " Number: " + number + " has been deleted \n")
            return True
        else:
            print "DAML delete address fail"
            return False

    elif type_khg == "SIP Account":
        side_hni = ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]
        side_hcm = ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNG","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH","1900","1800"]
        if type_number in side_hni:
            url = url_write_address_hni
        elif type_number in side_hcm:
            url = url_write_address_hcm
        else:
            url = url_write_address_hcm

        xmlData = '''<daml command="delete"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url, data=payload)
        response = result.text

        if "status=ok" in response:
            # print "Daml OK"
            f_out.write( timenow() + " Number: " + number + " has been deleted \n")
            return True
        else:
            print "DAML delete address fail"
            return False

    else:
        print "DAML delete address fail this case.Stop"
#--------------------------------------------Add number vao Account---------------------------------------------------------------------------------
def add_address(number,account,number_domain,blocked,type_khg,type_number):
    time_now = timenow()
    if type_khg == "SIP Trunk":
        xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>''' + number_domain + '''</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
        # time.sleep(3)
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_write_address, data=payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print("and")
            return True
        elif "status=ok" in response_hcm or "status=ok" in response_hni:
            print("or")
            return True
        else:
            print "DAML add address fail1"
            print xmlData
            return False
    elif type_khg == "SIP Account":
        side_hni = ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]
        side_hcm = ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNG","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH","1900","1800"]
        if type_number in side_hni:
            xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>sipacchni.ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
            number_domain = "sipacchni.ivoice.fpt.vn"
            url = url_write_address_hni
        elif type_number in side_hcm:
            xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
            number_domain = "ivoice.fpt.vn"
            url = url_write_address_hcm
        else:
            xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + blocked + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
            number_domain = "ivoice.fpt.vn"
            url = url_write_address

        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        # time.sleep(3)
        result = requests.post(url, data=payload)
        response = result.text

        if "status=ok" in response:
            return True
        else:
            print "DAML add address fail2"
            return False
    else:
        print "DAML delete address fail this case.Stop"
#---------------------------------------Time now--------------------------------------------------------------------------------------   
def timenow():
    global time_now
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now
#--------------------------------------Kiem tra number tren AAR---------------------------------------------------------------------------------------   
def check_address(number):
    xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    # time.sleep(3)
    result = requests.post(url_read_address, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]

    global get_acc
    get_acc = response_hcm[response_hcm.find("<account>") + 9:response_hcm.find("</account>")]
    get_disable = response_hcm[response_hcm.find("<disabled>") + 10:response_hcm.find("</disabled>")]
    get_blocked = response_hcm[response_hcm.find("<blocked>") + 9:response_hcm.find("</blocked>")]
    get_register = response_hcm[response_hcm.find("<location>") + 10:response_hcm.rfind("</location>")]

    if "status=ok" not in response_hcm and "status=ok" not in response_hni:
        print "Daml not OK"
    else:
        print ("Daml OK")

    if number in response_hcm:
        get_acc = response_hcm[response_hcm.find("<account>") + 9:response_hcm.find("</account>")]
        get_disable = response_hcm[response_hcm.find("<disabled>") + 10:response_hcm.find("</disabled>")]
        get_blocked = response_hcm[response_hcm.find("<blocked>") + 9:response_hcm.find("</blocked>")]
        get_register = response_hcm[response_hcm.find("<location>") + 10:response_hcm.rfind("</location>")]
        return True
    elif number in response_hni:
        get_acc = response_hni[response_hni.find("<account>") + 9:response_hni.find("</account>")]
        get_disable = response_hni[response_hni.find("<disabled>") + 10:response_hni.find("</disabled>")]
        get_blocked = response_hni[response_hni.find("<blocked>") + 9:response_hni.find("</blocked>")]
        get_register = response_hni[response_hni.find("<location>") + 10:response_hni.rfind("</location>")]
        return True
    else:
        print "So khong ton tai tren AAR"
        return False
#--------------------------------------Rut gon name KHG---------------------------------------------------------------------------------------   
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
    
    for z in range(len(list_remove_2)):
        if list_remove_2[z] in shortname:
            shortname = shortname.replace(list_remove_2[z], "")
    shortname = shortname.replace(" ", "")
    return shortname
#-----------------------------------------------------------------------------------------------------------------------------   
def user_rand(y):
    return "".join(random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") for x in range(y))
#-----------------------------------------------------------------------------------------------------------------------------   
def random_pass(y):
    return "".join(
        random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{}()") for x in range(y))

#---------------------------------------Add new account tren AAR--------------------------------------------------------------------------------------   
def add_new_account(new_account, info, tenant, routingTable, pricelist, number, password, ruleset, time_now, maliciousCallerId, sysAccountTopStop):
    xmlData = '''<daml command="write"><account><accountName>'''+new_account+'''</accountName><info>'''+info+'''</info><maxChannels>500</maxChannels><tenant>'''+tenant+'''</tenant><routingTable>'''+routingTable+'''</routingTable><pricelist>'''+pricelist+'''</pricelist><username>'''+number+'''</username><password>'''+password+'''</password><emergencyLocation>LOC Default</emergencyLocation><ruleset>'''+ruleset+'''</ruleset><validAfter>'''+time_now+'''</validAfter><sendAoc>false</sendAoc> <specialArrangement>false</specialArrangement><alarmOnExpiry>false</alarmOnExpiry><maliciousCallerId>'''+maliciousCallerId+'''</maliciousCallerId><useMediaServer>false</useMediaServer><sendingHoldStream>false</sendingHoldStream><sysAccountTopStop>'''+sysAccountTopStop+'''</sysAccountTopStop></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        # print "Daml Config OK"
        return True
    else:
        print "DAML ADD ADDRESS NOK"
        return False
#--------------------------------------Edit Account tren AAR---------------------------------------------------------------------------------------   
def edit_username(account, value):
    print "Resetting username..."
    try:
        time.sleep(1)
        xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><username>''' + value + '''</username> </account></daml>'''
        # print xmlData
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_write_account, data=payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]
        codestatus = result.status_code
        # print response
        # print "\n"
        # print codestatus
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            # print "\nDaml OK"
            return True
        else:
            # print "Daml Fail"
            return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def Disable_Account(account,BlockTime,username):
    try:
        print "Disable Account..."
        xmlData = '''<daml command="write"> <account>  <accountName>''' + account + '''</accountName> <username>''' + username +'''</username> <routingTable>Block Call Disable Account</routingTable> <validUntil>''' + BlockTime + '''</validUntil></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}

        time.sleep(1)
        result = requests.post(url_write_account,data = payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            return True
        else:
            print "waiting..."
    except requests.exceptions.RequestException as error:
        print"Error"
        return False
 #--------------------------------------------Doc ruleset cua Account---------------------------------------------------------------------------------   
def read_ruleset(account):
    global get_ruleset

    xmlData = '''<daml command="read"><account><accountName>'''+account+'''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    # for i in range(60):
    time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    codestatus = result.status_code
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]

    if "status=ok" in response_hcm or "status=ok" in response_hni:
        if account in response_hcm:
            get_ruleset = response_hcm[response_hcm.find("<ruleset>") + 9:response_hcm.rfind("</ruleset>")]
            return get_ruleset
            # break
        elif account in response_hni:
            get_ruleset = response_hni[response_hni.find("<ruleset>") + 9:response_hni.rfind("</ruleset>")]
            return get_ruleset
        else:
            print "Can not find this ruleset account"
            return "Empty"
    else:
        print "Daml read_ruleset Fail...waiting...."
    # return False
def Get_Username(account):
    try:
        # print "Getting username of Account " + account
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        username = ""
        # for i in range(60):
        #     time.sleep(3)
        result = requests.post(url_read_account, data = payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            if "<username>" in response_hcm:
                username = response_hcm[response_hcm.rfind("<username>")+ 10:response_hcm.find("</username>")]
                return username
                # break
            else:
                print "username not found "
                return username
                # break
            # print "waiting..."
    except requests.exceptions.RequestException as error:
        print"Error"
        return username

def Set_Username(account,username):
    try:
        print "Setting new username Account..."
        xmlData = '''<daml command="write"> <account>  <accountName>''' + account + '''</accountName> <username>''' + username +'''</username> </account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        for i in range(60):
            time.sleep(3)
            result = requests.post(url_write_account,data = payload)
            response = result.text
            response_hcm = split_responses(response)[0]
            response_hni = split_responses(response)[1]

            if "status=ok" in response_hcm and "status=ok" in response_hni:
                return True
                break
            else:
                print "waiting..." 
        
    except requests.exceptions.RequestException as error:
        print"Error"
        return False
#-----------------------------------------Sync Account to Inside----------------------------------------------------------------------------------
def check_number(account):
    headers = {'content-type': 'application/json'}
    try:
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        #time.sleep(2)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        # print response
        
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]
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

        if "status=ok" in response_hcm:
            # print "Daml OK"
            if get_number != "":
                return True
            else:
                return False
        else:
            # print "Daml Fail"
            return False
    except requests.exceptions.RequestException as error:
        print error
        return 0



def check_account(account):
    headers = {'content-type': 'application/json'}
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(2)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_responses(response)[0]
    response_hni = split_responses(response)[1]
    # print response

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


def add_account_inside(contract, account, amount, list_phone):
    # headers = {'Content-type': 'text/html'}
    print "Insert inside: ", contract, "|", account, "|", amount, "|", list_phone
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
            jsondata = '''{"TypeRequest":"I", "Contract": "''' + contract + '''","UserRequest": "Tool","ListAccount": [{"AccountName": "''' + account + '''", "Amount": "''' + amount + '''", "AreaCode": "''' + areacode + '''", "ListPhoneNumber": "{''' + list_phone + '''}"}]}'''
            payload = {"jsondata": jsondata}
            # print payload
            time.sleep(3)
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


def update_account_inside(contract, account, list_phone):
    # headers = {'content-type': 'application/json'}
    print "Update inside: ", contract, "|", account, "|", list_phone
    try:
        #if account[10:14] == "1800":
            #amount = "0"
        #elif account[10:14] == "1900":
            #amount = "0"
        for i in range(60):
            jsondata = '''{"TypeRequest":"U", "Contract": "''' + contract + '''","UserRequest": "Tool","ListAccount": [{"AccountName": "''' + account + '''","ListPhoneNumber": "{''' + list_phone + '''}"}]}'''
            payload = {"jsondata": jsondata}
            #print "payload:", payload
            time.sleep(3)
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


def sync_account_inside(contract, account):
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

    if update_account_inside(contract, account, list_phone) == False:  # func update khong nhap han muc vao
        print "Update Account Inside unsuccessfully. Try to add account on inside"
        if add_account_inside(contract, account, amount, list_phone):
            print "Insert Account to Inside Successfully\n"
            return True
        else:
            print "Insert Account to Inside Unsuccessfully\n"
            c_list.write(timenow() + "," + contract + "," + account + "," + amount + "," + list_phone + "\n")
            return False
    else:
        print "Update Account Inside Successfully"
        return True


#-------------------------------------------Tao new Account tren AAR----------------------------------------------------------------------------------
def create_account(number_list,old_account,new_account,ruleset,name_KHG,ip_KHG,port_KHG,type_IP,ip_KHG_BK,type_IP_BK,port_KHG_BK,valueMax,type_swap,type_number):
    global run,xmlData_MapSIPTrunk,info,password,type_KHG_2,type_KHG_3

#------------------------------------Check thong tin KHG-------------------------------------------------------------------------
    # shd = shd.replace(" ", "")
    namekhg = name_KHG.title()
    name_KHG = shortname(namekhg)
    name_KHG = name_KHG.replace(" ", "")
    # number = number.replace(" ", "")

    if "&" in name_KHG:
        name_KHG = name_KHG.replace("&", "")
    if "<" in name_KHG:
        name_KHG = name_KHG.replace("<", "")
    if ">" in name_KHG:
        name_KHG = name_KHG.replace(">", "")

    # type_IP_BK = "Public"
    # type_IP_BK2 = "Public"
    ListNumber_input = number_list.split(",")
    ListNumber = []
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    username_old = Get_Username(old_account)
    # print username_old
    ListNumber = Get_Number_2(old_account)
    k = len(ListNumber)
    if k == 0:
        print "Get fail list number of account " + old_account
        # break
    elif k > 0:
        print (ListNumber)#list so dt cua account
        for number in ListNumber_input:
            #print k
            if number in ListNumber:
                i = ListNumber.index(number)#bi trung username tai gia tri i
                #print i
                check_trunk_ip(old_account)
                # print "type_KHG_3",type_KHG
                delete_address(number,type_KHG,type_number)
                k = k-1

                if k == 0:
                    username1 = user_rand(10)
                    # info_disable = get_info_old + " -> Huy"
                    Disable_Account(old_account, time_now,username1)
                    print " Account: " + old_account + " has been disabled \n"
                    f_out.write( timenow() + " Account: " + old_account + " has been disabled \n")
                else:
                    if number == username_old:
                        if i < k-1:
                            if Set_Username(old_account, ListNumber[i+1]) == True:
                                print "Username change to " + ListNumber[i+1]
                        else:
                            if Set_Username(old_account, ListNumber[i-1]) == True:
                                print "Username change to " + ListNumber[i-1]

    # print "Input:"

    number = ""
    num_max = 0
    num_max = number_list.count(",") + 1
    # print num_max
    for n in range(num_max):
        if num_max == 0:
            break
        number = str(number_list.split(",")[n].strip())

        out_put = ""
#------------------------------Check Tanent Account-------------------------------------------------------------------------------
        # port_KHG_BK2 = "5060"
        type_number = ""
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
        elif number[0:2] == "09":
            type_number = "Mobile"
        elif number[0:2] == "01":
            type_number = "Mobile"
        elif number[0:2] == "08":
            type_number = "Mobile"

        if type_number == "1800":
            tenant = "FPT-1900"
        else:
            tenant = "FPT-" + type_number

        pricelist = tenant

        time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        sipTrunkName = ""
        sipTrunkName2 = ""

        sbc_main = ""
        sbc_backup = ""

        password = ""
        password = random_pass(19)
#--------------------------------------Tao info SIP Trunk-----------------------------------------------------------------------
        if type_swap == "Chuyen SIP Trunk sang SIP Account":
            info = "SIP Account Register " + name_KHG + " " + new_account
            if type_number in ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]:
                number_domain = "sipacchni.ivoice.fpt.vn"
            elif type_number in ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNG","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH","1900","1800"]:
                number_domain = "sipacc.ivoice.fpt.vn"
            else:
                number_domain = "sipacc.ivoice.fpt.vn"
            username = number

        elif type_swap == "Chuyen SIP Account sang SIP Trunk":
            if ip_KHG_BK == "":
                info = "SIP Trunking Account " + name_KHG + " " + new_account + " IP-" + ip_KHG + "_" + type_IP
            else:
                info = "SIP Trunking Account " + name_KHG + " " + new_account + " IP-" + ip_KHG + "_" + type_IP + " BK-" + ip_KHG_BK + "_" + type_IP_BK

            number_domain = "ivoice.fpt.vn"
            username = user_rand(14)

            if port_KHG == "5060":
                if new_account[0:2]=="SG":
                    sbc_main = "SBC-HCM"
                    sbc_backup = "SBC-HNI"
                elif new_account[0:2]=="HN":
                    sbc_main = "SBC-HNI"
                    sbc_backup = "SBC-HCM"
                else:
                    sbc_main = "SBC-HCM"
                    sbc_backup = "SBC-HNI"
            else:
                if new_account[0:2]=="SG":
                    sbc_main = "SG"
                    sbc_backup = "HN"
                elif new_account[0:2]=="HN":
                    sbc_main =  "HN"
                    sbc_backup = "SG"
                else:
                    sbc_main = "SG"
                    sbc_backup =  "HN"

            if type_IP == "Public":
                typeIP = "Pub"
            else:
                typeIP = type_IP

            if port_KHG == "5060":
                sipTrunkName = ip_KHG + "_Pri_" + type_IP + "_" + sbc_main
                sipTrunkName2 = ip_KHG + "_Pri_" + type_IP + "_" + sbc_backup
            else:
                sipTrunkName = ip_KHG + ":" + port_KHG +"_Pr_"  + type_IP + "_" + sbc_main
                sipTrunkName2 = ip_KHG + ":" + port_KHG +"_Pr_" + type_IP + "_" + sbc_backup

            if len(sipTrunkName)>32 or len(sipTrunkName2)>32:
                print "Fail. SIP Trunk Name too long (max 32 characters)"

            sipTrunk_info = "SIP Trunk Profile " + new_account + " " + name_KHG + " IP-" + ip_KHG + ":" + port_KHG + "_Pri_" + type_IP + "_" + sbc_main
            sipTrunk_info2 = "SIP Trunk Profile " + new_account + " " + name_KHG + " IP-" + ip_KHG + ":" + port_KHG + "_Pri_" + type_IP + "_" + sbc_backup
            if ip_KHG_BK != "":
                if port_KHG_BK == "5060":
                    if new_account[0:2]=="SG":
                        sbc_main_bk = "SBC-HCM"
                        sbc_backup_bk = "SBC-HNI"
                    elif new_account[0:2]=="HN":
                        sbc_main_bk = "SBC-HNI"
                        sbc_backup_bk = "SBC-HCM"
                    else:
                        sbc_main_bk = "SBC-HCM"
                        sbc_backup_bk = "SBC-HNI"
                else:
                    if new_account[0:2]=="SG":
                        sbc_main_bk = "SG"
                        sbc_backup_bk = "HN"
                    elif new_account[0:2]=="HN":
                        sbc_main_bk =  "HN"
                        sbc_backup_bk = "SG"
                    else:
                        sbc_main_bk = "SG"
                        sbc_backup_bk =  "HN"

                if port_KHG_BK == "5060":
                    sipTrunkName_BK = ip_KHG_BK + "_BK_" + type_IP_BK + "_" + sbc_main_bk
                    sipTrunkName_BK2 = ip_KHG_BK + "_BK_" + type_IP_BK + "_" + sbc_backup_bk
                else:
                    sipTrunkName_BK = ip_KHG_BK + ":" + port_KHG_BK + "_BK_" + type_IP_BK + "_" + sbc_main_bk
                    sipTrunkName_BK2 = ip_KHG_BK + ":" + port_KHG_BK + "_BK_"+ type_IP_BK + "_" + sbc_backup_bk

                if len(sipTrunkName_BK) > 32 or len(sipTrunkName_BK2) > 32:
                    print "Fail. SIP Trunk Name too long (max 32 characters)"

                sipTrunk_info_bk = "SIP Trunk Profile " + new_account + " " + name_KHG + " IP-" + ip_KHG_BK + ":" + port_KHG_BK + "_BK_" + type_IP_BK + "_" + sbc_main_bk
                sipTrunk_info_bk2 = "SIP Trunk Profile " + new_account + " " + name_KHG + " IP-" + ip_KHG_BK + ":" + port_KHG_BK + "_BK_" + type_IP_BK + "_" + sbc_backup_bk

#-------------------------------------------------------------------------------------------------------------
        if type_number == "1900" or type_number == "1800":
            sysAccountTopStop = ""
            routingTable = ""
            pricelist = ""
            # ruleset = "1900-1800 : Block All Outgoing"
            blocked = "true"
            maliciousCallerId = "false"
        else:
            sysAccountTopStop = '''<valueMax>''' + valueMax + '''</valueMax><alarmLevel>0.9</alarmLevel><dailyMax>0.0</dailyMax><monthlyReset>true</monthlyReset><dailyReset>false</dailyReset>'''
            routingTable = "Route to PSTN"
        	# ruleset = "Block : All Outgoing International Calls</ruleset><ruleset>Block : International Call - High Cost"
            blocked = "false"
            maliciousCallerId = "true"
#--------------------------------------Thong tin password cua account-----------------------------------------------------------------------
        time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print "Password of New Account: " + new_account + " is: " + password + "\n"
        f_out.write( timenow() + " Password of New Account: " + new_account + " is: " + password + "\n")
        # print "new_account: " + new_account

#---------------------------------------------Add SDT vao account----------------------------------------------------------------
        check_account = check_status_account(new_account)
        if check_account: #Neu account da ton tai thi chi add sdt vao acc
            check_trunk_ip(new_account)
            print "type_KHG_1",type_KHG
            status_add_address = add_address(number,new_account,number_domain,blocked,type_KHG,type_number)
            if status_add_address:
                print "- Added number"
                print "--> Number: " + number + " of Account: " + new_account + " has been added \n"
                f_out.write( timenow() + " Number: " + number + " of Account: " + new_account + " has been added \n")
                print "----------------------------------------------"
                print "Output: OK\n"
                if sync_account_inside(contract, new_account):
                    f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " OK" + '\n')
                    # print "Output: OK\n"
                else:
                    f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " not OK" + '\n')
                    # print "Output: Fail\n"

            else:
                list_num_fail.append(number)
                print "--> Add number: " + number + " of Account: " + new_account + " Error \n"
                f_out.write( timenow() + " Add number: " + number + " of Account: " + new_account + " Error \n")
                print "Output: Fail"
        else: #neu account chua ton tai thi tao account new
            if add_new_account(new_account, info, tenant, routingTable, pricelist, username, password, ruleset, time_now, maliciousCallerId, sysAccountTopStop):
                print "***Creating new account " + new_account +" OK***"
                if type_swap == 'Chuyen SIP Trunk sang SIP Account':
                    type_KHG_2 = 'SIP Account'
                elif type_swap == 'Chuyen SIP Account sang SIP Trunk':
                    type_KHG_2 = 'SIP Trunk'
                print "type_KHG_2",type_KHG_2
                status_add_address = add_address(number,new_account,number_domain,blocked,type_KHG_2,type_number)
                if status_add_address:
                    print "- Added number"
                    print "--> Number: " + number + " of Account: " + new_account + " has been added \n"
                    f_out.write( timenow() + " Number: " + number + " of Account: " + new_account + " has been added \n")
                    print "----------------------------------------------"
                    print "Output: OK\n"

                    if sync_account_inside(contract, new_account):
                        f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " OK" + '\n')
                        # print "Output: OK\n"
                    else:
                        f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " not OK" + '\n')
                        # print "Output: Fail\n"

                else:
                    list_num_fail.append(number)
                    print "--> Add number: " + number + " of Account: " + new_account + " Error \n"
                    f_out.write( timenow() + " Add number: " + number + " of Account: " + new_account + " Error \n")
                    print "----------------------------------------------"
                    print "Output: Fail"      
            else:
                print "***Creating new account " + new_account + " NOK***"
                list_num_fail.append(number)
                output = "NOK"
#-------------------------------------Tao SIP Trunk------------------------------------------------------------------------
        if type_swap == "Chuyen SIP Account sang SIP Trunk":
            print "\n1. Check SIP Trunk Profile:"
            print "SIP Trunk Name Main:",sipTrunkName
            print "SIP Trunk Name Backup:",sipTrunkName2
            checksiptrunk = check_siptrunk(sipTrunkName)
            checksiptrunk2 = check_siptrunk(sipTrunkName2)

            if (len(Find_SipTrunk(ip_KHG,port_KHG))) == 0 :

                print "SIP Trunk chua ton tai"
                print "\n2. Create SIP Trunk Profile:"

                xmlDataSIPTrunk_main = Create_SipTrunk(sipTrunkName,sipTrunk_info,ip_KHG,port_KHG,type_IP,"SBC-Main",sbc_main)
                xmlDataSIPTrunk_backup = Create_SipTrunk(sipTrunkName,sipTrunk_info,ip_KHG,port_KHG,type_IP,"SBC-Backup",sbc_main)
                status = add_siptrunk(xmlDataSIPTrunk_main)
                if status:
                    print "-> Create new sip trunk main OK\n"
                    # out_put = "Output: OK"
                    f_out.write( timenow() + " SIP Trunk: " + sipTrunkName + " is created \n")
                else:
                    print "-> Create new sip trunk main Fail"
                    out_put = "Output: Fail"

                xmlDataSIPTrunk2 = Create_SipTrunk(sipTrunkName2,sipTrunk_info2,ip_KHG,port_KHG,type_IP,"SBC-Backup",sbc_backup)
                status2 = add_siptrunk(xmlDataSIPTrunk2)
                if status2:
                    print "-> Create new sip trunk backup OK\n"            
                    # out_put = "Output: OK"
                    f_out.write( timenow() + " SIP Trunk: " + sipTrunkName2 + " is created \n")
                else:
                    print "-> Create new sip trunk bk Fail"
                    out_put = "Output: Fail"   
            else:
                print "-> SIP Trunk Main da ton tai\n"


            if ip_KHG_BK != "":
                print "\n2. Check SIP Trunk Backup Profile:"
                print "SIP Trunk Name Backup Main:",sipTrunkName_BK
                print "SIP Trunk Name Backup Backup:",sipTrunkName_BK2
                checksiptrunk_bk = check_siptrunk(sipTrunkName_BK)
                checksiptrunk_bk2 = check_siptrunk(sipTrunkName_BK2)
                
                if (len(Find_SipTrunk(ip_KHG_BK,port_KHG_BK))) == 0 :
                    print "SIP Trunk Backup chua ton tai"
                    print "\n2. Create SIP Trunk Backup Profile:"
                    
                    xmlDataSIPTrunk_BK_backup = Create_SipTrunk(sipTrunkName_BK,sipTrunk_info_bk2,port_KHG_BK,port_KHG_BK,type_IP,"SBC-Backup",sbc_main)
                    status = add_siptrunk(xmlDataSIPTrunk_BK_backup)
                    if status:
                        print "-> Create new sip trunk main OK\n"
                        # out_put = "Output: OK"
                        f_out.write( timenow() + " SIP Trunk: " + sipTrunkName_BK + " is created \n")
                    else:
                        print "-> Create new sip trunk main Fail"
                        out_put = "Output: Fail"

                    status = add_siptrunk(xmlDataSIPTrunk_BK_backup)
                    if status:
                        print "-> Create new sip trunk main OK\n"
                        # out_put = "Output: OK"
                        f_out.write( timenow() + " SIP Trunk: " + sipTrunkName_BK + " is created \n")
                    else:
                        print "-> Create new sip trunk backup_main Fail"
                        out_put = "Output: Fail"

                    xmlDataSIPTrunk_BK2 = Create_SipTrunk(sipTrunkName_BK2,sipTrunk_info_bk2,ip_KHG_BK,port_KHG_BK,type_IP,"SBC-Backup",sbc_backup)
                    status2 = add_siptrunk(xmlDataSIPTrunk_BK2)
                    if status2:
                        print "-> Create new sip trunk backup_bk OK\n"            
                        # out_put = "Output: OK"
                        f_out.write( timenow() + " SIP Trunk: " + sipTrunkName_BK2 + " is created \n")
                    else:
                        print "-> Create new sip trunk backup_bk Fail"
                        out_put = "Output: Fail"   
                else:
                    print "-> SIP Trunk Main da ton tai\n"
               
            if map_siptrunk_account(new_account, sipTrunkName) == True:
                print "***Add sip trunk Main to account " + new_account + " OK***\n"
                f_out.write(timenow() + " Ruleset: " + sipTrunkName + " has been added to account " + new_account + "\n")
                print "Output: OK\n"
            else:
                print "***Add sip trunk Main to account " + new_account + " NOK***\n"
                print "Output: Fail\n"
            if map_siptrunk_account(new_account, sipTrunkName2) == True:
                print "***Add sip trunk Main_BK to account " + new_account + " OK***\n"
                f_out.write(timenow() + " Ruleset: " + sipTrunkName + " has been added to account " + new_account + "\n")
                print "Output: OK\n"
            else:
                print "***Add sip trunk Main_BK to account " + new_account + " NOK***\n"
                print "Output: Fail\n"
            if ip_KHG_BK != "":
                if map_siptrunk_account(new_account, sipTrunkName_BK) == True:
                    print "***Add sip trunk BK to account " + new_account + " OK***\n"
                    f_out.write(timenow() + " Ruleset: " + sipTrunkName_BK + " has been added to account " + new_account + "\n")
                    print "Output: OK\n"
                else:
                    print "***Add sip trunk BK to account " + new_account + " NOK***\n"
                    print "Output: Fail\n"
                if map_siptrunk_account(new_account, sipTrunkName_BK2) == True:
                    print "***Add sip trunk BK to account " + new_account + " OK***\n"
                    f_out.write(timenow() + " Ruleset: " + sipTrunkName_BK2 + " has been added to account " + new_account + "\n")
                    print "Output: OK\n"
                else:
                    print "***Add sip trunk BK to account " + new_account + " NOK***\n"
                    print "Output: Fail\n"

    print "***Done All " + str(num_max) + " number***"

 #----------------------------------Ham chuyen SIP Trunk sang SIP Acc va nguoc lai-------------------------------------------------------------------------------------------   
def swap_acc_to_trunk(number_list,name_KHG,ip_KHG,port_KHG,type_IP,ip_KHG_BK,port_KHG_BK,type_IP_BK,valueMax,type_swap):
    global get_acc,contract,Tanent_Hientai,type_KHG_3

    number_check = str(number_list.split(",")[0].strip())
    print "number_check",number_check
    if check_address(number_check):
        print "Number:", number_check, "thuoc Account:", get_acc
        if type_swap == "Chuyen SIP Account sang SIP Trunk":
            f_out.write("\n" +
                timenow() + " # Start # Chuyen SIP Acc sang SIP Trunk: " + get_acc + "," + name_KHG + ","  + number_check + ","  + ip_KHG + ":" + port_KHG + "," +  type_IP + "," + ip_KHG_BK + "," + type_IP_BK + "," + valueMax + "\n")
        else:
            f_out.write("\n" +
                timenow() + " # Start #  Chuyen SIP Trunk sang SIP Acc: " + get_acc + ", " + name_KHG + ", " + number_check + ", " + valueMax + "\n")
            username = user_rand(14)
            if edit_username(get_acc, username):
                print "Edit username Success of Account:" + get_acc
                # return True
            else:
                print "Edit fail"

        account = get_acc

        if read_ruleset(get_acc):
            contract = account[0:9]
            type_number = ""
            if number_check[0:3] == "028":
                type_number = "HCM"
            elif number_check[0:3] == "024":
                type_number = "HNI"
            elif number_check[0:4] == "0236":
                type_number = "DNG"
            elif number_check[0:4] == "0274":
                type_number = "BDG"
            elif number_check[0:4] == "0225":
                type_number = "HPG"
            elif number_check[0:4] == "0237":
                type_number = "THA"
            elif number_check[0:4] == "0238":
                type_number = "NAN"
            elif number_check[0:4] == "0258":
                type_number = "KHA"
            elif number_check[0:4] == "0251":
                type_number = "DNI"
            elif number_check[0:4] == "0254":
                type_number = "VTU"
            elif number_check[0:4] == "0292":
                type_number = "CTO"
            elif number_check[0:4] == "0296":
                type_number = "AGG"
            elif number_check[0:4] == "0297":
                type_number = "KGG"
            elif number_check[0:4] == "0203":
                type_number = "QNH"
            elif number_check[0:4] == "0204":
                type_number = "BGG"
            elif number_check[0:4] == "0205":
                type_number = "LSN"
            elif number_check[0:4] == "0206":
                type_number = "CBG"
            elif number_check[0:4] == "0207":
                type_number = "TQG"
            elif number_check[0:4] == "0208":
                type_number = "TNN"
            elif number_check[0:4] == "0209":
                type_number = "BKN"
            elif number_check[0:4] == "0210":
                type_number = "PTO"
            elif number_check[0:4] == "0211":
                type_number = "VPC"
            elif number_check[0:4] == "0212":
                type_number = "SLA"
            elif number_check[0:4] == "0213":
                type_number = "LCU"
            elif number_check[0:4] == "0214":
                type_number = "LCI"
            elif number_check[0:4] == "0215":
                type_number = "DBN"
            elif number_check[0:4] == "0216":
                type_number = "YBI"
            elif number_check[0:4] == "0218":
                type_number = "HBH"
            elif number_check[0:4] == "0219":
                type_number = "HAG"
            elif number_check[0:4] == "0220":
                type_number = "HDG"
            elif number_check[0:4] == "0221":
                type_number = "HYN"
            elif number_check[0:4] == "0222":
                type_number = "BNH"
            elif number_check[0:4] == "0226":
                type_number = "HNM"
            elif number_check[0:4] == "0227":
                type_number = "TBH"
            elif number_check[0:4] == "0228":
                type_number = "NDH"
            elif number_check[0:4] == "0229":
                type_number = "NBH"
            elif number_check[0:4] == "0232":
                type_number = "QBH"
            elif number_check[0:4] == "0233":
                type_number = "QTI"
            elif number_check[0:4] == "0234":
                type_number = "TTH"
            elif number_check[0:4] == "0235":
                type_number = "QNM"
            elif number_check[0:4] == "0239":
                type_number = "HTH"
            elif number_check[0:4] == "0252":
                type_number = "BTN"
            elif number_check[0:4] == "0255":
                type_number = "QNI"
            elif number_check[0:4] == "0256":
                type_number = "BDH"
            elif number_check[0:4] == "0257":
                type_number = "PYN"
            elif number_check[0:4] == "0259":
                type_number = "NTN"
            elif number_check[0:4] == "0260":
                type_number = "KTM"
            elif number_check[0:4] == "0261":
                type_number = "DNO"
            elif number_check[0:4] == "0262":
                type_number = "DLK"
            elif number_check[0:4] == "0263":
                type_number = "LDG"
            elif number_check[0:4] == "0269":
                type_number = "GLI"
            elif number_check[0:4] == "0270":
                type_number = "VLG"
            elif number_check[0:4] == "0271":
                type_number = "BPC"
            elif number_check[0:4] == "0272":
                type_number = "LAN"
            elif number_check[0:4] == "0273":
                type_number = "TGG"
            elif number_check[0:4] == "0275":
                type_number = "BTE"
            elif number_check[0:4] == "0276":
                type_number = "TNH"
            elif number_check[0:4] == "0277":
                type_number = "DTP"
            elif number_check[0:4] == "0290":
                type_number = "CMU"
            elif number_check[0:4] == "0291":
                type_number = "BLU"
            elif number_check[0:4] == "0293":
                type_number = "HGG"
            elif number_check[0:4] == "0294":
                type_number = "TVH"
            elif number_check[0:4] == "0299":
                type_number = "STG"
            elif number_check[0:4] == "1800":
                type_number = "1800"
            elif number_check[0:4] == "1900":
                type_number = "1900"
            elif number_check[0:2] == "09":
                type_number = "Mobile"
            elif number_check[0:2] == "01":
                type_number = "Mobile"
            elif number_check[0:2] == "08":
                type_number = "Mobile"

            if type_number == "1800":
                Tanent_acc = "1900"
            else:
                Tanent_acc = type_number

            for x in range(60):
                time.sleep(3)
                if x == 0:
                    new_account = contract + "_" +  Tanent_acc
                else:
                    new_account = contract + "_" + Tanent_acc + "_" + str(x)

                if check_status_account(new_account):
                    # print "-------------------------"
                    # print "Status of account", new_account + ": " + get_disable
                    info_account = get_info
                    check_trunk_ip(new_account)
                    # print "type_KHG_2:",type_KHG
                    if ip_main != "" and get_disable == "Enable" and type_KHG == "SIP Trunk" and type_swap == "Chuyen SIP Account sang SIP Trunk":
                        # if ip_main != "":
                        if ip_KHG == ip_main and port_KHG == port_main:
                            number = ""
                            num_max = 0
                            num_max = number_list.count(",") + 1
                            for n in range(num_max):
                                if num_max == 0:
                                    break
                                number = str(number_list.split(",")[n].strip())
                                status_del_add = delete_address(number,type_KHG,type_number)
                                if status_del_add:
                                    print "-->  Number: " + number + " of Account: " + account + " has been deleted \n"
                                    # f_out.write( timenow() + " Number: " + number + " of Account: " + account + " has been deleted \n")
                                    status_disable = count_number(account)
                                    # print get_info
                                    if status_disable:
                                        print "--> Khong Disable Account"
                                    else:
                                        print "- Disable Account"
                                        # Edit Account AARENET
                                        #if "-> Huy" not in get_info:
                                        # info = get_info + " -> Huy"
                                        # print info
                                        old_username = user_rand(14)
                                        time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                                        status_edit_acc = Disable_Account(account, time_now, old_username)
                                        #status_edit_acc = edit_acc(account, info, time_now)
                                        if status_edit_acc:
                                            print "--> Disable account", account, "OK"
                                            f_out.write(timenow() + " Account: " + account + " has been disable" + "\n")
                                        else:
                                            print "--> Disable account", account, "Error"
                                else:
                                    list_num_fail.append(number)
                                    print "--> Delete number: " + number + " of Account: " + account + " Error \n"
                                    f_out.write( timenow() + " Delete number: " + number + " of Account: " + account + " Error \n")
                                    print "Output: Fail\n"
                                    out_put = "Output: Fail"

                                blocked = "false"
                                maliciousCallerId = "true"
                                type_KHG_3 = ""
                                if type_swap == "Chuyen SIP Trunk sang SIP Account":
                                    print ("Fail")
                                    type_KHG_3 = "SIP Account"
                                elif type_swap == "Chuyen SIP Account sang SIP Trunk":
                                    print ("True")
                                    type_KHG_3 = "SIP Trunk"
                                else:
                                    type_KHG_3 = "SIP Trunk"
                                number_domain = "ivoice.fpt.vn"
                                print ("type_KHG_3: " + type_KHG_3)
                                status_add_address = add_address(number,new_account,number_domain,blocked,type_KHG_3,type_number)
                                if status_add_address:
                                    print "- Added number"
                                    print "--> Number: " + number + " of Account: " + new_account + " has been added \n"
                                    f_out.write( timenow() + " Number: " + number + " of Account: " + new_account + " has been added \n")
                                    print "Output: OK\n"
                                    # break
                                    print "----------------------------------------------"
                                    if sync_account_inside(contract, new_account):
                                        f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " OK" + '\n')
                                        # print "Output: OK\n"
                                    else:
                                        f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " not OK" + '\n')
                                        # print "Output: Fail\n"
                                else:
                                    list_num_fail.append(number)
                                    print "--> Added number: " + number + " of Account: " + account + " Error \n"
                                    print "Output: Fail\n"
                                    f_out.write( timenow() + " Added number: " + number + " of Account: " + account + " Error \n")
                                    out_put = "Output: Fail"
                                    # break
                            print "Done All " + str(num_max) + " number"
                            break
                    # else:
                    #     print "Check subaccount other"
                else:
                    print '''*** TRIEN KHAI VOICE KHG NEW: ''' + new_account + "***"
                    create_account(number_list,account,new_account,get_ruleset,name_KHG,ip_KHG,port_KHG,type_IP,ip_KHG_BK,type_IP_BK,port_KHG_BK,valueMax,type_swap,type_number)
                    break
        else:
            print "Tool fail..because..read ruleset fail \n"
            print "Please running tool again !!! \n"
    else:
        print "Tool fail. Please running tool again !!! \n"
#---------------------------------------------------------Get Number--------------------------------------

def Get_Number_2(account):#tra ve list number of account
    try:
        print "Getting numbers of account..." + account
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        ListAddress = []
        time.sleep(1)
        result = requests.post(url_read_account,data = payload)
        response = result.text
        response_hcm = split_responses(response)[0]
        response_hni = split_responses(response)[1]
        #print response
        if "number" in response_hcm:
            arrayIndex = []
            for match in finditer("<number>|</number>", response_hcm):
               start =  match.start()
               end = match.end()
               arrayIndex.append(start)
               arrayIndex.append(end)
            k = 1
            for j in range(len(arrayIndex)):
                if k < len(arrayIndex):
                    addr_tmp = response_hcm[arrayIndex[k]:arrayIndex[k+1]]
                    ListAddress.append(addr_tmp)
                    k = k+4
                else:
                    return ListAddress
        if "number" in response_hni:
            arrayIndex = []
            for match in finditer("<number>|</number>", response_hni):
               start =  match.start()
               end = match.end()
               arrayIndex.append(start)
               arrayIndex.append(end)
            k = 1
            for j in range(len(arrayIndex)):
                if k < len(arrayIndex):
                    addr_tmp = response_hni[arrayIndex[k]:arrayIndex[k+1]]
                    ListAddress.append(addr_tmp)
                    k = k+4
                else:
                    return ListAddress
        else:
            return ListAddress
    except requests.exceptions.RequestException as error:
        print error
        return ListAddress


#=========================================================================================================================================================        
#----------------------------------------Code anh TienNH17---------Chuyen theo so account------------
def Get_AccountFromContract(list_contract):#Lay danh sanh account tu list HD
    list_Account = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.78',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    for contract in list_contract:
        query =("SELECT ACCOUNT_NAME FROM account WHERE ACCOUNT_NAME like '" + contract + "%'")
        #print query
        cur.execute(query)
        for (AccountName) in cur:
            #print("Account Name : {}".format(AccountName))
            stringAccount = str(AccountName)
            tmpAccount = stringAccount[(stringAccount.find("'"))+1 : (stringAccount.rfind("'"))]       
            list_Account.append(tmpAccount)
    cur.close()           
    cnx.close()
    return list_Account

def Get_Account(number):#tra ve account chua number
    try:
        print "Getting Account contain Number..." + number +"\n"
        xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "TIENNH17", "TypeAarenet": "100"}
        Account = ""
        result = requests.post(url_read_address,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "<address>" in HCM_response:
                Account = HCM_response[HCM_response.rfind("<account>") + 9:HCM_response.find("</account>")]
                return Account
            else:
                print "Number incorrect, please check again this number " + number
                return Account
    except requests.exceptions.RequestException as error:
        print error
        return Account
def reset_pass(account, password): #chua su dung
    print "Resetting password..."
    try:
        xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><password>''' + password + '''</password></account></daml>'''
        #url = "http://new.aarenet.fpt.net/daml/account/config"
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        time.sleep(2)
        result = requests.post(url_write_account, data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "ok" in HCM_response:
                print "Reset OK"
                return True
            else:
                print "Reset Password Failed"
                return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def reset_username(account,username):
    print "Resetting user name of account..."
    try:
        xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><username>''' + username + '''</username></account></daml>'''
        #url = "http://new.aarenet.fpt.net/daml/account/config"
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        result = requests.post(url_write_account, data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "ok" in HCM_response:
                print "Reset username OK"
                return True
            else:
                print "Reset username Failed"
                return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def IsSipTrunk(account):
    try:
        xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        SipTrunk = ""
        ArraySipTrunk = []
        time.sleep(1)
        result = requests.post(url_read_siptrunk,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:           
            arrayIndex = []
            for match in finditer("<sipTrunk>|</sipTrunk>", HCM_response):
               start =  match.start()
               end = match.end()
               arrayIndex.append(start)
               arrayIndex.append(end)
            k = 1
            for j in range(len(arrayIndex)):
                if k < len(arrayIndex):
                    sipTrunk_tmp = HCM_response[arrayIndex[k]:arrayIndex[k+1]]
                    ArraySipTrunk.append(sipTrunk_tmp)
                    k = k+4
                else:
                    break                                      
            if len(ArraySipTrunk) != 0:
                print "Account dang la SIP TRUNK"
                return ArraySipTrunk             
            else:
                print "Account la SIP Acc"
                return ArraySipTrunk
                sys.exit()
        print ArraySipTrunk             
    except requests.exceptions.RequestException as error:
        print error
        return ArraySipTrunk

def Find_SipTrunk(ip,port):
    i= 0
    print "Searching Sip Trunk: " + ip + ":" + port
    list_SipTrunk = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.78',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query =("SELECT NAME FROM siptrunk WHERE SIP_CONTACT like '%" + ip + ":" + port + "%'")
    #print(query)
    cur.execute(query)
    for (SipTrunk) in cur:
        #print("SIP Trunk Profile : {}".format(SipTrunk))
        stringSipTrunk = str(SipTrunk)
        tmpSipTrunk = stringSipTrunk[(stringSipTrunk.find("'"))+1 : (stringSipTrunk.rfind("'"))] 
        list_SipTrunk.append(tmpSipTrunk)
    cur.close()
    cnx.close()
    i+=1
    if len(list_SipTrunk) != 2 and len(list_SipTrunk) != 0 :
        print "So luong SIP Trunk Profile khong hop le, xin kiem tra lai !"
        sys.exit()
    else:
        return list_SipTrunk

def CheckPri_SIPtrunk (siptrunk):
    type_PR = r"(PR)"
    type_BK = r"(BK)"
    siptrunk_matchPr = re.search(type_PR,siptrunk,re.I|re.M)
    siptrunk_matchBK = re.search(type_BK,siptrunk,re.I|re.M)
    if siptrunk_matchBK :
        print("SIP Trunk dang la BK")
        return 2
    elif siptrunk_matchPr :
        print("SIP Trunk dang la Pri")
        return 1

def check_type_number(number):
    global type_number,check_side
    type_number = ""
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
    elif number[0:2] == "09":
        type_number = "Mobile"
    elif number[0:2] == "01":
        type_number = "Mobile"
    elif number[0:2] == "08":
        type_number = "Mobile"

    if type_number in ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]:
        check_side = "NorthSide"
    elif type_number in ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNG","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH","1900","1800"]:
        check_side = "SouthSide"

    return type_number,check_side

def delete_address_HNI_HCM(number):#xoa so sip Acc tren AA HNI
    check_type_number(number)
    if type_number in ["BKN","BGG","BNH","CBG","DBN","HAG","HNM","HNI","HTH","HDG","HPG","HBH","HYN","LCU","LSN","LCI","NDH","NAN","NBH","PTO","QBH","QNH","SLA","TBH","TNN","THA","TQG","VPC","YBI","QTI","TTH"]:
        url = hcm_url_write_address
    elif type_number in ["AGG","VTU","BLU","BTE","BDG","BPC","BTN","CMU","CTO","DNG","DLK","DNG","DNI","DTP","GLI","HGG","HCM","KHA","KGG","KTM","LDG","LAN","NTN","STG","TNH","TGG","TVH","VLG","QNM","QNI","PYN","BDH","1900","1800"]:
        url = hni_url_write_address
    else:
        print ("error check type_number")
    print "deleting number site AAR " + number
    print (url)
    xmlData = '''<daml command="delete"><address><number>''' + number + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url, data=payload)
    response = result.text
    if "ok" in response :
        print "Xoa so sip acc thanh cong tren AA-HNI "
        return True
    else:
        print "Xoa so sip acc khong thanh cong tren AA-HNI "
        return False

def add_address_HNI_HCM(number,account):#them so tren AA HNI case chuyen tu Sip Acc-> Sip Trunk
    print "Creating number site AA-HNI..." + number
    time_now = timenow()
    #HNI_time_now = HNI_time_now.replace(" ", "T")
    incoming_only = 'false'
    if number[0:4] == '1800' or number[0:4] == '1900':
        incoming_only = 'true'
    #xmlData = '''<daml command="write"><address>  <number>''' + number + '''</number>  <domain>ivoice.fpt.vn</domain><account>''' + account + '''</account>  <disabled>false</disabled>  <displayName>''' + number + '''</displayName> <blocked>''' + incoming_only + '''</blocked> <validAfter>''' + HNI_time_now + '''</validAfter> </address></daml>'''
    xmlData = '''<daml command="write"><address><number>''' + number + '''</number><domain>ivoice.fpt.vn</domain><account>''' + account + '''</account><disabled>false</disabled><displayName>''' + number + '''</displayName><language>en</language><validAfter>''' + time_now + '''</validAfter><showClip>true</showClip><hideClip>false</hideClip><mainNumber>false</mainNumber><baseNumber>false</baseNumber><registersViaMainNumber>false</registersViaMainNumber><signalingOnly>false</signalingOnly><blocked>''' + incoming_only + '''</blocked><singleLocation>false</singleLocation><preferredNumber>false</preferredNumber><noOfferOnBusy>false</noOfferOnBusy><callWaiting>false</callWaiting><callHold>false</callHold><priorityCall>false</priorityCall><privateNumber>false</privateNumber><balancedRouting>false</balancedRouting><autoRecord>false</autoRecord><busyIfAllDevicesAreBusy>false</busyIfAllDevicesAreBusy><queueLen>0</queueLen></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_address, data=payload)
    #print account
    #print xmlData
    response = result.text
    #print response
    if "ok" in response :
        print "Tao so SIP Acc thanh cong tren AA-HNI "
        return True
    else:
        print "Tao so SIP Acc khong thanh cong tren AA-HNI "
        return False

def Get_RuleSet(account):
    try:
        print "Reading Rule Set of Account " + account +"\n"
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        ArrayRuleSet = []
        time.sleep(1)
        result = requests.post(url_read_account,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        #print response
        else:
            arrayIndex = []
            for match in finditer("<ruleset>|</ruleset>", HCM_response):
               start =  match.start()
               end = match.end()
               arrayIndex.append(start)
               arrayIndex.append(end)
            k = 1
            for j in range(len(arrayIndex)):
                if k < len(arrayIndex):
                    ruleset_tmp = HCM_response[arrayIndex[k]:arrayIndex[k+1]]
                    ArrayRuleSet.append(ruleset_tmp)
                    k = k+4
                else:
                    return ArrayRuleSet
                    break
        return ArrayRuleSet
    except requests.exceptions.RequestException as error:
        print"Error"
        return Arr
def ChangeInfoAcc(account,info):
    try:
        print "Changing information Account..."
        xmlData = '''<daml command="write"> <account>  <accountName>''' + account + '''</accountName>  <info>''' + info + '''</info></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        result = requests.post(url_write_account,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "ok" in HCM_response:
                return True
            else:
                return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def ChangeDomain(number,domain):
    try:
        print "Changing domain Account..."
        check_type_number(number)
        if domain == "sipacc.ivoice.fpt.vn":
            if check_side == "SouthSide":
                domain = "sipacc.ivoice.fpt.vn"
                print (check_side)
                print (domain)
            elif check_side == "NorthSide":
                domain = "sipacchni.ivoice.fpt.vn"
                print (check_side)
                print (domain)
            else:
                print("error ChangeDomain")
                return domain
        else:
            domain == "ivoice.fpt.vn"
        xmlData = '''<daml command="write"> <address> <number>''' + number + '''</number> <domain>''' + domain + '''</domain></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        time.sleep(2)
        result = requests.post(url_write_account,data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "ok" in HCM_response:
                print "Changed domain success"
                return True
            else:
                return False
    except requests.exceptions.RequestException as error:
        print (error)
        return False

def RemoveTrunkOfAcc(account,ArraySipTrunk):
    try:
        flag = 0
        for SipTrunk in ArraySipTrunk:
            print "Removing SipTrunk..." + SipTrunk
            xmlData = '''<daml command="delete"><accountSipTrunkMap account="''' + account + '''" sipTrunk="''' + SipTrunk + '''"/></daml>'''
            payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
            time.sleep(2)
            result = requests.post(url_create_trunk,data = payload)
            response = result.text
            list_response = split_Response(response)
            HCM_response = list_response[0]
            HNI_response = list_response[1]
            #print HCM_response, len(HCM_response)
            #print HNI_response, len(HNI_response)
            if len(HCM_response) != len(HNI_response):
                print"He thong khong dong bo "
                sys.exit()
            else:               
                if "ok" in HCM_response:
                    flag += 1
        if flag == len(ArraySipTrunk):
            return True
        else:
            return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def isSipAccount(account):#Chi kiem tra tren site AA HCM
    try:
        xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        result = requests.post(hcm_url_read_siptrunk,data = payload)
        response = result.text
        if "ok" in response:
            if '''<sipTrunk>''' in response :
                print "Account dang la SIP TRUNK"
                return False
            else:
                print "Account la SIP Acc"
                return True
    except requests.exceptions.RequestException as error:
        print"Error"
        return False
    
def check_ProSIPTrunk(ipaddress, port, priority, type_connect):
    print "Checking SipTrunk Profile..."
    basicTrunkHN = ipaddress + "_" + priority + "_" + type_connect + "_" + "SBC-HNI"
    advanceTrunkHN = ipaddress + ":" + port + "_" + priority + "_" + type_connect + "_" + "HN" #Trunk co port # 5060
    basicTrunkHCM = ipaddress + "_" + priority + "_" + type_connect + "_" + "SBC-HCM"
    advanceTrunkHCM = ipaddress + ":" + port + "_" + priority + "_" + type_connect + "_" + "SG"
    if port == "5060":
        xmlData = '<daml command="read"><sipTrunk name="' + basicTrunkHCM + '"/></daml>'
    else:
        xmlData = '<daml command="read"><sipTrunk name="' + advanceTrunkHN + '"/></daml>'
    payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
    result = requests.post(url_read_siptrunk, data = payload)
    #print basicTrunkHCM
    #print advanceTrunkHCM
    response = result.text
    list_response = split_Response(response)
    HCM_response = list_response[0]
    HNI_response = list_response[1]
    #print HCM_response, len(HCM_response)
    #print HNI_response, len(HNI_response)
    if len(HCM_response) != len(HNI_response):
        print"He thong khong dong bo "
        sys.exit()       
    #print (response)
    else:
        if "ok" in HCM_response:
                print"SIP Trunk Available"                        
                return True 
        else:
            print"SIP Trunk UnAvailable"
            return False

def create_ProSIPTrunk(account,name,ipaddress, port, priority, type_connect):
    print "Creating Sip Trunk Profile..."
    try:
        SBC_type = ""
        #SBC_advance = ""
        TrunkNameBasic = ipaddress + "_" + priority + "_" + type_connect + "_" 
        TrunkNameAd = ipaddress + ":" + port + "_" + priority + "_" + type_connect + "_" 
        TrunkInfo = ipaddress + ":" + port + "_" + priority+ "_" + type_connect + "_" 
        if port == "5060":
            TrunkName = TrunkNameBasic
            SBC_HNI_type = "SBC-HNI"
            SBC_HCM_type = "SBC-HCM"
            if account[0:2] == 'HN':
                if priority == "Pri":
                    weightHN = "1000"
                    weightHCM = "0"
                else:
                    weightHN = "0"
                    weightHCM = "0"        
            else:
                if priority == "Pri":
                    weightHN = "0"
                    weightHCM = "1000"
                else:
                    weightHN = "0"
                    weightHCM = "0"
        else:
            TrunkName = TrunkNameAd
            SBC_HNI_type = "HN"
            SBC_HCM_type = "SG"
            if account[0:2] == 'HN':
                if priority == "Pr":
                    weightHN = "1000"
                    weightHCM = "0"
                else:
                    weightHN = "0"
                    weightHCM = "0"        
            else:
                if priority == "Pr":
                    weightHN = "0"
                    weightHCM = "1000"
                else:
                    weightHN = "0"
                    weightHCM = "0"
        if type_connect == 'MPLS':#Tao Trunk MPLS
            xmlData1 = '<daml command="create"><sipTrunk>  <name>' + TrunkName + SBC_HNI_type + '</name>  <info>SIP Trunk Profile ' + account + ' ' + name + ' ' + TrunkInfo + SBC_HNI_type + ' </info>  <sipContact>sip:' + ipaddress+ ":" + port + '</sipContact><route1>sip:172.28.0.12:5060</route1>   <route2>sip:118.69.115.134:5060</route2><q>' + weightHN + '</q>  <userAgent>Dialogic</userAgent>  <endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth>  <group>System</group> </sipTrunk></daml>'
            xmlData2 = '<daml command="create"><sipTrunk>  <name>' + TrunkName + SBC_HCM_type + '</name>  <info>SIP Trunk Profile ' + account + ' ' + name + ' ' + TrunkInfo + SBC_HCM_type + ' </info>  <sipContact>sip:' + ipaddress+ ":" + port + '</sipContact><route1>sip:172.28.0.78:5060</route1>   <route2>sip:118.69.114.166:5060</route2><q>' + weightHCM + '</q>  <userAgent>Dialogic</userAgent>  <endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth>  <group>System</group> </sipTrunk></daml>'         
        else:#Tao Trunk Public 
            xmlData1 = '<daml command="create"><sipTrunk>  <name>' + TrunkName + SBC_HNI_type + '</name>  <info>SIP Trunk Profile ' + account + ' ' + name + ' ' + TrunkInfo + SBC_HNI_type + ' </info>  <sipContact>sip:' + ipaddress+ ":" + port + '</sipContact><route1>sip:172.28.0.12:5060</route1>   <route2>sip:118.69.115.150:5060</route2><q>' + weightHN + '</q>  <userAgent>Dialogic</userAgent>  <endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth>  <group>System</group> </sipTrunk></daml>'
            xmlData2 = '<daml command="create"><sipTrunk>  <name>' + TrunkName + SBC_HCM_type + '</name>  <info>SIP Trunk Profile ' + account + ' ' + name + ' ' + TrunkInfo + SBC_HCM_type + ' </info>  <sipContact>sip:' + ipaddress+ ":" + port + '</sipContact><route1>sip:172.28.0.78:5060</route1>   <route2>sip:118.69.114.182:5060</route2><q>' + weightHCM + '</q>  <userAgent>Dialogic</userAgent>  <endpoint>Private DC1 UDP 5060</endpoint><auth>RemoteAddress</auth>  <group>System</group> </sipTrunk></daml>'   
        payload1 = {"XmlData": xmlData1, "UserRequest": "AOPT", "TypeAarenet": "100"}
        payload2 = {"XmlData": xmlData2, "UserRequest": "AOPT", "TypeAarenet": "100"}
        #time.sleep(2)
        #print xmlData1 + "\n"
        #print xmlData2
        result1 = requests.post(url_create_trunk, data = payload1)
        #time.sleep(2)
        result2 = requests.post(url_create_trunk, data = payload2)
        response1 = result1.text
        response2 = result2.text
        list_response1 = split_Response(response1)
        HCM_response1 = list_response1[0]
        HNI_response1 = list_response1[1]
        list_response2 = split_Response(response2)
        HCM_response2 = list_response2[0]
        HNI_response2 = list_response2[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response1) != len(HNI_response1):
            print"He thong khong dong bo "
            sys.exit()           
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        elif len(HCM_response2) != len(HNI_response2):
            print"He thong khong dong bo "
            sys.exit()           
        #print response1
        else:
            print"Create SIP Trunk Success"                 
            return True
    except requests.exceptions.RequestException as error:
        print error
        return False
           
def MapNewSIPtrunkToAcc(account,ipaddress, port, priority, type_connect):#Map new sip trunk vao Acccount
    print"Adding Sip Trunk Profile to Account..."
    try:
        SBC_type = ""
        TrunkNameBasic = ipaddress + "_" + priority + "_" + type_connect + "_" 
        TrunkNameAd = ipaddress + ":" + port + "_" + priority + "_" + type_connect + "_" 
        TrunkInfo = ipaddress + ":" + port + "_" + priority+ "_" + type_connect + "_" 
        if port == "5060":
            TrunkName = TrunkNameBasic
            SBC_HNI_type = "SBC-HNI"
            SBC_HCM_type = "SBC-HCM"
        else:
            TrunkName = TrunkNameAd
            SBC_HNI_type = "HN"
            SBC_HCM_type = "SG"
        xmlData1 = '<daml command="create"><accountSipTrunkMap account="' + account + '" sipTrunk="' + TrunkName + SBC_HNI_type + '"/></daml>'
        xmlData2 = '<daml command="create"><accountSipTrunkMap account="' + account + '" sipTrunk="' + TrunkName + SBC_HCM_type + '"/></daml>'
        payload1 = {"XmlData": xmlData1, "UserRequest": "AOPT", "TypeAarenet": "100"}
        payload2 = {"XmlData": xmlData2, "UserRequest": "AOPT", "TypeAarenet": "100"}
        time.sleep(2)
        result1 = requests.post(url_create_trunk, data = payload1)
        result2 = requests.post(url_create_trunk, data = payload2)
        response1 = result1.text
        response2 = result2.text
        list_response1 = split_Response(response1)
        HCM_response1 = list_response1[0]
        HNI_response1 = list_response1[1]
        #print HCM_response1,HNI_response1
        list_response2 = split_Response(response2)
        HCM_response2 = list_response2[0]
        HNI_response2 = list_response2[1]
        #print HCM_response1,HNI_response1
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response1) != len(HNI_response1):
            print"He thong khong dong bo "
            sys.exit()
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        elif len(HCM_response2) != len(HNI_response2):
            print"He thong khong dong bo "
            sys.exit()
        #print response1
        else:
            print"Adding SIP Trunk Success"
            return True
    except requests.exceptions.RequestException as error:
        print error
        return False

def MapSipTrunkToAcc(account,siptrunk):#map exist trunk vao account
    print"Adding Sip Trunk Profile to Account..."
    try:
        xmlData = '<daml command="create"><accountSipTrunkMap account="' + account + '" sipTrunk="' + siptrunk + '"/></daml>'
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_create_trunk, data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()
        else:
            if "ok" in HCM_response:
                print"Successfully add SIP Trunk " + siptrunk
                return True
            else:
                print "Add Sip Trunk to Account Fail "
                return False             
    except requests.exceptions.RequestException as error:
        print error
        return False

def CheckWeight_SIPtrunk(siptrunk):#kiem tra Main/Bak Trunk
    try:
        print "Checkking Weight of SIP Trunk"
        xmlData = '<daml command="read"><sipTrunk name="' + siptrunk + '"/></daml>'
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        time.sleep(1)
        result = requests.post(url_create_trunk, data = payload)
        response = result.text
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, len(HCM_response)
        #print HNI_response, len(HNI_response)
        if len(HCM_response) != len(HNI_response):
            print"He thong khong dong bo "
            sys.exit()   
        else:         
            if "ok" in HCM_response:
                weight = HCM_response[HCM_response.rfind("<q>")+3 : HCM_response.find("</q>")]
                if weight == "1000" :
                    return True
                else:
                    return False
    except requests.exceptions.RequestException as error:
        print error
        return False

def Get_Number(account):#tra ve list number of account
    try:
        print "Getting numbers of account..." + account
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        HCM_listAddress = []
        HNI_listAddress = []
        result = requests.post(url_read_account,data = payload)
        response = result.text
        #print response
        list_response = split_Response(response)
        HCM_response = list_response[0]
        HNI_response = list_response[1]
        #print HCM_response, type(len(HCM_response))
        #print HNI_response, type(len(HNI_response))
        if (account in HCM_response) and (account in HNI_response):
            HCM_arrayIndex = []
            HNI_arrayIndex = []
            for match in finditer("<number>|</number>", HCM_response):
               start =  match.start()
               end = match.end()
               HCM_arrayIndex.append(start)
               HCM_arrayIndex.append(end)
            k = 1
            for j in range(len(HCM_arrayIndex)):
                if k < len(HCM_arrayIndex):
                    addr_tmp = HCM_response[HCM_arrayIndex[k]:HCM_arrayIndex[k+1]]
                    HCM_listAddress.append(addr_tmp)
                    k = k+4
            for match in finditer("<number>|</number>", HNI_response):
               start =  match.start()
               end = match.end()
               HNI_arrayIndex.append(start)
               HNI_arrayIndex.append(end)
            k = 1
            for j in range(len(HNI_arrayIndex)):
                if k < len(HNI_arrayIndex):
                    addr_tmp = HNI_response[HNI_arrayIndex[k]:HNI_arrayIndex[k+1]]
                    HNI_listAddress.append(addr_tmp)
                    k = k+4
            if len(HCM_listAddress) != len(HNI_listAddress):
                print"He thong khong dong bo number "
                sys.exit()
            else:
                return HCM_listAddress
        else:
            print"He thong khong dong bo account "
            sys.exit()
    except requests.exceptions.RequestException as error:
        print error
        return ListAddress

def Get_valueCurrent(account):#lay tong current value tren account SIP TRUNK 2 site -> SIP ACC tren AA-HCM
    print "Getting value current of account " + account
    global tenant, routingTable, pricelist, listRuleset, maliciousCallerId, valueMax, khg_name, valueCurrent
    xmlData ='<daml command="read"><account><accountName>' + account + '</accountName></account></daml>'
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data = payload)
    response = result.text
    list_response = split_Response(response)
    HCM_response = list_response[0]
    HNI_response = list_response[1]
    if (account in HCM_response) and (account in HNI_response):
        if "<valueCurrent>" in (HCM_response or HNI_response): 
            valueCurrent_HCM = HCM_response[HCM_response.find("<valueCurrent>")+14:HCM_response.rfind("</valueCurrent>")]
            valueCurrent_HNI = HNI_response[HNI_response.find("<valueCurrent>")+14:HNI_response.rfind("</valueCurrent>")]
            valueCurrent = (float)(valueCurrent_HCM) + (float)(valueCurrent_HNI)
            return (str)(valueCurrent)
        else:
            print"He thong khong dong bo curren Value "
            sys.exit()
    else:
        print"He thong khong dong bo account "
        sys.exit()

def Set_valueCurrent_HCM(account,currentValue):#TH SIP Trunk -> SIP ACC
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_chuyen_sipacc_siptrunk.log", "a+")
    sysAccountTopStop ='''<valueCurrent mode="force">'''+ currentValue + '''</valueCurrent>'''
    xmlData = '''<daml command="write"> <account> <accountName>'''+account+'''</accountName> <sysAccountTopStop>'''+sysAccountTopStop+'''</sysAccountTopStop> </account> </daml>'''
    #print xmlData
    payload = {"XmlData": xmlData, "UserRequest": "aopt"}
    result = requests.post(hcm_url_write_account, data=payload)
    response = result.text
    if "ok" in response:
        print "Set value current Account HCM Success"
        f_out.write("Set value current Account HCM Success: " + account + "...\n")
        return True
    else:
        print "Set value current Account HCM Fail"
        f_out.write("Set value current Account HCM Fail: " + account + "...\n")
        sys.exit()
        
def Reset_valueCurrent_HNI(account):#reset current value account AA-HNI trong TH SIP Trunk -> SIP ACC
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_chuyen_sipacc_siptrunk.log", "a+")
    sysAccountTopStop ='''<valueCurrent mode="force">0.00</valueCurrent>'''
    xmlData = '''<daml command="write"> <account> <accountName>'''+account+'''</accountName> <sysAccountTopStop>'''+sysAccountTopStop+'''</sysAccountTopStop> </account> </daml>'''
    #print xmlData
    payload = {"XmlData": xmlData, "UserRequest": "aopt"}
    result = requests.post(hni_url_write_account, data=payload)
    response = result.text
    if "ok" in response:
        print "Reset value current Account HNI Success"
        f_out.write("Reset value current Account HNI Success: " + account + "...\n")
        return True
    else:
        print "Reset value current Account HNI Fail"
        f_out.write("Reset value current Account HNI Fail: " + account + "...\n")
        sys.exit()

def Get_Number_HCM_HNI(account):#tra ve list number of SIP Account tren AA-HCM
    try:
        print "Getting numbers of account in" + account
        xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT", "TypeAarenet": "100"}
        ListAddress = []
        arrayIndex = []
        time.sleep(1)
        result_hcm = requests.post(hcm_url_read_account,data = payload)
        result_hni = requests.post(hni_url_read_account,data = payload)
        response_hcm = result_hcm.text
        response_hni = result_hni.text
        if "ok" in response_hcm :
            if "number" in response_hcm:
                for match in finditer("<number>|</number>", response_hcm):
                   start =  match.start()
                   end = match.end()
                   arrayIndex.append(start)
                   arrayIndex.append(end)
                k = 1
                for j in range(len(arrayIndex)):
                    if k < len(arrayIndex):
                        addr_tmp = response_hcm[arrayIndex[k]:arrayIndex[k+1]]
                        ListAddress.append(addr_tmp)
                        k = k+4
                    else:
                        print (ListAddress," HCM")
            else:
                print (ListAddress," HCM")
        else:
            print "He thong khong nhan duoc phan hoi !!!"
            sys.exit()
        if "ok" in response_hni :
            if "number" in response_hni:
                for match in finditer("<number>|</number>", response_hni):
                    start =  match.start()
                    end = match.end()
                    arrayIndex.append(start)
                    arrayIndex.append(end)
                k = 1
                for j in range(len(arrayIndex)):
                    if k < len(arrayIndex):
                        addr_tmp = response_hni[arrayIndex[k]:arrayIndex[k+1]]
                        ListAddress.append(addr_tmp)
                        k = k+4
                    else:
                        print (ListAddress, "HNI")
            else:
                print (ListAddress, " HNI")
        else:
            print "He thong khong nhan duoc phan hoi !!!"
            sys.exit()
        return ListAddress
    except requests.exceptions.RequestException as error:
        print error
        return ListAddress

def main():
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_chuyen_sipacc_siptrunk.log", "a+")
    global c_list
    c_list = open("/home/administrator/aopt/logs/update_acc_inside_fail.csv", "a+")
    parser = OptionParser()

    parser.add_option("--o1", "--option", dest="type_check", type="string",
                      help="Input type of checking: Doi theo SDT / Doi theo account AA / Doi theo so hop dong")
    parser.add_option("-a", "--contract", dest="list_account", type="string", help="So Account AA")
    parser.add_option("-n", "--name", dest="name", type="string", help="Ten KHG")
    parser.add_option("-k", "--number_list", dest="number_list", type="string", help="Number (1,2,3)")
    parser.add_option("--o2", "--type_swap", dest="type_swap", type="string", help="Loai swap: Chuyen SIP Trunk sang SIP Account | Chuyen SIP Account sang SIP Trunk")
    parser.add_option("--ip1", dest="ip_KHG", type="string", help="IP Main")
    parser.add_option("--p1", dest="port_KHG", type="string", help="Port Main")
    parser.add_option("--ip1t", "--ip1_type", dest="type_IP", type="string", help="Loai IP Main")
    parser.add_option("--ip2", dest="ip_KHG_BK", type="string", help="IP BK1")
    parser.add_option("--p2", dest="port_KHG_BK", type="string", help="Port IP BK1")
    parser.add_option("--ip2t", "--ip2_type", dest="type_IP_BK", type="string", help="Loai IP BK1")
    parser.add_option("-c", "--contract2", dest="contract2", type="string", help="SHD_KHG")
    parser.add_option("-v", "--max", dest="valueMax", type="string", help="Han muc su dung", default="2000000")

    (options, args) = parser.parse_args()

    if options.type_swap == "Chuyen SIP Account sang SIP Trunk":
        if (options.ip_KHG != "") or (options.ip_KHG != "--ip1"):
            ip_KHG = options.ip_KHG
            type_IP = options.type_IP
            port_KHG = options.port_KHG
            ip_KHG = ip_KHG.replace(" ", "")
            port_KHG = port_KHG.replace(" ", "")
            type_IP = type_IP.replace(" ", "")
        elif (options.ip_KHG == "") or (options.ip_KHG == "--ip1"):
            # out_put = "IP KHG Main chua duoc nhap"
            ip_KHG = ""
            port_KHG =""
            type_IP =""

        if (options.ip_KHG_BK != "") or (options.ip_KHG_BK != "--ip2t"):
            ip_KHG_BK = options.ip_KHG_BK
            type_IP_BK = options.type_IP_BK
            port_KHG_BK = options.port_KHG_BK 
            ip_KHG_BK = str(ip_KHG_BK).replace(" ", "")
            port_KHG_BK = port_KHG_BK.replace(" ", "")
            type_IP_BK = type_IP_BK.replace(" ", "")
        else:
            ip_KHG_BK = ""
            port_KHG_BK =""
            type_IP_BK = ""

    else:
        ip_KHG = ""
        port_KHG =""
        type_IP =""
        ip_KHG_BK = ""
        port_KHG_BK = ""
        type_IP_BK = ""

    if (options.valueMax == "") or (options.valueMax == "-v"):
        options.valueMax = "2000000"

    type_check = options.type_check
    type_swap = options.type_swap
    valueMax = options.valueMax

    contract2 = options.contract2
    list_account = options.list_account
    name = options.name
    number_list = options.number_list

    print "Start time:", timenow()
    print '''"***''' + type_swap  + '''***"'''
    print "***Chuyen " + type_check + ''''''
    print "Gia tri can kiem tra:", number_list

    if type_check == "Doi theo SDT":
        global list_num_fail
        list_num_fail = []
        print "\nCheck infor configuration:"
        swap_acc_to_trunk(number_list,name,ip_KHG,port_KHG,type_IP,ip_KHG_BK,port_KHG_BK,type_IP_BK,valueMax,type_swap)
        print "List number failed: ", list_num_fail
                        ################ Doi theo Account AA #########################
    elif type_check == "Doi theo Account":
        list_account = list_account.replace(" ", "")
        ArrayAccount = list_account.split(",")
        domain_sipacc = "sipacc.ivoice.fpt.vn"
        domain_siptrunk = "ivoice.fpt.vn"
        print (ArrayAccount)
        if type_swap == 'Chuyen SIP Trunk sang SIP Account':
            for account in ArrayAccount:
                if (account[-4:] != "1900") and (account[-4:] != "1800") :
                    valueCurrent = Get_valueCurrent(account)
                    Set_valueCurrent_HCM(account,valueCurrent)
                    Reset_valueCurrent_HNI(account)
                ListNumber = Get_Number(account)
                if ListNumber != []:
                    password = random_pass(19)
                    username = ListNumber[0]
                    ArraySipTrunk = IsSipTrunk(account)
                    info = "SIP Account Register " + name + " " + account
                    time_now = timenow()
                    f_out.write(time_now + " ------------------------------------------------------------\n")
                    f_out.write(time_now + " Start Swap SIP Trunks to SIP Acc for " + account + "...\n")
                    if len(ArraySipTrunk) != 0:
                        for SipTrunk in ArraySipTrunk:
                            f_out.write(time_now + " Start Remove SIP Trunks Profile " + SipTrunk + "...\n")
                        if RemoveTrunkOfAcc(account, ArraySipTrunk) == True :
                            print "Remove Trunk Success"
                            for SipTrunk in ArraySipTrunk:
                                f_out.write(time_now + " Remove Success SIP Trunks Profile " + SipTrunk + "...\n")
                            f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                            if reset_username(account,username)== True:
                                print "New username of account: " + username
                                f_out.write(time_now + " Starting Reset password Account " + account + "...\n")
                                if reset_pass(account, password) == True :
                                    print "New Password is: " + password + "\n"
                                    f_out.write(time_now + " Reset Success password Account " + account + " with pass:" + password + "\n")
                                    f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                    if ChangeInfoAcc(account, info) == True:
                                        print "Change info success"
                                        flag = 1
                                        for number in ListNumber:
                                            if ChangeDomain(number, domain_sipacc) == True :
                                                f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                if delete_address_HNI_HCM(number) == True :
                                                    f_out.write(time_now + " Delete success number " + number + "...\n")
                                                else:
                                                    flag = 0
                                                    f_out.write(time_now + " Delete unsuccess number " + number + "...\n")
                                                    break
                                            else:
                                                flag = 0
                                                print "Changed domain Fail"
                                                f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                break
                                        if flag == 1 :
                                            print "Output: OK \n"
                                        else:
                                            sys.exit()
                                        f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                        f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                    else:
                                        print "Change info fail"
                                        f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Reset pass fail"
                                    f_out.write(time_now + " Reset Fail password Account " + account + "...\n")
                                    sys.exit()
                            else:
                                print "Reset username fail"
                                f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                sys.exit()
                        else:
                            print "Remove Trunk Fail"
                            f_out.write(time_now + " Remove Fail SIP Trunks Profile for Account \n" + account)
                            sys.exit()
                else:
                    print "Account " + account +" khong ton tai so"
        elif type_swap == "Chuyen SIP Account sang SIP Trunk":
            for account in ArrayAccount:
                ListNumber = Get_Number_HCM_HNI(account)
                username = random_pass(10)
                VerifyAccount = isSipAccount(account)
                time_now = timenow()
                f_out.write(time_now + " Start Swap SIP Acc to SIP Trunks for " + account + "...\n")
                if port_KHG == "5060" :
                    priority = 'Pri'
                else:
                    priority = 'Pr'
                if ListNumber != []:
                    if VerifyAccount == True :
                        info1 = "SIP Trunking Account " + name + " " + account + " " +"IP-" + ip_KHG + ":" + port_KHG + "_" + type_IP
                        #KHG chi co ip main
                        #if check_ProSIPTrunk(ip_KHG, port_KHG, "Pri", type_IP) == False:
                        if (len(Find_SipTrunk(ip_KHG,port_KHG))) == 0 :
                            f_out.write(time_now + " Start Create SIP Trunks Profile " + info1 + "...\n")
                            if create_ProSIPTrunk(account, name, ip_KHG, port_KHG, priority , type_IP) == True:
                                f_out.write(time_now + " Create Success SIP Trunks Profile " + info1 + "...\n")
                                f_out.write(time_now + " Start Adding SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                if MapNewSIPtrunkToAcc(account, ip_KHG, port_KHG, priority , type_IP) == True:
                                    f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                    f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                    if reset_username(account,username)==True:
                                        f_out.write(time_now + " Reset username success Account " + account + "...\n")
                                        f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                        if ChangeInfoAcc(account, info1) == True:
                                            print "Change info success"
                                            flag = 1
                                            for number in ListNumber:
                                                if add_address_HNI_HCM(number,account) == True :
                                                    f_out.write(time_now + " Add success number " + number + "...\n")
                                                    if ChangeDomain(number, domain_siptrunk) == True :
                                                        f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                    else:
                                                        flag = 0
                                                        f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                        break
                                                else:
                                                    flag = 0
                                                    f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                            if flag == 1:
                                                print "Output: OK \n"
                                            f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                            f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                        else:
                                            print "Change info fail"
                                            f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Reset username fail"
                                        f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Add Sip Trunk to Account Fail "
                                    f_out.write(time_now + " Add Fail SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                    sys.exit()
                            else:
                                print "Create Fail Sip Trunk Profile"
                                f_out.write(time_now + " Create Fail SIP Trunks Profile " + info1 + "...\n")
                                sys.exit()
                        else:
                            list_SipTrunk = Find_SipTrunk(ip_KHG,port_KHG)
                            f_out.write(time_now + " Start Adding SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                            for siptrunk in list_SipTrunk:
                                if CheckPri_SIPtrunk(siptrunk) == 2 :
                                    print "Xin kiem tra lai, SIP Trunk dang BK cho KHG khac"
                                    sys.exit()
                                else:
                                    MapSipTrunkToAcc(account,siptrunk)
                            #if MapAccToSIPtrunk(account, ip_KHG, port_KHG, "Pri", type_IP) == True:
                            f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                            f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                            if reset_username(account,username)== True:
                                f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                if ChangeInfoAcc(account, info1) == True:
                                    print "Change info success"
                                    flag = 1
                                    for number in ListNumber:
                                        if add_address_HNI_HCM(number,account) == True :
                                            f_out.write(time_now + " Add success number " + number + "...\n")
                                            if ChangeDomain(number, domain_siptrunk) == True :
                                                f_out.write(time_now + " Changed domain success " + number + "...\n")
                                            else:
                                                flag = 0
                                                f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                break
                                        else:
                                            flag = 0
                                            f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                    if flag == 1:
                                        print "Output: OK \n"
                                    f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                    f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                else:
                                    print "Change info fail"
                                    f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                    sys.exit()
                            else:
                                print "Reset username fail"
                                f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                sys.exit()
                        #KHG co IP Backup
                        if ip_KHG_BK != "":
                            priority = 'BK'
                            info = "SIP Trunking Account " + name + " " + account + " " + "IP-" + ip_KHG + ":" + port_KHG + "_" + type_IP + " BK-" + ip_KHG_BK + ":" + port_KHG_BK + "_" + type_IP_BK
                            info2 = "SIP Trunking Account " + name + " " + account + " " + "BK-" + "IP-" + ip_KHG_BK + ":" + port_KHG_BK + "_" + type_IP_BK
                            #if check_ProSIPTrunk(ip_KHG_BK, port_KHG_BK, "BK", type_IP_BK) == False:
                            if (len(Find_SipTrunk(ip_KHG_BK,port_KHG_BK))) == 0:
                                f_out.write(time_now + " Start Create SIP Trunks Profile " + info2 + "...\n")
                                if create_ProSIPTrunk(account, name, ip_KHG_BK, port_KHG_BK, priority , type_IP_BK) == True:
                                    f_out.write(time_now + " Create Success SIP Trunks Profile " + info2 + "...\n")
                                    f_out.write(time_now + " Start Adding SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                    if MapNewSIPtrunkToAcc(account, ip_KHG_BK, port_KHG_BK, priority, type_IP_BK) == True:
                                        f_out.write(time_now + " Add Success SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                        f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                        if reset_username(account,username)== True:
                                            f_out.write(time_now + " Reset username success Account " + account + "...\n")
                                            f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                            if ChangeInfoAcc(account, info) == True:
                                                print "Change info success"
                                                flag = 1
                                                for number in ListNumber:
                                                    if add_address_HNI_HCM(number,account) == True :
                                                        f_out.write(time_now + " Add success number " + number + "...\n")
                                                        if ChangeDomain(number, domain_siptrunk) == True :
                                                            f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                        else:
                                                            flag = 0
                                                            f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                            break
                                                    else:
                                                        flag = 0
                                                        f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                                if flag == 1:
                                                    print "Output: OK \n"
                                                    f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                                    f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                            else:
                                                print "Change info fail"
                                                f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                                sys.exit()
                                        else:
                                            print "Reset username fail"
                                            f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Add Sip Trunk to Account Fail "
                                        f_out.write(time_now + " Add Fail SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Create Fail Sip Trunk Profile "
                                    f_out.write(time_now + " Create Fail SIP Trunks Profile " + info2 + "...\n")
                                    sys.exit()
                            else:
                                f_out.write(time_now + " Start Adding SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                list_SipTrunk = Find_SipTrunk(ip_KHG_BK,port_KHG_BK)
                                for siptrunk in list_SipTrunk:
                                    if CheckPri_SIPtrunk(siptrunk) == 1 :
                                        if CheckWeight_SIPtrunk(siptrunk) == False :
                                            MapSipTrunkToAcc(account,siptrunk)
                                            break
                                    else:
                                        MapSipTrunkToAcc(account,siptrunk)
                                #if MapAccToSIPtrunk(account, ip_KHG_BK, port_KHG_BK, "BK", type_IP_BK) == True:
                                f_out.write(time_now + " Add Success SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                if reset_username(account,username)== True:
                                    f_out.write(time_now + " Reset username success Account " + account + "...\n")
                                    f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                    if ChangeInfoAcc(account, info) == True:
                                        print "Change info success"
                                        flag = 1
                                        for number in ListNumber:
                                            if add_address_HNI_HCM(number,account) == True :
                                                f_out.write(time_now + " Add success number " + number + "...\n")
                                                if ChangeDomain(number, domain_siptrunk) == True :
                                                    f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                else:
                                                    flag = 0
                                                    f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                    break
                                            else:
                                                flag = 0
                                                f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                        if flag == 1:
                                            print "Output: OK \n"
                                            f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                            f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                    else:
                                        print "Change info fail"
                                        f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Reset username fail"
                                    f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                    sys.exit()
                else:
                    print "Account "   + account + " khong ton tai dau so1"
        else:
            print " Ban nhap kieu chuyen doi khong dung "

            ###################### Doi Theo HD ######################################

    elif type_check == "Doi theo HD":
        contract2 = contract2.replace(" ", "")
        list_contract = contract2.split(",")
        ArrayAccount = Get_AccountFromContract(list_contract)
        if ArrayAccount != "" :
            domain_sipacc = "sipacc.ivoice.fpt.vn"
            domain_siptrunk = "ivoice.fpt.vn"
            #print ArrayAccount
            if type_swap == 'Chuyen SIP Trunk sang SIP Account':
                for account in ArrayAccount:
                    if (account[-4:] != '1900') and (account[-4:] != '1800'):
                        valueCurrent = Get_valueCurrent(account)
                        Set_valueCurrent_HCM(account,valueCurrent)
                        Reset_valueCurrent_HNI(account)
                    ListNumber = Get_Number(account)
                    if ListNumber != []:
                        password = random_pass(19)
                        username = ListNumber[0]
                        ArraySipTrunk = IsSipTrunk(account)
                        info = "SIP Account Register " + name + " " + account
                        time_now = timenow()
                        f_out.write(time_now + " Start Swap SIP Trunks to SIP Acc for " + account + "...\n")
                        if len(ArraySipTrunk) != 0:
                            for SipTrunk in ArraySipTrunk:
                                f_out.write(time_now + " Start Remove SIP Trunks Profile " + SipTrunk + "...\n")
                            if RemoveTrunkOfAcc(account, ArraySipTrunk) == True :
                                print "Remove Trunk Success"
                                for SipTrunk in ArraySipTrunk:
                                    f_out.write(time_now + " Remove Success SIP Trunks Profile " + SipTrunk + "...\n")
                                f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                if reset_username(account,username)== True:
                                    print "New username of account: " + username
                                    f_out.write(time_now + " Starting Reset password Account " + account + "...\n")
                                    if reset_pass(account, password) == True :
                                        print "New Password is: " + password + "\n"
                                        f_out.write(time_now + " Reset Success password Account " + account + " with pass:" + password + "\n")
                                        f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                        if ChangeInfoAcc(account, info) == True:
                                            print "Change info success"
                                            flag = 1
                                            for number in ListNumber:
                                                if ChangeDomain(number, domain_sipacc) == True :
                                                    f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                    if delete_address_HNI_HCM(number) == True :
                                                        f_out.write(time_now + " Delete success number " + number + "...\n")
                                                    else:
                                                        flag = 0
                                                        f_out.write(time_now + " Delete unsuccess number " + number + "...\n")
                                                        break
                                                else:
                                                    flag = 0
                                                    print "Changed domain Fail"
                                                    f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                    break
                                            if flag == 1 :
                                                print "Output: OK \n"
                                                f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                        else:
                                            print "Change info fail"
                                            f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Reset pass fail"
                                        f_out.write(time_now + " Reset Fail password Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Reset username fail"
                                    f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                    sys.exit()
                            else:
                                print "Remove Trunk Fail"
                                f_out.write(time_now + " Remove Fail SIP Trunks Profile for Account \n" + account)
                                sys.exit()
                    else:
                        print "Account " + account +" khong ton tai so"
            elif type_swap == "Chuyen SIP Account sang SIP Trunk":
                for account in ArrayAccount:
                    ListNumber = Get_Number_HCM_HNI(account)
                    username = random_pass(10)
                    VerifyAccount = isSipAccount(account)
                    time_now = timenow()
                    if port_KHG == "5060" :
                        priority = 'Pri'
                    else:
                        priority = 'Pr'
                    f_out.write(time_now + " Start Swap SIP Acc to SIP Trunks for " + account + "...\n")
                    if ListNumber != []:
                        if VerifyAccount == True :
                            info1 = "SIP Trunking Account " + name + " " + account + " " +"IP-" + ip_KHG + ":" + port_KHG + "_" + type_IP
                            #KHG chi co ip main
                            #if check_ProSIPTrunk(ip_KHG, port_KHG, "Pri", type_IP) == False:
                            if (len(Find_SipTrunk(ip_KHG,port_KHG))) == 0 :
                                print "SIP Trunk Profile chua ton tai"
                                f_out.write(time_now + " Start Create SIP Trunks Profile " + info1 + "...\n")
                                if create_ProSIPTrunk(account, name, ip_KHG, port_KHG, priority , type_IP) == True:
                                    f_out.write(time_now + " Create Success SIP Trunks Profile " + info1 + "...\n")
                                    f_out.write(time_now + " Start Adding SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                    if MapNewSIPtrunkToAcc(account, ip_KHG, port_KHG, priority, type_IP) == True:
                                        f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                        f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                        if reset_username(account,username)==True:
                                            f_out.write(time_now + " Reset username success Account " + account + "...\n")
                                            f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                            if ChangeInfoAcc(account, info1) == True:
                                                print "Change info success"
                                                flag = 1
                                                for number in ListNumber:
                                                    if add_address_HNI_HCM(number,account) == True :
                                                        f_out.write(time_now + " Add success number " + number + "...\n")
                                                        if ChangeDomain(number, domain_siptrunk) == True :
                                                            f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                        else:
                                                            flag = 0
                                                            f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                            break
                                                    else:
                                                        flag = 0
                                                        f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                                if flag == 1:
                                                    print "Output: OK \n"
                                                    f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                                    f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                            else:
                                                print "Change info fail" 
                                                f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                                sys.exit()
                                        else:
                                            print "Reset username fail"
                                            f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Add Sip Trunk to Account Fail "
                                        f_out.write(time_now + " Add Fail SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Create Fail Sip Trunk Profile"
                                    f_out.write(time_now + " Create Fail SIP Trunks Profile " + info1 + "...\n")
                                    sys.exit()
                            else:
                                list_SipTrunk = Find_SipTrunk(ip_KHG,port_KHG)
                                f_out.write(time_now + " Start Adding SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                for siptrunk in list_SipTrunk:
                                    if CheckPri_SIPtrunk(siptrunk) == 2 :
                                        print "Xin kiem tra lai, SIP Trunk dang BK cho KHG khac"
                                        sys.exit()
                                    else:
                                        MapSipTrunkToAcc(account,siptrunk)
                                #if MapAccToSIPtrunk(account, ip_KHG, port_KHG, "Pri", type_IP) == True:
                                f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                if reset_username(account,username)== True:
                                    f_out.write(time_now + " Add Success SIP Trunks Profile " + info1 + " to Account " + account + "...\n")
                                    f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                    if ChangeInfoAcc(account, info1) == True:
                                        print "Change info success"
                                        flag = 1
                                        for number in ListNumber:
                                            if add_address_HNI_HCM(number,account) == True :
                                                f_out.write(time_now + " Add success number " + number + "...\n")
                                                if ChangeDomain(number, domain_siptrunk) == True :
                                                    f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                else:
                                                    flag = 0
                                                    f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                    break
                                            else:
                                                flag = 0
                                                f_out.write(time_now + " Add unsuccess number " + number + "...\n")                                            
                                        if flag == 1:
                                            print "Output: OK \n"
                                            f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                            f_out.write(time_now + " Swap Success Account " + account + "...\n")                                        
                                    else:
                                        print "Change info fail" 
                                        f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                        sys.exit()
                                else:
                                    print "Reset username fail"
                                    f_out.write(time_now + " Change Fail username Account " + account + "...\n") 
                                    sys.exit()
                            #KHG co IP Backup
                            if ip_KHG_BK != "":
                                priority = 'BK'
                                info = "SIP Trunking Account " + name + " " + account + " " + "IP-" + ip_KHG + ":" + port_KHG + "_" + type_IP + " BK-" + ip_KHG_BK + ":" + port_KHG_BK + "_" + type_IP_BK
                                info2 = "SIP Trunking Account " + name + " " + account + " " + "BK-" + "IP-" + ip_KHG_BK + ":" + port_KHG_BK + "_" + type_IP_BK
                                #if check_ProSIPTrunk(ip_KHG_BK, port_KHG_BK, "BK", type_IP_BK) == False:
                                if (len(Find_SipTrunk(ip_KHG_BK,port_KHG_BK))) == 0:
                                    f_out.write(time_now + " Start Create SIP Trunks Profile " + info2 + "...\n")
                                    if create_ProSIPTrunk(account, name, ip_KHG_BK, port_KHG_BK, priority, type_IP_BK) == True:
                                        f_out.write(time_now + " Create Success SIP Trunks Profile " + info2 + "...\n")
                                        f_out.write(time_now + " Start Adding SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                        if MapNewSIPtrunkToAcc(account, ip_KHG_BK, port_KHG_BK, priority, type_IP_BK) == True:
                                            f_out.write(time_now + " Add Success SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                            f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                            if reset_username(account,username)== True:
                                                f_out.write(time_now + " Reset username success Account " + account + "...\n")                                    
                                                f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                                if ChangeInfoAcc(account, info) == True:
                                                    print "Change info success"
                                                    flag = 1
                                                    for number in ListNumber:
                                                        if add_address_HNI_HCM(number,account) == True :
                                                            f_out.write(time_now + " Add success number " + number + "...\n")
                                                            if ChangeDomain(number, domain_siptrunk) == True :
                                                                f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                            else:
                                                                flag = 0
                                                                f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                                break
                                                        else:
                                                            flag = 0
                                                            f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                                    if flag == 1:
                                                        print "Output: OK \n"
                                                        f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                                        f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                                else:
                                                    print "Change info fail"
                                                    f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                                    sys.exit()
                                            else:
                                                print "Reset username fail"
                                                f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                                sys.exit()
                                        else:
                                            print "Add Sip Trunk to Account Fail "
                                            f_out.write(time_now + " Add Fail SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Create Fail Sip Trunk Profile "
                                        f_out.write(time_now + " Create Fail SIP Trunks Profile " + info2 + "...\n")
                                        sys.exit()
                                else:
                                    f_out.write(time_now + " Start Adding SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                    list_SipTrunk = Find_SipTrunk(ip_KHG_BK,port_KHG_BK)
                                    for siptrunk in list_SipTrunk:
                                        if CheckPri_SIPtrunk(siptrunk) == 1 :
                                            if CheckWeight_SIPtrunk(siptrunk) == False :
                                                MapSipTrunkToAcc(account,siptrunk)
                                                break
                                        else:
                                            MapSipTrunkToAcc(account,siptrunk)
                                    #if MapAccToSIPtrunk(account, ip_KHG_BK, port_KHG_BK, "BK", type_IP_BK) == True:
                                    f_out.write(time_now + " Add Success SIP Trunks Profile " + info2 + " to Account " + account + "...\n")
                                    f_out.write(time_now + " Starting Reset username Account " + account + "...\n")
                                    if reset_username(account,username)== True:
                                        f_out.write(time_now + " Reset username success Account " + account + "...\n")
                                        f_out.write(time_now + " Starting Change information Account " + account + "...\n")
                                        if ChangeInfoAcc(account, info) == True:
                                            print "Change info success"
                                            flag = 1
                                            for number in ListNumber:
                                                if add_address_HNI_HCM(number,account) == True :
                                                    f_out.write(time_now + " Add success number " + number + "...\n")
                                                    if ChangeDomain(number, domain_siptrunk) == True :
                                                        f_out.write(time_now + " Changed domain success " + number + "...\n")
                                                    else:
                                                        flag = 0
                                                        f_out.write(time_now + " Changed domain fail " + number + "...\n")
                                                        break
                                                else:
                                                    flag = 0
                                                    f_out.write(time_now + " Add unsuccess number " + number + "...\n")
                                            if flag == 1:
                                                print "Output: OK \n"
                                                f_out.write(time_now + " Change Success information Account " + account + "...\n")
                                                f_out.write(time_now + " Swap Success Account " + account + "...\n")
                                        else:
                                            print "Change info fail" 
                                            f_out.write(time_now + " Change Fail information Account " + account + "...\n")
                                            sys.exit()
                                    else:
                                        print "Reset username fail"
                                        f_out.write(time_now + " Change Fail username Account " + account + "...\n")
                                        sys.exit()
                    else:
                        print "Account "   + account + " khong ton tai dau so2"
            else:
                print " Ban nhap kieu chuyen doi khong dung "
        else:
            print " SHD khong dung, xin vui long kiem tra lai "

    print "End time:",timenow()


if __name__ == "__main__":
    #add_address_HNI("02473000001","HNVO01234_BKN")
    main()
