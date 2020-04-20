use rd_staging;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rdSelCDSData`()
SQL SECURITY INVOKER
BEGIN
	## First get the Patient ID of the patient with the earlist non-processed row
	declare PatID varchar(150);
	declare BatchSeq int(11);
	declare NumRows int;
    declare LimitRows int;
    
	## Trying to make best use of indexes here, we get the earliest episode date and time
    ## and the lowest patient id with that episode date and time
	select min(d1.patientid) into PatID
	from cds_data d1
	where d1.EpisodeDateTime = (select min(d.EpisodeDateTime)
								from cds_data d
								where d.Processed_YN = "N")
	and d1.Processed_YN = "N";
    
    set NumRows = FOUND_ROWS();

    if PatID IS NOT NULL then
		select seq("cds") into BatchSeq;

		## second, get all of the episodes for that patient, we will process all episodes
		
        drop table if exists tmpData;
        
		CREATE TEMPORARY TABLE IF NOT EXISTS tmpData AS (

		SELECT d.MESSAGE_ID,
			d.BatchSeq,
			d.Processed_YN,
			d.PatientID,
			d.PatientFamilyName,
			d.PatientGivenName,
			d.PatientTitle,
			d.PatientDOB,
			d.PatientSex,
			d.PatientStreetAddress,
			d.PatientCity,
			d.PatientPostalCode,
			d.PatientState,
			d.PatientCountry,
			d.PatientStatus,
			d.PatientPregnancyFlag,
			d.PatientFastingFlag,
			d.EpisodeID,
			d.EpisodeOrderedTests,
			d.EpisodeDateTime,
			d.EpisodeClinicalNotes,
			d.AccountType,
			d.AccountClass,
			d.BillTo,
			d.BillingAddress,
			d.PatientPublicHealthIdentifier,
			d.EpisodePublicScheduleCode,
			d.PatientPrivateHealthFundName,
			d.PatientPrivateHealthFundID,
			d.ReqPhysicianID,
			d.ReqPhysicianName,
			d.ReqPhysicianSpeciality,
			d.ReqPhysicianDeliveryAddress,
			d.SugeryName,
			d.SurgeryCode,
			d.SurgeryAddress,
			d.SurgeryPostalCode,
			d.CopyPhysicianIDList,
			d.CopyPhysicianNameList,
			d.PanelIndicator,
			d.PanelID,
			d.PanelName,
			d.SampleID,
			d.SampleFluidType,
			d.SampleOriginLocation,
			d.SampleOriginSubLocation,
			d.SampleCollectionDateTime,
			d.SampleCollectionMethod,
			d.TestSiteSampleReceivedDateTime,
			d.TestLISCode,
			d.TestLISName,
			d.TestValue,
			d.TestNormalRange,
			d.TestUnits,
			d.TestPriority,
			d.TestDepartment,
			d.TestInstrument,
			d.TestRequestSite,
			d.TestSite,
			d.TestType,
			d.AbnormalFlag,
			d.TestOrderedDateTime,
			d.TestAnalyzerCompletionDateTime,
			d.TestResultFirstReviewedDateTime,
			d.TestResultReleasedDateTime
		FROM rd_staging.cds_data d
		where d.PatientID = PatID
		order by d.PatientID, d.EpisodeDateTime
		);
		
        set NumRows = FOUND_ROWS();
        
        ## We set a limit to suppress warnings about updates wihtout a constraint set, by setting the limit to
        ## the found rows + 1 from the previous query it also allows us to perform a quality check to make sure that
        ## the number of updated rows matches what we thought it should be
        set LimitRows = NumRows + 1;
        
		start transaction;

		update rd_staging.cds_data d
		inner join tmpData t
		set d.Processed_YN = "Y",
			d.BatchSeq = BatchSeq
		where d.MESSAGE_ID = t.MESSAGE_ID
			and d.Processed_YN = "N";
		
        commit;

		select
			d.MESSAGE_ID,
			BatchSeq,
			d.Processed_YN,
			d.PatientID,
			d.PatientFamilyName,
			d.PatientGivenName,
			d.PatientTitle,
			d.PatientDOB,
			d.PatientSex,
			d.PatientStreetAddress,
			d.PatientCity,
			d.PatientPostalCode,
			d.PatientState,
			d.PatientCountry,
			d.PatientStatus,
			d.PatientPregnancyFlag,
			d.PatientFastingFlag,
			d.EpisodeID,
			d.EpisodeOrderedTests,
			d.EpisodeDateTime,
			d.EpisodeClinicalNotes,
			d.AccountType,
			d.AccountClass,
			d.BillTo,
			d.BillingAddress,
			d.PatientPublicHealthIdentifier,
			d.EpisodePublicScheduleCode,
			d.PatientPrivateHealthFundName,
			d.PatientPrivateHealthFundID,
			d.ReqPhysicianID,
			d.ReqPhysicianName,
			d.ReqPhysicianSpeciality,
			d.ReqPhysicianDeliveryAddress,
			d.SugeryName,
			d.SurgeryCode,
			d.SurgeryAddress,
			d.SurgeryPostalCode,
			d.CopyPhysicianIDList,
			d.CopyPhysicianNameList,
			d.PanelIndicator,
			d.PanelID,
			d.PanelName,
			d.SampleID,
			d.SampleFluidType,
			d.SampleOriginLocation,
			d.SampleOriginSubLocation,
			d.SampleCollectionDateTime,
			d.SampleCollectionMethod,
			d.TestSiteSampleReceivedDateTime,
			d.TestLISCode,
			d.TestLISName,
			d.TestValue,
			d.TestNormalRange,
			d.TestUnits,
			d.TestPriority,
			d.TestDepartment,
			d.TestInstrument,
			d.TestRequestSite,
			d.TestSite,
			d.TestType,
			d.AbnormalFlag,
			d.TestOrderedDateTime,
			d.TestAnalyzerCompletionDateTime,
			d.TestResultFirstReviewedDateTime,
			d.TestResultReleasedDateTime
		FROM tmpData d
		order by d.PatientID, d.EpisodeDateTime, d.EpisodeID;        
	else
		select 0 as StatusCode, "No records found" as Message;
    end if;
END$$
DELIMITER ;
