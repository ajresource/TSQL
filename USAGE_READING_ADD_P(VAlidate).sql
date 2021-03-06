USE [isipl_amt_Ferreyros_87]
GO
/****** Object:  StoredProcedure [dbo].[USAGE_READING_ADD_P]    Script Date: 2/05/2014 3:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[USAGE_READING_ADD_P]
/******************************************************************************
	Name: USAGE_READING_ADD_P

	Called By: Usage interface application

	Desc: Calls the old SP usp_Add_Actual_Usage
			(which performs lots of 'business logic'
			when usage readings are imported)


	Auth: Darryl Smith
	Date: 24-Jul-2003
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	22-Apr-04	DS		Added to Sourcesafe scripts for inclusion in AMT 7
	10-Aug-04	DS		Changed to assume that Serial Number is actually
						Modular Mining Eqp Name (also changed spec)
	19 Sep 2005	SI		Changed to support Ellipse interface
	27 Oct 06	KN		If there are more than one Equipment matches with the Serial Number and Model, 
							then the Overhead cost will be assigned to the Equipment which has greater End Date
	10 Jan 07	KN		Fixed the Equipment Selection.
	13 Feb 07	ID		Modified the offset retrieving query to return the 
							offset from the most recent Actual Usage Recording date 
	05 Jun 07	SI		Changed to accept several records at once, added the rules to update usages
	21-Jul-07	KN		Fixed - Collation and tempDB Conflicts
	22 May 09	VV		CR8016 - AMT to AMT interface. Increased UOM to 50 char, EquipmentNo to 20
							changed @UsageReadingsXML from xml to text
	14 Jul 09	DS		CR8312 - usages more than 7 days before the most recent reading were not being
							imported
	10 Nov 09	VV		CR8436 It takes offset from the last reading entered but it does not check UOM
	21 Jan 10	KN		CR8715: Update QUOM Id if AMTVARIABLE.UsageImportModularName = 1
	12 Feb 2010	AL		CR8777: implemented ACTUAL_USAGE_REVALIDATE_P
	01 Mar 10	AL		CR8777: full revamp
	03 Mar 10	AL		CR8823: do not delete start usages
	12 Mar 10	AL		CR8835: fixed join
	02 Sep 10	KN		#390: DO not allow null on offset.
	24 Mar 11	GD		changed the size of EquipmentNo from 20 to 50
	15 Dec 11	RJ		#3126: Allow nulls for non-mandatory fields
*******************************************************************************/
	/* Param List */
	@UsageReadingsXML text
AS
--------------------------------------------
SET NOCOUNT ON


--### 1; load temp table
DECLARE @idoc int
EXEC sp_xml_preparedocument @idoc OUTPUT, @UsageReadingsXML

CREATE TABLE #I_USAGE_READING(
	SerialNo VARCHAR(50) COLLATE database_default NOT NULL CHECK(LTRIM(RTRIM(SerialNo)) <> ''),
	CumulativeUsage FLOAT NOT NULL,
	UsageReadingDate DATETIME NOT NULL,
	UOM VARCHAR(50) COLLATE database_default NOT NULL,
	Model VARCHAR(20) COLLATE database_default NULL,
	--RJ: 3126 
	EquipmentNo VARCHAR(50) COLLATE database_default NULL DEFAULT (''),
	System_Source VARCHAR(10) COLLATE database_default NULL,
	EquipmentId INT NULL,
	QUOMId INT NULL,
	--AL: 26/02/10
	Offset float NULL,
	LastRecordingDate datetime NULL,
	EqpPlanID int NULL,
	ExceedsProjectedUsage bit NULL
)	

if exists (select * from sys.tables where name='I_USAGE_READING_MM')
BEGIN
drop table I_USAGE_READING_MM
END

CREATE TABLE I_USAGE_READING_MM(
	SerialNo VARCHAR(255) ,
	CumulativeUsage FLOAT,
	UsageReadingDate DATETIME ,
	UOM VARCHAR(50) ,
	Model VARCHAR(20),
	--RJ: 3126 
	EquipmentNo VARCHAR(50),
	System_Source VARCHAR(10),
	EquipmentId INT NULL,
	QUOMId INT NULL,
	--AL: 26/02/10
	Offset float NULL,
	LastRecordingDate datetime NULL,
	EqpPlanID int NULL,
	ExceedsProjectedUsage bit NULL
)	

--INSERT #I_USAGE_READING(SerialNo, CumulativeUsage, UsageReadingDate, UOM, Model, EquipmentNo, System_Source)
INSERT I_USAGE_READING_MM(SerialNo, CumulativeUsage, UsageReadingDate, UOM, Model, EquipmentNo, System_Source)
SELECT 
	LTRIM(RTRIM(SerialNo)),
	CumulativeUsage,
	UsageReadingDate,
	LTRIM(RTRIM(UOM)),
	LTRIM(RTRIM(Model)),
	LTRIM(RTRIM(EquipmentNo)),
	LTRIM(RTRIM(System_Source)) 
FROM OPENXML (@idoc, '/I_USAGE_READINGs/I_USAGE_READING',2) WITH I_USAGE_READING_MM iur

EXEC sp_xml_removedocument @idoc

RETURN

--### 2: Map Eqp and QUOM 
--look up parameters needed to call usp_Add_ActualUsage
DECLARE @UsageImportModularName bit
SELECT TOP 1 @UsageImportModularName=UsageImportModularName FROM AMT_VARIABLE

IF @UsageImportModularName=1
	--DS 2004-Aug-10: look up as if the serialNumber field is the Modular Mining Eqp Name
	UPDATE	iur
	SET		EquipmentId = epl.EquipmentId,
			QUOMId = quom.QUOMId,
			EqpPlanID=epl.EqpPlanID
	FROM	tblEqpPlans epl
			RIGHT JOIN #I_USAGE_READING iur ON iur.SerialNo = epl.Modular_Mining_Eqp_Name
			LEFT JOIN tblQUOMs quom ON quom.Short_Desc = iur.UOM
ELSE
	UPDATE	iur
	SET		EquipmentId = eqp.EquipmentId,
			QUOMId = quom.QUOMId,
			EqpPlanID=ep.EqpPlanID
	FROM	tblEquipment eqp
		LEFT JOIN tblModels mod ON mod.ModelId=eqp.ModelId
		LEFT JOIN AMT_VARIABLE vr ON vr.amt_var_id=1
		LEFT JOIN tblEqpPlans EP ON EP.EquipmentId = eqp.EquipmentId
		LEFT JOIN tblEqpProjs EPROJ ON EPROJ.EqpPlanId = EP.EqpPlanId AND Projection_Type_ID = 1
		INNER JOIN 
		(-- if serial number and model matches more than one equipment , then select the equipment which has greater End Date
			SELECT	MAX(dbo.tblEqpProjs.EndDate) AS EndDate, dbo.tblEquipment.SerialNumber, dbo.tblEquipment.ModelId
			FROM	tblEquipment 
					INNER JOIN dbo.tblEqpPlans ON dbo.tblEquipment.EquipmentId = dbo.tblEqpPlans.EquipmentId 
					INNER JOIN dbo.tblEqpProjs ON dbo.tblEqpPlans.EqpPlanId = dbo.tblEqpProjs.EqpPlanId
			WHERE	tblEqpProjs.Projection_Type_ID = 1
			GROUP BY tblEquipment.SerialNumber, tblEquipment.ModelId
		) EqpMaxEndDate ON EqpMaxEndDate.SerialNumber = eqp.SerialNumber 
					AND EqpMaxEndDate.ModelId = eqp.ModelId 
					AND EPROJ.EndDate = EqpMaxEndDate.EndDate
		RIGHT JOIN #I_USAGE_READING iur ON ( (eqp.SerialNumber = iur.SerialNo AND ISNULL(vr.ModelSerialSeparator,'')='')
						OR (ISNULL(vr.ModelSerialSeparator,'')<>'' AND ISNULL(iur.Model,'')+vr.ModelSerialSeparator+iur.SerialNo=eqp.SerialNumber) )
						AND (mod.Model=iur.Model OR ISNULL(iur.Model,'')='' )
		LEFT JOIN tblQUOMs quom ON quom.Short_Desc = iur.UOM


--### 3: Remove usages that cannot be overwritten
DECLARE @DaysUsageToOverwrite INT
SELECT TOP 1 @DaysUsageToOverwrite = DaysUsageToOverwrite FROM AMT_VARIABLE

DELETE	iur
FROM	#I_USAGE_READING iur
		INNER JOIN tblEqpPlans epl ON epl.EquipmentId = iur.EquipmentId
		INNER JOIN tblEqpPlanStartUsages su ON su.EqpPlanId = epl.EqpPlanId AND su.StartUsageQUOMId = iur.QUOMId
		INNER JOIN (SELECT	iur.EquipmentId, iur.QUOMId, MAX(iur.UsageReadingDate) AS MaxUsageReadingDate
					FROM	#I_USAGE_READING iur
					GROUP BY iur.EquipmentId, iur.QUOMId
		) iurm ON iurm.EquipmentId = iur.EquipmentId AND iurm.QUOMId = iur.QUOMId
		INNER JOIN (SELECT	EquipmentId, QUOMId, MAX(RecordingDate) AS MaxRecordingDate
					FROM	tblActualUsages au
					GROUP BY au.EquipmentId, au.QUOMId
		) aum ON aum.EquipmentId = iur.EquipmentId AND aum.QUOMId = iur.QUOMId
WHERE	iur.CumulativeUsage < su.StartUsage
		OR iur.UsageReadingDate <= epl.StartDate
--		OR DATEDIFF(day, iurm.MaxUsageReadingDate, aum.MaxRecordingDate) > 7
		-- Can only overwrite back to date: (Last Usage Date - Days_Usage_to_Overwrite).
		OR iur.UsageReadingDate <= DATEADD(day, -@DaysUsageToOverwrite, aum.MaxRecordingDate)

DELETE	au
FROM	tblActualUsages au
		INNER JOIN (SELECT	iur.EquipmentId, iur.QUOMId, MIN(iur.UsageReadingDate) AS MinUsageReadingDate
					FROM	#I_USAGE_READING iur
					GROUP BY iur.EquipmentId, iur.QUOMId
		) iurm ON iurm.EquipmentId = au.EquipmentId AND iurm.QUOMId = au.QUOMId
WHERE	au.RecordingDate >= iurm.MinUsageReadingDate
		AND isnull(AU.StartUsageEqpPlanId, 0) = 0	--AL: 03/03/10

--### 4: Get offset for each eqp and quom
-- KN #390 - Offset cannot be NULL
UPDATE iur
SET Offset=ISNULL(A.Offset,0),
	LastRecordingDate=A.RecordingDate
FROM
	#I_USAGE_READING iur CROSS APPLY
	(SELECT TOP 1 Offset,RecordingDate
	FROM tblActualUsages
	WHERE EquipmentId = iur.EquipmentID AND QUOMId=iur.QUOMId
	ORDER BY RecordingDate DESC)A
	

--SELECT * FROM #I_USAGE_READING
	

--### 5: Add all these records to the invalid table after some cleanup
--delete records happening within the same minute
DELETE FROM iau
FROM
	tblInvalidActualUsages iau INNER JOIN
	#I_USAGE_READING iur ON 
			iau.EquipmentID=iur.EquipmentID
			AND iau.QUOMId=iur.QUOMId
			AND (iau.RecordingDate >= iur.UsageReadingDate)  			--AL: 19/06/08
			AND (iau.RecordingDate < DATEADD(minute, 1, iur.UsageReadingDate))	--AL: 19/06/08

DELETE FROM au
FROM
	tblActualUsages au INNER JOIN
	#I_USAGE_READING iur ON 
			au.EquipmentID=iur.EquipmentID
			AND au.QUOMId=iur.QUOMId
			AND (au.RecordingDate >= iur.UsageReadingDate)  			--AL: 19/06/08
			AND (au.RecordingDate < DATEADD(minute, 1, iur.UsageReadingDate))	--AL: 19/06/08

INSERT INTO tblInvalidActualUsages (EquipmentId, QUOMId, RecordingDate, Offset, 
		RecordedUsage, ActualUsage, CreatedInAMT, ExceedsProjectedUsage,
		StartUsageEqpPlanId, SerialNumber, UsageType, 
        LastModByUserId, LastModDate, CreatedByUserId, CreateDate,
		Model, EquipmentNo, System_Source)
SELECT	EquipmentId, QUOMId, UsageReadingDate, ISNULL(Offset,0), 
		CumulativeUsage-ISNULL(Offset,0), CumulativeUsage, 0,
		0 AS ExceedsProjectedUsage,	--this will be recalculated in the revalidation
		0, SerialNo, UOM, 
		0, getdate(), 0, getdate(), 
		Model,EquipmentNo, System_Source
FROM
		#I_USAGE_READING
	


--### 6: Revalidate these records to transfer to valid table
DECLARE @ActionXML varchar(MAX)
SET @ActionXML='<rows>'+(SELECT EquipmentId,QUOMId,MIN(LastRecordingDate) AS RecordingDate
						FROM #I_USAGE_READING WHERE ISNULL(EquipmentId,0)>0 GROUP BY EquipmentId,QUOMId FOR XML RAW)+'</rows>'

--print @ActionXML

EXEC ACTUAL_USAGE_REVALIDATE_P @ActionXML=@ActionXML


DROP TABLE #I_USAGE_READING

SET NOCOUNT OFF


