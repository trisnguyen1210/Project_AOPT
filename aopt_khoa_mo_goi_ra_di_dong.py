#Tool AOPT Khoa/mo goi ra di dong
#Code by DucTT7

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
from macpath import split
import mysql.connector
from mysql.connector import cursor

url_read_account = 'http://localhost:8888/daml/account/read_test'
url_write_account = 'http://localhost:8888/daml/account/write_test'
url_write_account_hcm = 'http://localhost:8888/daml/account/write/hcm'
url_write_account_hni = 'http://localhost:8888/daml/account/write/hni'
url_read_address = 'http://localhost:8888/daml/address/read_test'
url_read_address_hcm = 'http://localhost:8888/daml/address/read/hcm'
url_write_address = 'http://localhost:8888/daml/address/write'
url_read_siptrunk = 'http://localhost:8888/daml/siptrunk/read'
url_write_siptrunk = 'http://localhost:8888/daml/siptrunk/write'
url_read_ruleset = 'http://localhost:8888/daml/ruleset/read'
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

def check_add(number):
    # headers = {'content-type': 'application/json'}
    # try:
    xmlData = '''<daml command="read"><address><number>''' + number + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_address, data=payload)
    response = result.text
    # print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    global account
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML read address is OK"
        if number in response_hcm or number in response_hni:
            account = response_hcm[response_hcm.find("<account>") + 9:response_hcm.find("</account>")]
            return "OK"
        else:
            return "Fail"
    else:
        print "DAML read address is NOK"
        return "Fail"
    # except requests.exceptions.RequestException as error:
    #    print error
    #    return 0

def check_ruleset(ruleset, number):
    try:
        xmlData = '''<daml command="read"><ruleset name="''' + ruleset + '''"/></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        result = requests.post(url_read_account, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]

        if "status=ok" in response:
            if ruleset in response_hcm or ruleset in response_hni:
                if number in response_hcm and number in response_hni: # Neu sdt da dc cau hinh trong ruleset
                    return "Yes"
                else:
                    return "No"
            else:
                print "Can not find ruleset:", ruleset
                return "Fail"
        else:
            print "DAML read account is NOK"
            return "Fail"
    except requests.exceptions.RequestException as error:
        print error
        return "Fail"

def create_rule(number, ruleset, priority, dest_pattern, pref_source_pattern):
    name = number
    xmlData = '''<daml command="create"><rule><name>''' + name + '''</name><priority>''' + priority + '''</priority><execTime>PREROUTING</execTime><action>stop</action><rejectCode>403</rejectCode><rejectPhrase>Number Blocked</rejectPhrase><destPattern>''' + dest_pattern + '''</destPattern><prefIdPattern>'''+pref_source_pattern+'''</prefIdPattern><ruleset>'''+ruleset+'''</ruleset></rule></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_write_account, data=payload)
    response = result.text
    #print response
    if "ok" in response:
        print "DAML CREATE RULE is OK"
        return True
    else:
        print "DAML CREATE RULE is NOK"
        return False

def read_ruleset(account):
    try:
        xmlData = '''<daml command="read"><account><accountName>'''+account+'''</accountName></account></daml>'''
        payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
        time.sleep(0.5)
        result = requests.post(url_read_account, data=payload)
        response = result.text
        response_hcm = split_response(response)[0]
        response_hni = split_response(response)[1]
        if "status=ok" in response_hcm:
            if account in response_hcm:
                get_ruleset = response_hcm[response_hcm.find("<ruleset>"):response_hcm.rfind("</ruleset>") + 10]
                print "Present Ruleset:", get_ruleset
                return get_ruleset
            else:
                print "Can not find ruleset in this account"
                return ""
        elif "status=ok" in response_hni:
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

def add_acc_ruleset(account, ruleset_add):
    print "Configuring add ruleset..."
    xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName>''' + ruleset_add + '''</account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    time.sleep(0.5)
    result = requests.post(url_write_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm or "status=ok" in response_hni:
        print "add ruleset OK"
        return True
    else:
        print "add ruleset NOK"
        return False

def get_rule_id_hcm(ruleset_id_hcm, rule_name):
    list_rule_id = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select rule_id from rule where ruleset_id = '" + ruleset_id_hcm + "' and name = '" + rule_name + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_rule_id.append(tmpId)
    cur.close()
    cnx.close()

    #print "List rule id HCM", list_rule_id
    rule_id = list_rule_id[0]
    rule_id = rule_id.replace("(","").replace(",","")
    print "Rule id AS-HCM", rule_id
    return rule_id #tra ve list rule id

def get_rule_id_hni(ruleset_id_hni, rule_name):
    list_rule_id = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.139',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select rule_id from rule where ruleset_id = '" + ruleset_id_hni + "' and name = '" + rule_name + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_rule_id.append(tmpId)
    cur.close()
    cnx.close()

    #print "List rule id HNI", list_rule_id
    rule_id = list_rule_id[0]
    rule_id = rule_id.replace("(","").replace(",","")
    print "Rule id AS-HNI", rule_id
    return rule_id #tra ve list rule id

def get_rule_name_hcm(ruleset_id_hcm):
    list_rule_name = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select name from rule where ruleset_id = '" + ruleset_id_hcm + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_rule_name.append(tmpId)
    cur.close()
    cnx.close()

    print "List rule name AS-HCM", list_rule_name
    return list_rule_name #tra ve list rule name hcm

def get_rule_name_hni(ruleset_id_hni):
    list_rule_name = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.139',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select name from rule where ruleset_id = '" + ruleset_id_hni + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_rule_name.append(tmpId)
    cur.close()
    cnx.close()

    print "List rule name AS-HNI", list_rule_name
    return list_rule_name #tra ve list rule name hcm

def delete_rule(rule_id):
    try:
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
    except requests.exceptions.RequestException as error:
        print error
        return False

def get_account_from_address(address):
    xmlData = '''<daml command="read"><address><number>''' + address + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_address, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm or "status=ok" in response_hni:
        print "DAML READ ADDRESS is OK"
        if address in response:
            account = response[response.find("<account>") + 9:response.rfind("</account>")]
            print "This number's current account is: ", account
            return account
        else:
            print "Can not find this phone number"
            return "Fail"
    else:
        print "DAML READ ADDRESS is NOK"
        return "Fail"

def get_account_id_hcm_from_account_name(account):
    list_account_id = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select account_id from account where account_name like '" + account + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_account_id.append(tmpId)
    cur.close()
    cnx.close()

    #print "List account id", list_account_id
    account_id = list_account_id[0]
    account_id = account_id.replace("(","").replace(",","")
    print "Account id", account_id
    return account_id #tra ve account id

def get_list_number_hcm(account_id_hcm):
    list_number = []
    cnx = mysql.connector.connect(user='scc', password='sccivoice@2020',host='172.31.14.14',port = 3306,database = 'aareswitch_config')
    cur = cnx.cursor()
    query = ("select number from address where account_id = '" + account_id_hcm + "'")
    #print "query: ", query
    time.sleep(0.5)
    cur.execute(query)
    for (Id) in cur:
        Id = str(Id)
        tmpId = Id[(Id.find("'"))+1 : (Id.rfind("'"))]
        list_number.append(tmpId)
    cur.close()
    cnx.close()

    print "List number", list_number
    return list_number
    #for i in range(len(list_number)):
        #print list_number[i]

def get_acc_ruleset(account):
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data=payload)
    response = result.text
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    present_ruleset = response_hcm[response_hcm.find("<ruleset>"):response_hcm.rfind("</ruleset>") + 10]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML get ruleset is OK"
        if account in response_hcm and account in response_hni:
            if "ruleset" in response_hcm and account in response_hni:  # neu muc Ruleset da co add ruleset
                return present_ruleset
            else:  # neu muc Ruleset chua add ruleset nao
                print "None of rulesets have been configured"
                return ""
        else:
            print "Can not find account in response"
            return "Fail"
    else:
        print "DAML get ruleset is NOK"
        return "Fail"

def main():
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_khoa_mo_goi_ra_di_dong.log", "a+")

    # Parsing argurments
    # check input from AOPT
    parser = OptionParser()

    parser.add_option("-n", "--number_list", dest="number_list", type="string", help="Enter Phone numbers")
    parser.add_option("-o", "--option", dest="option", type="string", help="Select Khoa or Mo")
    parser.add_option("-t", "--telco", dest="telco", type="string", help="Select Telco")

    (options, args) = parser.parse_args()

    number_list = options.number_list
    option = options.option
    telco = options.telco

    number_list = number_list.replace(" ", "")

    if " " in number_list:
        print "--> Luu y khong nhap co khoang trang !"

    if number_list[-1:] == ",":
        print "--> Luu y khong nhap dau , o cuoi !"
        number_list = number_list[:-1]

    number_list = number_list.replace(" ", "")

    print "Numbers:", number_list
    print "Option:", option
    print "Telco:", telco

    num_max = 0
    num_max = number_list.count(",") + 1

    print "Tong cong:", num_max, "number\n"
    print "Start time:", timenow()
    list_num_fail = []

    f_out.write(timenow() + " # Start # Khoa/Mo goi ra huong di dong:" + number_list + "," + option + "," + telco + "\n")
    for n in range(num_max):
        if num_max == 0:
            break
        number = str(number_list.split(",")[n].strip())

        number = number.replace(" ", "")
        print str(n + 1) + ". " + number
        if number[0:4] == "1900" or number[0:4] == "1800":
            print number + " is not valid\n"
            break
        status_check_add = check_add(number)
        if option == "Khoa":
            print "Khoa huong goi " + telco
            if status_check_add == "Fail": # Neu so ko ton tai
                print "Number:", number, ' is not configured on Aareswitch'
                print "Output: Fail\n"
            else: # Neu so ton tai thi kiem tra so do dc add vao rule chua, neu chua thi add rule cua so do vao ruleset va add ruleset vao account cua so do
                if telco == "Mobifone":
                    ruleset = "Block : Outgoing to Mobifone by Address"
                    dest_pattern = "(070|076|077|078|079|090|093|089)(.*)"
                elif telco == "Viettel":
                    ruleset ="Block : Outgoing to Viettel by Address"
                    dest_pattern = "(032|033|034|035|036|037|038|039|0862|0865|0866|0867|0868|0869|096|097|098)(.*)"
                elif telco == "VinaPhone":
                    ruleset ="Block : Outgoing to VinaPhone by Address"
                    dest_pattern = "(081|082|083|084|085|0886|0888|0889|091|094)(.*)"

                check_rule = check_ruleset(ruleset, number)
                if check_rule == "Yes": # neu rule da dc tao thi ko tao nua
                    print "Number " + number + " was added before"
                elif check_rule == "No": # neu rule chua dc tao thi tao rule
                    priority = "25"
                    pref_source_pattern = number
                    if create_rule(number, ruleset, priority, dest_pattern, pref_source_pattern): # Neu tao rule thanh cong
                        f_out.write(timenow() + " Rule for : " + number + " has been created" + "\n")
                        print "Number " + number + " has been added\n"
                        #print "Output: OK\n"

                        # Kiem tra account cua sdt dang cau hinh
                        account = get_account_from_address(number)

                        # Add ruleset vao account
                        get_ruleset_all = read_ruleset(account)  # tat ca ruleset trong account
                        if get_ruleset_all != "" and get_ruleset_all != "Fail":
                            print "Account has rulesets"  # Account co cau hinh Ruleset khac
                            if ruleset not in get_ruleset_all:  # neu ruleset block goi ra di dong ko co trong account
                                print "Ruleset " + ruleset + " has not been added to account\n"
                                ruleset_add = get_ruleset_all + "<ruleset>" + ruleset + "</ruleset>"
                            else:  # neu ruleset block goi ra di dong co trong account
                                print "Ruleset " + ruleset + " was added to account before"
                                ruleset_add = ""
                        elif get_ruleset_all == "": # account ko co cau hinh ruleset
                            print "Account does not have ruleset"
                            ruleset_add = "<ruleset>" + ruleset + "</ruleset>"
                        else:
                            print "Daml Fail.. Try Again"
                            ruleset_add = "Fail"

                        if ruleset_add == "":
                            print "Do not add ruleset " + ruleset
                        elif ruleset_add == "Fail":
                            print "Output: Fail\n"
                            list_num_fail.append(number)
                        else:
                            if add_acc_ruleset(account, ruleset_add) == True:
                                print "Ruleset: " + ruleset_add + " has been added to account " + account + "\n"
                                f_out.write(timenow() + " Ruleset: " + ruleset_add + " has been added to account " + account + "\n")
                                #print "Output: OK\n"
                            else:
                                print "Add ruleset " + ruleset + " to account " + account + " NOK\n"
                                print "Output: Fail\n"
                                list_num_fail.append(number)
                    else: # Neu tao fail
                        list_num_fail.append(number)
                        print "Output: Fail\n"
                else:
                    list_num_fail.append(number)
                    print "Output: Fail\n"
        else: # Mo
            print "Mo huong goi " + telco
            if status_check_add == "Fail": # Neu so ko ton tai
                print "Number:", number, ' is not configured on Aareswitch'
                print "Output: Fail\n"
            else: # Neu so ton tai thi kiem tra so do dc add vao rule chua, neu chua thi add rule cua so do vao ruleset va add ruleset vao account cua so do
                if telco == "Mobifone":
                    ruleset_id_hcm = "10686"
                    ruleset_id_hni = "10666"
                elif telco == "Viettel":
                    ruleset_id_hcm = "10708"
                    ruleset_id_hni = "10685"
                elif telco == "VinaPhone": #VinaPhone
                    ruleset_id_hcm = "10710"
                    ruleset_id_hni = "10687"

                rule_id_hcm = get_rule_id_hcm(ruleset_id_hcm, number)
                rule_id_hni = get_rule_id_hni(ruleset_id_hni, number)
                rule_id = [rule_id_hcm, rule_id_hni]

                if rule_id == "":
                    print "Number: ", number, " was not blocked"
                    #print "Output: OK\n"
                else:
                    print "Rule ID:", rule_id, "\n"

                    for k in range(len(rule_id)):
                        print "Remove rule ID:", rule_id[k]
                        if rule_id[k] != []:
                            rule_id[k] = str(rule_id[k])
                            if delete_rule(rule_id[k]): # remove rule ra khoi ruleset
                                f_out.write(timenow() + " Rule block for number: " + number + " has been removed\n")
                                print "Rule block for number ", number, " has been removed\n"

                                #Remove Ruleset
                                #Kiem tra neu ruleset ko co rule cau hinh nhung so trong account thi untick ruleset
                                list_rule_name_hcm  = get_rule_name_hcm(ruleset_id_hcm)
                                list_rule_name_hni = get_rule_name_hni(ruleset_id_hni)

                                #Kiem tra account cua sdt dang cau hinh
                                account = get_account_from_address(number)
                                if account == "Fail":
                                    print "Can not find account"
                                else: # neu tim dc account name thi lay account name de query account id
                                    account_id_hcm = get_account_id_hcm_from_account_name(account)

                                    list_number_of_account = get_list_number_hcm(account_id_hcm)
                                    if len(list_rule_name_hcm) == 0: # neu ko con rule trong ruleset thi remove luon ruleset khoi account
                                        remove = "yes"
                                    else:
                                        for i in range(len(list_rule_name_hcm)):
                                            if list_rule_name_hcm[i] in list_number_of_account: # neu con rule block so sdt = sdt trong account thi ko remove ruleset
                                                remove = "no"
                                            else:
                                                remove = "yes"
                                    if remove == "yes": #remove ruleset khoi account
                                        get_ruleset = get_acc_ruleset(account)
                                        if telco == "Mobifone":
                                            ruleset_remove = "<ruleset>Block : Outgoing to Mobifone by Address</ruleset>"
                                        elif telco == "Viettel":
                                            ruleset_remove = "<ruleset>Block : Outgoing to Viettel by Address</ruleset>"
                                        elif telco == "VinaPhone":  # VinaPhone
                                            ruleset_remove = "<ruleset>Block : Outgoing to VinaPhone by Address</ruleset>"

                                        if get_ruleset != "Fail":
                                            ruleset = get_ruleset.replace(ruleset_remove, "")
                                            print "Removing ruleset " + ruleset_remove
                                            print "Ruleset after removing: ", ruleset

                                            if add_acc_ruleset(account, ruleset): # Neu remove ruleset thanh cong
                                                print "Successfully remove ruleset " + ruleset_remove + " from account"
                                                f_out.write(timenow() + " Account: " + account + " was added ruleset  " + ruleset + "\n")
                                                #print "Output: OK"
                                            else:
                                                print "Failed to remove ruleset " + ruleset_remove
                                                list_num_fail.append(number)
                                                print "Output: Fail\n"
                                    else:
                                        print "Do not remove ruleset\n"
                            else:
                                list_num_fail.append(number)
                                print "Output: Fail\n"

    print "List fail:", list_num_fail
    if len(list_num_fail) != 0:
        print "Output: Fail\n"
    else:
        print "Output: OK\n"

    print "End time:", timenow()
    f_out.write(timenow() + " # End # Khoa/Mo goi ra huong di dong: " + number_list + "," + option + "," + telco + "\n")

if __name__ == "__main__":
    main()