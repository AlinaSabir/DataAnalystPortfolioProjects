/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select * From dbo.CovidDeaths$;

Select location, date,total_cases, new_cases, total_deaths, population 
From CovidDeaths$ 
Where continent is not null order by 1,2;

--looking at total cases vs total deaths

Select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From CovidDeaths$ 
Where location like '%states%' order by 1,2 
;

--Looking at the total cases vs the population

Select location, date,total_cases, population, (total_cases/population)*100 as total_Case_population 
From CovidDeaths$  
order by 1,2;

--Countries with highest infection rate

Select location, Max(total_cases) as highestCount, population, 
Max((total_cases/population))*100 as PerInfected from CovidDeaths$ 
Where continent is not null 
Group By location, population 
order by PerInfected desc;

--showing countries with highest death count per population

-- by continent
Select location, 
Max(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths$ 
Where continent is null
Group By location
order by TotalDeathCount desc;

--showing continents with highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths$ 
Where continent is not null
Group By continent
order by TotalDeathCount desc;

--Global Numbers

Select  date, Sum(total_cases),sum(cast(total_deaths AS int))
From CovidDeaths$ 
Where continent is not null
group by date
order by 1,2 
;

Select  date, Sum(total_cases) as sumofcases,sum(cast(total_deaths AS int)) as sumofdeaths
From CovidDeaths$ 
Where continent is not null
group by date
order by 1,2 
;



Select  date, Sum(total_cases) as sumofcases,sum(cast(total_deaths AS int)) as sumofdeaths,
sum(cast(total_deaths AS int))/Sum(total_cases) as percentage
From CovidDeaths$ 
Where location = 'Pakistan'
group by date
order by 1,2
;


Select Sum(total_cases) as sumofcases,sum(cast(total_deaths AS int)) as sumofdeaths,
sum(cast(total_deaths AS int))/Sum(total_cases) as percentage
From CovidDeaths$ 
order by 1,2
;

----------------------------------------------------------------------------------

Select * From CovidVaccinations$

--Joins
--looking at total population vs vaccination

Select * From CovidDeaths$ dea 
join CovidVaccinations$ vac 
on dea.location= vac.location
and dea.date= vac.date;


Select dea.continent, dea.date,dea.location, dea.population, vac.new_vaccinations From CovidDeaths$ dea 
join CovidVaccinations$ vac 
on dea.location= vac.location
and dea.date= vac.date
where vac.new_vaccinations is not null and dea.continent is not null
order by 1,2,3
;


Select dea.continent, dea.date,dea.location, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location)
From CovidDeaths$ dea 
join CovidVaccinations$ vac 
on dea.location= vac.location
and dea.date= vac.date
where vac.new_vaccinations is not null and dea.continent is not null
order by 1,2,3
;


Select dea.continent, dea.date,dea.location, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
,(RollingPeopleVaccinated/population)*100 as Percentage
From CovidDeaths$ dea 
join CovidVaccinations$ vac 
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null and dea.location= 'Albania'
order by 1,2,3
;

--CTE

With PopvsVac (Continent,Date, Location,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.date,dea.location, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
--,(RollingPeopleVaccinated/population)*100 as Percentage
From CovidDeaths$ dea 
join CovidVaccinations$ vac 
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 1,2,3
)

Select * ,(RollingPeopleVaccinated/population) *100 From PopvsVac


















