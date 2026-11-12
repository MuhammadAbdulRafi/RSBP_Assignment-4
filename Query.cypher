//Hidden Gems (High Rating but Little Known)
MATCH (b:Book)
WHERE b.avg_rating >= 4.3 
  AND b.ratings_count < 5000 
  AND b.ratings_count > 100
RETURN b.title AS Title,
       b.avg_rating AS Rating,
       b.ratings_count AS RatingCount,
       b.popularity AS Popularity
ORDER BY b.avg_rating DESC
LIMIT 15;

//Authors with Consistently High Ratings
MATCH (b:Book)-[:WRITTEN_BY]->(a:Author)
WITH a, 
     AVG(b.avg_rating) AS AvgRating,
     MIN(b.avg_rating) AS MinRating,
     MAX(b.avg_rating) AS MaxRating,
     COUNT(b) AS TotalBooks
WHERE TotalBooks >= 3 AND MinRating >= 4.0
RETURN a.name AS Author,
       ROUND(AvgRating, 2) AS AverageRating,
       ROUND(MinRating, 2) AS LowestRating,
       ROUND(MaxRating, 2) AS HighestRating,
       TotalBooks
ORDER BY AvgRating DESC
LIMIT 10;

//Which publisher publishes the most popular books?
MATCH (b:Book)-[:PUBLISHED_BY]->(p:Publisher)
WITH p, 
     COUNT(b) AS TotalBooks,
     AVG(b.avg_rating) AS AverageRating,
     SUM(b.ratings_count) AS TotalRatings
RETURN p.name AS Publisher,
       TotalBooks,
       ROUND(AverageRating, 2) AS AvgRating,
       TotalRatings
ORDER BY TotalRatings DESC
LIMIT 10;

//Most Controversial Books (Many Reviews but Average Rating)
MATCH (b:Book)
WHERE b.reviews_count > 1000
WITH b, 
     (b.reviews_count * 1.0 / b.ratings_count) AS ReviewRatio
WHERE ReviewRatio > 0.1
RETURN b.title AS Title,
       b.avg_rating AS Rating,
       b.reviews_count AS ReviewCount,
       b.ratings_count AS RatingCount,
       ROUND(ReviewRatio, 3) AS ReviewToRatingRatio
ORDER BY ReviewRatio DESC
LIMIT 10;
