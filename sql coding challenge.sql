create database Artgallery
use Artgallery
--creating artist table
CREATE TABLE Artists (
    ArtistID int PRIMARY KEY,
    [Name] varchar(50) NOT NULL,
    Biography text,
    Nationality varchar(30)
);
-- create category table
CREATE TABLE Categories (
    CategoryID int PRIMARY KEY,
    [Name] varchar(50) NOT NULL
);
-- create artwork table
CREATE TABLE Artworks (
    ArtworkID int PRIMARY KEY,
    Title VARCHAR(40) NOT NULL,
    ArtistID int,
    CategoryID int,
    [Year] int,
    [Description] TEXT,
    ImageURL varchar(80),
    FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
);
-- create exhibition table
CREATE TABLE Exhibitions (
    ExhibitionID int PRIMARY KEY,
    Title varchar(50) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    [Description] TEXT
);
-- creating exhibitionartworks
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
);

-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, [Name], Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, [Name]) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');
-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, [Description], ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');
-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, [Description]) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

/*1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and 
list them in descending order of the number of artworks.*/
select a.[Name], count(ar.ArtworkID) as NumArts
from Artists a
left join Artworks ar on a.ArtistID = ar.ArtistID
group by a.[Name]
order by NumArts desc;

/*2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order 
them by the year in ascending order.*/
select ar.Title , ar.[Year]
from Artworks ar
join Artists a on ar.ArtistID = a.ArtistID
where a.Nationality in ('Spanish', 'Dutch')
order by ar.[Year] asc;

/*3. Find the names of all artists who have artworks in the 'Painting' category, and the number of 
artworks they have in this category.*/
select a.[Name], count(ar.ArtworkID) as NumArts
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
join Categories c on ar.CategoryID = c.CategoryID
where c.[Name] = 'Painting'
group by a.[Name];

/*4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their 
artists and categories.*/
select ar.Title, a.[Name] as Artist, c.[Name] as catename
from Artworks ar
join ExhibitionArtworks ea on ar.ArtworkID = ea.ArtworkID
join Exhibitions e on ea.ExhibitionID = e.ExhibitionID
join Artists a on ar.ArtistID = a.ArtistID
join Categories c on ar.CategoryID = c.CategoryID
where e.Title = 'Modern Art Masterpieces';

/*5. Find the artists who have more than two artworks in the gallery.*/
select a.[Name] ,count(ar.ArtworkId) as Numartworks
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
group by a.[Name]
having count(ar.ArtworkID) > 2;

/*6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 
'Renaissance Art' exhibition*/
select ar.Title 
from Artworks ar
join ExhibitionArtworks ea on ar.ArtworkID = ea.ArtworkID
join Exhibitions e on ea.ExhibitionID = e.ExhibitionID
where e.Title IN ('Modern Art Masterpieces', 'Renaissance Art')-- gives all artwork in both exhibis
group by ar.Title
having count(DISTINCT e.ExhibitionID) = 2;-- to get common artwrok in both exhibis

/*7. Find the total number of artworks in each category*/
select c.[Name] as catname, count(ar.ArtworkID) as TotalArts
from Categories c
left join Artworks ar on c.CategoryID = ar.CategoryID
group by c.[Name];

/*8. List artists who have more than 3 artworks in the gallery.*/
select a.[Name],count(ar.ArtworkId) as Numartworks
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
group by a.[Name]
having count(ar.ArtworkID) > 3;

/*9. Find the artworks created by artists from a specific nationality (e.g., Spanish).*/
select ar.Title, a.[Name]
from Artworks ar
join Artists a on ar.ArtistID = a.ArtistID
where a.Nationality = 'Spanish';

/*10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.*/
select e.ExhibitionID,e.Title
from Exhibitions e
join ExhibitionArtworks ea on e.ExhibitionID = ea.ExhibitionID
join Artworks ar on ea.ArtworkID = ar.ArtworkID
join Artists a on ar.ArtistID = a.ArtistID
where a.[Name] in('Vincent van Gogh', 'Leonardo da Vinci')-- gives both exhibi with both artists
group by e.ExhibitionID,e.Title
having COUNT(a.[Name]) = 2; -- gives single exhibi which as both artist

/*11. Find all the artworks that have not been included in any exhibition.*/
select ar.Title, ea.ArtworkID
from Artworks ar
left join ExhibitionArtworks ea on ar.ArtworkID = ea.ArtworkID
where ea.ArtworkID is null;

/*12. List artists who have created artworks in all available categories.*/
select a.[Name] ,count(c.CategoryID) as totcat
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
join Categories c on ar.CategoryID = c.CategoryID
group by a.[Name]
having count(distinct c.CategoryID) = (select count(*) from Categories);-- gives different cat count matching all categories

/*13. List the total number of artworks in each category.*/
select c.[Name] as catname, count(ar.ArtworkID) as Totalarts
from Categories c
left join Artworks ar on c.CategoryID = ar.CategoryID
group by c.[Name];

/*14. Find the artists who have more than 2 artworks in the gallery.*/
select a.[Name] ,count(ar.ArtworkId) as Numartworks
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
group by a.[Name]
having count(ar.ArtworkID) > 2;

/*15. List the categories with the average year of artworks they contain, only for categories with more
than 1 artwork.*/
select c.[Name] as catname, avg([Year]) as Avgofyear ,count(ar.ArtworkID) as catcount
from Categories c
join Artworks ar on c.CategoryID = ar.CategoryID
group by c.[Name]
having count(ar.ArtworkID) > 1;

/*16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.*/
select ar.Title
from Artworks ar
join ExhibitionArtworks ea on ar.ArtworkID=ea.ArtworkID
join Exhibitions e on ea.ExhibitionID=e.ExhibitionID
where e.Title = 'Modern Art Masterpieces';

/*17. Find the categories where the average year of artworks is greater than the average year of all 
artworks.*/
select c.[Name] as catname, avg(ar.[Year]) as Avgofyear 
from Categories c
join Artworks ar on c.CategoryID =ar.CategoryID
group by c.[Name] -- gives avg of categories
having Avg(ar.[Year]) > (select Avg([Year]) from Artworks);-- only cat 1 has avg so no greater value than it

/*18. List the artworks that were not exhibited in any exhibition.*/
select ar.Title
from Artworks ar
left join ExhibitionArtworks ea on ar.ArtworkID = ea.ArtworkID
where ea.ExhibitionID IS NULL;

--19. Show artists who have artworks in the same category as "Mona Lisa."
select a.[Name]
from Artists a
join Artworks ar on a.ArtistID = ar.ArtistID
where ar.CategoryID in (
    select CategoryID
   from Artworks 
   where Title = 'Mona Lisa'
) and a.[Name] != 'Vincent van Gogh' ;


/*20. List the names of artists and the number of artworks they have in the gallery*/
select a.[Name], count(ar.ArtworkID) as Totalarts
from Artists a
left join Artworks ar on a.ArtistID = ar.ArtistID
group by a.[Name];
