use btqwfrkhhohfbtds6c9u;

create table `Account`
(
	account_id int auto_increment,
    username varchar(255) unique,
    `password` char(64),
    create_date date,
    `role` varchar(5) not null,
    email varchar(255) unique,
    
    constraint PK_account primary key (account_id),
    constraint Account_role
    check (`role` = 'admin' or `role` = 'user' or `role` = 'staff')
);

create table `Admin`
(
    admin_id int,
    `name` varchar(255) character set utf8mb4,
    
    constraint PK_Admin primary key (admin_id),
    constraint FK_Admin_Account
    foreign key (admin_id) references Account(account_id) on delete cascade
);

create table `User`
(
    user_id int,
    `name` varchar(255) character set utf8mb4,
    age int,
    birthday date,
    parental_mode int,
    
    constraint PK_User
    primary key (user_id),
    
    constraint user_age
    check (age >= 0),
    
    constraint user_parentalMode
    check (parental_mode = 0 or parental_mode = 1),
    
    constraint FK_User_Account
    foreign key (user_id) references `Account`(account_id) on delete cascade
);

create table Subscription
(
    subscription_id int auto_increment,
    subscription_name varchar(10) unique,
    price_per_month decimal(10,2),
    resolution_cap int,
    
    constraint PK_subscription 
    primary key (subscription_id),
    
    constraint Subcription_name
    check (subscription_name = 'Free' or subscription_name = 'Premium' or subscription_name = 'Signature'),
    
    constraint resolution_cap
    check (resolution_cap = 720 or resolution_cap = 1080 or resolution_cap = 1440)
);

create table Subscription_plan
(
	user_id int,
    subscription_id int not null,
    start_date date,
    expired_date date,
    
    constraint PK_subcription_plan 
    primary key(user_id),
    
    constraint FK_subscription
    foreign key(subscription_id)
    references Subscription(subscription_id) on delete cascade,
    
    constraint FK_subscription_plan_user
    foreign key (user_id)
    references `User`(user_id) on delete cascade
);

create table credit_card
(
	card_id int auto_increment,
    card_number char(16) unique,
    cvv char(3),
    valid_thru char(5),
    user_id int,
    card_provider varchar(30),
    
    constraint PK_credit
    primary key (card_id),
    
    constraint FK_credit_user
    foreign key (user_id)
    references `User`(user_id) on delete cascade
);

create table Bill
(
	bill_id int auto_increment,
    content varchar(255),
    amount decimal(10,2),
    create_date date,
    user_id int,
    
    constraint PK_bill
    primary key (bill_id),
    
    constraint FK_bill_user
    foreign key (user_id)
    references `User`(user_id) on delete cascade
);

create table Movie
(
	movie_id int auto_increment,
    title varchar(255) character set utf8mb4,
    release_date date,
    rating int,
    overview text,
    length int,
    country varchar(255) character set utf8mb4,
    backdrop_path varchar(255),
    poster_path varchar(255),
    isSeries int not null,
    video_link varchar(80),
    
    constraint PK_Movie
    primary key(movie_id),
    
    constraint Movie_isSeries
    check (isSeries = 0 or isSeries = 1)
);

create table Season
(
    season_id int auto_increment,
    `name` varchar(255) character set utf8mb4,
    air_date date,
    season_number int,
    average_rating int,
    poster_path varchar(255),
    movie int,
    
    constraint PK_Season
    primary key(season_id),
    
    constraint FK_Season_Movie
    foreign key (movie) references Movie(movie_id) on delete cascade
);

create table Episode
(
    episode_id int auto_increment,
    title varchar(255) character set utf8mb4,
    overview text,
    length int,
    rating int,
    season int,
    video_link varchar(80),
    episode_number int not null,
    
    constraint PK_Episode
    primary key (episode_id),

    constraint FK_Episode_Season
    foreign key (season)
    references Season(season_id) on delete cascade
);
    
create table Award
(
	award_id int auto_increment,
    award_name varchar(255) character set utf8mb4,
    
    constraint PK_award
    primary key (award_id)
);

create table Award_Movie
(
	award_id int ,
    movie_id int,
    award_date date,
    
    constraint PK_award_movie
    primary key (award_id, movie_id, award_date),
    
    constraint FK_award
    foreign key (award_id) references Award(award_id) on delete cascade,
    
    constraint FK_movie
    foreign key (movie_id) references Movie(movie_id) on delete cascade
);

create table Genre
(
	genre_id int auto_increment,
    genre_name varchar(100) character set utf8mb4,
    
    constraint PK_genre
    primary key (genre_id)
);

create table Genre_Movie
(
	genre int,
    movie int,
    
    constraint PK_genre_movie
    primary key (genre, movie),
    
    constraint FK_genre_movie
    foreign key (genre) references Genre(genre_id) on delete cascade,
    
    constraint FK_movie_genre
    foreign key (movie) references Movie(movie_id) on delete cascade
);

create table MovieTrailer
(
	movie int,
    trailer_link varchar(255),
    
    constraint PK_MoviePoster primary key(movie, trailer_link),
    constraint FK_MovieTrailer
    foreign key (movie) references Movie(movie_id) on delete cascade
);

create table `Comment`
(
	`user` int,
    movie int,
    time_stamp datetime,
    content text,
    
    constraint PK_comment
    primary key (`user`, movie, time_stamp),
    
    constraint FK_comment_user
    foreign key (`user`) references `User`(user_id) on delete cascade,
    
    constraint FK_comment_movie
    foreign key (movie) references Movie(movie_id) on delete cascade
);

create table WatchList
(
	`user` int,
    movie int,
    order_number int,
    constraint PK_WatchList
    primary key (`user`, movie, order_number),
    
    constraint FK_watch_user
    foreign key (`user`) references `User`(user_id) on delete cascade,
    
    constraint FK_watch_movie
    foreign key (movie) references Movie(movie_id) on delete cascade
);

create table WatchHistory
(
	`user` int,
    movie int,
    time_stamp datetime,
    
    constraint PK_History
    primary key (`user`, movie, time_stamp),
    
    constraint FK_history_user
    foreign key (`user`) references `User`(user_id) on delete cascade,
    
    constraint FK_history_movie
    foreign key (movie) references Movie(movie_id) on delete cascade
);

-- Speed enhancement
CREATE INDEX idx_Account
ON `Account` (username, `password`);

CREATE INDEX idx_User
ON `User` (`name`);

CREATE INDEX idx_Movie
ON Movie (title);

-- more will come but I dont know which

-- Init solid data
insert into Subscription(subscription_name, price_per_month, resolution_cap)
values ('Free',108000.00,720),
		('Premium', 220000.00, 1080),
        ('Signature', 260000.00, 1440);
        
insert into Award(award_name)
values ('Golden Globe Awards'),
		('Oscars (Academy Awards)'),
        ('Annie Awards'),
        ('Best Director'),
        ('Best Actor'),
        ('Best Actress'),
        ('Best Picture'),
        ('Best Cinematography');
        
insert into Genre(genre_name)
values ('Action'), 
		('Adventure'), 
        ('Animation'), 
        ('Comedy'), 
        ('Crime'), 
        ('Documentary'), 
        ('Drama'), 
        ('Family'), 
        ('Fantasy'), 
        ('History'), 
        ('Horror'), 
        ('Music'), 
        ('Mystery'), 
        ('Romance'), 
        ('Science Fiction'), 
        ('Thriller'), 
        ('TV Movie'), 
        ('War'),
        ('Western');

insert into Genre(genre_name)
values ('Action & Adventure'),
	   ('Kids'),
       ('News'),
       ('Reality'),
       ('Sci-Fi & Fantasy'),
       ('Soap'),
       ('Talk'),
       ('War & Politics');