


--Creating additional column to calculate price in dollars as original price in df is Indian rupee.
--Afternote: Did not ended up using it as the numbers were not acurate as direct curency change in this case is not applicable and they price the books accordingly to different regions.

 ALTER TABLE [AmazonBooks].[dbo].[Books_df$]
ADD Price_dolars FLOAT

UPDATE [AmazonBooks].[dbo].[Books_df]
SET Price_dolars = ROUND(Price*0.012,2) 


--Most popular genre
--Afternote:The numbers does not look reliable, as most of them are round numbers(300,200,50)

SELECT Main_Genre,COUNT(*) AS num_books
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY num_books DESC

--Most popular Sub_genre
--Afternote: No diversity in numbers

SELECT Sub_Genre,COUNT(*) AS num_books
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Sub_Genre
ORDER BY num_books DESC

--Most popular Type of books

SELECT Type,COUNT(*) AS books_published
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Type
ORDER BY COUNT(Type) DESC

---------------------------Book count-----------------------

--Exploring If any Author has more than one book
SELECT Author,	COUNT(Title) AS Books_Published
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Author
ORDER BY COUNT(Title) DESC

--Make a case statement for authors, if * books then , if * books then , if ...

SELECT Author,COUNT(Title) AS Books_Published, 
CASE
 WHEN COUNT(Title)> 150 THEN 'Big Publisher'
 WHEN COUNT(Title)>= 100 THEN 'Medium Publisher'
 WHEN COUNT(Title)>= 30 THEN 'Small Publisher'
 WHEN COUNT(Title)>= 10 THEN 'Getting Serious'
 WHEN COUNT(Title)>= 1 THEN 'Beginer'
 END AS Categories
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Author
ORDER BY COUNT(Title) DESC

--Categorizing authors based on the number of books they've published and then counting the number of authors falling into each category.
--Afternote: Had technical help from ChatGPT
-- You can't directly reference an aggregated value (like COUNT(Title)) within a CASE statement without an aggregate function. Instead, you can use a subquery to calculate the COUNT(Title) and then apply the CASE statement in the outer query.

SELECT 
    Categories,
    COUNT(Author) AS Authors_Count
FROM (
    SELECT 
        Author,
        CASE
            WHEN Books_Published > 150 THEN 'Big Publisher'
            WHEN Books_Published >= 100 THEN 'Medium Publisher'
            WHEN Books_Published >= 30 THEN 'Small Publisher'
            WHEN Books_Published >= 10 THEN 'Getting Serious'
            WHEN Books_Published >= 1 THEN 'Beginner'
        END AS Categories
    FROM (
        SELECT 
            Author,
            COUNT(Title) AS Books_Published
        FROM 
            [AmazonBooks].[dbo].[Books_df]
        GROUP BY 
            Author
    ) AS AuthorBooks
) AS CategorizedAuthors
GROUP BY 
    Categories
ORDER BY 
    COUNT(Author) ;


------------------------Price----------------------------

--Average price per genre

SELECT Main_Genre,ROUND(AVG(Price),2) AS Average_price
From [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY AVG(Price) DESC

---Min and Max price per genre

SELECT Main_Genre,MIN(Price) AS Min_price,MAX(Price) AS Max_price
From [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY Max(Price) DESC

--The biggest difirence in min and max price

SELECT Main_Genre,(MAX(Price)-MIN(Price)) AS Price_fluctuation
From [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY Price_fluctuation DESC

-----------------------Rating----------------------------

--Top 10 books based on highest rating 
--Afternote: Does not present enaugh information for the 'best' book.

SELECT TOP(10) Title, Author, Rating,Nr_rated
FROM [AmazonBooks].[dbo].[Books_df]
ORDER BY Rating DESC ,Nr_rated DESC

--Top 10 books based on highest nr people rated
--Afternote:Noticed dublicates

SELECT TOP(10) Title,Author, Rating,Nr_rated
FROM [AmazonBooks].[dbo].[Books_df]
ORDER BY Nr_rated DESC

--Top 10 books based on highest nr people rated, remove dublicates
--Afternote:Still having dublicates and nr 8 and 9 could be the same book.

SELECT TOP(10) Title, Author, Rating, Nr_rated
FROM (
    SELECT DISTINCT Author,Title, Rating, Nr_rated
    FROM [AmazonBooks].[dbo].[Books_df]
) AS unique_books
ORDER BY Nr_rated DESC;


--Looking how many of the books are in each raiting point category

SELECT Rating, COUNT(*) AS book_count
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Rating
ORDER BY Rating DESC

--Average raiting per genre

SELECT Main_Genre,ROUND(AVG(Rating),2) AS Average_raiting
From [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY AVG(Rating) DESC

---Min and Max raiting per genre

SELECT Main_Genre,MIN(Rating) AS Min_rating,MAX(rating) AS Max_rating
From [AmazonBooks].[dbo].[Books_df]
GROUP BY Main_Genre
ORDER BY Min(Rating) DESC

----Average price per rating 
--Afternote: Price is not influencing rating

SELECT Rating,COUNT(*) AS book_count, ROUND(AVG(Price),2) As Avg_price
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Rating
ORDER BY Rating DESC

--Popular authors by rating, and has at least 10 books published

SELECT TOP(10) Author,ROUND(AVG(Rating),2) AS avg_rating
FROM [AmazonBooks].[dbo].[Books_df]
GROUP BY Author
HAVING COUNT(Title)> 10
ORDER BY avg_rating DESC

