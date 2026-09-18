-- ============================================
-- HOUSEHOLD DEBT ANALYSIS — SQL PIPELINE
-- Source: Eurostat (tec00104, tipspd22, tec00113)
-- ============================================

-- ============================================
-- PART 1: DATA CLEANING
-- Raw SDMX-CSV tables imported directly from Eurostat,
-- cleaned into analysis-ready tables below.
-- ============================================

-- Clean table: household debt-to-income ratio
DROP TABLE IF EXISTS tec00104_debt_to_income;

CREATE TABLE tec00104_debt_to_income (
    country TEXT,
    year INTEGER,
    value REAL
);

INSERT INTO tec00104_debt_to_income (country, year, value)
SELECT TRIM(geo), CAST(TIME_PERIOD AS INTEGER), CAST(OBS_VALUE AS REAL)
FROM tec00104_raw
WHERE OBS_VALUE IS NOT NULL AND OBS_VALUE != '';

-- Clean table: household debt as % of GDP
DROP TABLE IF EXISTS tipspd22_debt_to_gdp;

CREATE TABLE tipspd22_debt_to_gdp (
    country TEXT,
    year INTEGER,
    value REAL
);

INSERT INTO tipspd22_debt_to_gdp (country, year, value)
SELECT TRIM(geo), CAST(TIME_PERIOD AS INTEGER), CAST(OBS_VALUE AS REAL)
FROM tipspd22_raw
WHERE OBS_VALUE IS NOT NULL AND OBS_VALUE != '';

-- Clean table: disposable income per capita
DROP TABLE IF EXISTS tec00113_disposable_income;

CREATE TABLE tec00113_disposable_income (
    country TEXT,
    year INTEGER,
    value REAL
);

INSERT INTO tec00113_disposable_income (country, year, value)
SELECT TRIM(geo), CAST(TIME_PERIOD AS INTEGER), CAST(OBS_VALUE AS REAL)
FROM tec00113_raw
WHERE OBS_VALUE IS NOT NULL AND OBS_VALUE != '';


-- ============================================
-- PART 2: ANALYSIS QUERIES
-- ============================================

-- Query 1: Rank countries by debt-to-income ratio, separately for each year
SELECT country, year, value,
       RANK() OVER (PARTITION BY year ORDER BY value DESC) AS debt_rank
FROM tec00104_debt_to_income
ORDER BY year, debt_rank;

-- Query 2: Year-over-year change in Poland's debt-to-income ratio
SELECT country, year, value,
       value - LAG(value) OVER (PARTITION BY country ORDER BY year) AS yoy_change
FROM tec00104_debt_to_income
WHERE country = 'Poland'
ORDER BY year;

-- Query 3: EU average debt-to-income ratio, excluding years with incomplete country coverage
SELECT year, AVG(value) AS eu_avg, COUNT(DISTINCT country) AS countries_reporting
FROM tec00104_debt_to_income
GROUP BY year
HAVING countries_reporting >= 20
ORDER BY year;

-- Query 4: Poland's debt-to-income ratio alongside debt-to-GDP ratio, joined by country and year
SELECT d.country, d.year, d.value AS debt_to_income, g.value AS debt_to_gdp
FROM tec00104_debt_to_income d
JOIN tipspd22_debt_to_gdp g
  ON d.country = g.country AND d.year = g.year
WHERE d.country = 'Poland'
ORDER BY d.year;