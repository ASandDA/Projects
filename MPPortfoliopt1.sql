select *
from monkeypox..monkeypox
-- Data has a count for World built in, so that is being removed from querys in order to not double count

-- Looking at cases by location
select location, cast (date as DATE) AS Date, new_cases, total_cases
from monkeypox..monkeypox
WHERE location != 'World'
order by location, date


--Looking at the highest case count per location
--Using a CTE to pull the date of the highest case count)
WITH CTE AS
(select *,
	ROW_NUMBER() OVER (Partition by location order by date desc) AS RN 
	from monkeypox..monkeypox
)
select CTE.location, CTE.total_cases AS highestcasecount, MAX(cast (mp.date as DATE)) AS Date_of_highest_case_count
from CTE
	Inner JOIN monkeypox..monkeypox AS mp ON CTE.location = mp.location
WHERE RN = 1
group by CTE.location, CTE.total_cases
order by CTE.location


-- Looking at total cases per country
select location, SUM(cast (new_cases as int)) AS totalcases
from monkeypox..monkeypox
where location != 'World'
group by location
with rollup
order by location

-- Looking at what percent of total global cases each country represents
DELETE from monkeypox..monkeypox
WHERE location = 'World'
select location, SUM(cast (new_cases as int)) AS totalcases,
ROUND(SUM(cast (new_cases as int))*100.00 / (select SUM(cast (new_cases as int)) from monkeypox..monkeypox), 2) AS percent_of_total_global_cases
from monkeypox..monkeypox
group by location
with rollup
order by percent_of_total_global_cases desc

Create View casesbylocation as
select location, cast (date as DATE) AS Date, new_cases, total_cases
from monkeypox..monkeypox
WHERE location != 'World'
--order by location, date

Create View highcountbylocation as
WITH CTE AS
(select *,
	ROW_NUMBER() OVER (Partition by location order by date desc) AS RN 
	from monkeypox..monkeypox
)
select CTE.location, CTE.total_cases AS highestcasecount, MAX(cast (mp.date as DATE)) AS Date_of_highest_case_count
from CTE
	Inner JOIN monkeypox..monkeypox AS mp ON CTE.location = mp.location
WHERE RN = 1
group by CTE.location, CTE.total_cases
--order by CTE.location

Create View totalcasesbylocation as
select location, SUM(cast (new_cases as int)) AS totalcases
from monkeypox..monkeypox
where location != 'World'
group by location
with rollup
--order by location

Create View percentglobal as
--DELETE from monkeypox..monkeypox
--WHERE location = 'World'
select location, SUM(cast (new_cases as int)) AS totalcases,
ROUND(SUM(cast (new_cases as int))*100.00 / (select SUM(cast (new_cases as int)) from monkeypox..monkeypox), 2) AS percent_of_total_global_cases
from monkeypox..monkeypox
group by location
with rollup
--order by percent_of_total_global_cases desc