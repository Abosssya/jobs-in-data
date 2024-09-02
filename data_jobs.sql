SELECT * FROM ds_jobs;    (https://www.kaggle.com/datasets/hummaamqaasim/jobs-in-data  link to the dataset)

-- QUERY 1 - Comparing average salary (EURO) in remote full-time Data Science jobs by experience level : Entry-level, Mid-level, Senior 

SELECT ROUND(AVG(salary),0) AS avg_salary ,
		job_title, 
		experience_level AS job_level
FROM ds_jobs
WHERE job_title = 'Data Scientist' 
		AND employment_type = 'Full-time'
		AND work_setting = 'Remote'
GROUP BY 2,3
ORDER BY 1 DESC;


-- QUERY 2 - Salary levels in different company sizes in Data analyst jobs in USA


SELECT company_size AS size,
		job_title,
		ROUND(AVG(salary),0) AS avg_salary,
		company_location AS country
FROM ds_jobs
WHERE job_title LIKE 'Data Analyst' 
		AND company_location ='United States'
GROUP BY 1,2,4
ORDER BY 3 DESC;


-- QUERY 3 - The highest-paying jobs in the countries with the most job registrations (using CTE)"

-- 1) finding 10 countries with the most job counted
WITH top_countries AS (
		SELECT COUNT(*) AS country_count,
				 company_location 
		FROM ds_jobs
		GROUP BY 2
		ORDER BY 1 DESC
		LIMIT 10)
-- 2) from previous query, finding the top 10 highest-paying jobs in these countries		
SELECT job_title, 
		MAX(salary) AS max_salary,
		ds_jobs.company_location, 
		salary_currency,
		salary_in_usd
FROM ds_jobs 
 JOIN top_countries ON ds_jobs.company_location = top_countries.company_location 
GROUP BY 1,3,4,5
ORDER BY 2 DESC
LIMIT 10;
		
		
-- QUERY 4 - The difference in min salary between full-time remote and full-time in-person job in UK
		

SELECT job_title, 
		MAX(salary) AS min_salary,
		experience_level AS job_level,
		employment_type,
		work_setting
FROM ds_jobs
WHERE employment_type = 'Full-time'
		AND work_setting =  'Remote' 
GROUP BY 1,3,4,5
ORDER BY 2 DESC
LIMIT 1;

SELECT job_title, 
		MAX(salary) AS min_salary,
		experience_level AS job_level,
		employment_type,
		work_setting
FROM ds_jobs
WHERE employment_type = 'Full-time'
		AND work_setting =  'In-person' 
GROUP BY 1,3,4,5
ORDER BY 2 DESC
LIMIT 1;

-- Mid-level Research Scientists working in-person have the highest salary at $450,000, indicating strong compensation for on-site roles. In contrast, Senior Data Scientists working remotely earn slightly less at $412,000, showing competitive pay for remote positions but with a premium for in-person work.
		
		
-- Query 5 - Change in average salary of Data Scientist job 
		
SELECT DISTINCT ON(work_year)
		work_year,
		job_title, 
		AVG(salary) OVER(PARTITION BY work_year ORDER BY 1 ) AS avg_salary
FROM ds_jobs
WHERE job_title = 'Data Scientist'
;
