-- Create a database named 'movie_recommendation'
CREATE DATABASE movie_recommendation;
-- User Table
Create table Users(
UserID int primary key auto_increment,
Name varchar(100) not null,
Age int not null,
Gender enum('Male','Female','Others'),
JoinDate datetime default current_timestamp
);
-- Movie Table
create table Movies(
MovieID int primary key auto_increment,
Title varchar(100) not null,
ReleaseYear year not null,
Director varchar(100),
IMDB_Rating decimal(3,1) check (IMDB_Rating  between 0 and 10)
);
-- Review Table
create table Reviews(
ReviewID int primary key auto_increment,
UserID int ,
MovieID int,
ReviewText Text,
ReviewDate datetime default current_timestamp,
foreign key (UserID) references Users(UserID) on delete cascade,
foreign key (MovieID) references Movies(MovieID) on delete cascade
);
-- Rating Table
create table Rating(
RatingID int primary key auto_increment,
UserID int ,
MovieID int,
Rating  int check(Rating between 1 and 10),
ReviewAt datetime default current_timestamp,
foreign key (UserID) references Users(UserID) on delete cascade,
foreign key (MovieID) references Movies(MovieID) on delete cascade
);
-- watch history table
create table WatchHistory(
HistoryID int primary key auto_increment,
UserID int ,
MovieID int,
WatchedAt datetime default current_timestamp,
foreign key (UserID) references Users(UserID) on delete cascade,
foreign key (MovieID) references Movies(MovieID) on delete cascade
);


-- Insert Users
INSERT INTO Users (Name, Age, Gender) VALUES 
('Alice Johnson', 25, 'Female'),
('Bob Smith', 30, 'Male'),
('Charlie Brown', 28, 'Male'),
('Diana Prince', 22, 'Female'),
('Eve Adams', 35, 'Female');

-- Insert Movies
INSERT INTO Movies (Title, ReleaseYear, Director, IMDB_Rating) VALUES 
('Inception', 2010, 'Christopher Nolan', 8.8),
('Interstellar', 2014, 'Christopher Nolan', 8.6),
('The Dark Knight', 2008, 'Christopher Nolan', 9.0),
('Avengers: Endgame', 2019, 'Anthony Russo', 8.4),
('The Matrix', 1999, 'Lana Wachowski', 8.7);

-- Insert Ratings
INSERT INTO Rating (UserID, MovieID, Rating) VALUES 
(1, 1, 9),
(2, 1, 8),
(3, 2, 9),
(4, 3, 10),
(5, 4, 7),
(1, 5, 8);

-- Insert Reviews
INSERT INTO Reviews (UserID, MovieID, ReviewText) VALUES 
(1, 1, 'Mind-blowing movie with great cinematography!'),
(2, 1, 'Amazing concept, but a bit hard to follow.'),
(3, 2, 'Loved the scientific accuracy and visuals!'),
(4, 3, 'Best Batman movie ever!'),
(5, 4, 'Emotional and action-packed. A great conclusion.');

-- Insert Watch History
INSERT INTO WatchHistory (UserID, MovieID) VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(1, 5),
(2, 3);


USE `movie_recommendation`;

-- Retrieve all movies in the database
SELECT * FROM Movies;

-- Get all movies released after 2010
SELECT * FROM Movies WHERE ReleaseYear > 2010;

-- Fetch user reviews along with movie details
SELECT Users.Name AS UserName, Movies.Title AS MovieTitle, ReleaseYear, Movies.Director, ReviewText 
FROM Reviews 
JOIN Users ON Reviews.UserID = Users.UserID 
JOIN Movies ON Reviews.MovieID = Movies.MovieID;

-- Get all movie ratings along with their directors
SELECT Movies.Title AS MovieName, Rating, Movies.Director 
FROM Rating 
JOIN Movies ON Rating.MovieID = Movies.MovieID;

-- Fetch the watch history of a specific user (UserID = 1)
SELECT * FROM WatchHistory 
JOIN Users ON WatchHistory.UserID = Users.UserID 
WHERE Users.UserID = 1;

-- Get all movies directed by Christopher Nolan
SELECT * FROM Movies WHERE Director = "Christopher Nolan";

-- Retrieve movies with an IMDB rating greater than 8.5
SELECT * FROM Movies WHERE IMDB_Rating > 8.5;

-- Get all users older than 25 and order them by age in descending order
SELECT * FROM Users WHERE Age > 25 ORDER BY Age DESC;

-- Fetch all reviews sorted by the latest review date
SELECT * FROM Reviews ORDER BY ReviewDate DESC;

-- Get the top 3 highest-rated movies
SELECT * FROM Movies ORDER BY IMDB_Rating DESC LIMIT 3;

-- Count the number of users in the database
SELECT COUNT(UserID) FROM Users;

-- Get the average IMDB rating of all movies
SELECT AVG(IMDB_Rating) FROM Movies;

-- Count the number of movies each user has rated
SELECT Users.UserID, Users.Name, COUNT(Rating.MovieID) AS MoviesRated 
FROM Users 
LEFT JOIN Rating ON Users.UserID = Rating.UserID 
GROUP BY Users.UserID, Users.Name;

-- Count the number of reviews per movie
SELECT Movies.MovieID, Movies.Title, COUNT(Reviews.ReviewID) 
FROM Reviews 
JOIN Movies ON Reviews.MovieID = Movies.MovieID 
GROUP BY Movies.MovieID, Movies.Title;

-- Find the most-watched movie based on watch history
SELECT Movies.MovieID, Movies.Title, COUNT(WatchHistory.MovieID) AS WatchCount  
FROM WatchHistory 
JOIN Movies ON WatchHistory.MovieID = Movies.MovieID 
GROUP BY Movies.MovieID, Movies.Title 
ORDER BY WatchCount DESC 
LIMIT 1;

-- Get the average rating of each movie
SELECT Movies.MovieID, Movies.Title, AVG(Rating) AS AvgRating 
FROM Rating 
JOIN Movies ON Rating.MovieID = Movies.MovieID 
GROUP BY Movies.MovieID, Movies.Title;

-- Find users who watched a specific movie (e.g., 'Inception')
SELECT Users.UserID, Users.Name, Movies.Title 
FROM WatchHistory 
JOIN Users ON WatchHistory.UserID = Users.UserID 
JOIN Movies ON WatchHistory.MovieID = Movies.MovieID 
WHERE Movies.Title = "Inception";

-- Identify users who have rated movies but haven't written reviews
SELECT DISTINCT Users.UserID, Users.Name 
FROM Rating 
JOIN Users ON Rating.UserID = Users.UserID 
LEFT JOIN Reviews ON Rating.UserID = Reviews.UserID AND Rating.MovieID = Reviews.MovieID 
WHERE Reviews.ReviewID IS NULL;

-- Get users who have watched more than one movie
SELECT Users.UserID, Users.Name, COUNT(WatchHistory.MovieID) AS MoviesWatched 
FROM WatchHistory 
JOIN Users ON WatchHistory.UserID = Users.UserID 
GROUP BY Users.UserID, Users.Name 
HAVING COUNT(WatchHistory.MovieID) > 1;

-- Find the highest-rated movie based on user ratings
SELECT Movies.MovieID, Movies.Title, AVG(Rating.Rating) AS AverageRating 
FROM Rating 
JOIN Movies ON Rating.MovieID = Movies.MovieID 
GROUP BY Movies.MovieID, Movies.Title 
ORDER BY AverageRating DESC 
LIMIT 1;
