use `movie recomendation`;
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

select * from Movies;

select * from Movies where ReleaseYear>2010;

select Users.Name AS UserName,Movies.Title AS MovieTitle,ReleaseYear,Movies.Director,ReviewText from Reviews 
join Users on Reviews.UserID=Users.UserID 
join Movies on Reviews.MovieID=Movies.MovieID;

select Movies.Title As MovieName,Rating,Movies.Director from Rating join Movies on Rating.MovieID = Movies.MovieID;

select * from WatchHistory join Users on WatchHistory.UserID=Users.UserID where Users.UserID=1;
select * from Movies where Director="Christopher Nolan";
select * from Movies where IMDB_Rating>8.5;
select * from Users  where age>25 order by age desc;
select * from Reviews order by ReviewDate desc;
select * from Movies order by IMDB_Rating desc limit 3;
select count(userID) from users;
select avg(IMDB_Rating) from Movies;

SELECT Users.UserID, Users.Name, COUNT(Rating.MovieID) AS MoviesRated FROM Users 
LEFT JOIN Rating ON Users.UserID = Rating.UserID GROUP BY Users.UserID, Users.Name;

Select Movies.MovieID,Movies.Title,count(Reviews.ReviewID) from Reviews join movies on Reviews.MovieID =Movies.MovieID GROUP BY Movies.MovieID, Movies.Title;

select Movies.MovieID, Movies.Title, COUNT(WatchHistory.MovieID) AS WatchCount  from WatchHistory 
join Movies on WatchHistory.MovieID=Movies.MovieID group by Movies.MovieID,Movies.Title order by WatchCount desc limit 1;

select Movies.MovieID,Movies.Title,avg(Rating) as AvgRating from Rating join Movies on Rating.MovieID=Movies.MovieID group by Movies.MovieID,Movies.Title;

select Users.UserID,Users.Name,Movies.Title from WatchHistory join users on WatchHistory.UserID=Users.userID 
join Movies on WatchHistory.movieID=movies.movieID where movies.Title="Inception";

SELECT DISTINCT Users.UserID, Users.Name FROM Rating JOIN Users ON Rating.UserID = Users.UserID 
LEFT JOIN Reviews ON Rating.UserID = Reviews.UserID AND Rating.MovieID = Reviews.MovieID WHERE Reviews.ReviewID IS NULL;

select Users.UserID, Users.Name, COUNT(WatchHistory.MovieID) AS MoviesWatched FROM WatchHistory 
JOIN Users ON WatchHistory.UserID = Users.UserID group by Users.UserID, Users.Name having count( WatchHistory.movieID)>1;

SELECT Movies.MovieID, Movies.Title, AVG(Rating.Rating) AS AverageRating FROM Rating JOIN Movies ON Rating.MovieID = Movies.MovieID
GROUP BY Movies.MovieID, Movies.Title ORDER BY AverageRating DESC LIMIT 1;

