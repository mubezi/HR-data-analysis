USE projects;

SELECT * FROM hr2;

SET AUTOCOMMIT = OFF;

ROLLBACK;

ALTER TABLE hr2
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

COMMIT;

DESCRIBE hr2;

SET sql_safe_updates = 0;

UPDATE hr2
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
END;

SELECT * from hr;

SELECT birthdate FROM hr;

ROLLBACK;

UPDATE hr2
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
SELECT * FROM hr2;

COMMIT;

ALTER TABLE hr2
MODIFY COLUMN hire_date DATE;

-- SET TERMDATE TO DATE WITHOUT TIMESTAMPS AND SET EMPTY ROWS TO NULL

UPDATE hr2
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

SELECT termdate FROM hr2;

ALTER TABLE hr2
MODIFY COLUMN termdate DATE;

UPDATE hr2
SET termdate = null
WHERE termdate='';

COMMIT; 

/* ADD THE AGE COLUMN*/
ALTER TABLE hr2
ADD COLUMN age INT;


UPDATE hr2
SET age = timestampdiff(YEAR,birthdate,CURDATE());

SELECT * FROM hr2;

SELECT 
	min(age) as youngest,
    max(age) as oldest
FROM hr2;

SELECT
COUNT(*) AS staff_and_above
FROM hr2
WHERE age >= 18;

COMMIT;

-- 1. what is the gender breakdown of employees in the company
SELECT gender, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
group by gender;

-- 2. what is the race/ethinicty breakdown of employees in the company

SELECT * FROM hr2;

SELECT race, COUNT(*) as count
FROM hr2
WHERE age >= 18 and termdate IS NULL
GROUP BY race;

-- 3. what is the age distribution of employees in the company

SELECT 
	min(age) as youngest,
    max(age) as oldest
FROM hr2
WHERE age >= 18 AND termdate IS NULL;


SELECT 
	CASE
		WHEN age >= 18 AND age <= 29 THEN '20-29'
        WHEN age >= 30 AND age <= 39 THEN '30-39'
        WHEN age >= 40 AND age <= 49 THEN '40-49'
        WHEN age >= 50 AND age <= 59 THEN '50-59'
	END AS age_group,
	COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE
		WHEN age >= 18 AND age <= 29 THEN '20-29'
        WHEN age >= 30 AND age <= 39 THEN '30-39'
        WHEN age >= 40 AND age <= 49 THEN '40-49'
        WHEN age >= 50 AND age <= 59 THEN '50-59'
	END AS age_group,
    gender,
	COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- 4. How many employess work at headoffice verus remote
SELECT * FROM hr2;

SELECT location, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. what is the average length of employment for employess that have been terminated

SELECT 
round(avg(datediff(termdate,hire_date))/365,0) AS avg_length_employment
FROM hr2
WHERE age>=18 AND termdate <=curdate() AND termdate IS NOT NULL;

-- 6. How does the gender distribution vary across department and job titles

SELECT department,  gender, count(*) as count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender, department
ORDER BY department;

SELECT jobtitle,  gender, count(*) as count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender, jobtitle
ORDER BY jobtitle;

SELECT jobtitle, count(*) as count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8 what department has the highest turnover rate
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    count(*) as total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr2
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;

-- 9. what is the distribution of employees across locations by city and state
SELECT 
	location_state,
    count(*) as count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

-- 10. how has the employee count changed over time based on hire and term dates

SELECT
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires *100,2) as net_change_percentage
FROM(
	SELECT
		year(hire_date) as year,
        count(*) AS hires,
        sum(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
	FROM hr2
    WHERE age >=18
    GROUP BY year(hire_date)
)as subquery
ORDER BY year ASC;

-- 11. what is the employee tenure for each department
SELECT
	department,
    round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr2
WHERE termdate IS NOT NULL AND termdate <= curdate() AND age >=18
GROUP BY department
ORDER BY department;
    

    
    