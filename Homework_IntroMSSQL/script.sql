USE [master]
GO
/****** Object:  Database [Homework_School]    Script Date: 08/02/2015 12:50:55 ******/
CREATE DATABASE [Homework_School]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Homework_School', FILENAME = N'E:\Programing\SQL\MSSQL12.MSSQLSERVER\MSSQL\DATA\Homework_School.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Homework_School_log', FILENAME = N'E:\Programing\SQL\MSSQL12.MSSQLSERVER\MSSQL\DATA\Homework_School_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Homework_School] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Homework_School].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Homework_School] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Homework_School] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Homework_School] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Homework_School] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Homework_School] SET ARITHABORT OFF 
GO
ALTER DATABASE [Homework_School] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Homework_School] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Homework_School] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Homework_School] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Homework_School] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Homework_School] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Homework_School] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Homework_School] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Homework_School] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Homework_School] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Homework_School] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Homework_School] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Homework_School] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Homework_School] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Homework_School] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Homework_School] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Homework_School] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Homework_School] SET RECOVERY FULL 
GO
ALTER DATABASE [Homework_School] SET  MULTI_USER 
GO
ALTER DATABASE [Homework_School] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Homework_School] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Homework_School] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Homework_School] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Homework_School] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Homework_School', N'ON'
GO
USE [Homework_School]
GO
/****** Object:  User [vpenev]    Script Date: 08/02/2015 12:50:55 ******/
CREATE USER [vpenev] FOR LOGIN [vpenev] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [vpenev]
GO
/****** Object:  Table [dbo].[Classes]    Script Date: 08/02/2015 12:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[MaxStudents] [int] NOT NULL,
 CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 08/02/2015 12:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Age] [int] NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Classes] ON 

INSERT [dbo].[Classes] ([ID], [Name], [MaxStudents]) VALUES (1, N'C# Basic', 150)
INSERT [dbo].[Classes] ([ID], [Name], [MaxStudents]) VALUES (2, N'Java Basic', 120)
INSERT [dbo].[Classes] ([ID], [Name], [MaxStudents]) VALUES (3, N'HTML + CSS', 135)
INSERT [dbo].[Classes] ([ID], [Name], [MaxStudents]) VALUES (4, N'PHP', 180)
INSERT [dbo].[Classes] ([ID], [Name], [MaxStudents]) VALUES (5, N'JS', 140)
SET IDENTITY_INSERT [dbo].[Classes] OFF
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([ID], [Name], [Age], [PhoneNumber]) VALUES (1, N'Pesho', 15, N'+359 878 878 878')
INSERT [dbo].[Students] ([ID], [Name], [Age], [PhoneNumber]) VALUES (2, N'Gosho', 22, N'+359 888 888 888')
INSERT [dbo].[Students] ([ID], [Name], [Age], [PhoneNumber]) VALUES (3, N'Stamat', 21, N'+359 898 988 988')
INSERT [dbo].[Students] ([ID], [Name], [Age], [PhoneNumber]) VALUES (4, N'Minka', 20, N'+359 899 999 999')
SET IDENTITY_INSERT [dbo].[Students] OFF
USE [master]
GO
ALTER DATABASE [Homework_School] SET  READ_WRITE 
GO
