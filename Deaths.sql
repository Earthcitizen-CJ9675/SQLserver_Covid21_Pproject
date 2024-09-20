use Covid21;

select *
from deaths;

select *
from vaxx;

SELECT location, COUNT(*) AS total_entries
FROM Deaths
WHERE geo_class = 'Country'
GROUP BY location
ORDER BY total_entries DESC;

---Mortality per Country average
SELECT 
    location, 
    AVG(CAST(total_cases AS FLOAT)) AS avg_cases, 
    AVG(CAST(total_deaths AS FLOAT)) AS avg_deaths, 
    CASE 
        WHEN AVG(CAST(total_cases AS FLOAT)) = 0 THEN 0
        WHEN AVG(CAST(total_deaths AS FLOAT)) = 0 THEN 0
        ELSE (AVG(CAST(total_deaths AS FLOAT)) / AVG(CAST(total_cases AS FLOAT))) * 100
    END AS mortality
FROM Deaths
WHERE geo_class = 'country'
GROUP BY location
ORDER BY 3 desc;

---Mortality per day
SELECT
	date,
    location, 
    total_cases, 
    total_deaths, 
    case
	when total_deaths = 0 then 0
	when total_cases = 0 then 0
	else
	CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT) *100
	end AS mortality
FROM Deaths
WHERE geo_class = 'country'
---GROUP BY location
ORDER BY 4 desc;


---Morbidity and Mortality
SELECT
	---date,
    location,
	avg(cast(population as float)) as popluation,
    sum(new_cases) as total_cases,
	---total_cases,
    sum(new_deaths) as total_deaths,
	---total_deaths,
	CASE
        WHEN SUM(new_cases) = 0 THEN 0
        WHEN avg(cast(population as float)) = 0 THEN 0
        ELSE (CAST(SUM(new_cases) AS FLOAT)) / avg(cast(population as float)) * 100
    END AS morbidity,
    CASE
        WHEN SUM(new_cases) = 0 THEN 0
        WHEN SUM(new_deaths) = 0 THEN 0
        ELSE (CAST(SUM(new_deaths) AS FLOAT) / CAST(SUM(new_cases) AS FLOAT)) * 100
    END AS mortality
FROM Deaths
WHERE geo_class = 'country'
GROUP BY location
ORDER BY 5 desc;


---Morbidity and Mortality B
SELECT
	---date,
    location,
	---avg(cast(population as float)) as popluation,
	max(population) as popluation,
    ---sum(new_cases) as total_cases,
	max(total_cases) as total_cases,
    ---sum(new_deaths) as total_deaths,
	max(total_deaths) as total_deaths,
	CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(population) = 0 THEN 0
        ELSE (CAST(MAX(total_cases) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS morbidity,
    CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(total_deaths) = 0 THEN 0
        ELSE (CAST(MAX(total_deaths) AS FLOAT) / CAST(MAX(total_cases) AS FLOAT)) * 100
    END AS mortality
FROM Deaths
WHERE geo_class = 'country'
GROUP BY location
ORDER BY 4 desc;

---Morbidity and Mortality in select locations
use Covid21;
SELECT
	---date,
    location,
	continent,
	---avg(cast(population as float)) as popluation,
	max(population) as popluation,
    ---sum(new_cases) as total_cases,
	max(total_cases) as total_cases,
    ---sum(new_deaths) as total_deaths,
	max(total_deaths) as total_deaths,
	CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(population) = 0 THEN 0
        ELSE (CAST(MAX(total_cases) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS morbidity,
    CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(total_deaths) = 0 THEN 0
        ELSE (CAST(MAX(total_deaths) AS FLOAT) / CAST(MAX(total_cases) AS FLOAT)) * 100
    END AS mortality,
	    CASE
        WHEN MAX(population) = 0 THEN 0
        WHEN MAX(total_deaths) = 0 THEN 0
        ELSE (CAST(MAX(total_deaths) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS Deaths_percent_in_Population
FROM Deaths
---WHERE geo_class = 'country'
WHERE location IN ('China', 'Philippines', 'India', 'Australia')
   OR location LIKE '%United%'
GROUP BY location, continent
ORDER BY popluation desc;





---Morbidity and Mortality in Continents
use Covid21;
SELECT
	---date,
    ---location,
	continent,
	---avg(cast(population as float)) as popluation,
	max(population) as popluation,
    ---sum(new_cases) as total_cases,
	max(total_cases) as total_cases,
    --sum(new_deaths) as total_deaths,
	max(total_deaths) as total_deaths,
	CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(population) = 0 THEN 0
        ELSE (CAST(MAX(total_cases) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS morbidity,
    CASE
        WHEN MAX(total_cases) = 0 THEN 0
        WHEN MAX(total_deaths) = 0 THEN 0
        ELSE (CAST(MAX(total_deaths) AS FLOAT) / CAST(MAX(total_cases) AS FLOAT)) * 100
    END AS mortality,
	    CASE
        WHEN MAX(population) = 0 THEN 0
        WHEN MAX(total_deaths) = 0 THEN 0
        ELSE (CAST(MAX(total_deaths) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS Deaths_percent_in_Population
FROM Deaths
WHERE geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
GROUP BY continent
ORDER BY total_cases desc;



---Global Morbidity and Mortality by Day
use Covid21;
SELECT
	date,
    ---location,
	---continent,
	---avg(cast(population as float)) as popluation,
	---max(population) as popluation,
    sum(new_cases) as total_cases,
	---max(total_cases) as total_cases,
    sum(new_deaths) as total_deaths,
	--max(total_deaths) as total_deaths,
	CASE
        WHEN SUM(new_cases) = 0 THEN 0
        WHEN avg(cast(population as float)) = 0 THEN 0
        ELSE (CAST(SUM(new_cases) AS FLOAT)) / avg(cast(population as float)) * 100
    END AS morbidity,
    CASE
        WHEN SUM(new_cases) = 0 THEN 0
        WHEN SUM(new_deaths) = 0 THEN 0
        ELSE (CAST(SUM(new_deaths) AS FLOAT) / CAST(SUM(new_cases) AS FLOAT)) * 100
    END AS mortality,
	    CASE
        WHEN MAX(population) = 0 THEN 0
        WHEN SUM(new_deaths) = 0 THEN 0
        ELSE (CAST(SUM(new_deaths) AS FLOAT) / CAST(MAX(population) AS FLOAT)) * 100
    END AS Deaths_percent_in_Population
FROM Deaths
WHERE geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
GROUP BY date
ORDER BY date;