update epay.transaction_detail td
set td.td_notified = 1
where td.td_id in (select td_id 
                  FROM epay.transaction_detail td
                  INNER JOIN epay.transaction t on t.transact_id = td.transact_id
                  INNER JOIN epay.app_client ac on ac.ac_id = t.ac_id
                                             AND ac.ac_external_id = 'CUBECN'
                  INNER JOIN epay.psp_status psps on psps.psp_stat_id = td.psp_stat_id
                  INNER JOIN epay.transaction_status ts on ts.ts_id = psps.ts_id
                  INNER JOIN epay.contract_actions ca on ca.cact_id = ts.cact_id
                                             AND ca.cact_type = 'DoCapture'
                  WHERE td.td_notified = 0
                  and td.td_error_log is not null
                  and td_error_notified < 10);
				  

commit;
           