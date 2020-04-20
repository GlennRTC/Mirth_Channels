use rd_staging;
CREATE TABLE IF NOT EXISTS `cds_data` (
  `MESSAGE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BatchSeq` int(11) NOT NULL DEFAULT '0',
  `Processed_YN` varchar(5) DEFAULT 'N',
  `PatientID` varchar(150) DEFAULT NULL,
  `PatientFamilyName` varchar(150) DEFAULT NULL,
  `PatientGivenName` varchar(150) DEFAULT NULL,
  `PatientTitle` varchar(150) DEFAULT NULL,
  `PatientDOB` varchar(150) DEFAULT NULL,
  `PatientSex` varchar(5) DEFAULT NULL,
  `PatientStreetAddress` varchar(150) DEFAULT NULL,
  `PatientCity` varchar(150) DEFAULT NULL,
  `PatientPostalCode` varchar(150) DEFAULT NULL,
  `PatientState` varchar(150) DEFAULT NULL,
  `PatientCountry` varchar(150) DEFAULT NULL,
  `PatientStatus` varchar(150) DEFAULT NULL,
  `PatientPregnancyFlag` varchar(10) DEFAULT NULL,
  `PatientFastingFlag` varchar(10) DEFAULT NULL,
  `EpisodeID` varchar(150) DEFAULT NULL,
  `EpisodeOrderedTests` varchar(2000) DEFAULT NULL,
  `EpisodeDateTime` datetime DEFAULT NULL,
  `EpisodeClinicalNotes` text,
  `AccountType` varchar(150) DEFAULT NULL,
  `AccountClass` varchar(150) DEFAULT NULL,
  `BillTo` varchar(150) DEFAULT NULL,
  `BillingAddress` varchar(150) DEFAULT NULL,
  `PatientPublicHealthIdentifier` varchar(150) DEFAULT NULL,
  `EpisodePublicScheduleCode` varchar(1000) DEFAULT NULL,
  `PatientPrivateHealthFundName` varchar(150) DEFAULT NULL,
  `PatientPrivateHealthFundID` varchar(150) DEFAULT NULL,
  `ReqPhysicianID` varchar(150) DEFAULT NULL,
  `ReqPhysicianName` varchar(150) DEFAULT NULL,
  `ReqPhysicianSpeciality` varchar(150) DEFAULT NULL,
  `ReqPhysicianDeliveryAddress` varchar(150) DEFAULT NULL,
  `SugeryName` varchar(150) DEFAULT NULL,
  `SurgeryCode` varchar(150) DEFAULT NULL,
  `SurgeryAddress` varchar(150) DEFAULT NULL,
  `SurgeryPostalCode` varchar(150) DEFAULT NULL,
  `CopyPhysicianIDList` varchar(150) DEFAULT NULL,
  `CopyPhysicianNameList` varchar(150) DEFAULT NULL,
  `PanelIndicator` varchar(5) DEFAULT NULL,
  `PanelID` varchar(150) DEFAULT NULL,
  `PanelName` varchar(150) DEFAULT NULL,
  `SampleID` varchar(150) DEFAULT NULL,
  `SampleFluidType` varchar(150) DEFAULT NULL,
  `SampleOriginLocation` varchar(150) DEFAULT NULL,
  `SampleOriginSubLocation` varchar(150) DEFAULT NULL,
  `SampleCollectionDateTime` varchar(150) DEFAULT NULL,
  `SampleCollectionMethod` varchar(150) DEFAULT NULL,
  `TestSiteSampleReceivedDateTime` varchar(150) DEFAULT NULL,
  `TestLISCode` varchar(150) DEFAULT NULL,
  `TestLISName` varchar(150) DEFAULT NULL,
  `TestValue` varchar(2000) DEFAULT NULL,
  `TestNormalRange` varchar(150) DEFAULT NULL,
  `TestUnits` varchar(150) DEFAULT NULL,
  `TestPriority` varchar(150) DEFAULT NULL,
  `TestDepartment` varchar(150) DEFAULT NULL,
  `TestInstrument` varchar(150) DEFAULT NULL,
  `TestRequestSite` varchar(150) DEFAULT NULL,
  `TestSite` varchar(150) DEFAULT NULL,
  `TestType` varchar(150) DEFAULT NULL,
  `AbnormalFlag` varchar(5) DEFAULT NULL,
  `TestOrderedDateTime` varchar(150) DEFAULT NULL,
  `TestAnalyzerCompletionDateTime` varchar(150) DEFAULT NULL,
  `TestResultFirstReviewedDateTime` varchar(150) DEFAULT NULL,
  `TestResultReleasedDateTime` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`MESSAGE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=595 DEFAULT CHARSET=utf8;
select if (
    exists(
        select distinct index_name from information_schema.statistics 
        where table_schema = 'rd_staging' 
        and table_name = 'cds_data' and index_name = 'idxProcessedEpisodeID'
    )
    ,'select ''index idxProcessedEpisodeID exists'' _______;'
    ,'CREATE INDEX `idxProcessedEpisodeID` ON `cds_data` (`Processed_YN`, `EpisodeDateTime`, `EpisodeID`);') into @a;
PREPARE stmt1 FROM @a;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
select if (
    exists(
        select distinct index_name from information_schema.statistics 
        where table_schema = 'rd_staging' 
        and table_name = 'cds_data' and index_name = 'idxPatientID'
    )
    ,'select ''index idxPatientID exists'' _______;'
    ,'CREATE INDEX `idxPatientID` ON `cds_data` (`PatientID`);') into @a;
PREPARE stmt1 FROM @a;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;


