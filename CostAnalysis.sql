--Monthly Average Claim Cost
SELECT DATENAME(MONTH,start)
,CAST(ROUND(AVG(total_claim_cost),-2) AS INT) AS AverageClaimCost
FROM encounters
GROUP BY DATENAME(MONTH,start), MONTH(start)
ORDER BY MONTH(start)

--Total Claim Cost by Health Reason - Top 10
SELECT TOP 10 reasondescription
,SUM(total_claim_cost) AS TotalClaimCost
FROM Encounters
WHERE reasondescription IS NOT NULL
GROUP BY reasondescription
ORDER BY TotalClaimCost DESC

-- Patients by Cost Range
WITH CostRange AS 
(SELECT id
,total_claim_cost
,CASE
   WHEN total_claim_cost BETWEEN 0 AND 1000.99 THEN '0-1000'
   WHEN total_claim_cost BETWEEN 1001 AND 5000.99 THEN '1001-5000'
   WHEN total_claim_cost BETWEEN 5001 AND 50000.00 THEN '5001-50000'
   WHEN total_claim_cost >= 50001 THEN '50000+'
   ELSE 'undefined'
END AS Range
FROM encounters)

SELECT Range
,COUNT(total_claim_cost) AS Encounters
FROM CostRange
GROUP BY range
ORDER BY Encounters DESC

--Total Claim Cost over Time
SELECT YEAR(start) AS year
,SUM(total_claim_cost) as TotalClaimCost
FROM encounters
GROUP BY YEAR(start)
ORDER BY year

--Insurance Coverage Proportion by Race
SELECT p.race
,SUM(e.total_claim_cost) AS TotalClaimCost
,SUM(e.payer_coverage) AS PayerCoverage
,CASE 
	WHEN SUM(e.total_claim_cost) > 0 THEN FORMAT(SUM(e.payer_coverage) / SUM(e.total_claim_cost)*100, 'N2')
    ELSE '0.00'
END AS CoveragePercentage
FROM encounters e
LEFT JOIN patients p ON e.patient = p.id
WHERE p.race != 'other'
GROUP BY p.race
ORDER BY CoveragePercentage DESC

--Insurance Coverage Proportion by Payer
SELECT p2.name
,SUM(e.total_claim_cost) AS TotalClaimCost
,SUM(e.payer_coverage) AS PayerCoverage
,CASE
	WHEN SUM(e.total_claim_cost) > 0 THEN FORMAT(SUM(e.payer_coverage) / SUM(e.total_claim_cost)*100, 'N2')
	ELSE '0.00'
END AS CoverageProportion
FROM encounters e
LEFT JOIN Patients p ON e.patient = p.id
LEFT JOIN Payers p2 ON p2.id = e.payer
GROUP BY p2.name
ORDER BY CoverageProportion DESC

--Encounters with no insurance
SELECT COUNT(*) as Encounters
FROM encounters e
LEFT JOIN payers p2 ON e.payer = p2.id
WHERE p2.name = 'NO_INSURANCE'