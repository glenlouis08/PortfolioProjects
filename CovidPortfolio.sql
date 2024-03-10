Select * from PortfolioProject..covidDeath
where continent is not null




--Looking at Total Cases Vs Total Deaths
--Shows likelihood of dying if you contact Covid in your country
Select Location,date,total_Cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covidDeath
where Location='India'
order by 1,2



--Looking at Total_Cases Vs Population
--Shows what population has got Covid
Select Location,date,total_Cases,Population, (Total_Cases/Population)*100 as PercentPopulationInfected
from PortfolioProject..covidDeath
where Location='India'
order by 1,2



-- Looking at Countries with Highest Infection Rates with compared to population
Select Location,population,max(total_Cases) as HighestInfectionCount,Max((Total_Cases/Population)*100) as
PercentPopulationInfected
from PortfolioProject..covidDeath
where continent is not null
group by location,population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per population

Select Location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
where continent is not null
group by location
order by TotalDeathCount desc


--SHOWING CONTINENTS WITH HIGHEST DEATH COUNT

Select LOCATION,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeath
where continent is null
group by LOCATION
order by TotalDeathCount desc


--GLOBAL NUMBERS
Select sum(new_cases) AS TOTAL_CASES ,sum(new_deaths) AS TOTAL_DEATHS,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..covidDeath
where continent is not null and new_cases<>0
--Group By Date
order by DeathPercentage desc


--Looking at Total Population vs Vaccinations







-- USE CTE

WITH PopVsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as ( select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 sum(convert(float,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) 
 AS ROLLING_PEOPLE_VACCINATED
from PortfolioProject..covidDeath dea
join PortfolioProject..covidVaccine vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
)

select *,(RollingPeopleVaccinated/Population)*100 from PopVsVac
order by 2,3


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
vaccine numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select dea.continent as continent,dea.location as location,dea.date as date,dea.population as population,
vac.new_vaccinations as vaccine,
 sum(convert(float,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) 
 AS RollingPeopleVaccinated
from PortfolioProject..covidDeath dea
join PortfolioProject..covidVaccine vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 


select *,(RollingPeopleVaccinated/Population)*100 from #PercentPopulationVaccinated
order by 2,3



 
 --Creating View to store data for later visualizations
 Create View PercentPopulationVaccinated as
select dea.continent as continent,dea.location as location,dea.date as date,dea.population as population,
vac.new_vaccinations as vaccine,
 sum(convert(float,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) 
 AS RollingPeopleVaccinated
from PortfolioProject..covidDeath dea
join PortfolioProject..covidVaccine vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null



Select * from PercentPopulationVaccinated