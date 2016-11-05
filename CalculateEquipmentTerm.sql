SELECT E.EqpPlan + ': ' + epr.EqpProjName
	,epr.EqpprojId
	,epr.Eqp_Term_Rule_ID
	,e.StartDate
	,epr.EndUsage
	,epr.EndDate
	,e.Eqp_Terminated
	,epr.EndDate
	,e.Utilisation_Method_Id, epr.Annual_Utilisation, epr.ProjUsageProfileId
	,CASE epr.Eqp_Term_Rule_ID
			WHEN 1
				THEN dbo.GET_EQUIPMENT_END_DATE_F(epr.EqpPlanId, epr.EndQUOMId, epr.EndUsage, e.Utilisation_Method_Id, epr.Annual_Utilisation, epr.ProjUsageProfileId)
			ELSE epr.EndDate
			END AS CaculatedEndDate

	,DATEDIFF(YEAR, E.StartDate, CASE epr.Eqp_Term_Rule_ID
			WHEN 1
				THEN dbo.GET_EQUIPMENT_END_DATE_F(epr.EqpPlanId, epr.EndQUOMId, epr.EndUsage, e.Utilisation_Method_Id, epr.Annual_Utilisation, epr.ProjUsageProfileId)
			ELSE epr.EndDate
			END) AS Term
FROM tblEqpProjs epr
INNER JOIN tblEqpPlans E ON E.EqpPlanId = epr.EqpPlanId
ORDER BY Term DESC
