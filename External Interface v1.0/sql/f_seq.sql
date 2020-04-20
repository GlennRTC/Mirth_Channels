use rd_staging;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `seq`(seq_name char (20)) RETURNS int(11)
begin
 update seq set val=last_insert_id(val+1) where name=seq_name
 limit 1;
 return last_insert_id();
end$$
DELIMITER ;
