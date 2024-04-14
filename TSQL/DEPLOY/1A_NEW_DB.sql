USE [master]
GO

/****** Object:  Database [BMS3_new]    Script Date: 04/12/2016 17:11:34 ******/
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'BMS3_new')
DROP DATABASE [BMS3_new]
GO
CREATE DATABASE BMS3_new
GO 
USE [BMS3_new]
GO

/****** Object:  Table [dbo].[userlist]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userlist](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[fullname] [varchar](100) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[dept] [varchar](15) NOT NULL,
	[position] [varchar](5) NOT NULL,
	[sign] [varchar](50) NULL,
	[spv] [varchar](100) NULL,
	[priviledges] [varchar](150) NOT NULL,
	[status] [tinyint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[units]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[units](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[deptId] [smallint] NOT NULL,
	[code] [varchar](10) NOT NULL,
	[label] [varchar](150) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[units] ON
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (1, 1, N'ahu1', N'AHU1')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (2, 1, N'ahu2', N'AHU2')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (3, 1, N'wfi', N'WFI & PSG')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (4, 1, N'wpu', N'WPU')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (5, 1, N'demin', N'Demineralization')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (6, 3, N'wh', N'Warehouse')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (7, 2, N'drycore', N'Dry Core')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (8, 2, N'sterile', N'Sterile')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (9, 2, N'goods', N'Finished Goods')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (10, 4, N'retain', N'Retained Sample')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (11, 4, N'equipment', N'Equipment')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (12, 4, N'lab', N'Laboratory')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (13, 4, N'lab_chemic', N'Chemical Lab.')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (14, 4, N'lab_micro', N'Micro Lab.')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (15, 5, N'', N'')
SET IDENTITY_INSERT [dbo].[units] OFF
/****** Object:  Table [dbo].[tagtime]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tagtime](
	[time] [smallint] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[tagtime] ([time]) VALUES (1800)
/****** Object:  Table [dbo].[tagname]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tagname](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[tagname] [varchar](255) NOT NULL,
	[unit] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[report]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[report](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[unit] [varchar](20) NOT NULL,
	[dept] [varchar](10) NOT NULL,
	[date] [smalldatetime] NOT NULL,
	[status] [tinyint] NOT NULL,
	[update_date] [smalldatetime] NULL,
	[progress] [tinyint] NOT NULL,
 CONSTRAINT [PK_report] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[emailcfg]    Script Date: 04/12/2016 17:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[emailcfg](
	[id] [int] NOT NULL,
	[Host] [varchar](100) NOT NULL,
	[Port] [smallint] NOT NULL,
	[From] [varchar](150) NOT NULL,
	[FromName] [varchar](150) NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[ContentType] [VARCHAR](10) NOT NULL,
	[Timeout] [smallint] NULL,
	[SMTPAuth] [tinyint] NULL,
	[SMTPSecure] [VARCHAR](5) NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[SMTPDebug] [tinyint] NULL,
	[Debugoutput] [VARCHAR](5) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[emailcfg] ([id], [Host], [Port], [From], [FromName], [Priority], [ContentType], [Timeout], [SMTPAuth], [SMTPSecure], [Username], [Password], [SMTPDebug], [Debugoutput]) VALUES (1, N'148.168.192.85', 25, N'ruswendy.setiadi@pfizer.com', N'BMS Application', 0, N'text/html ', 300, 0, N'     ', NULL, NULL, 0, N'echo ')
/****** Object:  Table [dbo].[depts]    Script Date: 04/12/2016 17:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[depts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](10) NOT NULL,
	[label] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[depts] ON
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (1, N'eng', N'Engineering')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (2, N'prod', N'Production')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (3, N'wh', N'Warehouse')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (4, N'qo', N'Quality Op.')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (5, N'qa', N'Quality Ass.')
SET IDENTITY_INSERT [dbo].[depts] OFF
/****** Object:  Table [dbo].[comment]    Script Date: 04/12/2016 17:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[report_id] [int] NOT NULL,
	[submit_date] [smalldatetime] NOT NULL,
	[comment] [varchar](max) NOT NULL,
	[isReject] [tinyint] NULL,
	[position] [VARCHAR](10) NOT NULL,
	[uid] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_comment_report]    Script Date: 04/12/2016 17:02:59 ******/
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_report] FOREIGN KEY([report_id])
REFERENCES [dbo].[report] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_report]
GO

/****** Object:  Table [dbo].[userlog]    Script Date: 04/12/2016 17:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userlog](
	[date] [smalldatetime] NOT NULL,
	[userid] [smallint] NOT NULL,
	[event] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO