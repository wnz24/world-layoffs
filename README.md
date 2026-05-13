# 🗂️ Layoffs Data Analysis — SQL Project

A complete end-to-end SQL project covering data cleaning, standardization, and exploratory data analysis (EDA) on a real-world dataset of global tech layoffs.

---

## 📌 Project Overview

This project takes raw, messy layoffs data and transforms it into a clean, structured dataset ready for analysis. The goal was to practice real-world SQL skills that mirror what a data analyst does on the job — not just querying clean data, but preparing it first.

---

## 📁 Dataset

| Column | Description |
|--------|-------------|
| `company` | Name of the company |
| `location` | City/region of the company |
| `industry` | Industry sector |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Proportion of workforce laid off |
| `date` | Date of the layoff event |
| `stage` | Funding stage (Series A, IPO, etc.) |
| `country` | Country of the company |
| `funds_raised_millions` | Total funding raised in millions |

---

## 🧹 Part 1 — Data Cleaning & Standardization

Raw data is rarely clean. This stage involved:

- **Removing duplicates** — identified and dropped duplicate records
- **Standardizing values** — fixed inconsistent naming (e.g. same industry labeled differently)
- **Handling NULLs** — decided what to keep, fill, or remove
- **Fixing data types** — converted date column from text to proper DATE format
- **Trimming whitespace** — cleaned up extra spaces in text fields

---

## 🔍 Part 2 — Exploratory Data Analysis (EDA)

Once the data was clean, the analysis began. Key questions explored:

### General Overview
- What is the date range of the dataset?
- Which companies shut down entirely? (`percentage_laid_off = 1`)
- Did companies with more funding survive better?

### Aggregations
- Total layoffs by **company**
- Total layoffs by **industry**
- Total layoffs by **country**
- Total layoffs by **funding stage**
- Total layoffs by **year** and **month**

### Time Series
- Monthly layoff totals over time
- **Rolling total** of layoffs to track cumulative impact

### Rankings (CTE + Window Functions)
- Top 5 companies with most layoffs **per year**
- Top 10 industries with most layoffs **per year**
- Top 10 countries with most layoffs **per year**
- Top 10 funding stages with most layoffs **per year**

---

## 🛠️ SQL Concepts Used

| Concept | Usage |
|---------|-------|
| `GROUP BY` | Aggregating data by category |
| `ORDER BY` | Sorting results |
| `WHERE` | Filtering rows |
| `SUBSTRING()` | Extracting year-month from date |
| `YEAR()` | Extracting year from date |
| `SUM()` | Totalling layoffs |
| `AVG()` | Averaging percentage laid off |
| `MIN() / MAX()` | Finding date range |
| `CTEs (WITH)` | Breaking complex queries into steps |
| `DENSE_RANK()` | Ranking without gaps |
| `Window Functions` | Rolling totals with `OVER(ORDER BY)` |
| `PARTITION BY` | Resetting rank per year |

---

## 💡 Key Findings

- The dataset spans from **2020 to 2023**, covering the post-COVID tech downturn
- Several well-funded companies still laid off **100% of their workforce**
- The **tech and retail industries** were hit the hardest
- Layoffs peaked significantly in **2022-2023**
- The rolling total reveals how quickly layoffs **accelerated over time**

---

## 🚀 How to Run

1. Import the raw dataset into MySQL
2. Run the **cleaning scripts** first to create `layoffs_staging_f`
3. Run the **EDA scripts** to explore the cleaned data

---

## 🧰 Tools Used

- **MySQL** — all querying and analysis
- **MySQL Workbench** — writing and running queries

---

## 👤 Author

Made as a portfolio project to demonstrate real-world SQL skills in data cleaning, standardization, and exploratory analysis.
