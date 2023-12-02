--cleaning dataset Content

select *
from Content -- total 6 columns and 1000 rows

-- Checking for duplicate content ids

select count(Content_ID), Content_ID
from Content
group by Content_ID
having count(Content_ID) > 1 -- No duplicates found

-- Checking for spelling errors

select count(distinct(Type)), Type
from Content
Group by Type -- No spelling errors with column Type

select count(distinct(Category)), Category
from Content
Group by Category -- Found spelling errors with quotation marks, upper and lower first letter

-- Correcrting spelling errors

Alter Table Content
Add Category_Name nvarchar(50)

Update Content
Set Category_Name = LOWER(LTRIM(RTRIM(REPLACE(Category, '"', '')))) -- making all names to lowercase, removing leading and trailing spaces, removing quotation marks

select count(distinct(Category_Name)), Category_Name
from Content
Group by Category_Name


-- Checking for null or missing values

select *
from Content
where Content_ID is null or User_ID is null or Type is null or Category is null or URL is null

-- All null/missing values are belong to URL column. I will be keeping null values as they are because null values in URL column will not make any difference.

-- Deleting extra columns

-- column1 and URL are not needed for analysis, so I will drop those columns

Alter Table Content
Drop Column column1, URL, Category


-- Cleaned Table
select *
from Content --4 columns with 1000 rows

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Cleaning dataset Reactions

select *
from Reactions -- 5 columns with 25,553 rows

-- Checking for null/missing values

select *
from Reactions
where Content_ID is null or User_ID is null or Type is null or Datetime is null -- 3,019 rows where either User_Id is null or Type is null

-- For now I will delete rows where Type is null because score is based on Type

Delete
from Reactions
where Type is null -- 980 rows got deleted

-- Checking for spelling errors

select count(distinct(Type)), Type
from Reactions
Group by Type -- no errors found

-- Deleting extra column

Alter Table Reactions
Drop Column column1


-- Cleaned Table
select *
from Reactions --4 columns with 24,573 rows

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Cleaning Dataset ReactionTypes

select *
from ReactionTypes

-- There are only 16 rows with 4 colums, no duplicates and no nulls.

-- Deleting extra column

Alter Table ReactionTypes
Drop column column1

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 5 Categories

select TOP 5  C.Category_Name, Sum(T.Score) as Total_Score
from Reactions R Join Content C on R.Content_ID = C.Content_ID
join ReactionTypes T on R.Type = T.Type 
group by  C.Category_Name
order by Sum(T.Score) desc
