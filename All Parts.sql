EXEC dbo.PARTS_MANAGER_GET_P
 @UserId = 0, -- int
    @PriceGroupId = '', -- varchar(max)
    @CurrencyId = '', -- varchar(max)
    @SourceOfSupplyId = '', -- varchar(max)
    @PartTypeId = '', -- varchar(max)
    @PartDescription = '', -- varchar(max)
    @PartNumber = '', -- varchar(max)
    @MinPrice = '', -- varchar(max)
    @MaxPrice = '', -- varchar(max)
    @IsLastUpdated = NULL, -- bit
    @PriorDate = '2012-03-19 21:06:29', -- datetime
    @IsSuperSeded = 0, -- int
    @SJBranchId = '', -- varchar(max)
    @SJModelId = '', -- varchar(max)
    @SJComponentCodeId = '', -- varchar(max)
    @SJModifierCodeId = '', -- varchar(max)
    @SJTaskTypeId = '', -- varchar(max)
    @SJJobCodeId = '', -- varchar(max)
    @SJStatusId = '', -- varchar(max)
    @SJSourceId = '', -- varchar(max)
    @SJShowDummy = 0, -- smallint
    @SJReference = '', -- varchar(max)
    @SJSearchText = '', -- varchar(100)
    @SJMaxProbability = '', -- varchar(100)
    @SJMinProbability = '', -- varchar(100)
    @IsGetAnyway = NULL, -- bit
    @IsAddNewRow = NULL -- bit
