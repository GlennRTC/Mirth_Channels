use rd_staging;

-- Increase buffer size
SET GLOBAL innodb_buffer_pool_size=50331648;

-- Update processed status of cds data to 'Y'
update cds_data 
set processed_yn = 'Y' 
where processed_yn = 'Y' or processed_yn = 'E' or processed_yn = 'P';

-- Number of distinct recent episodes to be updated
SELECT count(distinct cds_data.EpisodeId)
    FROM cds_data
    INNER JOIN(
        SELECT  PatientId, MAX(EpisodeDateTime) AS ADate
        FROM    cds_data
        GROUP BY PatientId) AS max_cds_data
    ON max_cds_data.PatientId = cds_data.PatientId
    AND max_cds_data.ADate = cds_data.EpisodeDateTime

-- Updating most recent episodes to 'N'
update cds_data
INNER JOIN(
    SELECT distinct cds_data.EpisodeId as FinalId
    FROM cds_data
    INNER JOIN(
        SELECT  PatientId, MAX(EpisodeDateTime) AS ADate
        FROM    cds_data
        GROUP BY PatientId) AS max_cds_data
    ON max_cds_data.PatientId = cds_data.PatientId
    AND max_cds_data.ADate = cds_data.EpisodeDateTime) as final
ON final.FinalId = cds_data.EpisodeId
set cds_data.processed_yn = 'N';

-- Number of unprocessed rows
select count(*) 
from cds_data 
where processed_yn = 'N';

-- Number of unprocessed episodes
select count(distinct EpisodeId) 
from cds_data 
where processed_yn = 'N';
