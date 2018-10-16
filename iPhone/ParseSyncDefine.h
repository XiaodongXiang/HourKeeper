//
//  ParseSyncDefine.h
//  HoursKeeper
//
//  Created by humingjing on 15/4/29.
//
//

#ifndef HoursKeeper_ParseSyncDefine_h
#define HoursKeeper_ParseSyncDefine_h

#define PF_SYNCSTATUS                   @"sync_status"
#define PF_User                         @"parse_User"

//Client 表
#define PF_TABLE_CLIENT @"Clients"
//#define PF_CLIENT_ACCESSDATE            @"accessDate"
#define PF_CLIENT_ADDRESS               @"address"
#define PF_CLIENT_BEGINTIME             @"beginTime"
#define PF_CLIENT_CLIENTNAME            @"clientName"
#define PF_CLIENT_DAILYOVERFIRSTHOUR    @"dailyOverFirstHour"
#define PF_CLIENT_DAILYOVERFIRSTTAX     @"dailyOverFirstTax"
#define PF_CLIENT_DAILYOVERSECONDHOUR   @"dailyOverSecondHour"
#define PF_CLIENT_DAILYOVERSECONDTAX    @"dailyOverSecondTax"
#define PF_CLIENT_EMAIL                 @"email"
#define PF_CLIENT_ENDTIME               @"endTime"
#define PF_CLIENT_FAX                   @"fax"
#define PF_CLIENT_PAYPERIODDATE         @"payPeriodDate"
#define PF_CLIENT_PAYPERIODNUM1         @"payPeriodNum1"
#define PF_CLIENT_PAYPERIODNUM2         @"payPeriodNum2"
#define PF_CLIENT_PAYPERIODSTLY         @"payPeriodStly"
#define PF_CLIENT_PHONE                 @"phone"
#define PF_CLIENT_R_FRIRATE             @"r_friRate"
#define PF_CLIENT_R_ISDAILY             @"r_isDaily"
#define PF_CLIENT_R_MONRATE             @"r_monRate"
#define PF_CLIENT_R_SATRATE             @"r_satRate"
#define PF_CLIENT_R_SUNRATE             @"r_sunRate"
#define PF_CLIENT_R_THURATE             @"r_thuRate"
#define PF_CLIENT_R_TUERATE             @"r_tueRate"
#define PF_CLIENT_R_WEDRATE             @"r_wedRate"
#define PF_CLIENT_R_WEEKRATE            @"r_weekRate"
#define PF_CLIENT_RATEPERHOUR           @"ratePerHour"
#define PF_CLIENT_TIMEROUNDTO           @"timeRoundTo"
#define PF_CLIENT_WEBSITE               @"website"
#define PF_CLIENT_WEEKLYOVERFIRSTHOUR     @"weeklyOverFirstHour"
#define PF_CLIENT_WEEKLYOVERFIRSTTAX                  @"weeklyOverFirstTax"
#define PF_CLIENT_WEEKLYOVERSECONDHOUR  @"weeklyOverSecondHour"
#define PF_CLIENT_WEEKLYOVERSECONDTAX   @"weeklyOverSecondTax"
#define PF_CLIENT_LUNCHTIME             @"lunchTime"
#define PF_CLIENT_LUNCHSTART             @"lunchStart"

#define PF_CLIENT_ACCESSDATE            @"accessDate"
#define PF_CLIENT_UUID                  @"uuid"

/*
    Logs
 */
#define PF_TABLE_LOGS                   @"Logs"

#define PF_LOGS_ENDTIME                 @"endTime"
#define PF_LOGS_FINALMONEY              @"finalmoney"
#define PF_LOGS_ISINVOICE               @"isInvoice"
#define PF_LOGS_ISPAID                  @"isPaid"
#define PF_LOGS_NOTES                   @"notes"
#define PF_LOGS_OVERTIMEFREE            @"overtimeFree"
#define PF_LOGS_RATEPERHOUR             @"ratePerHour"
#define PF_LOGS_STARTTIME               @"starttime"
#define PF_LOGS_TOTALMONSY              @"totalmoney"
#define PF_LOGS_WORKED                  @"worked"
//外键
#define PF_LOGS_CLIENTUUID              @"client_Uuid"
#define PF_LOGS_INVOICEUUID             @"invoice_uuid"


#define PF_LOGS_UUID                    @"uuid"
#define PF_LOGS_ACCESSDATE              @"accessDate"

#define PF_LOGS_TOTALMONEY_WITHOVERTIMEPAY @"totalMoney_WithOvertimePay"

/*
    InvoiceProperty
 */
#define PF_TABLE_INVOICEPROPERTY        @"Invoiceproperty"

#define PF_PROPERTY_NAME                @"name"
#define PF_PROPERTY_PRICE               @"price"
#define PF_PROPERTY_QUANTITY            @"quantity"
#define PF_PROPERTY_TAX                 @"tax"

#define PF_PROPERTY_UUID                @"uuid"
#define PF_PROPERTY_ACCESSDATE              @"accessDate"
#define PF_PROPERTY_INVOICE          @"invoice"
/*
    Invoice
 */
#define PF_TABLE_INVOICE                @"Invoice"

#define PF_INVOICE_BALANCEDUE           @"balanceDue"
#define PF_INVOICE_DISCOUNT             @"discount"
#define PF_INVOICE_DUEDATE              @"dueDate"
#define PF_INVOICE_INVOICENO            @"invoiceNO"
#define PF_INVOICE_MESSAGE              @"message"
#define PF_INVOICE_PAIDDUE              @"paidDue"
#define PF_INVOICE_SUBTOTAL             @"subtotal"
#define PF_INVOICE_TAX                  @"tax"
#define PF_INVOICE_TERMS                @"terms"
#define PF_INVOICE_TITLE                @"title"
#define PF_INVOICE_TODATE               @"toDate"
#define PF_INVOICE_TOTALDUE             @"totalDue"

#define PF_INVOICE_UUID                 @"uuid"
#define PF_INVOICE_ACCESSDATE           @"accessDate"

//外键
#define PF_INVOICE_CLIENT               @"client"


#pragma mark Profile
/*
    Profile
 */
#define PF_TABLE_PROFILE                @"Profile"
#define PF_PROFILE_CITY                 @"city"
#define PF_PROFILE_STATE                @"state"
#define PF_PROFILE_COMPANY              @"company"
#define PF_PROFILE_EMAIL                @"email"
#define PF_PROFILE_FAX                  @"fax"
#define PF_PROFILE_FIRSTNAME            @"firstName"
#define PF_PROFILE_LASTNAME             @"lastName"
#define PF_PROFILE_PHONE                @"phone"
#define PF_PROFILE_STREET               @"street"
#define PF_PROFILE_ZIP                  @"zip"
#define PF_PROFILE_HEADIMAGE            @"headImage"

#define PF_PROFILE_UUID                 @"uuid"
#define PF_PROFILE_ACCESSDATE           @"accessDate"


#endif
