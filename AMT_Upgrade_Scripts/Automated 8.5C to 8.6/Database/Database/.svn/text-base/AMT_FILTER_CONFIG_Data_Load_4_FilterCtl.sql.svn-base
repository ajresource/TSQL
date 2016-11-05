
 
/***************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	---------------------------------------- 
17 Apr 12   TW			#3043 TaskGrid_TaskAuthorisation
03 Apr 12	KN			#3829 EditStrategyTaskEditorEqp
****end of history**********************************************************************************************************/

DECLARE @FilterConfigName VARCHAR(100),@FilterConfigXML xml,@FilterTypeID int

SET @FilterTypeID=4	--FilterCtl 
SET @FilterConfigName = 'EditStrategyTaskEditorEqp'

SET @FilterConfigXML='<EditStrategyTaskEditorEqp>
  <InitialParams>UserID</InitialParams>
  <StoredProcedure>EDITABLE_PROJ_MANAGER_GET_P</StoredProcedure>
  <SpParams>
    <UserID>|InitialParams.UserID|</UserID>
    <ProjHeaderId>|Projection.SelectedItemsNoAp|</ProjHeaderId>
    <EquipmentId>|Equipment.SelectedItemsNoAp|</EquipmentId>
  </SpParams>
  <Groups>
    <Filters>
      <Caption>Equipment Filters</Caption>
      <SubGroups>3</SubGroups>
    </Filters>
  </Groups>
  <Controls>
    <!-- ### Filters ### -->
    <!-- = Sub Group 1 = -->
    <SearchCtlWinNet>
      <Group>Filters</Group>
      <SubGroup>1</SubGroup>
      <ControlName>User</ControlName>
      <ControlParams>
        <Properties>
          <DataType>EqpSel_User</DataType>
          <SelectedItems>|InitialParams.UserID|</SelectedItems>
        </Properties>
      </ControlParams>
    </SearchCtlWinNet> 
	<SearchCtlWinNet>
		<Group>Filters</Group>
		<SubGroup>1</SubGroup>
		<ControlName>Projection</ControlName>
		<Required>true</Required>
		<ControlParams>
			<Properties>
			    <DataType>PROJ_HEADER</DataType>
				<Caption>Projection *</Caption>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
      <Group>Filters</Group>
      <SubGroup>2</SubGroup>
      <ControlName>AdditionalFields</ControlName>
      <ControlParams>
		<Items>
			<Item>1,Parts %</Item>
			<Item>2,Labour %</Item>
			<Item>3,Misc %</Item>
			<Item>4,New Parts %</Item>
			<Item>5,Sales Responsibility</Item>
		</Items>
        <Properties>
          <MultiSelector>true</MultiSelector>
          <Caption>Display Fields</Caption>
        </Properties>
      </ControlParams>
    </SearchCtlWinNet>
     <Label>
      <Group>Filters</Group>
      <SubGroup>3</SubGroup>
      <ControlName>lbl</ControlName>
      <ControlParams>
        <Properties>
          <Width>500</Width>
          <TextAlign>MiddleLeft</TextAlign>
          <Text />
          <Font.Style>Regular</Font.Style>
          <Tag>Dont Display</Tag>
        </Properties>
      </ControlParams>
    </Label>
    <SearchCtlWinNet>
      <Group>Filters</Group>
      <SubGroup>3</SubGroup>
      <ControlName>Equipment</ControlName>
      <Required>true</Required>
      <ControlParams>
        <Properties>
          <DataType>EqpSel_Equipment</DataType>
          <Visible>false</Visible>
        </Properties>
      </ControlParams>
    </SearchCtlWinNet>
  </Controls>
</EditStrategyTaskEditorEqp>	'

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


 
 
 

SET @FilterConfigName = 'TaskGrid_TaskAuthorisation'

SET @FilterConfigXML = '<TaskGrid_TaskAuthorisation>
  <InitialParams>UserID</InitialParams>
  <StoredProcedure>TASK_GRID_GET_P</StoredProcedure>
  <SpParams>
	<TaskGridType>3</TaskGridType>

	<StartDate>|dSelector.DateTimeValue1|</StartDate>
	<EndDate>|dSelector.DateTimeValue2|</EndDate>

	<BranchID>|Branch.SelectedItemsNoAp|</BranchID>
	<SiteID>|Site.SelectedItemsNoAp|</SiteID>
	<FleetID>|Fleet.SelectedItemsNoAp|</FleetID>
	<ModelID>|Model.SelectedItemsNoAp|</ModelID>
	<EqpPlanID>|Equipment.SelectedItemsNoAp|</EqpPlanID>
	<ParentEqpPlanID>|ParentEquipment.SelectedItemsNoAp|</ParentEqpPlanID>

	<SystemID>|System.SelectedItemsNoAp|</SystemID>
	<SubSystemID>|SubSystem.SelectedItemsNoAp|</SubSystemID>
	<ComponentCodeID>|CompCode.SelectedItemsNoAp|</ComponentCodeID>
	<TaskTypeID>|TaskType.SelectedItemsNoAp|</TaskTypeID>
	<SourceID>|Source.SelectedItemsNoAp|</SourceID>
	<RaisedByID>|RaisedBy.SelectedItemsNoAp|</RaisedByID>
	<PriorityID>|Priority.SelectedItemsNoAp|</PriorityID>
	<TaskStatusID>|TaskStatus.SelectedItemsNoAp|</TaskStatusID>
	<WorkgroupID>|WorkGroup.SelectedItemsNoAp|</WorkgroupID>
	<EmployeeResponsibleID>|Employee.SelectedItemsNoAp|</EmployeeResponsibleID>

	<StrategyTask>|rbcStrategy.Value|</StrategyTask>
	<Authorised>|rbcAuthorised.Value|</Authorised>
	<PlanningStatus>|JobReadyStatus.SelectedItemsNoAp|</PlanningStatus>
	<BacklogAge>|BacklogAge.SelectedItem|</BacklogAge>
	<Closed>2</Closed>
	
	<AuthorisationRequested>|rbcAuthorisationRequested.Value|</AuthorisationRequested>
	<WorkorderNumber>|ltbWorkorderNumber.TextBox.Text|</WorkorderNumber>
	<MinAuthorisedAmount>|lblMinAuthorisedAmount.TextBox.Text|</MinAuthorisedAmount>
	<MinActualAmount>|lblMinActualAmount.TextBox.Text|</MinActualAmount>
	<MinVarianceAmount>|lblMinVarianceAmount.TextBox.Text|</MinVarianceAmount>
	<DisplayFields_WOAuth>|DisplayFields_WOAuth.SelectedItemsNoAp|</DisplayFields_WOAuth>
  </SpParams>
  <Groups>
    <gbDateSelector>
      <Caption>Date Selector</Caption>
    </gbDateSelector>
    <EqpFilters>
      <Caption>Equipment Hierarchy</Caption>
      <SubGroups>3</SubGroups>
    </EqpFilters>
    <AdditionalFilters>
      <Caption>Additional Filters</Caption>
      <SubGroups>3</SubGroups>
    </AdditionalFilters>
  </Groups>
  <Controls>
    <!-- ### DateSelector ### -->
	<DateSelector>
		<Group>gbDateSelector</Group>
		<ControlName>dSelector</ControlName>
		<ControlParams>
			<Properties>
				<Type>Last3Months</Type>
			</Properties>
		</ControlParams>
	</DateSelector>

    <!-- ### EqpFilters ### -->
    <!-- = Sub Group 1 = -->
	<SearchCtlWinNet>
	  <Group>EqpFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>User</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>EqpSel_User</DataType>
		  <SelectedItems>|InitialParams.UserID|</SelectedItems>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>EqpFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>EqpType</ControlName>
	  <Required>true</Required>
	  <ControlParams>
		<Properties>
		  <DataType>EqpSel_EqpType</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>1</SubGroup>
		<ControlName>Branch</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Branch</DataType>
				<MultiSelector>false</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>1</SubGroup>
		<ControlName>Site</ControlName>
  	    <Required>true</Required>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Site</DataType>
				<MultiSelector>false</MultiSelector>
				<Caption>Site *</Caption>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>

    <!-- = Sub Group 2 = -->
	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>2</SubGroup>
		<ControlName>Fleet</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Fleet</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>2</SubGroup>
		<ControlName>Model</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Model</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>

    <!-- = Sub Group 3 = -->
	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>3</SubGroup>
		<ControlName>Equipment</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Equipment</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
		<Group>EqpFilters</Group>
		<SubGroup>3</SubGroup>
		<ControlName>ParentEquipment</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_Siblings_ParentEqp</DataType>
				<MultiSelector>false</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>



    <!-- ### AdditionalFilters ### -->
    <!-- = Sub Group 1 = -->
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>System</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>System</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>SubSystem</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>SubSystem</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>CompCode</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>CompCode</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>TaskType</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>TaskType</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>TaskStatus</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>TaskStatusWithExclude</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>1</SubGroup>
	  <ControlName>JobReadyStatus</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>JobReadyStatus</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	
    <!-- = Sub Group 2 = -->
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
		<ControlName>Source</ControlName>
		<ControlParams>
			<Properties>
				<DataType>Source</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
		<ControlName>RaisedBy</ControlName>
		<ControlParams>
			<Properties>
				<DataType>EqpSel_RaisedBy</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
		<ControlName>Priority</ControlName>
		<ControlParams>
			<Properties>
				<DataType>Priority</DataType>
				<MultiSelector>true</MultiSelector>
			</Properties>
		</ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>WorkGroup</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>EqpSel_WorkGroup</DataType>
		  <MultiSelector>true</MultiSelector>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Employee</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>EqpSel_Employee</DataType>
		  <MultiSelector>true</MultiSelector>
		  <Caption>Employee Resp.</Caption>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
      <Group>AdditionalFilters</Group>
      <SubGroup>2</SubGroup>
      <ControlName>DisplayFields_WOAuth</ControlName>
      <ControlParams>
        <Properties>
          <DataType>DisplayFields_WOAuth</DataType>
          <MultiSelector>true</MultiSelector>
        </Properties>
      </ControlParams>
    </SearchCtlWinNet>

    <!-- = Sub Group 3 = -->
	<DropdownListControl>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>3</SubGroup>
		<ControlName>BacklogAge</ControlName>
		<ControlParams>
			<Items>
				<Item>0,All Workorders</Item>
				<Item>30,Backlogs greater than 30 days</Item>
				<Item>60,Backlogs greater than 60 days</Item>
			</Items>
			<Properties>
				<Group.Text>Backlog Age</Group.Text>
			</Properties>
		</ControlParams>
	</DropdownListControl>
	<RadioButtonCollection>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>3</SubGroup>
		<ControlName>rbcStrategy</ControlName>
		<ControlParams>
			<Properties>
				<Group.Text>Strategy</Group.Text>
				<RadioButton1.Text>All</RadioButton1.Text>
				<RadioButton2.Text>Yes</RadioButton2.Text>
				<RadioButton3.Text>No</RadioButton3.Text>
				<RadioButtonValue1>2</RadioButtonValue1>
				<RadioButtonValue2>1</RadioButtonValue2>
				<RadioButtonValue3>0</RadioButtonValue3>
				<RadioButton3.Checked>true</RadioButton3.Checked>
				<NumberOfRadioButtons>3</NumberOfRadioButtons>
			</Properties>
		</ControlParams>
	</RadioButtonCollection>
	<RadioButtonCollection>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>3</SubGroup>
		<ControlName>rbcAuthorisationRequested</ControlName>
		<ControlParams>
			<Properties>
				<Group.Text>Requested</Group.Text>
				<RadioButton1.Text>All</RadioButton1.Text>
				<RadioButton2.Text>Yes</RadioButton2.Text>
				<RadioButton3.Text>No</RadioButton3.Text>
				<RadioButtonValue1>2</RadioButtonValue1>
				<RadioButtonValue2>1</RadioButtonValue2>
				<RadioButtonValue3>0</RadioButtonValue3>
				<RadioButton1.Checked>true</RadioButton1.Checked>
				<NumberOfRadioButtons>3</NumberOfRadioButtons>
			</Properties>
		</ControlParams>
	</RadioButtonCollection>
	<RadioButtonCollection>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>3</SubGroup>
		<ControlName>rbcAuthorised</ControlName>
		<ControlParams>
			<Properties>
				<Group.Text>Authorised</Group.Text>
				<RadioButton1.Text>All</RadioButton1.Text>
				<RadioButton2.Text>Yes</RadioButton2.Text>
				<RadioButton3.Text>No</RadioButton3.Text>
				<RadioButtonValue1>2</RadioButtonValue1>
				<RadioButtonValue2>1</RadioButtonValue2>
				<RadioButtonValue3>0</RadioButtonValue3>
				<RadioButton3.Checked>true</RadioButton3.Checked>
				<NumberOfRadioButtons>3</NumberOfRadioButtons>
			</Properties>
		</ControlParams>
	</RadioButtonCollection>
	<LabeledTextBox>    
		<Group>AdditionalFilters</Group>
		<SubGroup>3</SubGroup>
		<ControlName>ltbWorkorderNumber</ControlName>
		<ControlParams>
		  <Properties>
			<Label.Text>WO Number</Label.Text>
			<TextBox.Font.Style>Regular</TextBox.Font.Style>
		  </Properties>
		</ControlParams>
	  </LabeledTextBox>    

	
    <!-- = Constants = -->
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_System_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_System_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_System_StrategyTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_System_StrategyTask</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_System_EMIssue</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_System_EMIssue</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_SubSystem_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_SubSystem_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_SubSystem_StrategyTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_SubSystem_StrategyTask</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_SubSystem_EMIssue</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_SubSystem_EMIssue</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_CompCode_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_CompCode_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_CompCode_EMIssue</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_CompCode_EMIssue</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_TaskType_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_TaskType_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_Source_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_Source_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_Priority_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_Priority_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_Priority_EMIssue</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_Priority_EMIssue</DataType>
		  <SelectedItems>0</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

    <SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
      <ControlName>Constants_TaskStatusWithExclude_Exclude</ControlName>
      <ControlParams>
        <Properties>
          <DataType>Constants_TaskStatusWithExclude_Exclude</DataType>
		  <MultiSelector>true</MultiSelector>
          <SelectedItems>4,5</SelectedItems>
          <Visible>false</Visible>
        </Properties>
      </ControlParams>
    </SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_WorkGroup_EQS</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_WorkGroup_EQS</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>

	<SearchCtlWinNet>
	  <Group>AdditionalFilters</Group>
	  <SubGroup>2</SubGroup>
	  <ControlName>Constants_Employee_EQSTask</ControlName>
	  <ControlParams>
		<Properties>
		  <DataType>Constants_Employee_EQSTask</DataType>
		  <SelectedItems>1</SelectedItems>
		  <Visible>false</Visible>
		</Properties>
	  </ControlParams>
	</SearchCtlWinNet>
	
	<LabeledTextBox>
      <Group>AdditionalFilters</Group>
      <SubGroup>3</SubGroup>
      <ControlName>lblMinAuthorisedAmount</ControlName>
      <ControlParams>
        <Properties>
          <Label.Text>Authorisation Amt >= </Label.Text>
		  <TextBox.Font.Style>Regular</TextBox.Font.Style>
		  <TextBox.TextAlign>Right</TextBox.TextAlign>
          <TextBox.Text>0</TextBox.Text>
          <NumbersOnly>true</NumbersOnly>
        </Properties>
      </ControlParams>
    </LabeledTextBox>
    
    <LabeledTextBox>
      <Group>AdditionalFilters</Group>
      <SubGroup>3</SubGroup>
      <ControlName>lblMinActualAmount</ControlName>
      <ControlParams>
        <Properties>
          <Label.Text>Actual Amt >= </Label.Text>
		  <TextBox.Font.Style>Regular</TextBox.Font.Style>
          <TextBox.Text>0</TextBox.Text>
          <TextBox.TextAlign>Right</TextBox.TextAlign>
          <NumbersOnly>true</NumbersOnly>
        </Properties>
      </ControlParams>
    </LabeledTextBox>
    
    <LabeledTextBox>
      <Group>AdditionalFilters</Group>
      <SubGroup>3</SubGroup>
      <ControlName>lblMinVarianceAmount</ControlName>
      <ControlParams>
        <Properties>
          <Label.Text>Variance Amt >= </Label.Text>
		  <TextBox.Font.Style>Regular</TextBox.Font.Style>
		  <TextBox.TextAlign>Right</TextBox.TextAlign>
          <TextBox.Text>0</TextBox.Text>
          <NumbersOnly>true</NumbersOnly>
        </Properties>
      </ControlParams>
    </LabeledTextBox>
    

    

  </Controls>
</TaskGrid_TaskAuthorisation>'

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

GO
