--This script describes CUBE how to send one request to EP

/*
 * This table would record all the attributes of form
 */
select * from epay.contract_attributes ca

select * from pmnt p

select * from pmnt_attribute pa
inner join contract_actions ca on pa.cact_id = ca.cact_id

/*
 * This script records the payment method of EP,and which action is called.
 * Like: ALIPAY\DIRECTPAY\DoCapture
 * 3 main actions: 1)DoAuthentication. 2)DoAuthorization. 3)DoCaputre
 */
select * from ep_contract ec
--where ec.contract_id = '950'
order by ec.contract_name

select * from ep_contract ec
inner join contract_actions ca on ec.cact_id = ca.cact_id
--where ec.contract_id = '973'


/*
 * This script records all the actions with the description for action.
 * Like:
 * SYNC	ALIPAY\DIRECTPAY\AUTHENTICATION	Url used by alipay to display the payment success
   SYNC	ALIPAY\DIRECTPAY\AUTHENTICATION	transaction id
   SYNC	ALIPAY\DIRECTPAY\AUTHENTICATION	description of the subject
 */
--select * 
select ec.contract_mode, ec.contract_name, ca.conatt_description
from ep_contract ec
inner join contract_attributes ca on ec.contract_id = ca.contract_id
order by ec.contract_name

/*
 * app_request records all the transactions when CUBE send first request to EP
 */
select * from app_request ar
inner join ep_contract ec on ar.contract_id = ec.contract_id
inner join contract_actions ca on ec.cact_id = ca.cact_id
--where ar.order_id = 'cn13486650'
order by ar.ar_date desc


select * from app_req_param arp

select * from app_req_status ars


/*
 * CONTRACT_ACTIONS records all the actions.
 * Like "DoAuthentication"
 */
select * from contract_actions ca



/*
 * Retrieving all the order numbers which PSP is 'CAPTURE_SUCCESS'
 */
select t.order_id
from transaction t 
inner join transaction_detail td on t.transact_id = td.transact_id
inner join pmnt p on t.pmnt_id = p.pmnt_id
inner join psp_status ps on ps.psp_stat_id= td .psp_stat_id
inner join transaction_status ts on ts.ts_id = ps.ts_id
where to_char(td.td_date,'yyyymmdd') >= 20160526
and to_char(td.td_date,'yyyymmdd') <= 20160531
and ts.ts_description = 'CAPTURE_SUCCESS'
order by td.td_date




/*
 * Retrieving all the payment status for PSP side & EP side
 * Like:
 * MAX_RETRY_ERROR	1	17	AUTHORIZATION_ERROR
   DEFAULT_EP_ERROR	1	17	AUTHORIZATION_ERROR
   DEFAULT_EP_NO_ACTION		89	AUTHORIZATION_NO_ACTION
 */
select * from psp_status ps
inner join transaction_status ts on ts.ts_id = ps.ts_id
order by ts.ts_description


/*
 * Retrieving the order_id
 */
select * from epay.transaction t
where t.order_id = 'cn8317909'


/*
 *Retrieving all the channel type:
 *WECHAT
  KIOSK
  DEFAULT
  WEB
  MOBILE
  SHOP_IN_STORE
  TILL
 */
select * from epay.channel_type ct


/*
 *Retrieving all the PSP
 *Like:
  WECHAT_ONLINE
  MANUAL
  FIRST_DATA
  ALIPAY
  UNIONPAY
  ALIPAY_OFFLINE
  WECHAT_OFFLINE
 */
select * from epay.payment_service_provider


/*
 *Retrieving all the attributes for PSP
 */
--select * 
select psp.psp_name,p.pmnt_name,pa.pmnt_att_value,pm.pm_name,pmc.pmcat_name,ca.cact_type
--,ac.ac_external_id
from epay.payment_service_provider psp
inner join epay.pmnt p on p.psp_id = psp.psp_id
inner join epay.pmnt_attribute pa on pa.pmnt_id = p.pmnt_id
inner join epay.payment_methods pm on p.pm_id = pm.pm_id
inner join epay.payment_method_category pmc on pmc.pmcat_id = pm.pmcat_id
inner join epay.payment_method_category_client pmcc on pmcc.pmcat_id = pmc.pmcat_id
inner join epay.contract_actions ca on ca.cact_id = pa.cact_id
--inner join epay.app_client ac on ac.ac_id = pmcc.ac_id
where psp.psp_name LIKE 'UNIONPAY'
order by ca.cact_type




/*
 *For every transaction log, retrieving all the status for every action
 */
select * 
from epay.transaction t
inner join epay.transaction_detail td on t.transact_id = td.transact_id
inner join epay.transaction_logs tl on tl.td_id = td.td_id
inner join epay.transaction_status ts on ts.ts_id = t.ts_id
inner join epay.contract_actions ca on ca.cact_id = ts.cact_id


/*
 *Retrieving the status of transaction.
 */
select * 
from epay.transaction t
inner join epay.transaction_detail td on td.transact_id = t.transact_id
inner join epay. transaction_logs tl on tl.td_id = td.td_id
inner join epay.transaction_status ts on ts.ts_id = t.ts_id 
where t.transact_id = '64352'




select *
from epay.transaction_logs tl
inner join epay.transaction_detail td on td.td_id = tl.td_id
inner join epay.transaction t on t.transact_id = td.transact_id
inner join epay.app_client ac on ac.ac_id = t.ac_id
inner join epay.payment_method_category_client pmcc on pmcc.ac_id = ac.ac_id
inner join epay.payment_method_category pmc on pmc.pmcat_id = pmcc.pmcat_id
inner join epay.payment_methods pm on pm.pmcat_id = pmc.pmcat_id
inner join epay.pmnt p on p.pm_id = pm.pm_id
inner join epay.payment_debit_type pdt on pdt.pmnt_id = p.pmnt_id
inner join epay.debit_type dt on dt.dt_id = pdt.dt_id
where tl.tlog_id = 294
order by tl.tlog_id




select tl.tlog_id,tl.tlog_key,tl.tlog_value,td.td_notified,t.order_id,t.transact_id,ct.ct_type,dt_description
from epay.transaction_logs tl
inner join epay.transaction_detail td on td.td_id = tl.td_id
inner join epay.transaction t on t.transact_id = td.transact_id
inner join epay.channel_type ct on ct.ct_id = t.ct_id
inner join epay.payment_client_channel_type pcct on pcct.ct_id = ct.ct_id
inner join epay.payment_client_attributes pca on pca.pcct_id = pcct.pcct_id
inner join epay.payment_client_debit_type pcdt on pcdt.pcct_id = pcdt.pcct_id
inner join epay.payment_debit_type pdt on pdt.pdt_id = pcdt.pdt_id
inner join epay.debit_type dt on dt.dt_id = pdt.dt_id
where t.transact_id = '119996'







select * from transaction_status
select * from transaction_log
select * from epay.transaction_detail
select * from epay.payment_service_provider
select * from epay.pmnt_attribute
select * from epay.payment_client
select * from epay.payment_methods
select * from epay.payment_method_category
select * from epay.payment_method_category_client
select * from epay.payment_method_client
select * from epay.payment_client_channel_type
select * from epay.payment_client_debit_type
select * from epay.app_client
select * from epay.channel_type
select * from epay.logs_type
select * from epay.app_request
select * from epay.app_req_param
select * from epay.app_req_status
where tl.lt_id = 1
select * from epay.debit_type
select * from epay.contract_actions

select * from epay.transaction_logs tl
where tl.TLOG_TYPE = 'WEB_SERVICE'

select * from epay.transaction t
inner join epay.app_client ac on ac.ac_id = t.ac_id
