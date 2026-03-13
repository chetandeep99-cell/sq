SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_table;

-- subqueries
WITH january_jobs AS(
      SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
-- common table expression

/* we can use subqueries in 
SELECT, FROM, HAVING, WHERE
it is used when you want to run the inner query 
first and then it goes to the outer query */
SELECT 
    name AS company_name
FROM 
     company_dim
WHERE
   company_id IN (
SELECT 
     company_id
FROM 
    job_postings_fact
WHERE   

     job_no_degree_mention = true)





WITH  company_job_count AS(
SELECT 
      company_id,
      COUNT(*) AS total_jobs
FROM 
     job_postings_fact
GROUP BY
     company_id)


SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id


WITH remote_job_table AS (
SELECT 
    skill_id,
    COUNT(*) AS skill_count
 FROM 
     skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE 
    job_postings.job_work_from_home = TRUE AND
    job_title_short = 'Data Analyst'
GROUP BY 
     skill_id)
SELECT 
    remote_job_table.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_table
     
INNER JOIN skills_dim AS Skill ON skill.skill_id = remote_job_table.skill_id
order BY skill_count DESC
LIMIT 5;