EXEC dbo.STD_JOB_MANAGER_GET_P
 @UserId = 0, -- int
    @BranchId = '', -- varchar(max)
    @PriceGroupId = '', -- varchar(max)
    @CurrencyId = '', -- varchar(max)
    @ModelId = '', -- varchar(max)
    @ComponentCodeId = '', -- varchar(max)
    @ModifierCodeId = '', -- varchar(max)
    @TaskTypeId = '', -- varchar(max)
    @JobCodeId = '', -- varchar(max)
    @StatusId = '', -- varchar(max)
    @SourceId = '', -- varchar(max)
    @PartId = '', -- varchar(max)
    @ShowDummy = 0, -- smallint
    @Reference = '', -- varchar(max)
    @SearchText = '' -- varchar(100)
