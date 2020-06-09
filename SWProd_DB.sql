/******************************************************************
**	These set of statements ensure that existing tables, foreign
**	keys, and schema(s) are dropped before creating the 
**	necessary objects.
*******************************************************************/

IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[TicketTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[TicketTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Ticket_CategoryId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CategoryTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CategoryTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Category_ManagerId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CategoryTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CategoryTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Category_PriorityId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CreationLinkTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CreationLinkTbl] 
	DROP CONSTRAINT IF EXISTS [FK_CreationLink_CreatorId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CreationLinkTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CreationLinkTbl] 
	DROP CONSTRAINT IF EXISTS [FK_CreationLink_CreatedId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CreatedTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CreatedTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Created_UpdateId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CreatedTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CreatedTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Created_OriginId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CreatedTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CreatedTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Created_CategoryId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CompatibilityTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CompatibilityTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Compatibility_UpdateId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CategoryTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CategoryTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Category_ProjectId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[CategoryLinkTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CategoryLinkTbl] 
	DROP CONSTRAINT IF EXISTS [FK_CategoryLink_TypeId]
GO
IF EXISTS (
	SELECT * FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[RMS].[CategoryLinkTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[CategoryLinkTbl] 
	DROP CONSTRAINT IF EXISTS [FK_CategoryLink_CategoryId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[ActivityTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[ActivityTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Activity_StatusId]
GO
IF EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[RMS].[ActivityTbl]') 
	AND type in (N'U'))
ALTER TABLE [RMS].[ActivityTbl] 
	DROP CONSTRAINT IF EXISTS [FK_Activity_CategoryId]
GO

DROP TABLE IF EXISTS [RMS].[ProjectTbl]
GO
DROP TABLE IF EXISTS [RMS].[ManagerTbl]
GO
DROP TABLE IF EXISTS [RMS].[PriorityTbl]
GO
DROP TABLE IF EXISTS [RMS].[CategoryTbl]
GO
DROP TABLE IF EXISTS [RMS].[CategoryTypeTbl]
GO
DROP TABLE IF EXISTS [RMS].[CategoryLinkTbl]
GO
DROP TABLE IF EXISTS [RMS].[TicketTbl]
GO
DROP TABLE IF EXISTS [RMS].[StatusTbl]
GO
DROP TABLE IF EXISTS [RMS].[OriginTbl]
GO
DROP TABLE IF EXISTS [RMS].[UpdatesTbl]
GO
DROP TABLE IF EXISTS [RMS].[ActivityTbl]
GO
DROP TABLE IF EXISTS [RMS].[CreatorTbl]
GO
DROP TABLE IF EXISTS [RMS].[CreationLinkTbl]
GO
DROP TABLE IF EXISTS [RMS].[CreatedTbl]
GO
DROP TABLE IF EXISTS [RMS].[CompatibilityTbl]
GO
DROP SCHEMA IF EXISTS [RMS]
GO
/******************************************************************/


/*********************** Creation of schema ***********************/
CREATE SCHEMA RMS;
GO
/******************************************************************/


/*********************** Creation of tables ***********************/
/* 
**	The project table has four attributes:
**	- project ID		- project name		- project description
**	- project release number
*/
CREATE TABLE RMS.ProjectTbl(
	ProjectId INT IDENTITY(1,1) NOT NULL,
	ProjectName NVARCHAR(50) NOT NULL,
	ProjectDesc NVARCHAR(200) NOT NULL,
	ReleaseNum NVARCHAR(15) NOT NULL
);
ALTER TABLE RMS.ProjectTbl ADD CONSTRAINT 
	PK_ProjectId PRIMARY KEY CLUSTERED (ProjectId)
GO
CREATE UNIQUE INDEX Idx_ProjectName
	ON RMS.ProjectTbl(ProjectName);
GO

/* 
**	The manager table has four attributes:
**	- manager ID		- manager name		
**	- manager email		- manager phone number
*/
CREATE TABLE RMS.ManagerTbl(
	ManagerId INT IDENTITY(1,1) NOT NULL,
	ManagerName NVARCHAR(50),
	ManagerEmail NVARCHAR(254),
	ManagerPhone NVARCHAR(20)
);
ALTER TABLE RMS.ManagerTbl ADD CONSTRAINT 
	PK_ManagerId PRIMARY KEY CLUSTERED (ManagerId)
GO
CREATE UNIQUE INDEX Idx_ManagerEmail
	ON RMS.ManagerTbl(ManagerEmail);
GO

/* 
**	The priority table has three attributes:
**	- priority ID			- priority value
*/
CREATE TABLE RMS.PriorityTbl(
	PriorityId INT IDENTITY(1,1) NOT NULL,
	PriorityVal NVARCHAR(2)
);
ALTER TABLE RMS.PriorityTbl ADD CONSTRAINT 
	PK_PriorityId PRIMARY KEY CLUSTERED (PriorityId)
GO
CREATE UNIQUE INDEX Idx_PriorityVal
	ON RMS.PriorityTbl(PriorityVal);
GO


/* 
**	The category table has five attributes:
**	- category ID		- category title		
**	- category description		- project ID
**	- ticket number		- parent ticket number
*/
CREATE TABLE RMS.CategoryTbl(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryTitle NVARCHAR(300) NOT NULL,
	CategoryDesc NVARCHAR(2000),
	ProjectId INT,
	ManagerId INT,
	PriorityId INT,
	TicketNum INT,
	ParentNum INT,
);
--	CategoryId is selected as primary key
ALTER TABLE RMS.CategoryTbl ADD CONSTRAINT 
	PK_CategoryId PRIMARY KEY CLUSTERED (CategoryId)
GO
CREATE UNIQUE INDEX Idx_CategoryTitle
	ON RMS.CategoryTbl(CategoryTitle);
GO
--	ProjectId is a foreign key refencing ProjectId from
--	the Project table
ALTER TABLE RMS.CategoryTbl ADD CONSTRAINT 
	FK_Category_ProjectId FOREIGN KEY (ProjectId)
	REFERENCES RMS.ProjectTbl (ProjectId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	ManagerId is a foreign key refencing ManagerId from
--	the Manager table
ALTER TABLE RMS.CategoryTbl ADD CONSTRAINT 
	FK_Category_ManagerId FOREIGN KEY (ManagerId)
	REFERENCES RMS.ManagerTbl (ManagerId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	PriorityId is a foreign key refencing PriorityId from
--	the Priority table
ALTER TABLE RMS.CategoryTbl ADD CONSTRAINT 
	FK_Category_PriorityId FOREIGN KEY (PriorityId)
	REFERENCES RMS.PriorityTbl (PriorityId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The category type table has two attributes:
**	- type ID		- category type
*/
CREATE TABLE RMS.CategoryTypeTbl(
	TypeId INT IDENTITY(1,1) NOT NULL,
	CategoryType NVARCHAR(20)
);
--	TypeId is selected as primary key
ALTER TABLE RMS.CategoryTypeTbl ADD CONSTRAINT 
	PK_TypeId PRIMARY KEY CLUSTERED (TypeId)
GO
CREATE UNIQUE INDEX Idx_CategoryType
	ON RMS.CategoryTypeTbl(CategoryType);
GO

/* 
**	The category bridge table has two attributes:
**	- category ID		- type name
*/
CREATE TABLE RMS.CategoryLinkTbl(
	CategoryId INT,
	TypeId INT
);
--	CategoryId is a foreign key refencing CategoryId from
--	the Category table
ALTER TABLE RMS.CategoryLinkTbl ADD CONSTRAINT 
	FK_CategoryLink_CategoryId FOREIGN KEY (CategoryId)
	REFERENCES RMS.CategoryTbl (CategoryId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	CategoryId is a foreign key refencing CategoryId from
--	the Category table
ALTER TABLE RMS.CategoryLinkTbl ADD CONSTRAINT 
	FK_CategoryLink_TypeId FOREIGN KEY (TypeId)
	REFERENCES RMS.CategoryTypeTbl (TypeId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The ticket table has three attributes:
**	- ticket ID		- category name		- ticket number
*/
CREATE TABLE RMS.TicketTbl(
	TicketId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT,
	TicketNum INT
);
ALTER TABLE RMS.TicketTbl ADD CONSTRAINT 
	PK_TicketId PRIMARY KEY CLUSTERED (TicketId)
GO
CREATE UNIQUE INDEX Idx_TicketNum
	ON RMS.TicketTbl(TicketNum);
GO
--	CategoryId is a foreign key refencing CategoryId from
--	the Category table
ALTER TABLE RMS.TicketTbl ADD CONSTRAINT 
	FK_Ticket_CategoryId FOREIGN KEY (CategoryId)
	REFERENCES RMS.CategoryTbl (CategoryId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The status table has three attributes:
**	- status ID			- status definition
*/
CREATE TABLE RMS.StatusTbl(
	StatusId INT IDENTITY(1,1) NOT NULL,
	StatusDef NVARCHAR(10),
	--PriorityVal NVARCHAR(2)
);
ALTER TABLE RMS.StatusTbl ADD CONSTRAINT 
	PK_StatusId PRIMARY KEY CLUSTERED (StatusId)
GO
CREATE UNIQUE INDEX Idx_StatusDef
	ON RMS.StatusTbl(StatusDef);
GO


/* 
**	The origin table has two attributes:
**	- origin ID		- origin name
*/
CREATE TABLE RMS.OriginTbl(
	OriginId INT IDENTITY(1,1) NOT NULL,
	OriginName NVARCHAR(20)
);
ALTER TABLE RMS.OriginTbl ADD CONSTRAINT 
	PK_OriginId PRIMARY KEY CLUSTERED (OriginId)
CREATE UNIQUE INDEX Idx_OriginName
	ON RMS.OriginTbl(OriginName);
GO

/* 
**	The updates table has four attributes:
**	- update ID			- notification date		
**	- release date		- updated version
*/
CREATE TABLE RMS.UpdatesTbl(
	UpdateId INT IDENTITY(1,1) NOT NULL,
	NotifDate DATE,
	ReleaseDate DATE,
	UpdatedVersion NVARCHAR(15) NOT NULL
);
CREATE UNIQUE INDEX Idx_UpdatedVersion
	ON RMS.UpdatesTbl(UpdatedVersion);
GO
ALTER TABLE RMS.UpdatesTbl ADD CONSTRAINT 
	PK_UpdateId PRIMARY KEY CLUSTERED (UpdateId)
GO
/* 
**	The activity table has four attributes:
**	- activity ID		- category ID		- activity
**	- status ID
*/
CREATE TABLE RMS.ActivityTbl(
	ActivityId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT,
	Activity NVARCHAR(15) NOT NULL,
	StatusId INT
);
ALTER TABLE RMS.ActivityTbl ADD CONSTRAINT 
	PK_ActivityId PRIMARY KEY CLUSTERED (ActivityId)
GO
CREATE UNIQUE INDEX Idx_Activity
	ON RMS.ActivityTbl(Activity);
GO
--	CategoryId is a foreign key refencing CategoryId from
--	the Category table
ALTER TABLE RMS.ActivityTbl ADD CONSTRAINT 
	FK_Activity_CategoryId FOREIGN KEY (CategoryId)
	REFERENCES RMS.CategoryTbl (CategoryId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	StatusId is a foreign key refencing StatusId from
--	the Status table
ALTER TABLE RMS.ActivityTbl ADD CONSTRAINT 
	FK_Activity_StatusId FOREIGN KEY (StatusId)
	REFERENCES RMS.StatusTbl (StatusId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The created table has four attributes:
**	- created ID		- category ID		- origin ID		
**	- update ID
*/
CREATE TABLE RMS.CreatedTbl(
	CreatedId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT,
	OriginId INT,
	UpdateId INT,
);
ALTER TABLE RMS.CreatedTbl ADD CONSTRAINT 
	PK_CreatedId PRIMARY KEY CLUSTERED (CreatedId)
GO
--	CategoryId is a foreign key refencing CategoryId from
--	the Category table
ALTER TABLE RMS.CreatedTbl ADD CONSTRAINT 
	FK_Created_CategoryId FOREIGN KEY (CategoryId)
	REFERENCES RMS.CategoryTbl (CategoryId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	OriginId is a foreign key refencing OriginId from
--	the Origin table
ALTER TABLE RMS.CreatedTbl ADD CONSTRAINT 
	FK_Created_OriginId FOREIGN KEY (OriginId)
	REFERENCES RMS.OriginTbl (OriginId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	UpdateId is a foreign key refencing UpdateId from
--	the Updates table
ALTER TABLE RMS.CreatedTbl ADD CONSTRAINT 
	FK_Created_UpdateId FOREIGN KEY (UpdateId)
	REFERENCES RMS.UpdatesTbl (UpdateId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The creator table has three attributes:
**	- creator ID		- creator name		
**	- created date
*/
CREATE TABLE RMS.CreatorTbl(
	CreatorId INT IDENTITY(1,1) NOT NULL,
	CreatorName NVARCHAR(50),
	CreatedDate DATE NOT NULL
);
CREATE UNIQUE INDEX Idx_CreatorName
	ON RMS.CreatorTbl(CreatorName);
GO
ALTER TABLE RMS.CreatorTbl ADD CONSTRAINT 
	PK_CreatorId PRIMARY KEY CLUSTERED (CreatorId)
GO

/* 
**	The creation bridge table has two attributes:
**	- work creation ID		- creator ID
*/
CREATE TABLE RMS.CreationLinkTbl(
	CreatedId INT,
	CreatorId INT
);
--	CreatedId is a foreign key refencing CreatedId from
--	the Created table
ALTER TABLE RMS.CreationLinkTbl ADD CONSTRAINT 
	FK_CreationLink_CreatedId FOREIGN KEY (CreatedId)
	REFERENCES RMS.CreatedTbl (CreatedId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
--	CreatorId is a foreign key refencing CreatorId from
--	the Creator table
ALTER TABLE RMS.CreationLinkTbl ADD CONSTRAINT 
	FK_CreationLink_CreatorId FOREIGN KEY (CreatorId)
	REFERENCES RMS.CreatorTbl (CreatorId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO

/* 
**	The compatibility table has three attributes:
**	- compatibility ID		- update ID
**	- compatibility version (backwards compatible)
*/
CREATE TABLE RMS.CompatibilityTbl(
	CompId INT IDENTITY(1,1) NOT NULL,
	UpdateId INT,
	CompVersion NVARCHAR(15)
);
ALTER TABLE RMS.CompatibilityTbl ADD CONSTRAINT 
	PK_CompId PRIMARY KEY CLUSTERED (CompId)
GO
CREATE UNIQUE INDEX Idx_CompVersion
	ON RMS.CompatibilityTbl(CompVersion);
GO
--	UpdateId is a foreign key refencing CategoryId from
--	the Updates table
ALTER TABLE RMS.CompatibilityTbl ADD CONSTRAINT 
	FK_Compatibility_UpdateId FOREIGN KEY (UpdateId)
	REFERENCES RMS.UpdatesTbl (UpdateId)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
GO
/******************************************************************/