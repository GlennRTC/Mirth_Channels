use rd_staging;
CREATE INDEX `idxProcessedMessageID` ON `cds_data` (`Processed_YN`, `MESSAGE_ID`);
CREATE INDEX `idxProcessedYN` ON `cds_data` (`Processed_YN`);