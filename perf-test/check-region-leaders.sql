SHOW TABLE your_db.your_table REGIONS;


-- Use the regionID of the previous command for the next command
SELECT 
  p.REGION_ID, 
  p.IS_LEADER, 
  s.ADDRESS 
FROM INFORMATION_SCHEMA.TIKV_REGION_PEERS AS p
JOIN INFORMATION_SCHEMA.TIKV_STORE_STATUS AS s
  ON p.STORE_ID = s.STORE_ID
WHERE p.REGION_ID = <your_region_id>;



-- to check the PD leader in the cluster use in PD pod:
pd-ctl -u "http://127.0.0.1:2379" member leader show
