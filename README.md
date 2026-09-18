# Household Debt in Poland vs EU

A Power BI dashboard analyzing household debt-to-income levels across the 
EU, with a focus on Poland — combining Eurostat data, DAX modeling, SQL 
data preparation, and a Python-based time-series forecast.

## Overview

Poland's household debt-to-income ratio has declined from 55% in 2014 to 
36% in 2024 — well below the EU average and the EU Commission's 55% 
debt-to-GDP risk threshold. This project explores that trend, compares 
Poland to its EU peers, and forecasts where the ratio is heading through 
2027.

## Tools

- **Power BI** — dashboard, data modeling, DAX measures
- **Power Query** — data cleaning and transformation
- **Python** (pandas, statsmodels, scikit-learn) — time-series forecasting
- **SQL** (SQLite) — data cleaning pipeline and analytical queries 
  (window functions: RANK, LAG)

## Data Sources

- Eurostat, [tec00104](https://ec.europa.eu/eurostat/databrowser/product/page/tec00104) 
  — Household debt-to-income ratio
- Eurostat, [tipspd22](https://ec.europa.eu/eurostat/databrowser/view/tipspd22) 
  — Household debt, % of GDP
- Eurostat, [tec00113](https://ec.europa.eu/eurostat/databrowser/product/view/tec00113) 
  — Adjusted gross disposable income per capita
- Data downloaded: 15.09.2026

## Dashboard Structure

**1. Overview** — Current debt-to-income level, YoY change, EU ranking, 
and debt-to-GDP vs. the 55% risk threshold.

**2. Trend** — Poland vs. EU average over time (2014–2024), plus 
year-over-year change. Years with incomplete EU country coverage are 
excluded from the average.

**3. Country Comparison** — All EU countries ranked by debt-to-income 
ratio, with Poland highlighted. A scatter plot compares disposable income 
against debt levels to explore whether higher-income countries carry more 
or less relative debt.

**4. Forecast** — 3-year forecast (2025–2027) using Holt's linear trend 
method, selected from three candidates (SES, Holt, linear regression) 
based on the lowest MSE on a 2-year holdout test. Includes a 95% 
confidence interval, widening over the forecast horizon to reflect growing 
uncertainty.

## Key Insights

- Poland's debt-to-income ratio fell ~19 percentage points over the past 
  decade — consistent deleveraging, not a short-term fluctuation
- Despite the decline, Poland's gap versus the EU average has not 
  narrowed, as EU-wide debt also fell but from a much higher base
- At 22.6% debt-to-GDP, Poland ranks 23rd of 27 EU member states — 
  well below the Commission's 55% risk threshold
- Poland combines moderate disposable income with debt levels clearly 
  lower than income-comparable peers

## Methodology Notes

Three forecasting methods were tested on a 2-year holdout: Simple 
Exponential Smoothing (MSE 74.6), Holt's linear trend (MSE 17.8), and 
linear regression (MSE 119.8). Holt was selected and applied to the full 
dataset. Confidence intervals were derived from the model's residual 
standard error rather than a second statsmodels implementation, after an 
initial ETS-based attempt produced a degenerate fit (near-zero smoothing 
parameter) on this short time series.

## Files

- `Household-Debt-Dashboard.pbix` — Power BI dashboard
- `Household-Debt PYTHON FORECAST.ipynb` — Python forecasting notebook
- `SQL cleaning and queries.sql` — SQL data cleaning + analytical queries
- `Household-Debt DATA/` — Source CSV files from Eurostat
