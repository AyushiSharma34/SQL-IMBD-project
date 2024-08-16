USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- Number of rows: 14662
SELECT COUNT(*) FROM GENRE; 

-- Number of rows: 7997 
SELECT COUNT(*) FROM MOVIE;

-- Number of rows: 25735: 
SELECT COUNT(*) FROM NAMES; 

-- Number of rows: 7997 
SELECT COUNT(*) FROM RATINGS;

-- Number of rows: 15615 
SELECT COUNT(*) FROM ROLE_MAPPING;

--









-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT *
FROM movie WHERE id IS NULL; 

SELECT *
FROM movie WHERE title IS NULL;

SELECT *
FROM movie WHERE year IS NULL;

SELECT *
FROM movie WHERE date_published IS NULL;

SELECT *
FROM movie WHERE country IS NULL;

SELECT *
FROM movie WHERE worlwide_gross_income IS NULL;

SELECT *
FROM movie WHERE languages IS NULL;

SELECT *
FROM movie WHERE production_company IS NULL;





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)  AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Highest number of movies were released in 2017
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Pattern matching  using LIKE operator for country column 
SELECT Count(DISTINCT id) AS number_of_movies,year FROM movie WHERE  (country LIKE'%INDIA%' OR country LIKE '%USA%') AND year =2019;
-- 1059 movies were produced in the USA or India in the year 2019










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- Finding unique genres using Distinct keyword
SELECT DISTINCT genre from genre;
-- Movies belong to 13 genres in the given dataset 










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
-- Using LIMIT clause to display only the genre with the highest number of movies produced 
SELECT 	Genre, Count(m.id) AS number_of_movies 
FROM movie AS M INNER JOIN genre AS G where g.movie_id =m.id 
GROUP BY genre 
ORDER  BY number_of_movies DESC limit 1;
-- 4565 Drama movies were produced in total and are highest amoung all genres

        










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on the movie id and finding the distinct number
-- using result of CTE we find the count of movies which belongs to only 1 genre
WITH movies_with_one_genre AS (SELECT movie_id FROM genre  GROUP BY movie_id Having Count(DISTINCT genre)=1)
SELECT Count(*) AS movies_with_one_genre FROM movies_with_one_genre;
-- movies belong to only 1 genre are 3289 









/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- finding the average duration of movies by grouping the genres that nbelong to 
-- Finding the average duration of movies by grouping the genres that movies belong to 
SELECT genre, Round(AVG(duration),2) AS avg_duration  FROM movie AS m 
INNER JOIN genre AS g ON g.movie_id=m.id 
GROUP BY genre Order BY avg_duration DESC; 
-- Action game as the higest duration of 112.88 seconds followed by romanve and crime genres








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
-- CTE : Finds the rank of each genre based on the number of movies in each genre 
-- SELECT Query displays the genre rank and the number of movies belong to thriller genre
WITH genre_summary AS 
(SELECT genre, Count(movie_id) AS movie_count,
			  RANK() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank 
FROM genre GROUP BY genre)
SELECT *
FROM genre_summary WHERE genre= 'THRILLER';
-- THRILLER has rank =3 and movie count of 1484

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Using MIN and MAX FUNCTION FOR THE QUERY 
SELECT MIN(avg_rating) AS MIN_AVG_RATING, 
       MAX(avg_rating) AS MAX_AVG_RATING,
       MIN(total_votes) AS MIN_TOTAL_VOTES,
       MAX(total_votes) AS MAX_TOTAL_VOTES,
       MIN(median_rating) AS MIN_MEDIAN_RATING,
       MAX(median_rating) AS MAX_MEDIAN_RATING 
FROM ratings;

-- 





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- Baed on its average rating finding the rank of each movie 
-- Displaying the top 10 movies using Limit clause 
SELECT title , avg_rating,
              Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank 
FROM ratings AS r 
INNER JOIN movie  AS m
ON m.id=r.movie_id limit 10;
-- TOP 10 movies can be displayed using WHERE clause with CTE 
WITH MOVIE_RANK AS 
( SELECT title, avg_rating, ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings AS r
INNER JOIN movie AS M
ON m.id=r.movie_id) 
SELECT *FROM MOVIE_RANK WHERE movie_rank <=10;
-- Top 3 movies have average rating >=9.8 






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
-- Finding the number of movies based on median rating and sorting  based on movie count
SELECT median_rating,
         Count(movie_id) AS movie_count
FROM ratings GROUP BY median_rating ORDER BY movie_count DESC;










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
-- CTE: Finding the rank of production company based on movie count with average rating > 8 using ranking function 
-- Querying the CTE to find the production company rank=1 
WITH production_company_hit_movie_summary 
   AS (SELECT production_company, Count(movie_id)  AS MOVIE_COUNT,
                                  Rank()
                                    over(ORDER BY Count(movie_id) DESC) AS PROD_COMPANY_RANK 
								FROM ratings AS R
                                INNER JOIN movie AS M
                                      ON M.id= R.movie_id 
								WHERE avg_rating>8 
                                    AND production_company is NOT NULL 
								GROUP BY production_company) 
		SELECT * FROM production_company_hit_movie_summary 
        WHERE PROD_COMPANY_RANK=1;
-- Dream warrior pictures and national theatre live production houses has produced the most number of hit movies (avg rating>8)
-- They have rank1 and movie count is 3 

                                








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- query to find 
-- 1. Number of movies released in each genre
-- 2. During march 2017 
-- 3. In the USA (LIKE operator is used for pattern matching)
-- 4. movies had more then 1000 votes 
SELECT genre, 
Count(M.id) AS MOVIE_COUNT 
FROM movie AS M 
    INNER JOIN genre AS G
       ON G.movie_id = M.id 
	INNER JOIN ratings AS R 
        ON R.movie_id= M.id 
WHERE year= 2017 
    AND MONTH (date_published)=3 
    AND country LIKE '%USA%'
    AND  total_votes>1000 
GROUP BY genre
ORDER BY movie_count DESC; 
-- 24 drama movies were released during march 2017 in the USA and had more than 1000 votes 
-- top 3 genres are drama, comedy and action during march 2017 in the USA and had more than 1000 votes 









-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’ (LIKE operator is used for pattern matching)
-- 2. Which have an average rating > 8?
-- Grouping by title to fetch distinct movie titles as movie belog to more than one genre

SELECT  title,avg_rating,genre
FROM   movie AS M
INNER JOIN genre AS G ON  M.id = G.movie_id
INNER JOIN ratings AS R ON  M.id = R.movie_id
WHERE  title LIKE 'THE%' AND avg_rating>8
ORDER BY genre, avg_rating DESC;
-- There are 8 movies which begin with "THE "
-- The brighton miracle has highest average  rating on 9.5 
-- 	All  movies belong to top 3 genres
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
-- Between operator is used to find the movies released between 1 April 2018 anf 1 April 2019
SELECT median_rating, Count(*) AS movie_count FROM   movie AS M
INNER JOIN ratings AS R ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;
-- 361 movies have been released in a given condition
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Two approaches - one is search based on language and the other by country column
-- Approach 1: By language column
-- Compute the total number of votes for German and Italian movies.
WITH votes_summary AS
(SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes_per_movie,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes_per_movie
FROM votes_summary;
-- query to check if german votes> italian votes  using SELECT IF statement

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
 -- NULL counts for individual columns of names table
SELECT Count(*) AS name_nulls
FROM   names WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names WHERE  known_for_movies IS NULL; 

-- NULL counts for columns of names table using CASE statements
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;
-- Height, date_of_birth, known_for_movies columns contain NULLS



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- CTE: Computes the top 3 genres using average rating > 8 condition and highest movie counts
-- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  
WITH top_3_genres AS
(SELECT genre,
	Count(m.id)  AS movie_count,
    Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
	FROM   movie    AS m
	INNER JOIN genre  AS g
	ON  g.movie_id = m.id
	INNER JOIN ratings AS r
	ON   r.movie_id = m.id
	WHERE  avg_rating > 8
	GROUP BY   genre limit 3 )
SELECT n.NAME  AS director_name ,
 Count(d.movie_id) AS movie_count
FROM   director_mapping  AS d INNER JOIN genre G
using   (movie_id)
INNER JOIN names AS n
ON  n.id = d.name_id
INNER JOIN top_3_genres
using  (genre)
INNER JOIN ratings
using  (movie_id)
WHERE avg_rating > 8
GROUP BY   NAME
ORDER BY  movie_count DESC limit 3;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT N.name AS actor_name,
	Count(movie_id) AS movie_count
FROM   role_mapping AS RM
INNER JOIN movie AS M
	ON M.id = RM.movie_id
INNER JOIN ratings AS R USING(movie_id)
INNER JOIN names AS N
	ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;
-- Top 2 actors are Mammootty and Mohanlal.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Approach 1: Using select statement 
SELECT production_company,Sum(total_votes)  AS vote_count,
Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM   movie   AS m
INNER JOIN ratings  AS r
ON   r.movie_id = m.id
GROUP BY   production_company limit 3;

-- Approach 2: using CTEs
WITH ranking AS(
SELECT production_company, sum(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id=m.id
GROUP BY production_company)
SELECT production_company, vote_count, prod_comp_rank
FROM ranking WHERE prod_comp_rank<4;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_ratings AS
(SELECT n.name as actor_name,
SUM(r.total_votes) AS total_votes,
COUNT(m.id) as movie_count,
ROUND(SUM(r.avg_rating*r.total_votes)
        /
		SUM(r.total_votes)
			,2) AS actor_avg_rating
FROM names AS n INNER JOIN role_mapping AS a ON n.id=a.name_id
INNER JOIN movie AS m ON a.movie_id = m.id INNER JOIN
ratings AS r ON m.id=r.movie_id
WHERE category = 'actor' AND LOWER(country) like '%india%'
GROUP BY actor_name
)
SELECT *, RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM actor_ratings WHERE movie_count>=5;
-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.
-- Top actor is Vijay Sethupathi


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_ratings AS
(SELECT n.name as actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(SUM(r.avg_rating*r.total_votes)
        /
		SUM(r.total_votes)
			,2) AS actress_avg_rating
FROM names AS n INNER JOIN role_mapping AS a
ON n.id=a.name_id INNER JOIN movie AS m ON a.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE category = 'actress' AND LOWER(languages) like '%hindi%'
GROUP BY actress_name)
SELECT *,
	ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_ratings WHERE movie_count>=3 LIMIT 5;
-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharban

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One time watch'
        ELSE 'Flop'
    END AS movie_category FROM
    movie AS m LEFT JOIN
    ratings AS r ON m.id = r.movie_id LEFT JOIN
    genre AS g ON m.id = g.movie_id
WHERE
    LOWER(genre) = 'thriller'
        AND total_votes > 25000;

-- Using CASE statements to classify thriller movies as per avg rating

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_summary AS
(SELECT genre, ROUND(AVG(duration),2) AS avg_duration
FROM genre AS g LEFT JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre)
SELECT *,
	SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM genre_summary;


-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_genres AS
(SELECT genre, COUNT(m.id) AS movie_count,
RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre AS g LEFT JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre
)
,
top_grossing AS
(
SELECT  g.genre, year, m.title as movie_name, worlwide_gross_income,
RANK() OVER (PARTITION BY g.genre, year
ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM movie AS m INNER JOIN genre AS g ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_genres WHERE genre_rank<=3)
)
SELECT * FROM top_grossing
WHERE movie_rank<=5;
-- Top 3 Genres based on most number of movies
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_prod AS
(SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie AS m LEFT JOIN ratings AS r ON m.id = r.movie_id
WHERE median_rating>=8 AND m.production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY m.production_company)
SELECT  * FROM top_prod
WHERE prod_company_rank <= 2; 
-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_ratings AS
(SELECT n.name as actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(
		SUM(r.avg_rating*r.total_votes)
        /
		SUM(r.total_votes)
			,2) AS actress_avg_rating
FROM names AS n
INNER JOIN
	role_mapping AS a
		ON n.id=a.name_id
			INNER JOIN
        movie AS m
			ON a.movie_id = m.id
				INNER JOIN
            ratings AS r
				ON m.id=r.movie_id
					INNER JOIN
				genre AS g
				ON m.id=g.movie_id
WHERE category = 'actress' AND lower(g.genre) ='drama'
GROUP BY actress_name
)
SELECT *,
	ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM
	actress_ratings
LIMIT 3;

SELECT n.name as actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(
		SUM(r.avg_rating*r.total_votes)
        /
		SUM(r.total_votes)
			,2) AS actress_avg_rating
FROM names AS n
INNER JOIN
role_mapping AS a
ON n.id=a.name_id
INNER JOIN
movie AS m ON a.movie_id = m.id
INNER JOIN ratings AS r
ON m.id=r.movie_id
INNER JOIN genre AS g
ON m.id=g.movie_id
WHERE category = 'actress' AND lower(g.genre) ='drama'
GROUP BY actress_name; 
-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH top_directors AS
(
SELECT 
	n.id as director_id,
    n.name as director_name,
	COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as director_rank
FROM
	names AS n
		INNER JOIN
	director_mapping AS d
		ON n.id=d.name_id
			INNER JOIN
        movie AS m
			ON d.movie_id = m.id
GROUP BY n.id
),
movie_summary AS
(
SELECT
	n.id as director_id,
    n.name as director_name,
    m.id AS movie_id,
    m.date_published,
	r.avg_rating,
    r.total_votes,
    m.duration,
    LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date_published,
    DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published),date_published) AS inter_movie_days
FROM
	names AS n
		INNER JOIN
	director_mapping AS d
		ON n.id=d.name_id
			INNER JOIN
        movie AS m
			ON d.movie_id = m.id
				INNER JOIN
            ratings AS r
				ON m.id=r.movie_id
WHERE n.id IN (SELECT director_id FROM top_directors WHERE director_rank<=9)
)
SELECT 
	director_id,
	director_name,
	COUNT(DISTINCT movie_id) as number_of_movies,
	ROUND(AVG(inter_movie_days),0) AS avg_inter_movie_days,
	ROUND(
	SUM(avg_rating*total_votes)
	/
	SUM(total_votes)
		,2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM 
movie_summary
GROUP BY director_id
ORDER BY number_of_movies DESC, avg_rating DESC;






     