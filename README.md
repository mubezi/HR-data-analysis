This HR data analysis was done in mysql and Power BI to create an HR employee distribution report


**Data used**
Data - HR Data with over 22000 rows from the year 2000 to 2020.

Data Cleaning & Analysis - MySQL Workbench

Data Visualization - PowerBI

**Summary of Findings**
*There are more male employees
*White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
*The youngest employee is 20 years old and the oldest is 57 years old
*4 age groups were created (20-29, 30-39, 40-49, 50-59). A large number of employees were between 30-39 followed by 20-29 while the smallest group was 50-59.
*A large number of employees work at the headquarters versus remotely.
*The average length of employment for terminated employees is around 8 years.
*The gender distribution across departments is fairly balanced but there are generally more male than female employees.
*The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
*A large number of employees come from the state of Ohio.
*The net change in employees has increased over the years.
*The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.

**Limitations**
*Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.
*Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
