#!/usr/bin/python
# -*- coding: UTF-8 -*
# Code by HieuND16

import requests
import json
import time
import random
import datetime
import string
from openpyxl import Workbook
import re
from optparse import OptionParser
from macpath import split
import mysql.connector
from mysql.connector import cursor

url_read_account = 'http://localhost:8888/daml/account/read_test'
url_write_account = 'http://localhost:8888/daml/account/write_test'
url_read_address = 'http://localhost:8888/daml/address/read_test'
url_write_address = 'http://localhost:8888/daml/address/write_test'
url_read_siptrunk = 'http://localhost:8888/daml/siptrunk/read_test'
url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write_test'
url_read_ruleset = 'http://localhost:8888/daml/ruleset/read_test'

def split_response(response):
    pattern_response = r"{(.*)}.{(.*)}"

    response_hcm = ""
    response_hni = ""

    response_hcm = re.search(pattern_response, response).group(1)
    response_hni = re.search(pattern_response, response).group(2)

    return response_hcm, response_hni

def timenow():
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now

def check_address(value, payload):
    # headers = {'content-type': 'application/json'}
    # try:
    # time.sleep(1)
    result = requests.post(url_read_address, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    global get_acc, get_type_fw, get_fw_cfu, get_fw_cfb, get_fw_cff, get_fw_cfnr, get_disabled

    get_fw_cfu = ""
    get_fw_cff = ""
    get_fw_cfb = ""
    get_fw_cfnr = ""
    get_type_fw = ""
    get_disabled = "No"

    get_acc = response_hcm[response.find("<account>") + 9:response.find("</account>")]
    get_disabled = response_hcm[response_hcm.find("<disabled>") + 10:response_hcm.find("</disabled>")]

    if "cfu/" not in response_hcm:
        get_fw_cfu = response_hcm[response_hcm.find("<cfu>") + 5:response_hcm.find("</cfu>")]
        get_type_fw = "CFU: Call Forward Unconditional"
    elif "cfb/" not in response_hcm:
        get_fw_cfb = response_hcm[response_hcm.find("<cfb>") + 5:response_hcm.find("</cfb>")]
        get_type_fw = "CFB: Call Forward Busy"
    elif "cff/" not in response_hcm:
        get_fw_cff = response_hcm[response_hcm.find("<cff>") + 5:response_hcm.find("</cff>")]
        get_type_fw = "CFF: Call Forward Fallback"
    elif "cfnr/" not in response_hcm:
        get_fw_cfnr = response_hcm[response_hcm.find("<cfnr>") + 6:response_hcm.find("</cfnr>")]
        get_type_fw = "CFNR: Call Forward No Reply"
    elif "cfu/" not in response_hni:
        get_fw_cfu = response_hni[response_hni.find("<cfu>") + 5:response_hni.find("</cfu>")]
        get_type_fw = "CFU: Call Forward Unconditional"
    elif "cfb/" not in response_hni:
        get_fw_cfb = response_hni[response_hni.find("<cfb>") + 5:response_hni.find("</cfb>")]
        get_type_fw = "CFB: Call Forward Busy"
    elif "cff/" not in response_hcm:
        get_fw_cff = response_hni[response_hni.find("<cff>") + 5:response_hni.find("</cff>")]
        get_type_fw = "CFF: Call Forward Fallback"
    elif "cfnr/" not in response_hni:
        get_fw_cfnr = response_hni[response_hni.find("<cfnr>") + 6:response_hni.find("</cfnr>")]
        get_type_fw = "CFNR: Call Forward No Reply"

    if "status=ok" in response_hcm or "status=ok" in response_hni:
        print "Daml read address is OK"
        if value in response_hcm:
            return True
        elif value in response_hni:
            return True
        else:
            return False
    else:
        print "Daml read address is NOK"
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0


def check_account(value, payload):
    # headers = {'content-type': 'application/json'}
    # try:
    # time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    global get_info, get_username, get_pass, get_acc_status, get_pricelist, get_valueMax, get_ruleset
    global get_delay, get_call_inter, get_high_cost, get_prefix, get_channel, highcost_code, get_routingtable

    get_call_inter = "No"
    get_high_cost = "No"

    get_info = response_hcm[response_hcm.find("<info>") + 6:response_hcm.find("</info>")]
    get_username = response_hcm[response_hcm.find("<username>") + 10:response_hcm.find("</username>")]
    get_pass = response_hcm[response_hcm.find("<password>") + 10:response_hcm.find("</password>")]
    get_delay = response_hcm[response_hcm.find("<delay>") + 7:response_hcm.find("</delay>")]
    get_ruleset = response_hcm[response_hcm.find("<ruleset>") + 9:response_hcm.rfind("</ruleset>")]
    # get_channel =  response_hcm[response_hcm.find("<maxChannels>") + 13:response_hcm.rfind("</maxChannels>")]
    get_routingtable = response_hcm[response_hcm.find("<routingTable>") + 14:response_hcm.rfind("</routingTable>")]

    if "<maxChannels>" not in response_hcm:
        get_channel = "0"
    else:
        get_channel = response_hcm[response_hcm.find("<maxChannels>") + 13:response_hcm.rfind("</maxChannels>")]
    if "/pricelist" in response_hcm:
        get_pricelist = response_hcm[response_hcm.find("<pricelist>") + 11:response_hcm.find("</pricelist>")]
    else:
        get_pricelist = ""

    if "valueMax" in response_hcm:
        get_valueMax = response_hcm[response_hcm.find("<valueMax>") + 10:response_hcm.find("</valueMax>")]
    else:
        get_valueMax = "0.0"

    if "validUntil/" in response_hcm:
        get_acc_status = "Enable"
    else:
        get_acc_status = "Disable"

    if "Block : All Outgoing International Calls" in get_ruleset:
        get_call_inter = "No"
    elif "Allow : International Call - High Cost" in get_ruleset:
        get_call_inter = "Yes"
        get_high_cost = "Yes"
        highcost_code = ""
    else:
        get_call_inter = "Yes"
        get_high_cost = "No"

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml read account is OK"
        if value in response_hcm:
            return True
        else:
            return False
    else:
        print "Daml read account is NOK"
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0


def check_trunk_account(value, payload):
    # headers = {'content-type': 'application/json'}
    # try:
    # time.sleep(1)
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print "response hcm:", response_hcm
    global get_siptrunk, max_siptrunk, list_siptrunk
    # get_siptrunk = response[response.find("<sipTrunk>")+10:response.find("</sipTrunk>")]

    a = response_hcm.find("<sipTrunk>")
    b = response_hcm.rfind("</sipTrunk>") + 11
    string_trunk = response_hcm[a:b]
    list_siptrunk = []
    max_siptrunk = 0
    for i in range(6):
        if "<sipTrunk>" in string_trunk:
            s = string_trunk.find("<sipTrunk>") + 10
            e = string_trunk.find("</sipTrunk>")
            siptrunkName = str(string_trunk[s:e])
            if siptrunkName != "":
                max_siptrunk += 1
            else:
                break
            # print siptrunkName
            list_siptrunk.append(siptrunkName)
            string_trunk = string_trunk[e + 10:b]
    # print list_siptrunk
    # print max_siptrunk

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml read siptrunk map account is OK"
        if value in response_hcm:
            return True
        else:
            return False
    else:
        print "Daml read siptrunk map account is NOK"
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0


def check_siptrunk(value, payload):
    # headers = {'content-type': 'application/json'}
    # try:
    # time.sleep(1)
    result = requests.post(url_read_siptrunk, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    global get_ip, get_host, get_weight
    get_ip = response_hcm[response_hcm.find("<sipContact>") + 16:response_hcm.find("</sipContact>")]
    get_host = response_hcm[response_hcm.find("<route2>") + 12:response_hcm.find("</route2>")]
    get_weight = response_hcm[response_hcm.find("<q>") + 3:response_hcm.find("</q>")]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml read siptrunk is OK"
        if value in response_hcm:
            return True
        else:
            return False
    else:
        print "Daml read siptrunk is NOK"
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0


def check_host(value):
    if value in ['118.69.114.182', '118.69.115.150']:
        type_ip = 'Public'
    else:
        type_ip = 'MPLS'
    return type_ip


def check_ruleset(ruleset_ivr, pattern):
    try:
        xmlData = '''<daml command="read"><ruleset name="''' + ruleset_ivr + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        # time.sleep(1)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print "DAML read ruleset is OK"
            if ruleset_ivr in response_hcm and ruleset_ivr in response_hni:
                id = re.findall(pattern, response_hcm)
                if id == []:
                    return ""
                else:
                    return str(id[0])
            else:
                print "System is not synchronized"
        else:
            print "DAML read ruleset is NOK"
            return "Fail"
    except requests.exceptions.RequestException as error:
        print error
        return False

def get_account_id_from_account_name(account):
    list_account_id = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.78',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    #query =("SELECT ID FROM siptrunk WHERE SIP_CONTACT like '" + cpe_contact + "%'")
    query = ("select ACCOUNT_ID from account where account_name = '" + account + "'")
    #query = '''select id from account_siptrunk_map where siptrunk_id in ('20433','20435')'''
    #print query
    time.sleep(1)
    cur.execute(query)
    for (acc) in cur:
        #print("Account Name : {}".format(sip_contact))
        #print sip_contact
        string_acc_id = str(acc)
        #print string_SIP_Contact
        tmp = string_acc_id[(string_acc_id.find("'"))+1 : (string_acc_id.rfind("'"))]
        list_account_id.append(tmp)
    cur.close()
    cnx.close()
    #print list_account_id
    for index, element in enumerate(list_account_id):
        list_account_id[index] = element.replace("(", "").replace(",", "")
    return list_account_id #tra ve list account id

def get_siptrunk_id_from_account_id(list_account_id):
    list_siptrunk_id = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.78',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    for i in range(len(list_account_id)):
        query = ("select siptrunk_id from account_siptrunk_map where account_id = '" + list_account_id[i] + "'")
        #query = '''select id from account_siptrunk_map where siptrunk_id in ('20433','20435')'''
        #print query
        time.sleep(1)
        cur.execute(query)
        for (trunkid) in cur:
            #print("Account Name : {}".format(sip_contact))
            #print sip_contact
            string_trunkid = str(trunkid)
            #print string_SIP_Contact
            tmp = string_trunkid[(string_trunkid.find("'"))+1 : (string_trunkid.rfind("'"))]
            list_siptrunk_id.append(tmp)
    cur.close()
    cnx.close()
    #print list_siptrunk_id
    for index, element in enumerate(list_siptrunk_id):
        list_siptrunk_id[index] = element.replace("(", "").replace(",", "")
    return list_siptrunk_id #tra ve list siptrunk id

def get_sipcontact_from_siptrunk_id(list_siptrunk_id):
    list_sipcontact = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    for i in range(len(list_siptrunk_id)):
        query = ("select sip_contact from siptrunk where id = '" + list_siptrunk_id[i] + "'")
        #print query
        time.sleep(1)
        cur.execute(query)
        for (sipcontact) in cur:
            #print("Account Name : {}".format(sip_contact))
            #print sipcontact
            string_sipcontact = str(sipcontact)
            #print string_SIP_Contact
            tmp = string_sipcontact[(string_sipcontact.find("'"))+1 : (string_sipcontact.rfind("'"))]
            list_sipcontact.append(tmp)
    cur.close()
    cnx.close()
    #print list_sipcontact
    for index, element in enumerate(list_sipcontact):
        list_sipcontact[index] = element.replace("(", "").replace(",", "")
    #print list_siptrunk_id
    return list_sipcontact #tra ve list sipcontact

def get_host_from_siptrunk_id(list_siptrunk_id):
    list_host = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    for i in range(len(list_siptrunk_id)):
        query = ("select route2 from siptrunk where id = '" + list_siptrunk_id[i] + "'")
        #print query
        time.sleep(1)
        cur.execute(query)
        for (host) in cur:
            #print("Account Name : {}".format(sip_contact))
            #print host
            string_host = str(host)
            #print string_SIP_Contact
            tmp = string_host[(string_host.find("'"))+1 : (string_host.rfind("'"))]
            list_host.append(tmp)
    cur.close()
    cnx.close()
    #print list_sipcontact
    for index, element in enumerate(list_host):
        list_host[index] = element.replace("(", "").replace(",", "")
    #print list_host
    return list_host #tra ve list host

def get_weight_from_siptrunk_id(list_siptrunk_id):
    list_weight = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020', host='172.31.14.14', port=3306, database='aareswitch_config')
    cur = cnx.cursor()
    for i in range(len(list_siptrunk_id)):
        query = ("select q from siptrunk where id = '" + list_siptrunk_id[i] + "'")
        # print query
        time.sleep(1)
        cur.execute(query)
        for (q) in cur:
            # print("Account Name : {}".format(sip_contact))
            # print host
            string_q = str(q)
            # print string_SIP_Contact
            tmp = string_q[(string_q.find("'")) + 1: (string_q.rfind("'"))]
            list_weight.append(tmp)
    cur.close()
    cnx.close()
    # print list_sipcontact
    for index, element in enumerate(list_weight):
        list_weight[index] = element.replace("(", "").replace(",", "")
    #print list_weight
    return list_weight  # tra ve list host

def main():
    f_out = open("/home/administrator/aopt/logs/aopt_check_profile_khg.log", "a+")

    # Parsing argurments
    parser = OptionParser()

    parser.add_option("-n", "--number_list", dest="number_list", type="string", help="Enter number list")

    (options, args) = parser.parse_args()

    number_list = options.number_list

    list_num_fail = []

    global get_siptrunk, get_ip, get_host, get_type_fw, get_fw_cfu, get_fw_cfb, get_fw_cff, get_fw_cfnr, get_delay, get_prefix, list_siptrunk, max_siptrunk
    global get_acc, get_username, get_pass, get_info, get_pricelist, get_acc_status, get_valueMax, get_ruleset, get_call_inter, get_high_cost, get_weight

    print "*** Kiem tra profile cau hinh dau so ***"
    if " " in number_list:
        print "--> Luu y khong nhap co khoang trang !"

    if number_list[-1:] == ",":
        print "--> Luu y khong nhap dau , o cuoi !"
        number_list = number_list[:-1]

    number_list = number_list.replace(" ", "")

    print "Danh sach:", number_list

    num_max = 0
    num_max = number_list.count(",") + 1

    print "Tong cong:", num_max, "number\n"
    print "Start time:", timenow()

    f_out.write(timenow() + " # Start # Check profile ky thuat: " + number_list + "\n")

    if num_max == 0:
        print "Output: Fail"
    else:
        for n in range(num_max):
            time.sleep(1)
            number = str(number_list.split(",")[n].strip())
            number = number.replace(" ", "")

            print str(n + 1) + ". " + number

            delay = ""
            fw_number = ""
            list_siptrunk = []

            xml_Address = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
            payload_Address = {"XmlData": xml_Address, "UserRequest": "AOPT"}
            status_Address = check_address(number, payload_Address)

            if status_Address:
                # print 'Number:',number,'ton tai tren AAR'
                account = get_acc
                type_fw = get_type_fw
                inter_num = ""
                if get_fw_cfu != "":
                    fw_number = get_fw_cfu
                elif get_fw_cfb != "":
                    fw_number = get_fw_cfb
                elif get_fw_cff != "":
                    fw_number = get_fw_cff
                elif get_fw_cfnr != "":
                    fw_number = get_fw_cfnr

                xml_Account = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
                payload_Account = {"XmlData": xml_Account, "UserRequest": "AOPT"}
                status_Account = check_account(account, payload_Account)

                if status_Account:
                    name = ""
                    # print info
                    status_acc = get_acc_status
                    username = str(get_username)
                    password = get_pass
                    pricelist = get_pricelist
                    valueMax = float(get_valueMax)
                    valueMax = str(valueMax).replace(".0", "")
                    max_channel = get_channel
                    ivrdebt = ""

                    # Kiem tra cau hinh IVR
                    if number[0:5] == "19006":
                        ruleset_ivr = "Announcement VAS - 1900"
                        pattern = r'''<id>(\d+)</id>\s*<destPattern>\(?''' + number + '''\)?</destPattern>'''  # dat rulename = number moi dc
                        rule_id = check_ruleset(ruleset_ivr, pattern)
                        if rule_id == "":
                            # print "Number: ", number, " does not config IVR"
                            ivr1900 = "No"
                        elif rule_id == "Fail":
                            print "DAML Check ruleset Failed. Please try again later\n"
                            ivr1900 = "N/A"
                        else:
                            ivr1900 = "Yes"
                    else:
                        ivr1900 = "No"

                    # rulesetAll = get_ruleset
                    # print rulesetAll
                    if get_fw_cfnr != "" and get_delay != 0:
                        delay = get_delay

                    if number[0:5] == "19006" or number[0:5] == "18006":
                        call_inter = "No"
                        call_high_cost = "No"
                        highcost_code = ""
                    else:
                        call_inter = get_call_inter
                        call_high_cost = get_high_cost
                        highcost_code = ""

                    if "Remove" in get_ruleset:
                        if account[0:2] == "SG":
                            prefix = "1" + account[4:9]
                        else:
                            prefix = "2" + account[4:9]
                    else:
                        prefix = ""

                    if number[0:5] == "19006" or number[0:5] == "18006":
                        if get_disabled == "true":
                            status_number = "Khoa 2 chieu"
                        else:
                            status_number = "Binh thuong"
                    else:  # neu so co dinh
                        if (
                                get_routingtable == "Block Call By Tool" or get_routingtable == "Block Call Inside") and get_disabled == "false":
                            status_number = "Khoa 1 chieu"
                        elif (
                                get_routingtable == "Block Call By Tool" or get_routingtable == "Block Call Inside") and get_disabled == "true":
                            status_number = "Khoa 2 chieu"
                        else:
                            status_number = "Binh thuong"

                    xml_TrunkAccount = '''<daml command="read"><accountSipTrunkMap account="''' + account + '''"/></daml>'''
                    payload_TrunkAcc = {"XmlData": xml_TrunkAccount, "UserRequest": "AOPT"}
                    status_TrunkAcc = check_trunk_account(account, payload_TrunkAcc)

                    if status_TrunkAcc == True:
                        typeKHG = "SIP Trunk"
                        list_account_id = get_account_id_from_account_name(account)
                        #print list_account_id

                        list_siptrunk_id = get_siptrunk_id_from_account_id(list_account_id)
                        #print list_siptrunk_id

                        list_sipcontact = get_sipcontact_from_siptrunk_id(list_siptrunk_id)
                        #print list_sipcontact

                        list_ip_host = get_host_from_siptrunk_id(list_siptrunk_id)
                        #print list_ip_host

                        list_weight = get_weight_from_siptrunk_id(list_siptrunk_id)
                        #print list_weight

                        list_ip = []
                        list_host = []
                        list_type = []

                        for i in range(len(list_sipcontact)):
                            if list_sipcontact[i] != list_sipcontact[i-1]:
                                list_ip.append(list_sipcontact[i])

                                if list_ip_host[i] == "sip:118.69.114.166:5060" or list_ip_host[i] == "sip:118.69.115.134:5060":
                                    list_host.append("MPLS")
                                else:
                                    list_host.append("Public")

                                j = i
                                if list_weight[j] == '1000' or list_weight[j+1] == '1000':
                                    list_type.append("Primary")
                                else:
                                    list_type.append("Backup")
                            else:
                                i += 1

                        for index, element in enumerate(list_ip):
                            list_ip[index] = element.replace("sip:", "")
                        print "List IP:", list_ip
                        print "List host:", list_host
                        print "List type:", list_type
                        index = list_type.index("Primary")
                        #print index
                        ip_main = list_ip[index]
                        typeip_main = list_type[index]
                        host_main = list_host[index]

                        ip_bk = []
                        typeip_bk = []
                        host_bk = []

                        for k in range(len(list_ip)):
                            if k != index:
                                ip_bk.append(list_ip[k])
                                typeip_bk.append(list_type[k])
                                host_bk.append(list_host[k])
                        ip_bk1 = ip_bk[0]
                        typeip_bk1 = typeip_bk[0]
                        host_bk1 = host_bk[0]

                        ip_bk2 = ip_bk[1]
                        typeip_bk2 = typeip_bk[1]
                        host_bk2 = host_bk[1]

                        '''
                        list_ip = []
                        list_host = []
                        list_q = []
                        for i in range(len(list_siptrunk_id)):
                            if list_sipcontact[i] != list_sipcontact[i-1]:
                                list_ip.append(list_sipcontact[i])
                        #print "List IP:", list_ip_tmp

                        for index, element in enumerate(list_ip):
                            list_ip[index] = element.replace("sip:", "")
                        print "List IP:", list_ip

                        y = 0
                        while y in range(len(list_ip_host)):
                            #print y
                            #print list_ip_host
                            if list_ip_host[y] == "sip:118.69.115.150:5060" or list_ip_host[y] == "sip:118.69.114.182:5060":
                                list_host.append("Public")
                            else:
                                list_host.append("MPLS")
                            y += 2
                        print list_host

                        j = 0
                        while j in range(len(list_weight)):
                            list_q.append(list_weight[j])
                            j += 2
                        print list_q
                        '''

                        get_info = get_info.replace("SIP Trunking Account", "")
                        # print "info:", get_info
                        get_info = get_info.strip()
                        # print "info:", get_info[0: get_info.find(" ")]
                        name = get_info[0: get_info.find(" ")]
                        # f_out.write(account+','+disable+','+pricelist+','+typeKHG+',,,'+ip+','+port+','+type_ip+','+host+','+valueMax+'\n')
                        # file_output.append([account, disable, pricelist, typeKHG, "", "", ip_main, port_main, typeip_main, list_host[0], ip_bk1, port_bk1, typeip_bk1, list_host[1], ip_bk2, port_bk2, typeip_bk2, list_host[2], prefix, type_fw, fw_number, delay, call_inter, call_high_cost, valueMax])
                        print "Number: ", number
                        print "Account: ", account
                        print "Status Account: ", status_acc
                        print "Ten KHG: ", name
                        print "Loai tien khai: ", typeKHG
                        print "IP Main: ", ip_main
                        #print "Port IP Main: ", port_main
                        print "Loai IP Main: ", typeip_main
                        print "Host IP Main: ", host_main
                        print "IP BK1: ", ip_bk1
                        #print "Port IP BK1: ", port_bk1
                        print "Loai IP BK1: ", typeip_bk1
                        print "Host IP BK1: ", host_bk1
                        print "IP BK2: ", ip_bk2
                        #print "Port IP BK2: ", port_bk2
                        print "Loai IP BK2: ", typeip_bk2
                        print "Host IP BK2: ", host_bk2
                        #print "IP Media: ", ip_media
                        #print "Port IP Media: ", port_media
                        #print "Loai IP Media: ", typeip_media
                        #print "Host IP Media: ", list_host[3]
                        print "Prefix: ", prefix
                        print "Loai Forward: ", type_fw
                        print "So trung gian forward: ", inter_num
                        print "So dich forward: ", fw_number
                        print "Thoi gian cho forward (s): ", delay
                        print "So cuoc goi dong thoi toi da cho phep: ", max_channel
                        print "Mo huong goi quoc te: ", call_inter
                        print "Cho phep goi quoc te gia cao: ", call_high_cost
                        print "Ma quoc te gia cao: ", highcost_code
                        print "Han muc account: ", valueMax
                        print "IVR thong bao cuoc 1900: ", ivr1900
                        print "Tinh trang dau so: ", status_number
                    else:
                        typeKHG = "SIP Account"

                        ip_main = ""
                        ip_bk1 = ""
                        ip_bk2 = ""
                        port_main = ""
                        port_bk1 = ""
                        port_bk2 = ""
                        typeip_main = ""
                        typeip_bk1 = ""
                        typeip_bk2 = ""
                        ip_media = ""
                        port_media = ""
                        typeip_media = ""
                        list_iptrunk = ['', '', '', '']
                        list_port = ['', '', '', '']
                        list_typeip = ['', '', '', '']
                        list_host = ['', '', '', '']

                        get_info = get_info.replace("SIP Account Register", "")
                        # print "info:", get_info
                        get_info = get_info.strip()
                        # print "info:", get_info[0: get_info.find(" ")]
                        name = get_info[0: get_info.find(" ")]
                        # f_out.write(account+','+disable+','+pricelist+','+typeKHG+','+username+','+password+',,,,,'+valueMax+'\n')

                        print "Number: ", number
                        print "Account: ", account
                        print "Status Account: ", status_acc
                        print "Ten KHG: ", name
                        print "Loai tien khai: ", typeKHG
                        print "Username: ", username
                        print "Password: ", password
                        print "Loai Forward: ", type_fw
                        print "So trung gian forward: ", inter_num
                        print "So dich forward: ", fw_number
                        print "Thoi gian cho forward (s): ", delay
                        print "So cuoc goi dong thoi toi da cho phep: ", max_channel
                        print "Mo huong goi quoc te: ", call_inter
                        print "Cho phep goi quoc te gia cao: ", call_high_cost
                        print "Ma quoc te gia cao: ", highcost_code
                        print "Han muc account: ", valueMax
                        print "IVR thong bao cuoc 1900: ", ivr1900
                        print "Tinh trang dau so: ", status_number
            else:
                print 'Number:', number, 'khong ton tai tren AAR'
                list_num_fail.append(number)

            if list_num_fail != []:
                print "List dau so khong ton tai: ", list_num_fail
            else:
                print "Output: OK\n"

    print "End time:", timenow()
    f_out.write(timenow() + " # End # Check profile ky thuat: " + number_list + "\n")


if __name__ == "__main__":
    main()
