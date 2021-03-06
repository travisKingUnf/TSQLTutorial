USE [master]
GO
/****** Object:  Database [Movies]    Script Date: 3/25/2016 12:32:30 PM ******/
CREATE DATABASE [Movies]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Movies', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Movies.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Movies_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Movies_log.ldf' , SIZE = 5248KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Movies] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Movies].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Movies] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Movies] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Movies] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Movies] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Movies] SET ARITHABORT OFF 
GO
ALTER DATABASE [Movies] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Movies] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Movies] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Movies] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Movies] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Movies] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Movies] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Movies] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Movies] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Movies] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Movies] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Movies] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Movies] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Movies] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Movies] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Movies] SET RECOVERY FULL 
GO
ALTER DATABASE [Movies] SET  MULTI_USER 
GO
ALTER DATABASE [Movies] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Movies] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Movies] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Movies] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Movies] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Movies]
GO
/****** Object:  UserDefinedFunction [dbo].[fnFirstName]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnFirstName]
(
	@FullName AS VARCHAR(MAX)
)

RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SpacePosition AS INT
	DECLARE @Answer AS VARCHAR(MAX)

	SET @SpacePosition = CHARINDEX(' ', @FullName);
	
	IF @SpacePosition = 0
		SET @Answer = @FullName

	ELSE
		SET @Answer = LEFT(@FullName, @SpacePosition - 1)

	RETURN @Answer
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnLongDate]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnLongDate]
(
	@FullDate AS DATETIME
)
RETURNS VARCHAR(MAX)
AS 
BEGIN
	
	RETURN	DATENAME(DW, @FullDate) + ' ' +
			DATENAME(D, @FullDate)  + 
			CASE

				WHEN DAY(@FullDate) IN ( 1 , 21 , 31) THEN 'st'
				WHEN DAY(@FullDate) IN ( 2 , 22) THEN 'nd'
				WHEN DAY(@FullDate) IN ( 3 , 23) THEN 'rd'
				ELSE 'th'

			END + ' ' +
			DATENAME(M, @FullDate)  + ' ' + 
			DATENAME(YY, @FullDate)

END

GO
/****** Object:  UserDefinedFunction [dbo].[PeopleInYear]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PeopleInYear]
(
	@BirthYear INT
)
RETURNS @t TABLE
(
	PersonName VARCHAR(MAX),
	PersonDOB  DATETIME,
	PersonJob  VARCHAR(8)
)
AS

BEGIN

	INSERT INTO @t
	SELECT
		d.DirectorName,
		d.DirectorDOB,
		'Director'
	FROM	
		tblDirector as d
	WHERE 
		YEAR(d.DirectorDOB) = @BirthYear

	INSERT INTO @t
	SELECT
		a.ActorName,
		a.ActorDOB,
		'Actor'
	FROM	
		tblActor AS a
	WHERE
		YEAR(a.ActorDOB) = @BirthYear

	RETURN
END


GO
/****** Object:  Table [dbo].[tblActor]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActor](
	[ActorID] [int] NOT NULL,
	[ActorName] [nvarchar](255) NULL,
	[ActorDOB] [datetime] NULL,
	[ActorGender] [nvarchar](255) NULL,
	[ActorDateOfDeath] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblActor] PRIMARY KEY CLUSTERED 
(
	[ActorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCast]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCast](
	[CastID] [int] NOT NULL,
	[CastFilmID] [int] NULL,
	[CastActorID] [int] NULL,
	[CastCharacterName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCast] PRIMARY KEY CLUSTERED 
(
	[CastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCertificate]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCertificate](
	[CertificateID] [bigint] NOT NULL,
	[CertificateName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCertificate] PRIMARY KEY CLUSTERED 
(
	[CertificateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCountry]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCountry](
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCountry] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblDirector]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDirector](
	[DirectorID] [int] IDENTITY(1,1) NOT NULL,
	[DirectorName] [nvarchar](255) NULL,
	[DirectorDOB] [datetime] NULL,
	[DirectorGender] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblDirector2] PRIMARY KEY CLUSTERED 
(
	[DirectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblDirectorOrig]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDirectorOrig](
	[DirectorID] [int] NOT NULL,
	[DirectorName] [nvarchar](255) NULL,
	[DirectorDOB] [datetime] NULL,
	[DirectorGender] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblDirector] PRIMARY KEY CLUSTERED 
(
	[DirectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblFilm]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFilm](
	[FilmID] [int] IDENTITY(1,1) NOT NULL,
	[FilmName] [nvarchar](255) NULL,
	[FilmReleaseDate] [datetime] NULL,
	[FilmDirectorID] [int] NULL,
	[FilmLanguageID] [int] NULL,
	[FilmCountryID] [int] NULL,
	[FilmStudioID] [int] NULL,
	[FilmSynopsis] [nvarchar](max) NULL,
	[FilmRunTimeMinutes] [int] NULL,
	[FilmCertificateID] [bigint] NULL,
	[FilmBudgetDollars] [int] NULL,
	[FilmBoxOfficeDollars] [int] NULL,
	[FilmOscarNominations] [int] NULL,
	[FilmOscarWins] [int] NULL,
	[FilmCumulativeOscars] [int] NULL,
 CONSTRAINT [PK_tblFilm2] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblFilmOrig]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFilmOrig](
	[FilmID] [int] NOT NULL,
	[FilmName] [nvarchar](255) NULL,
	[FilmReleaseDate] [datetime] NULL,
	[FilmDirectorID] [int] NULL,
	[FilmLanguageID] [int] NULL,
	[FilmCountryID] [int] NULL,
	[FilmStudioID] [int] NULL,
	[FilmSynopsis] [nvarchar](max) NULL,
	[FilmRunTimeMinutes] [int] NULL,
	[FilmCertificateID] [bigint] NULL,
	[FilmBudgetDollars] [int] NULL,
	[FilmBoxOfficeDollars] [int] NULL,
	[FilmOscarNominations] [int] NULL,
	[FilmOscarWins] [int] NULL,
	[FilmCumulativeOscars] [int] NULL,
 CONSTRAINT [PK_tblFilm] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblLanguage]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLanguage](
	[LanguageID] [int] NOT NULL,
	[LanguageName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblLanguage] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblStudio]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStudio](
	[StudioID] [int] NOT NULL,
	[StudioName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblStudio] PRIMARY KEY CLUSTERED 
(
	[StudioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[FilmsInYear]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FilmsInYear]
(
	@StartYear INT,
	@EndYear INT
)
RETURNS TABLE
AS
RETURN 
	SELECT
		F.FilmName,
		F.FilmReleaseDate,
		F.FilmRunTimeMinutes
	FROM
		tblFilm AS F
	WHERE
		YEAR(F.FilmReleaseDate) BETWEEN @StartYear AND @EndYear
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblCertificate2] FOREIGN KEY([FilmCertificateID])
REFERENCES [dbo].[tblCertificate] ([CertificateID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblCertificate2]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblCountry2] FOREIGN KEY([FilmCountryID])
REFERENCES [dbo].[tblCountry] ([CountryID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblCountry2]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblLanguage2] FOREIGN KEY([FilmLanguageID])
REFERENCES [dbo].[tblLanguage] ([LanguageID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblLanguage2]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblStudio12] FOREIGN KEY([FilmStudioID])
REFERENCES [dbo].[tblStudio] ([StudioID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblStudio12]
GO
/****** Object:  StoredProcedure [dbo].[spExample]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spExample]

AS
BEGIN
	select * from tblFilm
END

GO
/****** Object:  StoredProcedure [dbo].[spFilmYears]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Dynamic SQL and the IN operator

CREATE PROC [dbo].[spFilmYears]
(
	@YearList NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @SQLString NVARCHAR(MAX)

	SET @SQLString =	N'SELECT * FROM 
						tblFilm WHERE YEAR(FilmReleaseDate) IN (' + @YearList + ')
						ORDER BY FilmReleaseDate'

	EXECUTE sp_executesql @SQLString

END

GO
/****** Object:  StoredProcedure [dbo].[spGetDirector]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spGetDirector](@DirectorName VARCHAR(MAX))
AS 
BEGIN 
	SAVE TRAN AddDirector

	INSERT INTO tblDirector (DirectorName)
	VALUES (@DirectorName)

	IF(SELECT COUNT(*) FROM tblDirector WHERE DirectorName = @DirectorName) > 1
		BEGIN
			PRINT 'DIRECTOR ALREADY EXISTED'
			ROLLBACK TRAN AddDirector
		END

	RETURN @@IDENTITY

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertIntoTemp]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spInsertIntoTemp](@Text AS VARCHAR(MAX))
AS
BEGIN
	INSERT INTO #TempFilms
	SELECT
		FilmName,
		FilmReleaseDate
	FROM 
		tblFilm
	WHERE
		FilmName LIKE '%' + @Text + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[spListCharacters]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spListCharacters]
(
	@FilmID INT,
	@FilmName VARCHAR(MAX),
	@FilmDate DATETIME
)
AS
BEGIN

	PRINT @FilmName + ' was released on ' + dbo.fnLongDate(@FilmDate)
	PRINT '=========================================================='
	PRINT 'List of characters'
	PRINT '=========================================================='

	DECLARE CharactersAndActorsCursor CURSOR 
		FOR
			SELECT
				C.CastCharacterName,
				A.ActorName
			FROM
				tblCast AS C
				INNER JOIN
					tblActor AS A
					ON C.CastActorID = A.ActorID
			WHERE
				C.CastFilmID = @FilmID

	DECLARE @CharacterName VARCHAR(MAX)
	DECLARE @ActorName VARCHAR(MAX)
	
	OPEN CharactersAndActorsCursor
	
		FETCH NEXT FROM CharactersAndActorsCursor
			INTO @CharacterName, @ActorName

		WHILE @@FETCH_STATUS = 0
	
		BEGIN
			PRINT @CharacterName + ' (' + @ActorName + ')'

			FETCH NEXT FROM CharactersAndActorsCursor
				INTO @CharacterName, @ActorName

		END
	CLOSE CharactersAndActorsCursor
	DEALLOCATE CharactersAndActorsCursor
	PRINT ' '
END
GO
/****** Object:  StoredProcedure [dbo].[spSelectFromTemp]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spSelectFromTemp]
AS
BEGIN
	SELECT
		*
	FROM 
		#TempFilms
	ORDER BY
		Release DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spVariableData]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spVariableData]
	(
		@InfoType VARCHAR(9) -- THIS CAN BE ALL, AWARD, or FINANCIAL
	)
AS
BEGIN

	IF @InfoType = 'ALL'
		BEGIN
			(SELECT * FROM tblFilm)
			RETURN
		END
	ELSE IF @InfoType = 'AWARD'
		BEGIN
			SELECT FilmName , FilmOscarWins , FilmOscarNominations FROM tblFilm ORDER BY FilmOscarWins DESC , FilmOscarNominations DESC 
			RETURN
		END
	ELSE IF @InfoType = 'FINANCIAL'
		BEGIN
			SELECT FilmName , FilmBoxOfficeDollars , FilmBudgetDollars , CAST(FilmBoxOfficeDollars - FilmBudgetDollars AS money) AS PROFIT FROM tblFilm ORDER BY PROFIT DESC
			RETURN
		END

	ELSE
		SELECT 'You must pass in ALL, AWARD, or FINANCIAL'

END
GO
/****** Object:  StoredProcedure [dbo].[spVariableTable]    Script Date: 3/25/2016 12:32:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Creating Stored Procedure that uses dynamic sql

CREATE PROC [dbo].[spVariableTable]
(
	@TableName NVARCHAR(128)
)
AS
BEGIN

	DECLARE @SQLString NVARCHAR(128)
	SET @SQLString = N'SELECT * FROM ' + @TableName

	EXECUTE sp_executesql @SQLString

END
GO
USE [master]
GO
ALTER DATABASE [Movies] SET  READ_WRITE 
GO
