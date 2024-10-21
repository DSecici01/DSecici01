select *
from portifolioProject..CovidDeaths
order by 3,4


-- select data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population 
From portifolioProject..CovidDeaths
order by 1,2


-- Looking at total Cases vs Total Deaths 

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portifolioProject..CovidDeaths
order by 1,2

-- looking at total cases from one specific country 

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portifolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got Covid 

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From portifolioProject..CovidDeaths
where location like '%states%'
order by 1,2


-- look at countries with highetst  infection rate compared to population 

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM portifolioProject..CovidDeaths
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc

--- showing countries with higehst death count per population 

SELECT Location, MAX(Total_deaths) as TotalDeathCount
FROM portifolioProject..CovidDeaths
GROUP BY Location
ORDER BY TotalDeathCount desc

SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portifolioProject..CovidDeaths
where continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


--- lets break things down by continent 

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portifolioProject..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portifolioProject..CovidDeaths
where continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

--- global numbers 

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from portifolioProject..CovidDeaths
where continent is not null 
order by 1,2

--- looking at total population and vaccinations 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
From portifolioProject..CovidDeaths dea
join portifolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccubated
From portifolioProject..CovidDeaths dea
join portifolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3

-- use CTE 

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccubated
From portifolioProject..CovidDeaths dea
join portifolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null

)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccubated
From portifolioProject..CovidDeaths dea
join portifolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- creating view to store data for later visualizations 

DROP view if exists PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccubated
From portifolioProject..CovidDeaths dea
join portifolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * 
from PercentPopulationVaccinated