USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


SELECT COUNT(*) FROM movie;
SELECT COUNT(*) FROM genre;
SELECT COUNT(*) FROM director_mapping;
SELECT COUNT(*) FROM names;
SELECT COUNT(*) FROM ratings;
SELECT COUNT(*) FROM role_mapping;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_nulls,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_nulls,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_nulls,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_nulls,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_nulls,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_nulls,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_nulls,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worldwide_gross_income_nulls,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_nulls,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_nulls
FROM
    movie;
 
/* ans : Country, Worldwide_gross_income, Languages and Prodcution_company */

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
SELECT 
    Year, COUNT(*)
FROM
    movie
GROUP BY Year
ORDER BY 1;

SELECT 
    MONTH(date_published), COUNT(*)
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY 2 DESC;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(*)
FROM
    movie
WHERE
    year = 2019
    and (country like '%USA%' or country like '%India%');

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

SELECT 
    genre.genre
FROM
    genre 
GROUP BY genre.genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

SELECT 
    genre.genre, count(*)
FROM
    movie
        INNER JOIN
    genre ON movie.id = genre.movie_id
where year = 2019
GROUP BY genre.genre
order by 2 desc;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_distinct_genre AS 
	(SELECT 
		movie.id,movie.year
	FROM
		movie
			INNER JOIN
		genre ON movie.id = genre.movie_id
	GROUP BY movie.id
	HAVING COUNT(genre) = 1) 
SELECT 
    genre.genre, COUNT(m.id)
FROM
    movies_distinct_genre m
        INNER JOIN
    genre ON m.id = genre.movie_id
GROUP BY genre.genre
ORDER BY 2 DESC;


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
SELECT 
    genre, AVG(duration)
FROM
    movie INNER JOIN genre 
	ON movie.id = genre.movie_id
GROUP BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    genre, 
    count(movie_id),
    Rank() over (order by count(movie_id) desc) as genre_rank
FROM
    movie INNER JOIN genre 
	ON movie.id = genre.movie_id
GROUP BY genre;

/*Ans : Thriller rank is 3 */ 


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

SELECT 
    MIN(avg_rating),
    MAX(avg_rating),
    MIN(total_votes),
    MAX(total_votes),
    MIN(median_rating),
    MAX(median_rating)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
GROUP BY movie.id;
        

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


with rank_info as (SELECT 
    title,
    avg_rating,
    dense_rank() over (order by avg_rating desc) as avg_rating_rank
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
GROUP BY movie.id)
SELECT 
    *
FROM
    rank_info
WHERE
    avg_rating_rank <= 10;


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

SELECT 
    median_rating, COUNT(*)
FROM
    ratings
GROUP BY median_rating
ORDER BY 1;


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

select 
	production_company,
	count(id), 
	rank() over (order by count(id) desc)
from movie 
inner join ratings on movie.id = ratings.movie_id
where production_company is not null and ratings.avg_rating > 8
group by production_company
order by 2 desc;



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

SELECT 
    genre.genre, COUNT(id)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
        INNER JOIN
    genre ON movie.id = genre.movie_id
WHERE
    ratings.total_votes > 1000
        AND movie.year = 2017
        AND movie.Country = 'USA'
GROUP BY genre
ORDER BY 2 DESC;


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


SELECT 
    title, avg_rating, genre
FROM
    movie
        INNER JOIN
    genre ON movie.id = genre.movie_id
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    movie.title LIKE 'the%'
        AND ratings.avg_rating > 8;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(distinct movie.id)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    date_published >= '2018-04-01'
        AND date_published <= '2019-04-01'
        AND median_rating = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select 'german' as language,sum(total_votes)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
where movie.languages like '%german%' 
union
select 'italin' as language ,sum(total_votes)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
where movie.languages like '%italian%';



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

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    Names;


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

SELECT 
    names.name, COUNT(movie.id)
FROM
    movie
        INNER JOIN
    director_mapping dm ON movie.id = dm.movie_id
        INNER JOIN
    genre ON movie.id = genre.movie_id
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
        INNER JOIN
    names ON dm.name_id = names.id
WHERE
    avg_rating > 8
        AND genre.genre IN ('Drama' , 'Comedy', 'Thriller')
GROUP BY names.name
ORDER BY 2 DESC;


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

SELECT 
    names.name, COUNT(movie.id)
FROM
    movie
        INNER JOIN
    role_mapping rm ON movie.id = rm.movie_id
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
        INNER JOIN
    names ON rm.name_id = names.id
WHERE ratings.median_rating >= 8
GROUP BY names.name
order by 2 desc;

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

SELECT 
	production_company, 
	SUM(total_votes), 
	RANK() OVER (ORDER BY SUM(total_votes) DESC) 
FROM 
	movie 
    INNER JOIN ratings 
    ON movie.id = ratings.movie_id
WHERE 
	production_company IS NOT NULL
GROUP BY 
	movie.production_company;


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


WITH actor_details as (SELECT 
    names.name actor_name,
    SUM(ratings.total_votes) as total_votes,
    COUNT(rm.movie_id) as movie_count,
    ROUND(sum((avg_rating*total_votes))/sum(total_votes),2) as actor_avg_rating
FROM
    role_mapping rm
        INNER JOIN
    ratings ON rm.movie_id = ratings.movie_id
        INNER JOIN
    names ON rm.name_id = names.id
		INNER JOIN
	movie on rm.movie_id = movie.id
WHERE
    category = 'actor' 
    AND movie.country LIKE '%India%'
GROUP BY names.name
HAVING COUNT(rm.movie_id) >= 5)
SELECT *,
       Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_details; 


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


WITH actress_details AS (SELECT 
    names.name actor_name,
    SUM(ratings.total_votes) as total_votes,
    COUNT(rm.movie_id) as movie_count,
    ROUND(sum((avg_rating*total_votes))/sum(total_votes),2) as actor_avg_rating
FROM
    role_mapping rm
        INNER JOIN
    ratings ON rm.movie_id = ratings.movie_id
        INNER JOIN
    names ON rm.name_id = names.id
		INNER JOIN
	movie on rm.movie_id = movie.id
WHERE
    category = 'actress' 
    AND movie.country LIKE '%India%'
    AND languages LIKE '%Hindi%'
GROUP BY names.name
HAVING COUNT(rm.movie_id) >= 3)
SELECT *,
       Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actress_details; 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


WITH Movies_Avg_Rating as (
SELECT 
    title,avg_rating
FROM
    movie
        INNER JOIN
    genre ON movie.id = genre.movie_id
		INNER JOIN
	ratings on movie.id = ratings.movie_id
where genre.genre like 'Thriller'
group by title,avg_rating)
select *,Case 
		when avg_rating > 8 then 'Superhit movies'
		when avg_rating >=7 and avg_rating <=8 then 'Hit movies'
        when avg_rating >=5 and avg_rating <=7 then 'One-time-watch movies'
        when avg_rating <5 then 'Flop Movies'
        End 
from Movies_Avg_Rating;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
1+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM movie 
INNER JOIN genre 
ON movie.id= genre.movie_id
GROUP BY genre
order by 1, 2 ;


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

-- Top 3 Genres based on most number of movies

with movie_details as (SELECT 
    genre,
    year,
    title AS movie_name,
	CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income,
	DENSE_Rank() over (partition by year order by CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) desc) as movie_rank
FROM
    genre
        INNER JOIN
    movie ON genre.movie_id = movie.id
    AND genre.genre IN ('drama','comedy','thriller')) -- reference from Q4
SELECT 
    *
FROM
    movie_details
WHERE
    movie_rank <= 5;


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

SELECT 
    production_company, COUNT(id),RANK() OVER (ORDER BY count(id) DESC)
FROM
    movie
        INNER JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    median_rating >= 8
        AND production_company IS NOT NULL
        AND POSITION(',' IN languages) > 0
GROUP BY production_company
LIMIT 2;


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

SELECT 
    names.name,
    SUM(total_votes),
    COUNT(movie.id),
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),
            2) AS actress_avg_rating,
	RANK() OVER (ORDER BY count(movie.id) DESC)
FROM
    role_mapping rm
        INNER JOIN
    movie ON rm.movie_id = movie.id
        INNER JOIN
    names ON rm.name_id = names.id
        INNER JOIN
    ratings ON ratings.movie_id = movie.id
        INNER JOIN
    genre ON genre.movie_id = movie.id
WHERE
    rm.category = 'actress'
        AND ratings.avg_rating > 8
        AND genre LIKE '%Drama%'
GROUP BY names.name
LIMIT 3;





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

WITH movie_date_diff AS 
(WITH movie_dates AS (SELECT 
	movie.id AS movie_id,
	LEAD(date_published,1) OVER (PARTITION BY dm.name_id ORDER BY date_published ) AS next_date,
	date_published,
	total_votes,
	avg_rating,
	duration,
	names.id,
	names.name
FROM 
	director_mapping dm
        INNER JOIN
    names ON names.id = dm.name_id
        INNER JOIN
    ratings ON ratings.movie_id = dm.movie_id
        INNER JOIN
	movie ON movie.id = dm.movie_id)
    select *,
    Datediff(next_date, date_published) AS date_difference
    from movie_dates)
SELECT 
    id AS director_id,
    name AS director_name,
    COUNT(movie_id) AS number_of_movie,
    ROUND(AVG(date_difference), 0) AS avg_inter_movie_days,
    AVG(avg_rating) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM  
	movie_date_diff
GROUP BY id,name
ORDER BY 3 DESC



