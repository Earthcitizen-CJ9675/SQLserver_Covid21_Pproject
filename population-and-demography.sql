---Change' total_population' data type from float to bigint
update POP_DEM
set  total_population = ROUND(total_population, 0);

ALTER TABLE POP_DEM
ALTER COLUMN total_population bigint;

---Set Labels/Categories on 'Entity' values inorder to be able to extract country values from non-country values
ALTER TABLE POP_DEM
ADD Geo_Classification VARCHAR(50);

UPDATE POP_DEM
SET Geo_Classification = 'Continent'
WHERE Entity LIKE '%(UN)%';

UPDATE POP_DEM
SET Geo_Classification = 'Category'
WHERE Entity IN (
    'High-income countries',
    'Land-locked developing countries (LLDC)',
    'Least developed countries',
    'Less developed regions',
    'Less developed regions, excluding China',
    'Less developed regions, excluding least developed countries',
    'Lower-middle-income countries',
    'Low-income countries',
    'More developed regions',
    'Small island developing states (SIDS)',
    'Upper-middle-income countries',
    'World'
);

UPDATE POP_DEM
SET Geo_Classification = 'Country'
WHERE Geo_Classification IS NULL;


---Generate table with needed columns and rows only
select
	entity,
	year,
	total_population
from POP_DEM
where Geo_Classification = 'Country'
order by entity asc
;