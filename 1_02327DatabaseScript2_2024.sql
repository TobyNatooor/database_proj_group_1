USE dkavisendb;

-- Showing the most read article in each topic

-- Lists the top 10 journalists with most amount of total readers
select FirstName, LastName, SUM(NrOfReaders) as readers
from Article natural join writer as w join journalist as j where j.CPR = w.writer
group by writer order by readers desc
limit 10;

