--Total revenue
SELECT FORMAT(SUM(total_claim_cost),'N2') AS TotalRevenue
FROM encounters

--Revenue broken down by year
SELECT YEAR(start) AS Year
,FORMAT(SUM(total_claim_cost), 'N2') AS Revenue
FROM encounters
GROUP BY YEAR(start)
ORDER BY 1 

--Avergage cost per visit
SELECT FORMAT(AVG(total_claim_cost),'N2') AS AverageCost
FROM Encounters

--Total insurance coverage
SELECT FORMAT(SUM(payer_coverage),'N2')
from encounters

--Total Claim Cost
SELECT FORMAT(SUM(total_claim_cost),'N2')
FROM encounters

--Total Payer Cost
SELECT FORMAT(SUM(payer_coverage), 'N2')
FROM Encounters

-- Total Patients
SELECT count(*)
FROM patients

--Readmitted Patients
WITH AdmissionCount AS (SELECT patient, COUNT(*) AS admissions
FROM encounters
GROUP BY patient
HAVING COUNT(*) > 1)

SELECT COUNT(*)
FROM AdmissionCount

--Readmission Rate
WITH AdmissionCount AS (
	SELECT patient, 
    COUNT(*) AS admissions
    FROM encounters
    GROUP BY patient
    HAVING COUNT(*) > 1
)
SELECT CAST(
    (CAST(COUNT(*) AS DECIMAL(10,2)) / 
    (SELECT COUNT(DISTINCT patient) FROM encounters))
    *100 AS DECIMAL(10, 2)) AS ReadmissionRate
FROM AdmissionCount;


-- Total Procedures
SELECT COUNT(*)
FROM Procedures

--Claimed procedures
SELECT COUNT(*)
FROM procedures p
LEFT JOIN encounters e ON p.encounter = e.id
LEFT JOIN payers p2 ON e.PAYER = p2.Id
WHERE e.PAYER_COVERAGE > 0

--Encounters by Location
SELECT p.city
,p.county
,p.state
,COUNT(*) AS TotalEncounters
FROM encounters e
LEFT JOIN patients p ON e.PATIENT=p.Id
GROUP BY p.city, p.county, p.state
ORDER BY 4 DESC

--Average length of stay (Hours)
SELECT ROUND(AVG(CAST(DATEDIFF(MINUTE,start,stop) AS FLOAT) / 60),2)
from encounters

--Average Patient Visits
WITH VisitCount AS(SELECT patient, COUNT(id) AS visits
FROM Encounters
GROUP BY patient)

SELECT ROUND(AVG(CAST(visits AS FLOAT)),2)
FROM VisitCount