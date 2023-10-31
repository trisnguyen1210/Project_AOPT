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


def timenow():
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return time_now

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
        
def read_address(address):#tra ve account cua number, thuc thi tren AA-HCM
    xmlData = '''<daml command="read"><address><number>''' + address + '''</number></address></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_address, data=payload)
    response = result.text
    account = response[response.find("<account>") + 9:response.rfind("</account>")]

    if "status=ok" in response:
        #print "DAML read address is OK"
        if address in response:
            print "Account for " + address + " is: " + account
            return account
        else:
            print "Can not find this phone number"
            return False
    else:
        return False
    
def Get_forwardAccount(account):#tra lai list call forward cua account-thuc hien tren AA-HCM
    xmlData ='''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    global list_call_fw
    list_call_fw = []
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
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
        
def set_CallFW(account,anum,bnum,type_fw,delay,priority):#set call forward cho account
    try:
        global f_out,list_call_fw
        f_out = open("/home/administrator/aopt/logs/aopt_config_forward.log", "a+")
        print "Setting forward cho Account..." + account
        content_CallFW = '''<callForward><suspended>false</suspended>   <delay>''' + delay +'''</delay>   <propagateBusy>false</propagateBusy>   <parallelCall>false</parallelCall>   <alwaysRing>false</alwaysRing>   <earlyMedia>false</earlyMedia>   <lastDiversion>false</lastDiversion>   <reroute>false</reroute>   <destPattern>''' + anum + '''</destPattern>   <sourcePattern/>   <sourcePresentationPattern>UNDEFINED</sourcePresentationPattern>   <rejectPattern/>   <destReplace>''' + bnum + '''</destReplace>   <timePattern/>   <name>''' + anum + ' to ' +  bnum + '''</name>   <priority>''' + priority + '''</priority>   <type>''' + type_fw + '''</type> </callForward>'''
        list_call_fw.append(content_CallFW)
        print "Dang cau hinh callforward " + anum + " to " + bnum + " type " + type_fw
        #f_out.write(timenow() + "\nDang cau hinh callforward " + anum + " to " + bnum + " type " + type_fw)
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
            f_out.write(timenow() + " # Cau hinh thanh cong callforward " + anum + " to " + bnum + " type " + type_fw +"\n" )
            return True
        else:
            print "Cau hinh that bai forward cho account : " + account
            f_out.write(timenow() + " # Cau hinh that bai call forward " + anum + " to " + bnum + " type " + type_fw +"\n")
            sys.exit()
            return False            
    except requests.exceptions.RequestException as error:
        print error
        return False
    
def get_acc_ruleset(account):#ap dung so 1900/1800 site AA-HCM
    xmlData = '''<daml command="read"><account><accountName>''' + account + '''</accountName></account></daml>'''
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    result = requests.post(url_read_account, data=payload)
    response = result.text
    list_response = split_Response(response)
    HCM_response = list_response[0]
    HNI_response = list_response[1]
    #print HNI_response
    present_ruleset_HCM = HCM_response[HCM_response.find("<ruleset>"):HCM_response.rfind("</ruleset>") + 10]
    present_ruleset_HNI = HNI_response[HNI_response.find("<ruleset>"):HNI_response.rfind("</ruleset>") + 10]
    if "ok" in HCM_response and "ok" in HNI_response:
        #print "DAML get ruleset is OK"
        if len(present_ruleset_HCM) != len(present_ruleset_HNI):
            print "Ruleset khong dong bo tren he thong "
            sys.exit()
        else:
            if "ruleset" in HCM_response:  # neu muc Ruleset da co add ruleset
                #print "Present ruleset:", present_ruleset
                return present_ruleset_HCM

            else:  # neu muc Ruleset chua add ruleset nao
                print "None of rulesets have been configured"
                return ""
    else:
        print "DAML get ruleset is NOK"
        return "Fail"

def set_routingTable_hni(account,routingTable):#ap dung so 1900/1800 site AA-HNI
    global f_out
    f_out = open("/home/administrator/aopt/logs/aopt_config_forward.log", "a+")
    print "Setting routing table for account..." + account
    xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><routingTable>''' + routingTable + '''</routingTable></account></daml>'''
    #xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName><info>Test</info></account></daml>'''
    #print xmlData
    payload = {"XmlData": xmlData, "UserRequest": "aopt"}
    result = requests.post(hni_url_write_account, data=payload)
    response = result.text
    #print response
    if "ok" in response:
        f_out.write(timenow() + " # Add routing table is OK \n")
        print "Add routing table successfully"
        return True
    else:
        f_out.write(timenow() + " # Add routing table is NOK \n")
        print "Add routing table fail"
        sys.exit()
        return False

def add_acc_ruleset(account, ruleset):#uncheck "Block All Outgoing "
    print "Configuring ruleset..."
    #print ruleset
    #print account
    xmlData = '''<daml command="write"><account><accountName>''' + account + '''</accountName>''' + ruleset + '''</account></daml>'''
    #print xmlData
    payload = {"XmlData": xmlData, "UserRequest": "AOPT"}
    #print payload
    result = requests.post(url_write_account, data=payload)
    response = result.text
    #print response
    if "ok" in response:
        #print "DAML add ruleset is OK"
        return True
    else:
        print "DAML add ruleset is NOK"
        return False

def main():
    global f_out,list_call_fw
    f_out = open("/home/administrator/aopt/logs/aopt_config_forward.log", "a+")
    # Parsing argurments
    # check input from AOPT
    parser = OptionParser()

    parser.add_option("-o", "--option", dest="option", type="string", help="Enter Forward truc tiep or Forward trung gian")
    parser.add_option("-s", "--source_num", dest="source_num", type="string", help="Enter Source Phone Number")
    parser.add_option("--d1", "--dest_num", dest="dest_num", type="string", help="Enter Dest Phone Number")
    parser.add_option("--t1", "--dest_fw_type_1", dest="dest_fw_type_1", type="string", help="Enter Forward Type From Source Number To Dest Number or Intermediate Number to Dest Number (If you choose Forward trung gian)")
    parser.add_option("--time1", "--delay_1", dest="delay_1", type="string", help="Enter Delay Forward Time From Source Number To Dest Number or Intermediate Number to Dest Number (If you choose Forward trung gian and CFNR)")
    parser.add_option("--d2", "--inter_num", dest="inter_num", type="string", help="Enter Intermediate Phone Number")
    parser.add_option("--t2", "--dest_fw_type_2", dest="dest_fw_type_2", type="string", help="Enter Forward Type From Source Number to Intermediate Number (If you choose Forward trung gian)")
    parser.add_option("--time2", "--delay_2", dest="delay_2", type="string", help="Enter Delay Forward Time From Source Number to Intermediate Number")

    (options, args) = parser.parse_args()

    if (options.source_num == "" or options.dest_num == ""):
        print 'Input source num or dest num is empty'

    for op in ('source_num', 'dest_num'): # don't check address and IP BK2
        if not getattr(options, op):
            print 'Gia tri %s chua duoc nhap vao' % op
            parser.print_help()
            sys.exit()

    option = options.option
    source_num = options.source_num
    dest_num = options.dest_num
    dest_fw_type_1 = options.dest_fw_type_1
    delay_1 = options.delay_1
    inter_num = options.inter_num
    dest_fw_type_2 = options.dest_fw_type_2
    delay_2 = options.delay_2

    source_num = source_num.replace(" ", "")
    dest_num = dest_num.replace(" ", "")
    inter_num = inter_num.replace(" ", "")
    delay_1 = delay_1.replace(" ", "")
    delay_2 = delay_2.replace(" ", "")

    print "Start time:", timenow(), "\n"
    f_out.write(timenow() + " # Start # Config Forward: " + option + "," + source_num + "," + inter_num + "," + dest_num + "," + dest_fw_type_1 + "," + delay_1 + "," + dest_fw_type_2 + "," + delay_2 + "\n")

    print "Option: " + option
    print "Source Number:" + source_num
    print "Intermediate Number:" + inter_num
    print "Dest Number:" + dest_num
    print "Forward Type 1:" + dest_fw_type_1
    print "Delay 1:" + delay_1
    print "Forward Type 2:" + dest_fw_type_2
    print "Delay 2:" + delay_2

    account = read_address(source_num)
    list_call_fw = Get_forwardAccount(account)
    if account != False:
        if option == "Forward truc tiep":
            print "Forward truc tiep from " + source_num + " to " + dest_num
            if source_num[0:5] == "18006" or source_num[0:5] == "19006":#dv FPT -> co dinh FPT
                if dest_num[3:5]!="73" and dest_num[4:6]!="73" :
                    print "Khong the thuc hien vi so dest forward truc tiep khong phai so onnet"
                    f_out.write(timenow() + "Khong the thuc hien vi so dest forward truc tiep khong phai so onnet\n")
                    sys.exit()
                else:
                    get_ruleset = get_acc_ruleset(account)
                    if get_ruleset != "Fail":
                        get_ruleset = get_ruleset.replace("1900-1800 : Block All Outgoing", "<ruleset></ruleset>")
                        if add_acc_ruleset(account, get_ruleset) == True:
                            print "Successfully add ruleset to account"
                            f_out.write(timenow() + " Ruleset: " + get_ruleset + " has been added to account " + account + "\n")
                            set_routingTable_hni(account, "Route for 1800-1900 FW")
                            if dest_fw_type_1 == "CFNR" :
                                set_CallFW(account, source_num, dest_num, "CFNR", delay_1, "1")
                                print "Output: OK\n"
                                f_out.write(timenow() + "Forward truc tiep from " + source_num + " to " + dest_num + " successfully\n")
                            else:
                                set_CallFW(account, source_num, dest_num, dest_fw_type_1, "", "1")
                                f_out.write(timenow() + "Forward truc tiep from " + source_num + " to " + dest_num + " successfully\n")
                                print "Output: OK\n"
                        else:
                            print "Fail to add ruleset to account"
                            f_out.write(timenow() + "Forward truc tiep from " + source_num + " to " + dest_num + " fail\n")
                            print "Output: Fail\n"
                            
            else:#co dinh FPT -> pstn
                if source_num[3:5] == "73" or source_num[4:6] == "73":#format so co dinh FPT
                    if dest_fw_type_1 == "CFNR" :
                        set_CallFW(account, source_num, dest_num, "CFNR", delay_1, "1")
                        print "Output: OK\n"
                        f_out.write(timenow() + "Forward truc tiep from " + source_num + " to " + dest_num + " successfully\n")
                    else:
                        set_CallFW(account, source_num, dest_num, dest_fw_type_1, "", "1")
                        f_out.write(timenow() + "Forward truc tiep from " + source_num + " to " + dest_num + " successfully\n")
                        print "Output: OK\n"     
                                               
        if option == "Forward trung gian":
            if inter_num[3:5] == "73" or inter_num[4:6] == "73":#so trung gian phai la co dinh FPT
                print "Forward trung gian from " + source_num + " to " + inter_num
                account_inter = read_address(inter_num)
                if source_num[0:5] == "18006" or source_num[0:5] == "19006":#dv FPT -> co dinh FPT -> pstn          
                    get_ruleset = get_acc_ruleset(account)
                    if get_ruleset != "Fail":
                        get_ruleset = get_ruleset.replace("1900-1800 : Block All Outgoing", "<ruleset></ruleset>")
                        #print "New ruleset:" + get_ruleset
                        if add_acc_ruleset(account, get_ruleset) == True:
                            print "Successfully add ruleset to account"
                            f_out.write(timenow() + " Ruleset: " + get_ruleset + " has been added to account " + account + "\n")
                            set_routingTable_hni(account, "Route for 1800-1900 FW")
                            if dest_fw_type_2 == "CFNR" :
                                set_CallFW(account, source_num, inter_num, "CFNR", delay_2, "1")
                                if dest_fw_type_1 == "CFNR" :
                                    list_call_fw = Get_forwardAccount(account_inter)
                                    set_CallFW(account_inter, inter_num, dest_num, "CFNR", delay_1, "1")
                                    f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + " successfully\n")
                                    print "Output: OK\n"
                                else:
                                    list_call_fw = Get_forwardAccount(account_inter)
                                    set_CallFW(account_inter, inter_num, dest_num, dest_fw_type_1, "", "1")
                                    f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + " successfully\n")
                                    print "Output: OK\n"                                    
                                #f_out.write(timenow() + " Forward from: " + source_num + " to " + dest_num + " has been configured to account " + account + "\n")    
                            else:
                                set_CallFW(account, source_num, inter_num, dest_fw_type_2, "", "1")
                                if dest_fw_type_1 == "CFNR" :
                                    list_call_fw = Get_forwardAccount(account_inter)
                                    set_CallFW(account_inter, inter_num, dest_num, "CFNR", delay_1, "1")
                                    f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + " successfully\n")
                                    print "Output: OK\n"
                                else:
                                    list_call_fw = Get_forwardAccount(account_inter)
                                    set_CallFW(account_inter, inter_num, dest_num, dest_fw_type_1, "", "1")
                                    f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + " successfully\n")                                
                                    print "Output: OK\n"
                        else:
                            print "Fail to add ruleset to account"
                            print "Output: Fail\n"
                            
                else:#co dinh FPT -> co dinh FPT -> pstn
                    if dest_fw_type_2 == "CFNR" :
                        set_CallFW(account, source_num, inter_num, "CFNR", delay_2, "1")
                        if dest_fw_type_1 == "CFNR" :
                            list_call_fw = Get_forwardAccount(account_inter)
                            set_CallFW(account_inter, inter_num, dest_num, "CFNR", delay_1, "1")
                            f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + "successfully\n")
                            print "Output: OK\n"
                        else:
                            list_call_fw = Get_forwardAccount(account_inter)
                            set_CallFW(account_inter, inter_num, dest_num, dest_fw_type_1, "", "1")
                            f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + "successfully\n")
                            print "Output: OK\n"                            
                        #f_out.write(timenow() + " Forward from: " + source_num + " to " + dest_num + " has been configured to account " + account + "\n")                      
                    else:
                        set_CallFW(account, source_num, inter_num, dest_fw_type_2, "", "1")
                        if dest_fw_type_1 == "CFNR" :
                            list_call_fw = Get_forwardAccount(account_inter)
                            set_CallFW(account_inter, inter_num, dest_num, "CFNR", delay_1, "1")
                            f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + "successfully\n")
                            print "Output: OK\n"
                        else:
                            list_call_fw = Get_forwardAccount(account_inter)
                            set_CallFW(account_inter, inter_num, dest_num, dest_fw_type_1, "", "1")
                            f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + "successfully\n")                                
                            print "Output: OK\n"
            else:
                print "so trung gian khong phai so co dinh FPT "
                f_out.write(timenow() + "so trung gian khong phai so co dinh FPT !!!")
                f_out.write(timenow() + "Forward trung gian from " + source_num + " to " + dest_num + "fail\n")
                print "Output: Fail\n"
    else:
        print "This phone number does not exist"
        f_out.write(timenow() + "This phone number does not exist\n")
        print "Output: Fail\n"
        
    print "End time:", timenow()
    f_out.write(timenow() + " # End # Config Forward: " + option + "," + source_num + "," + inter_num + "," + dest_num + "," + dest_fw_type_1 + "," + delay_1 + "," + dest_fw_type_2 + "," + delay_2 + "\n")

if __name__ == "__main__":
    main()
