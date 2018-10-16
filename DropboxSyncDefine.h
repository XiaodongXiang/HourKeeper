//
//  DropboxSyncDefine.h
//  HoursKeeper
//
//  Created by xy_dev on 10/12/13.
//
//

#ifndef HoursKeeper_DropboxSyncDefine_h
#define HoursKeeper_DropboxSyncDefine_h


//dropbox nil data
#define DROPBOX_NIL_DATA                         @"*db%nil%data%unable%use*"




//dropbox Table name
#define DB_LOG_TABLE                             @"db_log_table"
#define DB_INVOICE_TABLE                         @"db_invoice_table"
#define DB_CLIENT_TABLE                          @"db_client_table"
#define DB_INVOICEPERTY_TABLE                    @"db_invoiceperty_table"                     //1



//local Table name
#define LC_LOG_TABLE                             @"Logs"
#define LC_INVOICE_TABLE                         @"Invoice"
#define LC_CLIENT_TABLE                          @"Clients"
#define LC_INVOICEPTY_TABLE                      @"Invoiceproperty"



//Log table filed key
//log
#define LOG_FINALMONEY                           @"log_finalmoney"          //breakTime
#define LOG_STARTTIME                            @"log_starttime"
#define LOG_ENDTIME                              @"log_endtime"
#define LOG_RATEPERHOUR                          @"log_ratePerHour"
#define LOG_TOTALMONEY                           @"log_totalmoney"
#define LOG_WORKED                               @"log_worked"
#define LOG_NOTES                                @"log_notes"
#define LOG_ISINVOICE                            @"log_isInvoice"
#define LOG_ISPAID                               @"log_isPaid"
#define LOG_UUID                                 @"log_uuid"
#define LOG_INVOICEUUID                          @"log_invoiceUuid"
#define LOG_CLIENTUUID                           @"log_clientUuid"
#define LOG_ACCESSDATE                           @"log_accessDate"
#define LOG_SYNCSTATUS                           @"log_syncStatus"
#define LOG_OVERTIMEFREE                         @"log_overtimefree"                          //1



//Invoice table filed key
//invoice
#define INV_TITLE                                @"inv_title"
#define INV_INVOICENO                            @"inv_invoiceNO"
#define INV_SUBTOTAL                             @"inv_subtotal"
#define INV_DISCOUNT                             @"inv_discount"
#define INV_TAX                                  @"inv_tax"
#define INV_TOTALDUE                             @"inv_totalDue"
#define INV_PAIDDUE                              @"inv_paidDue"
#define INV_BALANCEDUE                           @"inv_balanceDue"
#define INV_DUEDATE                              @"inv_dueDate"
#define INV_TERMS                                @"inv_terms"
#define INV_MESSAGE                              @"inv_message"
#define INV_UUID                                 @"inv_uuid"
#define INV_PARENTUUID                           @"inv_parentUuid"
#define INV_ACCESSDATE                           @"inv_accessDate"
#define INV_SYNCSTATUS                           @"inv_syncStatus"



//Client table filed key
#define CLT_BEGINTIME                            @"clt_beginTime"
#define CLT_ENDTIME                              @"clt_endTime"
#define CLT_CLIENTNAME                           @"clt_clientName"
#define CLT_RATEPERHOUR                          @"clt_ratePerHour"
#define CLT_TIMEROUNDTO                          @"clt_timeRoundTo"
#define CLT_DAILYFIRTAX                          @"clt_dailyFirTax"
#define CLT_DAILYFIRHR                           @"clt_dailyFirHr"
#define CLT_DAILYSECTAX                          @"clt_dailySecTax"
#define CLT_DAILYSECHR                           @"clt_dailySecHr"
#define CLT_EMAIL                                @"clt_email"
#define CLT_PHONE                                @"clt_phone"
#define CLT_FAX                                  @"clt_fax"
#define CLT_WEBSITE                              @"clt_website"
#define CLT_ADDRESS                              @"clt_address"
#define CLT_PAYSTLY                              @"clt_payStly"
#define CLT_PAYNUM1                              @"clt_payNum1"
#define CLT_PAYNUM2                              @"clt_payNum2"
#define CLT_PAYDATE                              @"clt_payDate"
#define CLT_UUID                                 @"clt_uuid"
#define CLT_ACCESSDATE                           @"clt_accessDate"
#define CLT_SYNCSTATUS                           @"clt_syncStatus"
#define CLT_ISDAILY                              @"clt_isDaily"                               //1
#define CLT_MONRATE                              @"clt_monrate"                               //1
#define CLT_TUERATE                              @"clt_tuerate"                               //1
#define CLT_WEDRATE                              @"clt_wedrate"                               //1
#define CLT_THURATE                              @"clt_thurate"                               //1
#define CLT_FRIRATE                              @"clt_frirate"                               //1
#define CLT_SATRATE                              @"clt_satrate"                               //1
#define CLT_SUNRATE                              @"clt_sunrate"                               //1
#define CLT_WEEKLYFIRTAX                         @"clt_weeklyFirTax"
#define CLT_WEEKLYFIRHR                          @"clt_weeklyFirHr"
#define CLT_WEEKLYSECTAX                         @"clt_weeklySecTax"
#define CLT_WEEKLYSECHR                          @"clt_weeklySecHr"
#define CLT_WEEKRATE                             @"clt_weekrate"                               //1



//Invoiceproperty table filed key                                                             //1
#define INVPTY_QUANTITY                         @"invpty_quantity"
#define INVPTY_NAME                             @"invpty_name"
#define INVPTY_PRICE                            @"invpty_price"
#define INVPTY_TAX                              @"invpty_tax"
#define INVPTY_ACCESSDATE                       @"invpty_accessdate"
#define INVPTY_SYNCSTATUS                       @"invpty_syncstatus"
#define INVPTY_UUID                             @"invpty_uuid"
#define INVPTY_PARENTUUID                       @"invpty_parentUuid"




#endif


