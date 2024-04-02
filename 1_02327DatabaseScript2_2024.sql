USE dkavisendb;

-- Lists the top 10 journalists with most amount of total readers
select FirstName, LastName, SUM(NrOfReaders) as Readers
from Article natural join Writer as w join Journalist as j where j.CPR = w.writer
group by Writer order by Readers desc
limit 10;

-- Identify which journalists were both writers and reporters, having shot at least a photo that was used for a news article they wrote
select w.ArticleTitle, j.FirstName, j.LastName
from Writer w
join IncludesPhoto ip on w.ArticleTitle = ip.ArticleTitle
join Photo p on ip.PhotoTitle = p.PhotoTitle
join Journalist j on p.Reporter = j.CPR
where j.CPR = w.writer;

-- Showing the most read article in each topic
select Topic, ArticleTitle as Most_Read, max(NrOfReaders) as Readers
from Article
group by Topic order by Readers desc;

-- Show reporters whose photos were never used more than once
select distinct j.FirstName, j.LastName
from Journalist j
join Photo p on j.CPR = p.Reporter
left join IncludesPhoto ip on p.PhotoTitle = ip.PhotoTitle
group by j.CPR, j.FirstName
having COUNT(distinct p.PhotoTitle) > 0
and COUNT(distinct ip.ArticleTitle) < 2;

-- Identify which topics, overall, attracted less reads that the average
select Topic, avg(NrOfReaders) AverageNrOfReadersForTopic
from Article
group by Topic
having avg(NrOfReaders) < (select avg(NrOfReaders) from Article);