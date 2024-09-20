use Covid21;
Select *
from Vaxx
;

---Join Deaths and Vaxx
use Covid21;
Select 
*
---date,
---location,
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
---WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY location
---ORDER BY date
;


---Total Population vs Total Vaxxed
use Covid21;
Select 
---*
---date,
---location,
max(d.population) as population,
max(v.total_vaccinations) as total_vaccinated,
cast(max(v.total_vaccinations) as float)/cast(max(d.population) as float) * 100 as percent_vaxxed
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
---WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY location
---ORDER BY date
;




---Total Population vs Total Vaxxed (Running/Rolling Total)
use Covid21;
Select 
---*
D.continent,
D.location,
D.date,
d.population,
---max(d.population) as population,
v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as vaxxed_running_total,
cast((sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_vaxxed
---max(v.total_vaccinations) as total_vaccinated,
---cast(max(v.total_vaccinations) as float)/cast(max(d.population) as float) * 100 as percent_vaxxed
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY d.continent, d.location, d.date
ORDER BY d.location, d.date
;



---Derivative Table "firstnewtable"
use Covid21;
with firstnewtable (Continent, Location, Date, Population, new_vaccinations, Vaxxed_Running_Total, percent_of_population_vaxxed)
as
(
Select 
---*
D.continent,
D.location,
D.date,
d.population,
---max(d.population) as population,
v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as vaxxed_running_total,
---cast((sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_vaxxed
cast((sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_of_population_vaxxed
---max(v.total_vaccinations) as total_vaccinated,
---cast(max(v.total_vaccinations) as float)/cast(max(d.population) as float) * 100 as percent_vaxxed
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY d.continent, d.location, d.date
---ORDER BY d.location, d.date
)
select
*
from firstnewtable;


---Derivative Table "secondnewtable" using Create Table and Insert
use Covid21;
drop table if exists secondnewtable
Create Table secondnewtable
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date date, 
Population numeric, 
new_vaccinations numeric, 
Vaxxed_Running_Total numeric, 
percent_of_population_vaxxed float
)

insert into secondnewtable
Select 
---*
D.continent,
D.location,
D.date,
d.population,
---max(d.population) as population,
v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as vaxxed_running_total,
---cast((sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_vaxxed
cast((sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_of_population_vaxxed
---max(v.total_vaccinations) as total_vaccinated,
---cast(max(v.total_vaccinations) as float)/cast(max(d.population) as float) * 100 as percent_vaxxed
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY d.continent, d.location, d.date
---ORDER BY d.location, d.date
;

---
use Covid21;
select
*
from secondnewtable;


---Create View
Create view VaxxOps as
Select 
---*
D.continent,
D.location,
D.date,
d.population,
---max(d.population) as population,
v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date) as vaxxed_running_total,
---cast((sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_vaxxed
cast((sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, d.date)) as float)/cast(d.population as float)*100 as percent_of_population_vaxxed
---max(v.total_vaccinations) as total_vaccinated,
---cast(max(v.total_vaccinations) as float)/cast(max(d.population) as float) * 100 as percent_vaxxed
from Deaths D
join Vaxx V
on D.location = V.location
and D.date = V.date
WHERE D.geo_class = 'country'
---WHERE location IN ('China', 'Philippines', 'India', 'Australia')
---   OR location LIKE '%United%'
---GROUP BY d.continent, d.location, d.date
---ORDER BY d.location, d.date
;