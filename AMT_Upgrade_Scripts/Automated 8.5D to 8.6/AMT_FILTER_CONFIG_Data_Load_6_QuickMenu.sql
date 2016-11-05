

/***************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
04 Sep 11   GD          Mod:EQSPlanning,EQSBacklog,EQSWorkorder E624 added one menu item QMA_OPEN_EXTERNAL_WORKORDER
--------	--------	----------------------------------------
**************************************************************************************************************/
DECLARE @FilterConfigName VARCHAR(100),@FilterConfigXML xml,@FilterTypeID int

SET @FilterTypeID=6	--QuickMenu

--EQSPlanning
SET @FilterConfigName = 'EQSPlanning'

SET @FilterConfigXML='<EQSPlanning>
  <Groups>
    <Edition>
      <Caption>Edit</Caption>
	  <Width>100</Width>
    </Edition>
    <EqpReport>
      <Caption>Equipment Reports</Caption>
	  <Width>130</Width>
    </EqpReport>
    <PlanReport>
      <Caption>Planning Reports</Caption>
	  <Width>130</Width>
    </PlanReport>
    <RightClick>
      <Visible>false</Visible>
    </RightClick>
  </Groups>
  <Controls>
    <!-- ### Edition ### -->
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EditEV</ControlName>
      <MenuActionType>QMA_EVENT_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EventAssign</ControlName>
      <ControlParams>
        <Properties>
          <Text>Assign to Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EventRemove</ControlName>
      <MenuActionType>QMA_WORKORDER_EVENT_REMOVE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Remove from Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep2</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Closure</ControlName>
      <MenuActionType>QMA_WIZARD_CLOSURE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Closure Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkText</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkSearch</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ERP_WorkorderOpen</ControlName>
      <MenuActionType>QMA_OPEN_EXTERNAL_WORKORDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Open External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Shutdown</ControlName>
      <MenuActionType>QMA_SHUTDOWN_MANAGE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add / Edit Shutdown</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep5</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep6</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### EqpReport ### -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PrintJF</ControlName>
      <MenuActionType>QMA_REPORT_PRINT_JOB_FOLDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Print Job Folder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ServiceReport</ControlName>
      <MenuActionType>QMA_REPORT_SERVICE_REPORT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Service Report</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PMHistory</ControlName>
      <MenuActionType>QMA_REPORT_PM_HISTORY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>PM Work History</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_BacklogListing</ControlName>
      <MenuActionType>QMA_REPORT_BACKLOG_LISTING</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Backlog Listing</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ComponentStatus</ControlName>
      <MenuActionType>QMA_REPORT_COMP_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Component Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscope</ControlName>
      <MenuActionType>QMA_REPORT_SIMPLE_WORKSCOPE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Simple Workscope</Text>
        </Properties>
      </ControlParams>
    </Menu>
     <!-- Start VS CR#11 -->
     <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscopeFeedback</ControlName>
      <MenuActionType>QMA_REPORT_WORKSCOPE_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workscope and Job feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <!-- End VS CR#11 -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_EquipmentStatistics</ControlName>
      <MenuActionType>QMA_REPORT_EQP_STATS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Equipment Statistics</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### PlanReport ### -->
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanAdv</ControlName>
      <MenuActionType>QMA_REPORT_DAILY_WEEKLY_WORKPLAN</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Daily / Weekly Work Plan</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanStand</ControlName>
      <MenuActionType>QMA_REPORT_WORKPLAN_WO_SUMMARY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workplan - Workorder Summary</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceAvailFill</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_AVAIL_FILL</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Availability and Fill</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceLabourWorkStatus</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_LABOUR_WORK_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Labour Work Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_PlannedDTEvents</ControlName>
      <MenuActionType>QMA_REPORT_PLANNED_DT_EVENT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Planned Downtime Events</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkLocAlloc</ControlName>
      <MenuActionType>QMA_REPORT_WORK_LOC_ALLOC</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Work Location Allocation</Text>
        </Properties>
      </ControlParams>
    </Menu>


    <!-- ### RightClick ### -->
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EditEV</ControlName>
      <MenuActionType>QMA_EVENT_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EventAssign</ControlName>
      <ControlParams>
        <Properties>
          <Text>Assign to Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EventRemove</ControlName>
      <MenuActionType>QMA_WORKORDER_EVENT_REMOVE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Remove from Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep2</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Closure</ControlName>
      <MenuActionType>QMA_WIZARD_CLOSURE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Closure Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkText</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkSearch</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep5</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>
  </Controls>
</EQSPlanning>'

IF @FilterConfigName <> '' AND CAST(@FilterConfigXML AS VARCHAR(MAX)) <> ''
BEGIN
	IF EXISTS (SELECT * FROM AMT_FILTER_CONFIG WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID)
		BEGIN
			UPDATE AMT_FILTER_CONFIG SET FilterConfig = @FilterConfigXML,LastModDate=GetDate() WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID
		END
	ELSE
		BEGIN
			INSERT INTO AMT_FILTER_CONFIG (FilterConfigName, FilterConfig,FilterTypeID) VALUES (@FilterConfigName, @FilterConfigXML,@FilterTypeID)
		END

END


--EQSBacklog
SET @FilterConfigName = 'EQSBacklog'

SET @FilterConfigXML='<EQSBacklog>
  <Groups>
    <Edition>
      <Caption>Edit</Caption>
	  <Width>100</Width>
    </Edition>
    <EqpReport>
      <Caption>Equipment Reports</Caption>
	  <Width>130</Width>
    </EqpReport>
    <PlanReport>
      <Caption>Backlog Reports</Caption>
	  <Width>130</Width>
    </PlanReport>
    <RightClick>
      <Visible>false</Visible>
    </RightClick>
  </Groups>
  <Controls>
    <!-- ### Edition ### -->
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkText</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkSearch</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ERP_WorkorderOpen</ControlName>
      <MenuActionType>QMA_OPEN_EXTERNAL_WORKORDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Open External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep6</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### EqpReport ### -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PrintJF</ControlName>
      <MenuActionType>QMA_REPORT_PRINT_JOB_FOLDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Print Job Folder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ServiceReport</ControlName>
      <MenuActionType>QMA_REPORT_SERVICE_REPORT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Service Report</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PMHistory</ControlName>
      <MenuActionType>QMA_REPORT_PM_HISTORY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>PM Work History</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_BacklogListing</ControlName>
      <MenuActionType>QMA_REPORT_BACKLOG_LISTING</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Backlog Listing</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ComponentStatus</ControlName>
      <MenuActionType>QMA_REPORT_COMP_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Component Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscope</ControlName>
      <MenuActionType>QMA_REPORT_SIMPLE_WORKSCOPE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Simple Workscope</Text>
        </Properties>
      </ControlParams>
    </Menu>
     <!-- Start VS CR#11 -->
     <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscopeFeedback</ControlName>
      <MenuActionType>QMA_REPORT_WORKSCOPE_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workscope and Job feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <!-- End VS CR#11 -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_EquipmentStatistics</ControlName>
      <MenuActionType>QMA_REPORT_EQP_STATS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Equipment Statistics</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### PlanReport ### -->
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanAdv</ControlName>
      <MenuActionType>QMA_REPORT_DAILY_WEEKLY_WORKPLAN</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Daily / Weekly Work Plan</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanStand</ControlName>
      <MenuActionType>QMA_REPORT_WORKPLAN_WO_SUMMARY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workplan - Workorder Summary</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceAvailFill</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_AVAIL_FILL</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Availability and Fill</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceLabourWorkStatus</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_LABOUR_WORK_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Labour Work Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_PlannedDTEvents</ControlName>
      <MenuActionType>QMA_REPORT_PLANNED_DT_EVENT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Planned Downtime Events</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkLocAlloc</ControlName>
      <MenuActionType>QMA_REPORT_WORK_LOC_ALLOC</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Work Location Allocation</Text>
        </Properties>
      </ControlParams>
    </Menu>


    <!-- ### RightClick ### -->
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkText</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkSearch</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep5</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>
  </Controls>
</EQSBacklog>'

IF @FilterConfigName <> '' AND CAST(@FilterConfigXML AS VARCHAR(MAX)) <> ''
BEGIN
	IF EXISTS (SELECT * FROM AMT_FILTER_CONFIG WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID)
		BEGIN
			UPDATE AMT_FILTER_CONFIG SET FilterConfig = @FilterConfigXML,LastModDate=GetDate() WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID
		END
	ELSE
		BEGIN
			INSERT INTO AMT_FILTER_CONFIG (FilterConfigName, FilterConfig,FilterTypeID) VALUES (@FilterConfigName, @FilterConfigXML,@FilterTypeID)
		END

END



--EQSWorkorder
SET @FilterConfigName = 'EQSWorkorder'

SET @FilterConfigXML='<EQSWorkorder>
  <Groups>
    <Edition>
      <Caption>Edit</Caption>
	  <Width>100</Width>
    </Edition>
    <EqpReport>
      <Caption>Equipment Reports</Caption>
	  <Width>130</Width>
    </EqpReport>
    <PlanReport>
      <Caption>Workorder Reports</Caption>
	  <Width>130</Width>
    </PlanReport>
    <RightClick>
      <Visible>false</Visible>
    </RightClick>
  </Groups>
  <Controls>
    <!-- ### Edition ### -->
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_EditEV</ControlName>
      <MenuActionType>QMA_EVENT_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Closure</ControlName>
      <MenuActionType>QMA_WIZARD_CLOSURE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Closure Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkText</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementLinkSearch</ControlName>
      <ParentName>ED_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ERP_WorkorderOpen</ControlName>
      <MenuActionType>QMA_OPEN_EXTERNAL_WORKORDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Open External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_Shutdown</ControlName>
      <MenuActionType>QMA_SHUTDOWN_MANAGE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add / Edit Shutdown</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep5</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>Edition</Group>
      <ControlName>ED_Sep6</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>Edition</Group>
      <ControlName>ED_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### EqpReport ### -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PrintJF</ControlName>
      <MenuActionType>QMA_REPORT_PRINT_JOB_FOLDER</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Print Job Folder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ServiceReport</ControlName>
      <MenuActionType>QMA_REPORT_SERVICE_REPORT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Service Report</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_PMHistory</ControlName>
      <MenuActionType>QMA_REPORT_PM_HISTORY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>PM Work History</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_BacklogListing</ControlName>
      <MenuActionType>QMA_REPORT_BACKLOG_LISTING</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Backlog Listing</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_ComponentStatus</ControlName>
      <MenuActionType>QMA_REPORT_COMP_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Component Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscope</ControlName>
      <MenuActionType>QMA_REPORT_SIMPLE_WORKSCOPE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Simple Workscope</Text>
        </Properties>
      </ControlParams>
    </Menu>
     <!-- Start VS CR#11 -->
     <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_SimpleWorkscopeFeedback</ControlName>
      <MenuActionType>QMA_REPORT_WORKSCOPE_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workscope and Job feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <!-- End VS CR#11 -->
    <Menu>
      <Group>EqpReport</Group>
      <ControlName>ER_EquipmentStatistics</ControlName>
      <MenuActionType>QMA_REPORT_EQP_STATS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Equipment Statistics</Text>
        </Properties>
      </ControlParams>
    </Menu>

    <!-- ### PlanReport ### -->
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanAdv</ControlName>
      <MenuActionType>QMA_REPORT_DAILY_WEEKLY_WORKPLAN</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Daily / Weekly Work Plan</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkplanStand</ControlName>
      <MenuActionType>QMA_REPORT_WORKPLAN_WO_SUMMARY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Workplan - Workorder Summary</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceAvailFill</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_AVAIL_FILL</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Availability and Fill</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_ResourceLabourWorkStatus</ControlName>
      <MenuActionType>QMA_REPORT_RESOURCE_LABOUR_WORK_STATUS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Resource Labour Work Status</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_PlannedDTEvents</ControlName>
      <MenuActionType>QMA_REPORT_PLANNED_DT_EVENT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Planned Downtime Events</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>PlanReport</Group>
      <ControlName>PR_WorkLocAlloc</ControlName>
      <MenuActionType>QMA_REPORT_WORK_LOC_ALLOC</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Work Location Allocation</Text>
        </Properties>
      </ControlParams>
    </Menu>


    <!-- ### RightClick ### -->
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_ExpressAddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD_EXPRESS</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Express Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_AddWo</ControlName>
      <MenuActionType>QMA_WORKORDER_ADD</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EditWO</ControlName>
      <MenuActionType>QMA_WORKORDER_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_EditEV</ControlName>
      <MenuActionType>QMA_EVENT_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Edit Event</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_DeleteWO</ControlName>
      <MenuActionType>QMA_WORKORDER_DELETE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Delete Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyWO</ControlName>
      <MenuActionType>QMA_WORKORDER_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep1</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Authorisation</ControlName>
      <MenuActionType>QMA_WIZARD_AUTHORISATION</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Authorisation Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Feedback</ControlName>
      <MenuActionType>QMA_FEEDBACK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Feedback</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Closure</ControlName>
      <MenuActionType>QMA_WIZARD_CLOSURE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Closure Wizard</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>ED_Sep3</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLink</ControlName>
      <ControlParams>
        <Properties>
          <Text>Link Workorder Settlement</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkText</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <ControlType>Text</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementLinkSearch</ControlName>
      <ParentName>RC_SettlementLink</ParentName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_LINK</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Search</Text>
        </Properties>
      </ControlParams>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_SettlementCreate</ControlName>
      <MenuActionType>QMA_WORKORDER_SETTLEMENT_CREATE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Create External Workorder</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep4</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Shutdown</ControlName>
      <MenuActionType>QMA_SHUTDOWN_MANAGE</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Add / Edit Shutdown</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep5</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_StrategyTask</ControlName>
      <MenuActionType>QMA_TASK_EDIT</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Strategy Task Details</Text>
        </Properties>
      </ControlParams>
    </Menu>
	<Menu>
      <Group>RightClick</Group>
      <ControlName>RC_Sep6</ControlName>
      <ControlType>Separator</ControlType>
    </Menu>
    <Menu>
      <Group>RightClick</Group>
      <ControlName>RC_CopyTable</ControlName>
      <MenuActionType>QMA_TABLE_COPY</MenuActionType>
      <ControlParams>
        <Properties>
          <Text>Copy the Table</Text>
        </Properties>
      </ControlParams>
    </Menu>
  </Controls>
</EQSWorkorder>'

IF @FilterConfigName <> '' AND CAST(@FilterConfigXML AS VARCHAR(MAX)) <> ''
BEGIN
	IF EXISTS (SELECT * FROM AMT_FILTER_CONFIG WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID)
		BEGIN
			UPDATE AMT_FILTER_CONFIG SET FilterConfig = @FilterConfigXML,LastModDate=GetDate() WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID
		END
	ELSE
		BEGIN
			INSERT INTO AMT_FILTER_CONFIG (FilterConfigName, FilterConfig,FilterTypeID) VALUES (@FilterConfigName, @FilterConfigXML,@FilterTypeID)
		END

END
