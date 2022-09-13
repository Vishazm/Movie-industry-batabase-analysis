--Take a look into database
SELECT [name]
      ,[rating]
      ,[genre]
      ,[year]
      ,[released]
      ,[score]
      ,[votes]
      ,[director]
      ,[writer]
      ,[star]
      ,[country]
      ,[budget]
      ,[gross]
	  ,[ID]
      ,[company]
      ,[runtime]
  FROM [movies].[dbo].[movies$]


--Empty values count
SELECT
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [name] is NULL) as name,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [rating] is NULL) as rating,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [year] is NULL) as year,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [genre]  is NULL) as genre,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [score]  is NULL) as score,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [director]  is NULL) as director, 
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [gross]  is NULL) as worlwide_gross_income,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [writer]  is NULL) as writer,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [company]  is NULL) as production_company,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [budget] is NULL) as budget,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [released] is NULL) as released,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [votes] is NULL) as votes,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [star] is NULL) as star,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [country] is NULL) as country,
(SELECT count(*) FROM [movies].[dbo].[movies$] WHERE [runtime] is NULL) as runtime


--Deleting all the rows with empty cells
delete from [movies].[dbo].[movies$] where [budget]=' ' OR [budget] IS NULL;
delete from [movies].[dbo].[movies$] where [gross]=' ' OR [gross] IS NULL;
delete from [movies].[dbo].[movies$] where [company]=' ' OR [company] IS NULL;



--Adding ID column, just in case

ALTER TABLE [movies].[dbo].[movies$]
ADD ID INT IDENTITY(1,1)



--Changing Data types
ALTER TABLE [movies].[dbo].[movies]
 ALTER COLUMN budget numeric
 ALTER TABLE [movies].[dbo].[movies]
 ALTER COLUMN budget bigint
 --
ALTER TABLE [movies].[dbo].[movies$]
 ALTER COLUMN gross numeric
 ALTER TABLE [movies].[dbo].[movies$]
 ALTER COLUMN gross bigint



 -- Find the avarage duration of the movies in specific genres
SELECT     genre,
           Round(Avg(runtime),2) AS avg_duration
FROM       [movies].[dbo].[movies$]
GROUP BY   genre
ORDER BY avg_duration DESC;



--Biography has the highest avarage duration, and Animation has the shortest avarage, which is funny because Animation has one of the highest budget movies
--The avarage rating for each genre
alter table  [movies].[dbo].[movies$]
alter column score float

select genre, round(avg(score),2) as Score_avg
from  [movies].[dbo].[movies$]
group by genre
order by Score_avg desc
--Unsuprisingly horror has the lowest ranking



--Biography has the highest score on avarage, let's see the top score movies it contains
select name, year, score, runtime, director, star
from [movies].[dbo].[movies$]
where genre = 'Biography'
order by score desc



--Let's see the most popular movies by sorting them with votes count
alter table [movies].[dbo].[movies$]
alter column votes float
select name, director, star, year, score, company, country, released, votes from [movies].[dbo].[movies$]
order by votes desc




--We can see the company with the most popular movies
select company, sum(votes) as amount_of_votes_per_company 
from [movies].[dbo].[movies$]
group by company
order by amount_of_votes_per_company desc
--Warner Bros. has the highest amount of votes, so it practically has the most popular movies, 


--Let's see if it's true for the budget
Select sum(try_parse(budget as float) )/count(name) as avarage_budget, count(name) as number_of_movies_prodused, company
from [movies].[dbo].[movies$]
group by company
having count(name) > 10
order by avarage_budget desc




--Let's check if this numbers are correct
select name, budget, gross, company, score
from [movies].[dbo].[movies$]
where company = 'Marvel Studios'
order by budget desc




--So we can see the majority of companies have one movie, so we need to iliminate the small ones
Select sum(try_parse(budget as float) )/count(name) as avarage_budget, count(name) as number_of_movies_prodused, company
from [movies].[dbo].[movies$]
group by company
having count(name)> 5
order by avarage_budget desc




--Much better, so we see from the relatively bugger companies with the highest avarage budget, we can also find out which company has the highest amount of movies
Select sum(try_parse(budget as float) )/count(name) as avarage_budget, count(name) as number_of_movies_prodused, company
from [movies].[dbo].[movies$]
group by company
having count(name)> 5
order by number_of_movies_prodused desc




--But which company has the most profitable production
select company, round(avg([gross] / try_parse(budget as float)),2) as profitabilty, count(name) as number_of_movies
from [movies].[dbo].[movies$]
where [gross] is not NULL and [budget] is not NULL
group by company
having count(name)>5--you can increase the number if you want bugger companies
order by profitabilty desc




--!!We can see that the most profitable companies are the small ones making horror movies, but which is the most profitable genre

select [genre], round(avg([gross] / try_parse(budget as float)),2) as profitabilty
from [movies].[dbo].[movies$]
where [gross] is not NULL and [budget] is not NULL
group by [genre]
order by profitabilty desc


--And lets check the avg rating for each genre
select [genre], round(avg(score),2) as rating
from [movies].[dbo].[movies$]
group by genre
order by rating desc
--So poeple really spend their money on horror, but they dont really like them




--Which are the stars that played in the highest ranking movies?
select star, count(star) as number_of_movies,
round(avg(score),2) as score_avg
from [movies].[dbo].[movies$]
group by star 
having count(star)> 20
order by score_avg desc, number_of_movies desc


--And its Kang-ho Song, the guy from the Parasites
select * from [movies].[dbo].[movies$]
where star = 'Kang-ho Song'





--Comapany with the highest number of hit movies(score higher than 7, more than 5 films produced)
SELECT company,
      Count(company) AS company_films_count, round(avg(score),2) as avg_score
from [movies].[dbo].[movies$]
where score > 7
GROUP BY company
having Count(company)> 5
order by company_films_count desc, avg_score desc



--Let's see if Warner Bros always had sucessfull movies
Select year, round(avg(score),2) as avg_score, Count(company) AS company_films_count from [movies].[dbo].[movies$] 
where company = 'Warner Bros.'
group by year
order by avg_score desc



--And let's check which was the year with the best movies according to audience
Select year, round(avg(score),2) as avg_score, Count(name) AS Films_count from [movies].[dbo].[movies$] 
group by year
order by Avg_score desc


--So 2013 movies seem to be great, as it was the highest ranking movies year for 'Warner Bros.' too
Select * from [movies].[dbo].[movies$] where year = '2013'
order by score desc
