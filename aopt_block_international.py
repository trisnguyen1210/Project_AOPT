#!/usr/bin/python
# -*- coding: UTF-8 -*
#Code by HieuND16

import requests
import json
import sys
import time
import random
import datetime
import string
from optparse import OptionParser
import re

def split_response(response):
    pattern_response = r"{(.*)}.{(.*)}"

    response_hcm = ""
    response_hni = ""

    response_hcm = re.search(pattern_response, response).group(1)
    response_hni = re.search(pattern_response, response).group(2)

    return response_hcm, response_hni

def get_account(number):
    #headers = {'content-type': 'application/json'}
    #try:
    xmlData = '''<daml command="read"><address><number>'''+number+'''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post('http://localhost:8888/daml/address/read_test', data = payload)
    response = result.text
    #print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]


    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML read account is OK"
        if number in response_hcm:
            get_account = response_hcm[response_hcm.find("<account>") + 9:response_hcm.rfind("</account>")]
            return get_account
        elif number in response_hni:
            get_account = response_hni[response_hni.find("<account>") + 9:response_hni.rfind("</account>")]
            return get_account
        else:
            return ""    
    else:        
        print "DAML read account is NOK"
        return ""
    #except requests.exceptions.RequestException as error:
    #    print error
    #    return 0

def get_acc_ruleset(account):
    #headers = {'content-type': 'application/json'}
    #try:
    xmlData = '''<daml command="read"><account><accountName>'''+account+'''</accountName></account></daml>'''    
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post('http://localhost:8888/daml/account/read_test', data = payload)
    response = result.text
    #print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]

    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML get account ruleset is OK"
        if account in response_hcm and account in response_hni:
            if "ruleset" in response_hcm:
                get_ruleset = response_hcm[response_hcm.find("<ruleset>") + 9:response_hcm.rfind("</ruleset>")]
                return get_ruleset
            else:
                return ""
    else:
        print "DAML get account ruleset is NOK"
        return "Fail"
    #except requests.exceptions.RequestException as error:
    #    print error
    #    return 0

def add_acc_ruleset(account,ruleset):
    #headers = {'content-type': 'application/json'}
    #try:
    xmlData = '''<daml command="write"><account><accountName>'''+account+'''</accountName>'''+ruleset+'''</account></daml>'''   
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post('http://localhost:8888/daml/account/write_test', data = payload)
    response = result.text
    #print response
    response_hcm = split_response(response)[0]
    response_hni = split_response(response)[1]
    if "status=ok" in response_hcm and "status=ok" in response_hni:
        print "DAML add account ruleset is OK"
        return True
    else:
        print "DAML add account ruleset is NOK"
        return False
    #except requests.exceptions.RequestException as error:
    #    print error
    #    return 0

def main():    
    f_out = open("/home/administrator/aopt/logs/aopt_block_international.log", "a+")
    #Parsing argurments
    parser = OptionParser()

    parser.add_option("-n", "--number", dest="number", type="string", help="Input number for Block International Call")
    
    (options, args) = parser.parse_args()
    
    if (options.number == "None"):
            print 'Input Number Error'
    if not getattr(options, "number"):
        print 'Gia tri number chua duoc nhap vao'
        parser.print_help()
        sys.exit()

    number = options.number

    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    print "1. Find account:"
    account = get_account(number)
    #print account
    
    if account != "":
        print "Number:",number,"of Account:",account,"\n"
        print "2. Block International for Number " + number + ":"
        get_ruleset = get_acc_ruleset(account)
        if get_ruleset != "Fail":
            if get_ruleset != "":     
                if "Block : International Call - High Cost" in get_ruleset:       
                    ruleset = "<ruleset>" + get_ruleset + "</ruleset><ruleset>Block : All Outgoing International Calls</ruleset>"
                    #ruleset = "<ruleset>" + get_ruleset + "</ruleset><ruleset>Block : All Outgoing International Calls New</ruleset>"
                else:
                    ruleset = "<ruleset>" + get_ruleset + "</ruleset><ruleset>Block : All Outgoing International Calls</ruleset><ruleset>Block : International Call - High Cost</ruleset>"
                    #ruleset = "<ruleset>" + get_ruleset + "</ruleset><ruleset>Block : All Outgoing International Calls New</ruleset><ruleset>Block : International Call - High Cost</ruleset>"
            else:
                ruleset = "<ruleset>Block : All Outgoing International Calls</ruleset><ruleset>Block : International Call - High Cost</ruleset>"
                #ruleset = "<ruleset>Block : All Outgoing International Calls New</ruleset><ruleset>Block : International Call - High Cost</ruleset>"
        else:
            ruleset = "Fail"
        if ruleset != "Fail":
            status = add_acc_ruleset(account,ruleset)
            if status:
                print "--> Block International OK\n"                
                print "Output: OK"
                f_out.write(time_now + " Number: " + number + " of Account: " + account + " is blocked international call\n")
            else:
                print "--> Block International Fail"
                print "Output: Fail"
        else:
            print "--> Get nothing ruleset of account"
            print "Output: Fail"
    else:
        print "--> So dien thoai",number,"khong ton tai tren he thong !"
        print "Output: Fail"
    
    
    
if __name__ == "__main__":
    main()
