use rd_staging;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rdSelCDSCount`()
SQL SECURITY INVOKER
BEGIN
	declare RowCount int(1);
	select COUNT(*) into RowCount
    from rd_staging.cds_data d
	where d.Processed_YN = "N";
    
    select RowCount as StatusCode, "Records found" as Message;
END$$
DELIMITER ;