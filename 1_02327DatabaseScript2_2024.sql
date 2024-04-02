USE dkavisendb;

-- Showing the most read article in each topic
select Topic, articleTitle as Most_Read, max(nrofreaders) as readers
from article
group by Topic order by readers desc;

-- Lists the top 10 journalists with most amount of total readers
select FirstName, LastName, SUM(NrOfReaders) as readers
from Article natural join writer as w join journalist as j where j.CPR = w.writer
group by writer order by readers desc
limit 10;

-- Show reporters whose photos were never used more than once
SELECT DISTINCT j.FirstName, j.LastName
FROM journalist j
JOIN Photo p ON j.CPR = p.Reporter
LEFT JOIN IncludesPhoto ip ON p.PhotoTitle = ip.PhotoTitle
GROUP BY j.CPR, j.FirstName
HAVING COUNT(DISTINCT p.PhotoTitle) > 0
AND COUNT(DISTINCT ip.ArticleTitle) < 2;

-- Identify which topics, overall, attracted less reads that the average
select Topic
from article
group by Topic
having avg(nrOfReaders) < (select avg(nrOfReaders) from article);
