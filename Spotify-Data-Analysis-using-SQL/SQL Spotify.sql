SELECT TOP (1000) [Artist]
      ,[Track]
      ,[Album]
      ,[Album_type]
      ,[Danceability]
      ,[Energy]
      ,[Loudness]
      ,[Speechiness]
      ,[Acousticness]
      ,[Instrumentalness]
      ,[Liveness]
      ,[Valence]
      ,[Tempo]
      ,[Duration_min]
      ,[Title]
      ,[Channel]
      ,[Views]
      ,[Likes]
      ,[Comments]
      ,[Licensed]
      ,[official_video]
      ,[Stream]
      ,[EnergyLiveness]
      ,[most_playedon]
  FROM [Spofiy].[dbo].[Sp]

--Retrieve the names of all tracks that have more than 1 billion streams.

  SELECT Track
  FROM [Spofiy].[dbo].[Sp]
  WHERE [Stream] > 1000000000;


--List all albums along with their respective artists.

  SELECT [Album],
  Artist 
  FROM [Spofiy].[dbo].[Sp]


--Get the total number of comments for tracks where licensed = TRUE.

  SELECT SUM([Comments]) AS Total_Comments
  FROM [Spofiy].[dbo].[Sp]
  WHERE [Licensed] = 'TRUE';

--Find all tracks that belong to the album type single.

  SELECT [Track]
  FROM [Spofiy].[dbo].[Sp]
  WHERE [Album_type] = 'single';

--Count the total number of tracks by each artist.

  SELECT Artist,
  COUNT(Track) AS  total_number_of_tracks_by_each_artist
  FROM [Spofiy].[dbo].[Sp] 
  GROUP BY Artist;

--Calculate the average danceability of tracks in each album.

  SELECT [Album],
       AVG([Danceability]) AS AVG_Danceability
  FROM [Spofiy].[dbo].[Sp]
  GROUP BY  [Album]
  ORDER BY AVG([Danceability]) DESC

--Find the top 5 tracks with the highest energy values.

  SELECT TOP(5) [Track],
  MAX([Energy])
  FROM [Spofiy].[dbo].[Sp]
  GROUP BY [Track]
  ORDER BY MAX([Energy]) DESC

--List all tracks along with their views and likes where official_video = TRUE.

  SELECT [Track],
  [Views],
  [Likes]
  FROM [Spofiy].[dbo].[Sp]
  WHERE [official_video]  ='TRUE';

--For each album, calculate the total views of all associated tracks.

  SELECT [Album],
  SUM([Views])AS Total_Views
  FROM [Spofiy].[dbo].[Sp]
  GROUP BY [Album];

--Retrieve the track names that have been streamed on Spotify more than YouTube.

  SELECT [Track],
  [most_playedon]
  FROM [Spofiy].[dbo].[Sp]
  WHERE [most_playedon] = 'Spotify'


--Find the top 3 most-viewed tracks for each artist using window functions.

  WITH CTE AS (
	SELECT [Artist],
	[Track],
	SUM([Views]) AS Total_veiwes,
	ROW_NUMBER()OVER(PARTITION BY [Artist] ORDER BY SUM([Views]) DESC) AS RN
	FROM [Spofiy].[dbo].[Sp]
	GROUP BY [Artist],
	[Track]
  )
  SELECT [Artist],
	[Track],
	Total_veiwes
	FROM CTE
	WHERE RN IN(1,2,3)
	ORDER BY [Artist] DESC;


--Write a query to find tracks where the liveness score is above the average.

SELECT [Track],[Liveness]
FROM [Spofiy].[dbo].[Sp]
WHERE [Liveness] > (SELECT AVG([Liveness])
FROM [Spofiy].[dbo].[Sp])


--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH CTE1 AS (
	SELECT MAX ([Energy]) AS MX ,
	MIN([Energy]) AS MI,
	[Album]
	FROM [Spofiy].[dbo].[Sp]
	GROUP BY [Album]
)
SELECT [Album] ,
MX-MI  AS EnergyDifference
FROM CTE1

--Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT [Track] 
FROM [Spofiy].[dbo].[Sp]
WHERE [Energy] /[Liveness] > 1.2


--Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
  [Track],
  [Likes],
  [Views],
  SUM([Likes]) OVER (ORDER BY [Views]) AS CumulativeLikes
FROM [Spofiy].[dbo].[Sp]
ORDER BY [Views];







