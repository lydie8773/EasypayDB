/*ClientAsyncApplicationRequestTraitment*/
select ar.AR_ID AS COUNTER
  FROM epay.APP_REQUEST ar
 inner join epay.APP_REQ_STATUS ars on ars.ars_id = ar.ars_id
 where ars.ars_desc = 'TO_PROCESS'
 ORDER BY ar.AR_ID
 
select * from epay.app_request


/*
 *Retrieving two status for APP_REQUEST
 *Like:
  TO_PROCESS
  DONE
 */
select * from epay.app_req_status


/*
 *How to relaunch the related action for transaction
 *1.Find related problem transaction
  2.Find the status of these transactions
  3.Find the block action for these transactions
 */
 --1
 select * from epay.app_request ar
 inner join epay.app_req_status ars on ars.ars_id = ar.ars_id
 inner join epay.transaction t on t.transact_id = ar.transact_id
 inner join epay.transaction_status ts on ts.ts_id = t.ts_id
 inner join epay.contract_actions ca on ts.cact_id = ca.cact_id
 where ars.ars_desc = 'TO_PROCESS'




/*RelaunchAUTHENTICATIONWAITINGAction*/
SELECT 
tr.TRANSACT_ID AS COUNTER, 
pa.pmnt_att_value, 
MAX(td.TD_DATE)
FROM TRANSACTION tr
INNER JOIN TRANSACTION_DETAIL td ON tr.TRANSACT_ID = td.TRANSACT_ID
INNER JOIN TRANSACTION_STATUS trs ON trs.TS_ID = tr.TS_ID
INNER JOIN PMNT pmnt ON pmnt.pmnt_id = tr.pmnt_id
INNER JOIN PMNT_ATTRIBUTE pa ON (pa.pmnt_id = pmnt.pmnt_id and
                                 pa.cact_id = trs.cact_id)
INNER JOIN PAYMENT_METHODS pm ON pm.pm_id = pmnt.pm_id
INNER JOIN PAYMENT_METHOD_CATEGORY pmc ON pmc.pmcat_id = pm.pmcat_id
WHERE (trs.TS_DESCRIPTION = 'AUTHENTICATION_SUCCESS' OR
      trs.TS_DESCRIPTION = 'PREPARE_AUTH_SUCCESS')
AND pa.pmnt_att_key = 'DELAY_RELAUNCH'
AND pmc.pmcat_name != 'MANUAL'
GROUP BY tr.transact_id, pa.pmnt_att_value
HAVING MAX(td.TD_DATE) < (sysdate - (CAST(pa.pmnt_att_value AS NUMBER) / 86400)) AND SUM(td.td_error_requested) < 10
ORDER BY sum(td.td_error_requested);





/*RelaunchWAITINGAction*/
SELECT tr.TRANSACT_ID AS COUNTER, pa.pmnt_att_value, MAX(td.TD_DATE)
FROM TRANSACTION tr
INNER JOIN TRANSACTION_DETAIL td ON tr.TRANSACT_ID = td.TRANSACT_ID
INNER JOIN TRANSACTION_STATUS trs ON trs.TS_ID = tr.TS_ID
INNER JOIN PMNT pmnt ON pmnt.pmnt_id = tr.pmnt_id
INNER JOIN PMNT_ATTRIBUTE pa ON (pa.pmnt_id = pmnt.pmnt_id and
                                 pa.cact_id = trs.cact_id)
INNER JOIN PAYMENT_METHODS pm ON pm.pm_id = pmnt.pm_id
INNER JOIN PAYMENT_METHOD_CATEGORY pmc ON pmc.pmcat_id = pm.pmcat_id
WHERE trs.TS_DESCRIPTION IN ('AUTHORIZATION_WAITING', 'CAPTURE_WAITING','REFUND_WAITING', 'VOID_WAITING')
AND pa.pmnt_att_key = 'DELAY_RELAUNCH'
AND pmc.pmcat_name != 'MANUAL'
GROUP BY tr.transact_id, pa.pmnt_att_value
HAVING MAX(td.TD_DATE) < (sysdate - (CAST(pa.pmnt_att_value AS NUMBER) / 86400)) AND SUM(td.td_error_requested) < ?
ORDER BY sum(td.td_error_requested)





/*NotifyClientApplicationBatch*/
SELECT td.td_id AS COUNTER
select * 
FROM transaction_detail td
INNER JOIN transaction t on t.transact_id = td.transact_id
INNER JOIN app_client ac on ac.ac_id = t.ac_id
                         AND ac.ac_external_id = 'CUBECN'
INNER JOIN psp_status psps on psps.psp_stat_id = td.psp_stat_id
INNER JOIN transaction_status ts on ts.ts_id = psps.ts_id
INNER JOIN contract_actions ca on ca.cact_id = ts.cact_id
                               AND ca.cact_type = 'DoAuthentication'
WHERE td.td_notified = 0
AND td.td_error_notified < 10
ORDER BY td.td_error_notified, td.td_id











select * from epay.transaction_status ts
select * from epay.contract_actions ca
 
 
