'''Author: PhongDT23 || 0866773886
Date: 08/08/2019
Description: Cau hinh dieu chinh tang giam han muc theo dau so
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

url_read_account = 'http://localhost:8888/daml/account/read_test'
url_write_account = 'http://localhost:8888/daml/account/write_test'
url_read_address = 'http://localhost:8888/daml/address/read_test'
url_write_address = 'http://localhost:8888/daml/address/write_test'
url_read_siptrunk = 'http://localhost:8888/daml/siptrunk/read_test'
url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write_test'
url_read_ruleset = 'http://localhost:8888/daml/ruleset/read_test'
url_write_ruleset = 'http://localhost:8888/daml/ruleset/write_test'

url_read_address_hcm = 'http://localhost:8888/daml/address/read/hcm'
url_write_address_hcm = 'http://localhost:8888/daml/address/write/hcm'

pattern = r"(\d+\.\d+\.\d+\.\d+(\:?)\w+\-?\w+)"


def split_response(response):
    pattern_response = r"{(.*)}.{(.*)}"

    response_hcm = ""
    
    response_hni = ""

    response_hcm = re.search(pattern_response, response).group(1)
    response_hni = re.search(pattern_response, response).group(2)

    return response_hcm, response_hni
    

def read_account(account,number):
    global get_cfname, response,get_valueCurrent, number_domain,get_valueMax,valueMax_number
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    # print response
    valueMax_number = []
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        if account in response_hcm:
            if "valueMax" in response_hcm:
                get_valueMax = response_hcm[response_hcm.find("<valueMax>") + 10:response_hcm.find("</valueMax>")]
            else:
                get_valueMax = "0.0"

            if "valueCurrent" in response_hcm:
                get_valueCurrent = response_hcm[response_hcm.find("<valueCurrent>") + 14:response_hcm.find("</valueCurrent>")]
            else:
                get_valueCurrent = "0.0"

            if "domain" in response_hcm:
                number_domain = response_hcm[response_hcm.find("<domain>") + 14:response_hcm.find("</domain>")]
            else:
                number_domain = ""

            # if "addAddressTopStop" in response:
            #     valueMax_number = response[response.find(number) + 19:response.find("</addAddressTopStop>")]
            # else:
            #     valueMax_number = "0.0"
            # print "\n valueMax_number: ", valueMax_number 

            if "addAddressTopStop" in response:
                arrayIndex = []
                for match in finditer("<number>|</addAddressTopStop>", response):
                   start =  match.start()
                   end = match.end()
                   arrayIndex.append(start)
                   arrayIndex.append(end)
                   # print arrayIndex
                k = 1
                for j in range(len(arrayIndex)):
                    if k < len(arrayIndex):
                        value_tmp = response[arrayIndex[k]:arrayIndex[k+1]]
                        valueMax_number.append(value_tmp)
                        k = k+8
                        # print "valueMax_number", valueMax_number
                    else:
                        return valueMax_number
            else:    
                return valueMax_number
            
            return True
        else:
            print "Account not found"
            return False

def timenow():
    global time_now
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now

def read_address(address):
    global account
    xmlData = '''<daml command="read"><address><number>''' + address + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_address, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    account = response[response.find("<account>") + 9:response.rfind("</account>")]

    if "status=ok" in response_hcm or "status=ok" in response_hni:
        #print "DAML read address is OK"
        if address in response_hcm or address in response_hni:
            # print "Account for " + address + " is: " + account
            return account
        else:
            print "Can not find this phone number"
            return False
    else:
        return False

def check_acc_siptrunk_map(account):
    xmlData = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print response
    #list_trunk = []
    # print re.match(pattern, response)
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        # print "DAML check Account SIP Trunk Map OK"
        if account in response_hcm and account in response_hni:
            # print "Account ", account, " is SIP Trunk"
            return True
        else:
            # print "Account ", account, " is SIP Account"
            return False
    else:
        # print "DAML check Account SIP Trunk Map NOK"
        return False
def change_value_addr(number, valueMax,new_account, contract,type_khg):
    
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

    if type_number == "1900" or type_number == "1800":
        # sysAccountTopStop = ""
        # routingTable = ""
        # pricelist = ""
        # ruleset = "1900-1800 : Block All Outgoing"
        blocked = "true"
        maliciousCallerId = "false"
    else:
        # sysAccountTopStop = '''<valueMax>''' + valueMax + '''</valueMax><alarmLevel>0.9</alarmLevel><dailyMax>0.0</dailyMax><monthlyReset>true</monthlyReset><dailyReset>false</dailyReset>'''
        # routingTable = "Route to PSTN"
        # ruleset = "Block : All Outgoing International Calls</ruleset><ruleset>Block : International Call - High Cost"
        blocked = "false"
        maliciousCallerId = "true" 
    print  "type_khg :",type_khg
    if type_khg == "siptrunk":
        xmlData_Address = '''<daml command="write"><address><number>''' + number + '''</number><addAddressTopStop><valueMax>''' + valueMax + '''</valueMax><alarmLevel>0.9</alarmLevel><monthlyReset>true</monthlyReset></addAddressTopStop></address></daml>'''
        payload = {"XmlData": xmlData_Address, "UserRequest": "AOPT"}
        result = requests.post(url_write_address, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        # print response
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print "Thay doi han muc cua dau so " + number + " thanh " + valueMax + " VND"
            if sync_account_inside(contract, new_account):
                f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " OK" + '\n')
                print "Output: OK\n"
            else:
                f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " not OK" + '\n')
            f_out.write(timenow() + " Dieu chinh tang giam han muc " + number + "to " + valueMax + "...successful\n")
            return True
        else:
            print "Change Value of number " + number + " : Fail"
            return False
            f_out.write(timenow() + " Dieu chinh tang giam han muc " + number + "to " + valueMax + "...failed\n")

    else:
        xmlData_Address = '''<daml command="write"><address><number>''' + number + '''</number><addAddressTopStop><valueMax>''' + valueMax + '''</valueMax><alarmLevel>0.9</alarmLevel><monthlyReset>true</monthlyReset></addAddressTopStop></address></daml>'''
        payload = {"XmlData": xmlData_Address, "UserRequest": "AOPT"}
        result = requests.post(url_write_address, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        # print response
        if "status=ok" in response_hcm or "status=ok" in response_hni:
            print "Thay doi han muc cua dau so " + number + " thanh " + valueMax + " VND"
            if sync_account_inside(contract, new_account):
                f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " OK" + '\n')
                print "Output: OK\n"
            else:
                f_out.write(timenow() + " Cap nhat Inside: " + contract + ", " + new_account + " not OK" + '\n')
            f_out.write(timenow() + " Dieu chinh tang giam han muc " + number + "to " + valueMax + "...successful\n")
            return True
        else:
            print "Change Value of number " + number + " : Fail"
            return False
            f_out.write(timenow() + " Dieu chinh tang giam han muc " + number + "to " + valueMax + "...failed\n")

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

        if "status=ok" in response_hcm or "status=ok" in response_hni:
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



def check_account(account):
    headers = {'content-type': 'application/json'}
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(2)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    # print response

    global valueMax

    if "valueMax" in response_hcm or "valueMax" in response_hni:
        get_valueMax = response_hcm[response_hcm.find("<valueMax>") + 10:response_hcm.find("</valueMax>")]
    else:
        get_valueMax = "0.0"

    valueMax = float(get_valueMax)
    valueMax = str(valueMax).replace(".0", "")

    if "status=ok" in response_hcm or "status=ok" in response_hni:
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
            response_hcm = split_response(response)[0]
            response_hni = split_response(response)[1]
            # print result.status_code
            # print response

            if "Success" in response_hcm:
                print "DAML Add Account Inside OK"
                temp = True
                break
            elif "Fail" in response_hcm:
                print "DAML Add Account Inside NOK"
                print response
                temp = False
                break
            elif "Request again after 10 s" in response_hcm:
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
            response_hcm = split_response(response)[0]
            response_hni = split_response(response)[1]
            #print response

            if "Success" in response_hcm or "Success" in response_hni:
                print "DAML Update Account Inside OK"
                temp = True
                break
            elif "Fail" in response_hcm:
                print "DAML Update Account Inside NOK"
                print response_hcm
                temp = False
                break
            elif "Request again after 10 s" in response_hcm:
                print response_hcm
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


def main():

    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_dieu_chinh_tang_giam_han_muc.log", "a+")
    global c_list
    c_list = open("/home/administrator/aopt/logs/update_acc_inside_fail.csv", "a+")
    parser = OptionParser()

    parser.add_option("--k", "--address_edit_list", dest="address_edit_list", type="string", help="address_edit_list")
    parser.add_option("-o", "--option_edit", dest="option_edit", type="string", help="Tang them han muc | Giam bot han muc" )
    parser.add_option("--v", "--value_edit", dest="value_edit", type="string", help="value_edit")
    
    (options, args) = parser.parse_args()

    # address_edit_list =  "02337300001,02157300001" #raw_input("Nhap list so: ",)
    # option_edit = "giam bot" #raw_input("Nhap option :tang them| giam bot: ")
    # value_edit = "3000"#raw_input("Nhap gia tri han muc can thay doi: ")
    
    address_edit_list = options.address_edit_list
    option_edit = options.option_edit
    value_edit = options.value_edit

    value_edit = value_edit + ".0"
    
    if option_edit == "Giam bot han muc":
        value_edit = -float(value_edit)
    else:
        value_edit = value_edit

    if address_edit_list !="":
        address_edit = ""
        src_num_max = 0
        src_num_max = address_edit_list.count(",") + 1
        print "*** Start time:" + timenow() + "***\n"
        for n in range(src_num_max):
            if src_num_max == 0:
                break
            address_edit = str(address_edit_list.split(",")[n].strip())

 
            if read_address(address_edit):
                account = read_address(address_edit)
                contract = account[0:9]
                read_account(account,address_edit)
                matching = [s for s in valueMax_number if (address_edit in s) ]
                valueMax_number_tmp = str(matching).strip("[]u'")
                valueMax_number_ok = valueMax_number_tmp[valueMax_number_tmp.find("<valueMax>") + 10:valueMax_number_tmp.find("</valueMax>")]
                # print "\n valueMax_number_ok:", valueMax_number_ok
                # valueMax_number_ok = float(valueMax_number_ok)
                print "Han muc hien tai cua dau so " + address_edit + " la "+  str(get_valueMax) + " VND"
                try:
                    valueMax_OK = float(get_valueMax) + float(value_edit)
                except requests.exceptions.RequestException as error:
                    print error
                    return valueMax_OK  
                valueMax_OK = str(valueMax_OK)
                valueCurrent = get_valueCurrent
                valueCurrent = str(valueCurrent)
                
                # change_value_addr(address_edit, value_edit)
                if check_acc_siptrunk_map(account):  # SIP Trunk
                    type_khg = "siptrunk"
                else:
                    type_khg = "sipacc"

                if  valueMax_OK >= valueCurrent:
                   change_value_addr(address_edit, valueMax_OK, account,contract,type_khg)
                else:
                    print "Valuemax > valueCurrent !!!"
                    print "Please check your input topstop !!!\n"
                    break
            else:
                print "Not found this numbers\n"
                print "Please try agains !!! \n"
    else:
        print "Lack of numbers !!!"
        print "Please check your input numbers !!!\n"
        print "Output: Fail\n"
    print "End time:", timenow()
    f_out.write(timenow() + " # End # Dieu chinh tang giam han muc: " + address_edit + "," + account + "is " + valueMax + "\n")

if __name__ == "__main__":
    main()
