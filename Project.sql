Select * 
From Covid_Data.covid_deaths;

Select *
From Covid_Data.covid_vaccinations;

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_Data.covid_deaths
Order by Location, date;


#Total Cases vs Total Deaths --(Death percantage if you contacted Covid)

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS death_percentage
From Covid_Data.covid_deaths
Where Location like 'Europe'
Order by Location, date;

# Total Cases vs Population --(What percent of population has gotten Covid)

Select Location, date, total_cases, Population,(total_cases/Population)*100 AS InfectedPopulationPercent
From Covid_Data.covid_deaths
Where Location like 'Europe'
Order by 1, 2;

# Countries with the Highest Infection Rate compared to Population

Select Location, MAX(total_cases) as HighestInfectionCount, Population,MAX((total_cases/Population))*100 AS InfectedPopulationPercent
From Covid_Data.covid_deaths
Group by Population, Location
Order by InfectedPopulationPercent desc;

# Countries with the Highest Death Count per population

Select Location, MAX(cast(total_deaths as SIGNED)) AS TotalDeathsCount
From Covid_Data.covid_deaths
Group by Location
Order by HighestDeathsCount desc;

#Continents with the Highest Death Count

Select continent, MAX(cast(total_deaths as SIGNED)) AS TotalDeathsCount
From Covid_Data.covid_deaths
Where continent is not null
Group by 1
Order by 2 desc;

#Global numbers

Select SUM(cast(new_cases as SIGNED)) as total_cases, SUM(cast(new_deaths as SIGNED)) as total_deaths, SUM(cast(new_deaths as SIGNED))/SUM(cast(new_cases as SIGNED))*100 as DeathPercentage
from Covid_Data.covid_deaths
# Group by date
Order by 1, 2;

## Total population vs Vaccination

Select dea.continent, dea.location,  
SUM(Cast(vax.new_vaccinations as Signed)) as total_new_vax, Sum(Population) as  total_population
From Covid_Data.covid_deaths as dea
Join Covid_Data.covid_vaccinations as vax
    On dea.location = vax.location
    and dea.date = vax.date
    Group by dea.continent, dea.location
    Order by dea.continent;

##Rolling count new tests per day

Select dea.continent, dea.location, dea.date, dea.population, vax.new_tests,
SUM(CAST(vax.new_tests as Signed)) over (partition by dea.location order by dea.location, dea.date) as RollingNewTests
From Covid_Data.covid_deaths as dea
Join Covid_Data.covid_vaccinations as vax
    On dea.location = vax.location
    and dea.date = vax. date
    order by 2,3;

## Percent of total vaccinated population

Select dea.continent, dea.location, dea.date, dea.population, vax.total_vaccinations, Round((total_vaccinations/Population)*100, 3) as PercentPopulationVax, 
case when Round((total_vaccinations/Population)*100, 3) > 100 then 'due to second dose of the vaccine not indicated in the dataset' ELSE '' end as test
from Covid_Data.covid_deaths as dea
Join Covid_Data.covid_vaccinations as vax
    On dea.location = vax.location
    and dea.date = vax. date
Order by 2,3;


## Rolling count new vaccination per day

Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(CAST(vax.new_vaccinations as Signed)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVax
From Covid_Data.covid_deaths as dea
Join Covid_Data.covid_vaccinations as vax
    On dea.location = vax.location
    and dea.date = vax. date
    order by 2,3;

