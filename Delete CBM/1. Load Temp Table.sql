USE [isipl_AMT_Smaldeel]
GO

/****** Object:  Table [dbo].[zzAJ_CBMDel]    Script Date: 11/28/2012 17:23:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zzAJ_CBMDel]') AND type in (N'U'))
DROP TABLE [dbo].[zzAJ_CBMDel]
GO

USE [isipl_AMT_Smaldeel]
GO

/****** Object:  Table [dbo].[zzAJ_CBMDel]    Script Date: 11/28/2012 17:23:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[zzAJ_CBMDel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Element_Code] [varchar](50) NULL,
	[Element_Description] [varchar](50) NULL,
	[Element_UOM] [varchar](50) NULL,
	[Lower_Normal_Level] [varchar](50) NULL,
	[Uppper_Normal_Level] [varchar](50) NULL,
	[Measurement_Type_Code] [varchar](50) NULL,
	[Measurement_Type_Description] [varchar](50) NULL,
	[Compartment] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[Component_Code] [varchar](50) NULL,
	[Workorder_Measurement] [nchar](10) NULL,
 CONSTRAINT [PK_zzAJ_CBMDel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


INSERT INTO [zzAJ_CBMDel] VALUES  ('AL-ENG','Aluminum','Ppm','Lover','999','LAB TEST','Engine Oil','Engine','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('CR-ENG','Chromium','Ppm','0','999','LAB TEST','Engine oil','ENGINE','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('CU-ENG','Copper','Ppm','0','999','LAB TEST','Engine oil','Engine','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('CU-TRANS','Copper','Ppm','0','999','LAB TEST','Transmission oil','Transmission','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('FE TRANS','Iron','Ppm','0','999','LAB TEST','Transmission oil','Transmission','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('FE-ENG','Iron','Ppm','0','999','LAB TEST','Engine oil','Engine','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('FUEL','Fuel','Litres','0','1000000','FUEL','Fuel','TANK','Fuel','6400 - Machine','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('GROUSER BA','LT Grouser Bar','Percent','0','1000','LT GROUSER BAR','Wear','UNDER CARRAIGE','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('GROUSER BA','RT Grouser Bar','Percent','0','1000','RT GROUSER BAR','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('IDLER','LT Idler','Percent','0','1000','LT IDLER','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('IDLER','RT Idler','Percent','0','1000','RT IDLER','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('LD-ENG','Lead','Ppm','0','999','LAB TEST','Engine Oil','Engine','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('LINK HEIGH','LT Link Height','Percent','0','1000','LT LINK HEIGHT','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('LINK HEIGH','RT Link Height','Percent','0','1000','RT LINK HEIGHT','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('SI-ENG','Silicon','Ppm','0','999','LAB TEST','Engine Oil','Engine','SOS','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('SPROCKET','LT Sprocket','Percent','0','1000','LT SPROCKET','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('SPROCKET','RT Sprocket','Percent','0','1000','RT SPROCKET','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TOP ROLLER','LT Top Roller 1','Percent','0','1000','LT TOP ROLLER 1','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TOP ROLLER','LT Top Roller 2','Percent','0','1000','LT TOP ROLLER 2','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TOP ROLLER','RT Top Roller 1','Percent','0','1000','RT TOP ROLLER 1','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TOP ROLLER','RT Top Roller 2','Percent','0','1000','RT TOP ROLLER 2','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK BUSH','LT Track Bushes','Percent','0','1000','LT TRACK BUSHES','Wear','Under Carraige','Under Carraige','','FALSE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK BUSH','RT Track Bushes','Percent','0','1000','RT TRACK BUSHES','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 1','Percent','0','1000','LT TRACK ROLLER 1','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 2','Percent','0','ComWork','LT TRACK ROLLER 2','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 3','Percent','0','1000','LT TRACK ROLLER 3','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 4','Percent','0','1000','LT TRACK ROLLER 4','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 5','Percent','0','1000','LT TRACK ROLLER 5','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 6','Percent','0','1000','LT TRACK ROLLER 6','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','LT Track Roller 7','Percent','0','1000','LT TRACK ROLLER 7','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 1','Percent','0','1000','RT TRACK ROLLER 1','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 2','Percent','0','1000','RT TRACK ROLLER 2','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 3','Percent','0','1000','RT TRACK ROLLER 3','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 4','Percent','0','1000','RT TRACK ROLLER 4','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 5','Percent','0','1000','RT TRACK ROLLER 5','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 6','Percent','0','1000','RT TRACK ROLLER 6','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('TRACK ROLL','RT Track Roller 7','Percent','0','1000','RT TRACK ROLLER 7','Wear','Under Carraige','Under Carraige','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-BUSH','UC-Track Bushes External Wear (LT)','%','0','1000','TRACK BUSHES EXTERNAL WEAR (LT)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-BUSH','UC-Track Bushes External Wear (RT)','%','0','1000','TRACK BUSHES EXTERNAL WEAR (RT)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-CAR ROL','UC-Carrier Roller 1 (LT)','%','0','1000','CARRIER ROLLER (LT-P1)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-CAR ROL','UC-Carrier Roller 2 (LT)','%','0','1000','CARRIER ROLLER (LT-P2)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-CAR ROL','UC-Carrier Roller 1 (RT)','%','0','1000','CARRIER ROLLER (RT-P1)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-CAR ROL','UC-Carrier Roller 2 (RT)','%','0','1000','CARRIER ROLLER (RT-P2)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-GROU BA','UC-Grouser Bar (LT)','%','0','1000','GROUSER BAR (LT)','Wear','Undercarriage','TD, DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-GROU BA','UC-Grouser Bar (RT)','%','0','1000','GROUSER BAR (RT)','Wear','Undercarriage','TD, DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (LT)','Idler Wheel Wear (LT)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (LT-FT)','Idler Wheel Wear (LT-FT)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (LT-RR)','Idler Wheel Wear (LT-RR)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (RT)','Idler Wheel Wear (RT)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (RT-FT)','Idler Wheel Wear (RT-FT)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-IDL WH','UC-Idler Wheel','%','0','1000','IDLER WHEEL (RT-RR)','Idler Wheel Wear (RT-RR)','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-LINK HG','UC-Link Assembly Height (LT)','%','0','1000','LINK ASSEMBLY HEIGHT (LT)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-LINK HG','UC-Link Assembly Height (RT)','%','0','1000','LINK ASSEMBLY HEIGHT (RT)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-SPROCKE','UC-Sprocket Wheel (LT)','%','0','1000','SPROCKET WHEEL (LT)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-SPROCKE','UC-Sprocket Wheel (RT)','%','0','1000','SPROCKET WHEEL (RT)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 1 (LT)','%','0','1000','TRACK ROLLER (LT-P1)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 2 (LT)','%','0','1000','TRACK ROLLER (LT-P2)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 3 (LT)','%','0','1000','TRACK ROLLER (LT-P3)','Wear','Undercarriage','EXC,TD,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 4 (LT)','%','0','1000','TRACK ROLLER (LT-P4)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 5 (LT)','%','0','1000','TRACK ROLLER (LT-P5)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 6 (LT)','%','0','1000','TRACK ROLLER (LT-P6)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 7 (LT)','%','0','1000','TRACK ROLLER (LT-P7)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 8 (LT)','%','0','1000','TRACK ROLLER (LT-P8)','Wear','Undercarriage','EXC','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 1 (RT)','%','0','1000','TRACK ROLLER (RT-P1)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 2 (RT)','%','0','1000','TRACK ROLLER (RT-P2)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 3 (RT)','%','0','1000','TRACK ROLLER (RT-P3)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 4 (RT)','%','0','1000','TRACK ROLLER (RT-P4)','Wear','UNDERCARRIAGE','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 5 (RT)','%','0','1000','TRACK ROLLER (RT-P5)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 6 (RT)','%','0','1000','TRACK ROLLER (RT-P6)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 7 (RT)','%','0','1000','TRACK ROLLER (RT-P7)','Wear','Undercarriage','EXC,TR,DR','','TRUE')
INSERT INTO [zzAJ_CBMDel] VALUES  ('UC-TR ROLL','UC-Track Roller 8 (RT)','%','0','1000','TRACK ROLLER (RT-P8)','Wear','Undercarriage','EXC','','TRUE')
