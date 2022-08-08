select location, date, total_cases, new_cases, total_deaths, new_deaths, population
from PortfolioProject..coviddeaths
order by location, date

-- Looking at total cases vs total deaths in the US
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpct
from PortfolioProject..coviddeaths
where location = 'United States'
order by location, date

-- Looking at total cases vs population in the US
select location, date, total_cases, population, (total_cases/population)*100 AS Covidpospct
from PortfolioProject..coviddeaths
where location = 'United States'
order by location, date

-- Which countries have the highest infection 
select location, population, MAX(total_cases) AS highestcasecount, MAX((total_cases/population))*100 AS highestpctinfected
from PortfolioProject..coviddeaths
where continent is not null
group by location, population
order by highestpctinfected desc

-- Which countried have the highest death rate
-- total deaths is type varchar, so needs to be changed to integer
select location, MAX( cast (total_deaths as int)) AS totaldeathcount
from PortfolioProject..coviddeaths
where continent is not null
group by location
order by totaldeathcount desc

-- Looking at global numbers, what dates had the highest # of cases
select date, SUM(new_cases) AS totalglobalcasesbydate, SUM(cast (new_deaths as int)) AS totalglobaldeathsbydate, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS globaldeathpctbydate
from PortfolioProject..coviddeaths
where continent is not null
group by date
order by totalglobalcasesbydate desc

-- Now we can bring in our vaccination data and join with our deaths table
select *
from PortfolioProject..coviddeaths AS cd
JOIN PortfolioProject..covidvax AS cv
ON cd.location = cv.location AND cd.date = cv.date
where cd.continent is not null

-- Let's look at how much of the global population has been vaccinated
select cd.location, cd.date, cd.population, cv.people_vaccinated, (people_vaccinated/population)*100 AS rollingvaxtotal
from PortfolioProject..coviddeaths AS cd
JOIN PortfolioProject..covidvax AS cv
ON cd.location = cv.location AND cd.date = cv.date
where cd.continent is not null
order by cd.location, cd.date

-- Creating views to store data for viz
Create View Casesvdeaths as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpct
from PortfolioProject..coviddeaths
where location = 'United States'
--order by location, date

Create View Casesvpop as
select location, date, total_cases, population, (total_cases/population)*100 AS Covidpospct
from PortfolioProject..coviddeaths
where location = 'United States'
--order by location, date

Create View Globaldeaths as
select date, SUM(new_cases) AS totalglobalcasesbydate, SUM(cast (new_deaths as int)) AS totalglobaldeathsbydate, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS globaldeathpctbydate
from PortfolioProject..coviddeaths
where continent is not null
group by date
-- order by totalglobalcasesbydate desc

Create View Vaxtotal as
select cd.location, cd.date, cd.population, cv.people_vaccinated, (people_vaccinated/population)*100 AS rollingvaxtotal
from PortfolioProject..coviddeaths AS cd
JOIN PortfolioProject..covidvax AS cv
ON cd.location = cv.location AND cd.date = cv.date
where cd.continent is not null
--order by cd.location, cd.date