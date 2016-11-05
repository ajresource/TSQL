DELETE   FROM  dbo.DEFERRED_TASK
DELETE     FROM dbo.TASK_OPERATION_LABOUR
DELETE   FROM  dbo.TASK_OPERATION_MISC
DELETE   FROM  dbo.TASK_OPERATION_PART
DELETE   FROM  dbo.TASK_OPERATION
DELETE   FROM  dbo.TASK_DOCUMENT
DELETE   FROM  dbo.TASK
DELETE   FROM   dbo.DOWN_TIME_ALLOCATION
DELETE   FROM  dbo.EVENT
DELETE FROM AGREEMENT_PART_PRICE
DELETE  FROM  dbo.tblWorkOrderProjs
DELETE  FROM  dbo.tblRepActualCosts
DELETE  FROM  dbo.tblRepActualCosts_EqpProj
DELETE  FROM  dbo.tblRepBilling
DELETE  FROM  dbo.tblRepProjCosts
DELETE  FROM  dbo.tblRepProjCosts_EqpProj
DELETE  FROM  dbo.tblRepUsages

DELETE   FROM  dbo.tblWorkOrderSettlements
DELETE   FROM  dbo.tblWorkOrderOperations
DELETE   FROM  dbo.tblWorkOrderInvoices
DELETE   FROM  dbo.tblWorkOrders

DELETE  FROM  dbo.tblProjTaskOccs

DELETE   FROM  dbo.tblEqpPlanStartUsages
WHERE     (NOT (EqpPlanId IN
                          (SELECT     EqpPlanId
                            FROM          dbo.tblEqpPlans
                            WHERE      (EqpPlan LIKE N'%OHEAD%'))))
                            
DELETE     dbo.tblActualUsages
FROM         dbo.tblActualUsages INNER JOIN
                      dbo.tblEqpPlans ON dbo.tblActualUsages.EquipmentId = dbo.tblEqpPlans.EquipmentId
WHERE     (NOT (EqpPlanId IN
                          (SELECT     EqpPlanId
                            FROM          dbo.tblEqpPlans
                            WHERE      (EqpPlan LIKE N'%OHEAD%'))))

DELETE from COST_ALLOCATION_DETAIL
delete from COST_ALLOCATION
DELETE   FROM  dbo.tblProjTaskAmts
							
UPDATE         dbo.tblProjTasks  SET      PlanTaskOptId = null
DELETE FROM    dbo.tblProjTaskOpts
DELETE   FROM  dbo.NEXT_OCC_STRATEGY
DELETE  FROM dbo.CBM_FAILURE_MODE_ASSESSMENT
DELETE    FROM dbo.PROJ_TASK_DOCUMENT
DELETE     FROM         dbo.tblProjTasks
DELETE   FROM  dbo.tblActualBillings
DELETE  FROM    SALES_AGREEMENT
DELETE FROM   dbo.tblProjBillingAmounts
DELETE FROM dbo.tblProjBillings
   
DELETE   FROM  dbo.tblEqpProjs
WHERE     (NOT (EqpPlanId IN
                          (SELECT     EqpPlanId
                            FROM          dbo.tblEqpPlans
                            WHERE      (EqpPlan LIKE N'%OHEAD%'))))
                            
SELECT *   FROM  dbo.REP_DAILY_USAGE
DELETE   FROM  dbo.REP_EQP_PLAN_SCHED_HRS
DELETE   FROM  AGR_TYPE_EQP_PLAN
DELETE FROM         dbo.EQP_TECH_VALUE
DELETE FROM         dbo.EQP_ASSET
DELETE FROM         dbo.AR_DETAIL
DELETE  FROM dbo.PH_TRANSACTION_USAGE
DELETE  FROM   dbo.PH_REVENUE_ANALYSIS
delete FROM dbo.PH_TRANSACTION_PROJECT
DELETE FROM dbo.PH_TRANSACTION_HEADER
DELETE FROM dbo.PH_PLANT_HIRE_RATE_DETAIL
DELETE FROM dbo.PH_PROJECT_CHARGE_SIMULATOR
delete FROM dbo.PH_PLANT_HIRE_RATE
DELETE FROM         dbo.PH_EQP_PLANT_HIRE
DELETE  FROM         dbo.AR_TRANSACTION
DELETE FROM         dbo.ATTACHED_DOCUMENT_EQUIPMENT
DELETE FROM         dbo.PRODUCTION_STATISTICS_DATA
DELETE FROM CM_MEASUREMENT
--DELETE   FROM  dbo.tblEqpPlans
--WHERE     (NOT (EqpPlanId IN
--                          (SELECT     EqpPlanId
--                            FROM          dbo.tblEqpPlans
--                            WHERE      (EqpPlan LIKE N'%OHEAD%'))))
                          
--DELETE     dbo.tblEquipment
--FROM         dbo.tblEqpPlans RIGHT OUTER JOIN
--                      dbo.tblEquipment ON dbo.tblEqpPlans.EquipmentId = dbo.tblEquipment.EquipmentId
--WHERE     (dbo.tblEqpPlans.EquipmentId IS NULL)
  
DELETE   FROM  RECON_GLR_MANUAL
DELETE   FROM  RECON_GLR_DATA
DELETE   FROM  AGR_TYPE_EQP_PLAN


DELETE FROM  dbo.PROJECTED_TASK_COST_PTTU
DELETE FROM  dbo.FINANCIAL_REPORT_PARAMETER
delete from tblFleetSystemMargins
DELETE   FROM  dbo.PART_PRICE_ADJUSTMENT
DELETE   FROM  dbo.tblFleets
DELETE   FROM  dbo.tblContracts
DELETE   FROM  dbo.EMPLOYEE
DELETE   FROM  dbo.AVAILABLE_MAN_HOURS
DELETE   FROM  dbo.WORK_GROUP
DELETE   FROM  dbo.EMPLOYEE
DELETE   FROM  WORK_LOCATION
DELETE   FROM  dbo.tblSites
DELETE   FROM  dbo.tblLabourRates

DELETE FROM   dbo.WORK_SCOPE_JOB_DOCUMENT
DELETE FROM   dbo.WORK_SCOPE_JOB
DELETE FROM   dbo.WORK_SCOPE_DOCUMENT

DELETE FROM   dbo.EMI_STAGE_DOCUMENT
DELETE FROM   dbo.EM_ISSUE_MODEL
DELETE FROM   dbo.EMI_REGISTRATION
DELETE FROM   dbo.EMI_EVALUATION
DELETE FROM   dbo.EMI_TECHNICAL_ANALYSIS
DELETE FROM   dbo.EMI_IMPACT
DELETE FROM   dbo.EMI_LONG_TERM_ACTION
DELETE FROM   dbo.EMI_SHORT_TERM_ACTION

DELETE FROM   dbo.EM_ISSUE
DELETE   FROM  dbo.tblPricedJobs
DELETE   FROM  dbo.tblPartMarkups
DELETE   FROM  dbo.tblBranches
DELETE   FROM  dbo.tblUsageStepAmts
DELETE   FROM  dbo.tblUsageStepRels
DELETE   FROM  dbo.tblUsageSteps
DELETE   FROM  dbo.tblUsageProfiles
DELETE   FROM  dbo.tblProjTaskAmts
DELETE   FROM  dbo.tblProjTaskOpts
DELETE   FROM  dbo.tblProjTasks
DELETE  FROM         dbo.tblPricedJobs
DELETE  FROM        dbo.STD_JOB_OPERATION_MISC
DELETE  FROM        dbo.STD_JOB_OPERATION_LABOUR
DELETE  FROM        dbo.tblStdJobOperationParts
DELETE  FROM        dbo.tblStdJobOperations
DELETE  FROM        dbo.tblStdJobs

--DELETE FROM         dbo.FUNCTION_HIERARCHY
--WHERE     (User_ID <> 1)

DELETE FROM dbo.AMT_SESSION

--DELETE FROM         dbo.AMT_USER
--WHERE     (AMT_User_ID <> 1)

DELETE FROM         dbo.AGREEMENT_REPORT
DELETE FROM         dbo.AMT_MODULE
DELETE FROM         dbo.OVERHEAD_DETAIL_COSTS
DELETE FROM         dbo.OVERHEAD_COST_CATEGORIES
DELETE FROM         dbo.COST_CENTRE
DELETE FROM         dbo.COST_RESPONSIBILITY
DELETE FROM         dbo.EMI_DOCUMENT
DELETE FROM         dbo.EQP_CATEGORY
DELETE FROM         dbo.EQP_CRITICALITY
DELETE FROM         dbo.EQP_LOCATION
DELETE FROM         dbo.FCAST_PERIOD
DELETE FROM         dbo.JOB_LOCATION
DELETE FROM         dbo.KPI_DATA
DELETE FROM         dbo.KPI_TARGET
DELETE FROM         dbo.KPI_VALUE

DELETE FROM         dbo.PROJECTION_HEADER
WHERE     (Projection_Header_ID > 5)
DELETE FROM         dbo.SUPPLIER
DELETE FROM         dbo.REGION

DELETE FROM         dbo.tblPartPrices
DELETE FROM         dbo.tblParts
DELETE FROM         dbo.SOURCE_OF_SUPPLY

DELETE FROM         dbo.TASK_SPECIFIC_DOWNTIME

--DELETE   FROM dbo.tblCostPartsEscalations
--DELETE FROM         dbo.tblCostEscalations


--DELETE    dbo.tblModels
--FROM         dbo.tblManufacturers INNER JOIN
--                      dbo.tblModels ON dbo.tblManufacturers.ManufacturerId = dbo.tblModels.ManufacturerId
--WHERE     (dbo.tblManufacturers.Manufacturer <> 'Caterpillar')


--DELETE FROM         dbo.tblManufacturers
--WHERE     (Manufacturer <> 'Caterpillar')

--DELETE FROM dbo.tblCustomers

DELETE
FROM         dbo.tblExRateCurrencies
WHERE     (ExRateID <> 0)

DELETE
FROM         dbo.tblExRates
WHERE     (ExRateID <> 0)

UPDATE         dbo.tblFinancialPeriods
SET     FinancialPeriod = CalenderPeriod


DELETE FROM dbo.tblInvalidActualBillings
DELETE FROM dbo.tblInvalidActualUsages



DELETE     dbo.tblLabourRates
FROM         dbo.tblLabourRates INNER JOIN
                      dbo.tblLabourActivities ON dbo.tblLabourRates.LabourActivityId = dbo.tblLabourActivities.LabourActivityId
WHERE     (dbo.tblLabourActivities.LabourActivityId <> 0)

--DELETE
--FROM         dbo.tblLabourActivities
--WHERE     (LabourActivityId <> 0)


--DELETE FROM dbo.tblProjBillingAmounts
--DELETE FROM dbo.tblProjBillings

--DELETE
--FROM         dbo.tblQUOMs
--WHERE     (QUOMId <> 1)

--UPDATE         dbo.tblQUOMs
--SET     SAPQUOM = 'OH', Short_Desc = 'OH'
--WHERE     (QUOMId = 1)

--DELETE
--FROM         dbo.tblQualifiers
--WHERE     (QualifierId <> 1)

--DELETE
--FROM         dbo.tblUOMs
--WHERE     (UOMId <> 1)

DELETE FROM dbo.tblUnlinkedWO
DELETE FROM dbo.tblWorkOrderCodeTransRules
DELETE FROM dbo.TEST_TIME

--DELETE FROM dbo.WORK_APPLICATION

--DELETE FROM dbo.WORK_SCOPE_RESPONSIBILITY
--WHERE RESPONSIBILITY_ID <> 1

delete from BUDGET_COST
delete from BUDGET_HEADCOUNT
delete from BUDGET_OCC
delete from BUDGET_OVERHEAD_COST
delete from BUDGET_PERIOD_USAGE
delete from BUDGET_PH_REVENUE
delete from BUDGET_PH_PROJECT
delete from BUDGET_RVIC
delete from  BUDGET_TASK
delete from BUDGET_PERIOD
delete from BUDGET_OVERHEAD_CATEGORY
delete from BUDGET_OVERHEAD
delete from BUDGET_EQUIPMENT
delete from BUDGET_HEADER

DELETE FROM         dbo.TASK_HEADER
WHERE     (Task_Header_Id > 1)

UPDATE         dbo.TASK_HEADER
SET     Description = '0.0.0.0 NONE', Component_Code = '0', Modifier_Code = '0', Task_Type = '0', Application_Code = '0'
WHERE     (Task_Header_Id = 1)



Delete from IMPORT_ERROR
delete from IMPORT_PROJECTION
