use rd_staging;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rdUpdCDSStatus`(BatchSeq int unsigned, EpisodeID varchar(150), BatchStatus char(1))
    SQL SECURITY INVOKER
BEGIN
	declare NumRows int;
    
    start transaction;
    update rd_staging.cds_data d
		set d.Processed_YN = BatchStatus
		where d.BatchSeq = BatchSeq
        and d.EpisodeID = EpisodeID;
        set NumRows = ROW_COUNT();
    commit;
    select 0 as StatusCode, concat("Records Updated: ", convert(NumRows, char(11))) as Message;
END$$
DELIMITER ;
