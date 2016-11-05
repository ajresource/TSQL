DECLARE @MaxOccurrencePerYear INT = 0

--E1335  
--SELECT @MaxOccurrencePerYear = Varchar_Value
--FROM AMT_TYPED_VARIABLE
--WHERE Value_Name = 'MaxOccurrencePerYear'

--SELECT @MaxOccurrencePerYear

SET @MaxOccurrencePerYear = 400

--KN 8749 - Optimisatation
CREATE TABLE #EQPPROJ_ENDUSAGE (
	EqpProjId INT NOT NULL
	,QUOMId FLOAT NULL
	,Usage FLOAT NULL
	)

CREATE INDEX #EQPPROJ_ENDUSAGE_ind ON #EQPPROJ_ENDUSAGE (
	EqpProjId
	,QUOMId
	)

INSERT #EQPPROJ_ENDUSAGE
SELECT A.EqpProjId
	,A.UsageQUOMId
	,dbo.GET_USAGE_FROM_DATE_F(A.EqpProjId, A.UsageQUOMId, A.EndDate)
FROM (
	SELECT DISTINCT BE.EqpProjId
		,BE.EndDate
		,BT.UsageQUOMId
	FROM tblProjTasks BT
	INNER JOIN tblEqpProjs BE ON BT.EqpProjId = BE.EqpProjId
	) A

SELECT prtsk.EqpProjId
	,prtsk.ProjTaskId
	,prtsk.Task_header_Id
	,CASE 
		WHEN DATEDIFF(d, eqppl.StartDate, eqppr.EndDate) > 0
			THEN (EU.Usage - ISNULL(eqpplSU.StartUsage, 0)) / prtsk.Frequency / DATEDIFF(d, eqppl.StartDate, eqppr.EndDate) * 365.25
		ELSE 0
		END AS Occs
		,DATEDIFF(d, eqppl.StartDate, eqppr.EndDate)/ 365.25 AS Term
INTO #ProjTaskWithMoreOccs
FROM tblProjTasks prtsk
INNER JOIN tblEqpProjs eqppr ON eqppr.EqpProjId = prtsk.EqpProjId
INNER JOIN tblEqpPlans eqppl ON eqppl.EqpPlanId = eqppr.EqpPlanId
LEFT JOIN #EQPPROJ_ENDUSAGE EU ON EU.EqpProjId = prtsk.EqpProjId
	AND ISNULL(EU.QUOMId, 0) = ISNULL(prtsk.USageQUOMID, 0)
LEFT JOIN tblEqpPlanStartUsages eqpplSU ON eqpplSU.EqpPlanId = eqppl.EqpPlanId
	AND ISNULL(eqpplSU.StartUsageQUOMId, 0) = ISNULL(prtsk.UsageQUOMId, 0)
WHERE prtsk.Frequency > 0
	AND CASE 
		WHEN DATEDIFF(d, eqppl.StartDate, eqppr.EndDate) > 0
			THEN (EU.Usage - ISNULL(eqpplSU.StartUsage, 0)) / prtsk.Frequency / DATEDIFF(d, eqppl.StartDate, eqppr.EndDate) * 365.25
		ELSE 0
		END > @MaxOccurrencePerYear

DROP TABLE #EQPPROJ_ENDUSAGE

SELECT EH.Branch
	,EH.Site
	,EH.Fleet
	,EH.EqpPlan
	,EH.Projection_Type_Name
	,TH.Description
	,PT.Occs AS CalculatedOccPerYear
	,REALOCC.Occ AS TotalNoOfOccsInProjOccTable
	,PT.Term AS EquipmentTermInYears
	,PT.ProjTaskId
	,PT.EqpProjId

FROM #ProjTaskWithMoreOccs PT
INNER JOIN EQUIPMENT_HIERARCHY_V EH ON EH.EqpProjId = PT.EqpProjId
INNER JOIN TASK_HEADER TH ON TH.Task_Header_Id = PT.Task_Header_Id
LEFT JOIN (
SELECT ProjTaskId, COUNT(*)  AS Occ 
 	 FROM tblProjTaskOccs
	GROUP BY ProjTaskId
	) REALOCC ON REALOCC.ProjTaskId = PT.ProjTaskId
ORDER BY PT.Occs DESC

DROP TABLE #ProjTaskWithMoreOccs
	-- SELECT ProjTaskId, COUNT(*)  AS Occ 
	-- INTO #ProjTaskWithMoreOccs
	-- FROM tblProjTaskOccs
	--GROUP BY ProjTaskId
	--ORDER BY Occ DESC
