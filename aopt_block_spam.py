'''Author: Doan Phong
Date: 28/11/2018
Description: Input:SDT KHG, so spam call, ten KHG
Output: add ruleset vao account'''

from optparse import OptionParser
import requests
import json
import time
import random
import datetime
import sys
import os.path
import string
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

def timenow():
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now

def shortname(name_khg):
    shortname = ""
    list_remove = ["Tnhh", "Cty", "Mtv", "Va", "-", "&", ".", "(", ")", "Ltd", "Co.,Ltd.", "Vpdd", "Vpls"]
    list_remove_2 = ["Cong Ty", "Co Phan", "Mtv", "Ho Chi Minh", "Ha Noi", "Da Nang", "Cp", "Giao Duc Dao Tao",
                     "Duoc Pham", "Ho Kinh Doanh", "Thuong Mai", "San Xuat", "Xuat Khau", "Dau Tu", "Phat Trien",
                     "Bat Dong San", "Cong Nghe", "Dich Vu", "Thuong Mai", "Chi Nhanh", "Tu Van", "Nha Hang",
                     "Mot Thanh Vien", "Van Phong Dai Dien", "Tai Thanh Pho", "Trach Nhiem Huu Han", "Ky Thuat",
                     "Da Khoa Quoc Te", "Truong Mam Non", "Ltd", "Tai HCM", "Chi Nhanh Ho Chi Minh", "Chi Nhanh Ha Noi",
                     "Giao Nhan Van Chuyen"]

    if ("Viet Nam") or ("Xuat Nhap Khau")  in name_khg:
        name_khg = name_khg.replace("Viet Nam", ".VN")
        name_khg = name_khg.replace("Xuat Nhap Khau", "XNK")


    amount = name_khg.count(" ") + 1
    #print amount
    #print name_khg
    list_word = []
    for i in range(amount):
        word = str(name_khg.split(" ")[i].strip())
        list_word.append(word)

    for x in list_word:
        #print x
        if x in list_remove:
            print x
            list_word.remove(x)
            print list_word
    for y in list_word:
        shortname = shortname + " " + y
        #print shortname
    # print len(list_remove_2)
    for z in range(len(list_remove_2)):
        if list_remove_2[z] in shortname:
            shortname = shortname.replace(list_remove_2[z], "")
    shortname = shortname.replace(" ", "")
    return shortname

def read_address(address):
    try:
        xmlData = '''<daml command="read"><address><number>''' + address + '''</number></address></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        time.sleep(1)
        result = requests.post(url_read_address, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            # print "DAML READ ADDRESS is OK"
            if address in response_hcm:
                account = response_hcm[response_hcm.find("<account>") + 9:response_hcm.rfind("</account>")]
                print "Account for this phone number is: ", account
                return account
            if address in response_hni:
                account = response_hni[response_hni.find("<account>") + 9:response_hni.rfind("</account>")]
                print "Account for this phone number is: ", account
                return account                
            else:
                print "Can not find this phone number"
                return ""
        else:
            print "DAML READ ADDRESS is NOK"
            return ""
    except requests.exceptions.RequestException as error:
        print error
        return False

def read_ruleset(account):
    try:
        xmlData = '''<daml command="read"><account><accountName>'''+account+'''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        time.sleep(1)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            if account in response_hcm:
                get_ruleset = response_hcm[response_hcm.find("<ruleset>"):response_hcm.rfind("</ruleset>") + 10]
                print "Present Ruleset:", get_ruleset
                return get_ruleset
            if account in response_hni:
                get_ruleset = response_hni[response_hni.find("<ruleset>"):response_hni.rfind("</ruleset>") + 10]
                print "Present Ruleset:", get_ruleset
                return get_ruleset
            else:
                print "Can not find ruleset in this account"
                return ""
        else:
            print "DAML read account is NOK"
            print "Request again after 10 s"
            return "Fail"
    except requests.exceptions.RequestException as error:
        print error
        return "Fail"

def find_ruleset(ruleset):
    try:
        xmlData = '''<daml command="read"><ruleset><name>''' + ruleset + '''</name></ruleset></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        time.sleep(1)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        #print response
        if "status=ok" in response_hcm and "status=ok" in response_hni:
            print "DAML FIND ruleset is OK"
            if ruleset in response_hcm:
                ruleset_exist =  response_hcm[response_hcm.find("<ruleset>"):response_hcm.rfind("</ruleset>") + 10]
                return ruleset_exist
            else:
                return ""
        else:
            return "Fail"
    except requests.exceptions.RequestException as error:
        print error
        return False

def create_ruleset(ruleset):
    xmlData = '''<daml command="write"><ruleset><name>''' + ruleset + '''</name><description>''' + ruleset + '''</description><userViewable>false</userViewable></ruleset></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(1)
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    #print response
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        #print "DAML CREATE RULESET is OK"
        return True
    else:
        #print "DAML CREATE RULESET is NOK"
        return False

def create_rule(ruleset, spam_num, number):
    xmlData = '''<daml command="create"><rule><name>''' + spam_num + '''</name><priority>1</priority><execTime>POSTROUTING</execTime><destPattern>''' + number + '''</destPattern><rejectCode>403</rejectCode><action>next</action><rejectPhrase>Forbidden</rejectPhrase><prefIdPattern>''' + spam_num + '''</prefIdPattern><sourcePresentationReplace>SHOW</sourcePresentationReplace><ruleset>''' + ruleset + '''</ruleset></rule></daml>'''  # Xem trong AS.6.9 What news
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(1)
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        #print "DAML CREATE RULE is OK"
        return True
    else:
        #print "DAML CREATE RULE is NOK"
        return False

def add_acc_ruleset(account, ruleset_add):
    print "Configuring add ruleset..."
    xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName>''' + ruleset_add + '''</account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(1)
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        #print "add ruleset OK"
        return True
    else:
        #print "add ruleset NOK"
        return False



def main():
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_block_spam.log", "a+")

    parser = OptionParser()

    parser.add_option("-s", "--spam_num_list", dest="spam_num_list", type="string", help="Input spam number")
    parser.add_option("-n", "--address", dest="address", type="string", help="Input address KHG")
    parser.add_option("-k", "--name", dest="name", type="string", help="Input name KHG")

    (options, args) = parser.parse_args()

    if (options.spam_num_list == "None" or options.address == "None" or  options.name == "None"):
        print 'Input Contract Error'
    for op in ("spam_num_list", "address", "name"):
        if not getattr(options, op):
            print 'Gia tri %s chua duoc nhap vao' %op
            parser.print_help()
            sys.exit()

    spam_num_list = options.spam_num_list
    address = options.address
    name = options.name

    spam_num_max = 0
    spam_num_max = spam_num_list.count(",") + 1


    if "&" in name:
        name = name.replace("&","")
    if "<" in name:
        name = name.replace("<","")
    if ">" in name:
        name = name.replace(">","")
    if "-" in name:
        name = name.replace("-","")

    name = name.title()
    name = shortname(name)
    print "Customer name:", name
    print "Spam Number:", spam_num_list
    print "Customer number:", address

    print "Start time:", timenow()
    f_out.write(timenow() + " # Start # Block spam call: " + spam_num_list + "," + address + "," + name + "\n")

    ruleset_add = ""
    account = read_address(address)
    if account != "":
        ruleset = "Block : Spam Number " + name + " " + account
        ruleset_find = "<ruleset>" + ruleset + "</ruleset>"

        get_ruleset_all = read_ruleset(account) # tat ca ruleset trong account
        find_rulset_aar = find_ruleset(ruleset) # tat ca ruleset AAR
        if get_ruleset_all != "" and get_ruleset_all != "Fail":
            print "Account has ruleset "
            if ruleset not in get_ruleset_all: # neu ruleset block Spam ko co trong account
                print "Ruleset " + ruleset + " has not been added to account"
                if ruleset_find not in find_rulset_aar: # neu ruleset block Spam ko co trong AAR
                    print "Ruleset " + ruleset + " has not been created"
                    create_ruleset(ruleset)
                    print "Create ruleset " + ruleset + " OK\n"
                    for n in range(spam_num_max):
                        if spam_num_max == 0:
                            break
                        spam_num = str(spam_num_list.split(",")[n].strip())
                        create_rule(ruleset, spam_num, address)
                        print "Rule ", address, " has been created successfully"
                    ruleset_add = get_ruleset_all + "<ruleset>" + ruleset + "</ruleset>"
                    f_out.write(timenow() + " Ruleset: " + ruleset + " has been created\n")
                else: # neu ruleset block Spam co trong AAR
                    print "Ruleset " + ruleset + " was created before"
                    for n in range(spam_num_max):
                        if spam_num_max == 0:
                            break
                        spam_num = str(spam_num_list.split(",")[n].strip())
                        if spam_num in find_rulset_aar:   # neu rule da ton tai trong ruleset
                            print "Rule " + spam_num + " was configured"
                            #ruleset_add = get_ruleset_all + "<ruleset>" + ruleset + "</ruleset>"
                        else:
                            create_rule(ruleset, spam_num, address)
                            print "Rule ", spam_num, " has been added to account successfully"
                        ruleset_add = get_ruleset_all + "<ruleset>" + ruleset + "</ruleset>"
            else:   # neu ruleset block Spam co trong account
                print "Ruleset " + ruleset + " was added to account before"
                for n in range(spam_num_max):
                    if spam_num_max == 0:
                        break
                    spam_num = str(spam_num_list.split(",")[n].strip())
                    if spam_num in find_rulset_aar:
                        print "Rule ", spam_num, " was configured before"
                        ruleset_add = "Fail"
                    else:
                        create_rule(ruleset, spam_num, address)
                        print "Rule ", spam_num, " has been added to account successfully"
                        ruleset_add = "OK"

        elif get_ruleset_all == "":
            print "Account does not have ruleset"
            if ruleset in find_rulset_aar:
                print "Ruleset " + ruleset + " was configured"
                ruleset_add = "<ruleset>" + ruleset + "</ruleset>"
            else:
                print "Ruleset " + ruleset + " was not configured"
                create_ruleset(ruleset)
                print "Create ruleset " + ruleset + " OK\n"
                for n in range(spam_num_max):
                    if spam_num_max == 0:
                        break
                    spam_num = str(spam_num_list.split(",")[n].strip())
                    create_rule(ruleset, spam_num, address)
                    print "Rule ", spam_num, " has been added to account successfully"
                ruleset_add = "<ruleset>" + ruleset + "</ruleset>"
                f_out.write(timenow() + " Ruleset: " + ruleset + " has been created\n")
        else:
            print "Daml Fail.. Try Again"
            ruleset_add == "Fail"

        if ruleset_add == "OK":
            print "Output: OK\n"
        elif ruleset_add == "Fail":
            print "Output: Fail\n"
        else:
            if add_acc_ruleset(account, ruleset_add) == True:
                print "Add ruleset Block Spam to account " + account + " OK\n"
                f_out.write(timenow() + " Ruleset: " + ruleset_add + " has been added to account " + account + "\n")
                print "Output: OK\n"
            else:
                print "Add ruleset Block Spam to account " + account + " NOK\n"
                print "Output: Fail\n"
    else:
        print "Output: Fail\n"
    print "End time:",timenow()
    f_out.write(timenow() + " # End # Block spam call: " + spam_num_list + "," + address + "," + name + "\n")

if __name__ == "__main__":
    main()