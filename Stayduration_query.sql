--Average LOS (Hours) by Health Reason - Top 5
SELECT TOP 5 reasondescription, AVG(DATEDIFF(HOUR,start,stop)) as AverageLOS
FROM encounters 
GROUP BY reasondescription
ORDER BY AverageLOS DESC

--Monthly Average LOS (Hours)
SELECT DATENAME(MONTH,start) as Month,
ROUND(AVG(CAST(DATEDIFF(HOUR,start,stop) AS FLOAT)),2) AS AverageLOS
FROM Encounters
GROUP BY DATENAME(MONTH,start), MONTH(start)
ORDER BY MONTH(start)

--Yearly Average LOS (Hours)
SELECT YEAR(start) AS Year, ROUND(AVG(CAST(DATEDIFF(HOUR,start,stop) AS FLOAT)),2) AS AverageLOS
FROM encounters
GROUP BY YEAR(start)
ORDER BY Year

--Male vs Female Average LOS (Hours)
SELECT p.gender, ROUND(AVG(CAST(DATEDIFF(HOUR,start,stop) AS FLOAT)),2) as AverageLOS
FROM encounters e
LEFT JOIN patients p ON e.patient = p.id
GROUP BY p.gender
ORDER BY 2 DESC
