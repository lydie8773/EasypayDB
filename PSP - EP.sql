select * from pmnt_attribute pa

/*
 *payment_method_category records the category for every payment.
 *like:
  PRIMARY
  MANUAL
  COMPLEMENTARY
 */
select * from payment_method_category pmcat

/*PMNT records all the means of payments
 *like
 *WECHAT_ONLINE - SCAN_PAY
  WECHAT_ONLINE - DIRECT_PAY
  ALIPAY_QRCODE
  MANUAL - CHECK
  FIRST_DATA - ECHECK
  FIRST_DATA - GIFTCARD
 */
select * from pmnt p

select *
from pmnt p
inner join payment_service_provider psp on p.psp_id = psp.psp_id


/*To check this transaction use which means of payment*/
select * 
from transaction t 
inner join pmnt p on t.pmnt_id = p.pmnt_id
where t.transact_id = '66387'


select *
from payment_client pc 
inner join payment_method_client pmc on pmc.pmc_id = pc.pmc_id
inner join pmnt p on p.pmnt_id = pc.pmnt_id
inner join transaction t on t.pmnt_id = p.pmnt_id

inner join app_client ac on t.ac_id = ac.ac_id and ac.ac_id = pmc.ac_id

where t.transact_id = '66387';








select * from payment_methods pm

select * from payment_service_provider psp

select * from payment_client pc

select * from payment_method_category_client pmcc

select * from payment_method_category pmcat

select * from app_client
