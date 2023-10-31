# Tool AOPT Huy/thanh ly dau so v0.1 (them phan xoa ivr 1900)
# Code by DucTT7

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

url_read_account = 'http://localhost:8888/daml/account/read_test'
url_write_account = 'http://localhost:8888/daml/account/write_test'
url_write_account_hcm = 'http://localhost:8888/daml/account/write/hcm'
url_write_account_hni = 'http://localhost:8888/daml/account/write/hni'
url_read_address = 'http://localhost:8888/daml/address/read_test'
url_read_address_hcm = 'http://localhost:8888/daml/address/read/hcm'
url_write_address = 'http://localhost:8888/daml/address/write_test'
url_write_address_hcm = 'http://localhost:8888/daml/address/write/hcm'
url_read_siptrunk = 'http://localhost:8888/daml/siptrunk/read_test'
url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write_test'
url_read_ruleset = 'http://localhost:8888/daml/ruleset/read_test'
url_write_ruleset = 'http://localhost:8888/daml/ruleset/write_test'
url_write_ruleset_hcm = 'http://localhost:8888/daml/ruleset/write/hcm'
url_write_ruleset_hni = 'http://localhost:8888/daml/ruleset/write/hni'

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


def user_rand(y):
    #print "user rand"
    return "".join(random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") for x in range(y))


def delete_address(number, type_khg):
    # headers = {'content-type': 'application/json'}
    # try:
    if type_khg == "siptrunk":
        xmlData = '''<daml command="delete"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        #time.sleep(1)
        result = requests.post(url_write_address, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print "Daml delete address OK"
            return True
        else:
            print "DAML delete address NOK"
            return False
    else:
        xmlData = '''<daml command="delete"><address><number>''' + number + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        # time.sleep(1)
        result = requests.post(url_write_address, data=payload)
        response = result.text

        if "status=ok" in response:
            print "Daml delete address OK"
            return True
        else:
            print "DAML delete address NOK"
            return False



def check_ruleset(ruleset, pattern):
    try:
        id = []
        xmlData = '''<daml command="read"><ruleset name="''' + ruleset + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        #time.sleep(1)
        result = requests.post(url_read_ruleset, data=payload)
        response = result.text
        #print response
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            # print "DAML CHECK RULESET is OK"
            if ruleset in response_hcm and ruleset in response_hni:
                #id = re.findall(pattern, response_hcm)
                id_hcm = re.findall(pattern, response_hcm)
                id.append(id_hcm)
                #print "ID HCM:", id_hcm
                id_hni = re.findall(pattern, response_hni)
                id.append(id_hni)
                #print "ID HNI:", id_hni
                #print "ID hcm:", id[0]
                if id == []:
                    # print "This number has not been configured IVR before\n"
                    return ""
                else:
                    return id
            else:
                print "Can not find this rule"
        else:
            print "DAML read account is NOK"
            return "Fail"
    except requests.exceptions.RequestException as error:
        print error
        return False


def delete_rule(rule_id, type_khg, k):
    try:
        if type_khg == "siptrunk":
            if k == 0:
                url_write_ruleset = url_write_ruleset_hcm
            else:
                url_write_ruleset = url_write_ruleset_hni
            xmlData = '''<daml command="delete"><rule id="''' + rule_id + '''"/></daml>'''
            payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
            result = requests.post(url_write_ruleset, data=payload)
            response = result.text
            #response_hcm = split_response(response)[0]
            #response_hni = split_response(response)[1]
            #print response_hcm
            #print response_hni
            if "status=ok" in response:
                print "DAML delete rule is OK"
                return True
            else:
                print "DAML delete rule is NOK"
                return False
        else:
            xmlData = '''<daml command="delete"><rule id="''' + rule_id + '''"/></daml>'''
            payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
            result = requests.post(url_write_ruleset_hcm, data=payload)
            response = result.text
            #response_hcm = split_response(response)[0]
            #response_hni = split_response(response)[1]
            #print "Delete rule ", response
            if "status=ok" in response:
                print "DAML delete rule is OK"
                return True
            else:
                print "DAML delete rule is NOK"
                return False
    except requests.exceptions.RequestException as error:
        print error
        return False


def check_add(number):
    # headers = {'content-type': 'application/json'}
    # try:
    xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(1)
    result = requests.post(url_read_address, data=payload)

    response = result.text
    # print response

    global account
    account = response[response.find("<account>") + 9:response.find("</account>")]

    if number in response:
        return True
    else:
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0


def check_acc(account):
    # headers = {'content-type': 'application/json'}
    # try:
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #time.sleep(1)
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print "xmlData:", xmlData
    #print "check response:", response

    if "<number>" in response_hcm:
        get_number = response_hcm[response_hcm.find("<number>") + 8:response_hcm.find("</number>")]
    elif "<number>" in response_hni:
        get_number = response_hni[response_hni.find("<number>") + 8:response_hni.find("</number>")]
    else:
        get_number = ""

    # print get_number

    global get_info
    # global get_ip
    get_info = response_hcm[response_hcm.find("<info>") + 6:response_hcm.find("</info>")]

    #print "info:", get_info

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        if account in response_hcm:
            if get_number == "":
                return True
            else:
                return False
        else:
            print "DAML read account is NOK. Can not find account in response"
            return False
    else:
        print "DAML read account is NOK"
        return False



def edit_acc(account, info, time_now, old_username):
    # headers = {'content-type': 'application/json'}
    # try:
    xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><info>''' + info + '''</info> <username>''' + old_username + '''</username><validUntil>''' + time_now + '''</validUntil></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    # time_now_hni = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    # xmlData_hni = '''<daml command="write"><account><accountName>''' + account + '''</accountName><info>''' + info + '''</info> <username>''' + old_username + '''</username><validUntil>''' + time_now_hni + '''</validUntil></account></daml>'''
    # payload_hni = {"XmlData": xmlData_hni, "UserRequest": "AOPT"}
    # result = requests.post(url_write_account_hni, data=payload_hni)
    # response_hni = result.text

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "Daml Disable Account OK"
        return True
    else:
        print "Daml Disable Account NOK"
        return False
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0

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
        print "DAML check Account SIP Trunk Map OK"
        if account in response_hcm and account in response_hni:
            print "Account ", account, " is SIP Trunk"
            return True
        else:
            print "Account ", account, " is SIP Account"
            return False
    else:
        print "DAML check Account SIP Trunk Map NOK"
        return False


def delete(n, number_list):
    f_out = open("/home/administrator/aopt/logs/aopt_CPN_delete_address.log", "a+")

    print "*** Xoa so de Chuyen phap nhan ***"
    if " " in number_list:
        print "--> Luu y khong nhap co khoang trang !"

    if number_list[-1:] == ",":
        print "--> Luu y khong nhap dau , o cuoi !"
        number_list = number_list[:-1]

    number_list = number_list.replace(" ", "")

    #print "Danh sach:", number_list

    num_max = 0
    num_max = number_list.count(",") + 1

    ruleset_ivr = "Announcement VAS - 1900"

    #print "Tong cong:", num_max, "number\n"
    #print "Start time:", timenow()
    list_num_fail = []
    # print num_max
    f_out.write(timenow() + " # Start # Delete Number: " + number_list + "\n")
    for i in range(num_max):
        if num_max == 0:
            break
        number = str(number_list.split(",")[i].strip())

        number = number.replace(" ", "")

        print str(n + 1) + ". " + number
        if ((len(number) == 11) and (number[0:2] == "02")) or ((len(number) == 8) and (number[0:1] == "1")) or (
                (len(number) == 10) and (number[0:1] == "1")):
            time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            out_put = ""
            global account, get_info

            # Check xem Address tren AARENET-NEW da ton tai hay chua
            status_check_add = check_add(number)
            # print account
            if status_check_add == False:
                print "Number:", number, '--> Khong ton tai tren AARENET'
                print "Output: Fail"
                # f_out.write(number+' chua ton tai\n')
            else:
                print "Number: ", number, "thuoc Account:", account, "--> Ton tai tren AARENET"
                if check_acc_siptrunk_map(account):  # SIP Trunk
                    type_khg = "siptrunk"
                else:
                    type_khg = "sipacc"
                status_del_add = delete_address(number, type_khg)
                if status_del_add:
                    print "- Delete number"
                    print "--> Delete number:", number, "OK"
                    f_out.write(time_now + " Number: " + number + " of Account: " + account + " has been deleted \n")

                    if number[0:4] == "1900":
                        # pattern = r'''<action>stop</action>\s*<id>(\d+)</id>\s*<destPattern>\(?''' + number + '''\)?</destPattern>'''   #dat rulename = number moi dc
                        pattern = r'''<id>(\d+)</id>\s*<destPattern>\(?''' + number + '''\)?</destPattern>'''  # dat rulename = number moi dc
                        # for j in range(2):
                        rule_id = check_ruleset(ruleset_ivr, pattern)
                        if rule_id == "":
                            print "Number: ", number, " does not have IVR"
                        elif rule_id == "Fail":
                            print "DAML Check ruleset Failed. Please try again later\n"
                        else:
                            print "Rule ID:", rule_id
                            for k in range(len(rule_id)):
                                if rule_id[k] != []:
                                    rule_id[k][0] = str(rule_id[k][0])
                                    if delete_rule(rule_id[k][0], type_khg, k):
                                        f_out.write(time_now + " IVR of number: " + number + " has been removed\n")
                                        print "IVR of number ", number, " has been removed\n"
                                        # print "Output:OK\n"
                                    else:
                                        list_num_fail.append(number)
                                        print "Output:Fail\n"

                    status_disable = check_acc(account)
                    # print get_info
                    if status_disable:
                        print "- Disable Account"
                        # Edit Account AARENET
                        # if "-> Huy" not in get_info:
                        info = get_info + " -> Huy"
                        # print info
                        old_username = user_rand(14)
                        # print "old username:", old_username
                        time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        # print "time now:", time_now
                        status_edit_acc = edit_acc(account, info, time_now, old_username)
                        # status_edit_acc = edit_acc(account, info, time_now)
                        if status_edit_acc:
                            print "--> Disable account", account, "OK"
                            f_out.write(timenow() + " Account: " + account + " has been disable" + "\n")

                        else:
                            print "--> Disable account", account, "Error"
                    else:
                        print "--> Khong Disable Account"
                    # print "Output: OK\n"
                else:
                    list_num_fail.append(number)
                    print "--> Delete number:", number, "Error"
                    print "Output: Fail\n"
        else:
            print "--> Nhap sai format cua number"
    print "List number failed: ", list_num_fail
    if list_num_fail == []:
        return True
    else:
        return False
    #print "End time:", timenow()
    f_out.write(timenow() + " # End # Delete Number: " + number_list + "\n")

def main():
    delete(n, number_list)

if __name__ == "__main__":
    main()
