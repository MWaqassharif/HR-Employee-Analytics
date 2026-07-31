CREATE DATABASE HR_Employee_Attrition;

USE HR_Employee_Attrition;
SELECT * FROM Employees;

/*=============================================
Q1. How many employees are there in the company?
================================================*/
SELECT COUNT(*) AS total_employees FROM Employees;

/*=============================================
Q2. Show all columns available in the dataset.
================================================*/
DESCRIBE   Employees;

/*=============================================
Q3. Show all unique departments.
================================================*/
SELECT DISTINCT Department FROM Employees;

/*=============================================
Q4. How many unique Job Roles are available?
================================================*/
SELECT COUNT(DISTINCT JobRole) As total_Job  FROM Employees;
/*=============================================
Observation: There are 9 unique job roles in the company.
================================================*/

/*=============================================
Q5. Show employees ordered by Monthly Income (Highest to Lowest).
================================================*/
SELECT JobRole,Department, MonthlyIncome 
FROM Employees
ORDER BY MonthlyIncome  DESC;

/*=============================================
Q6. How many employees left the company?
================================================*/
SELECT COUNT(*) AS left_company
FROM  Employees
WHERE Attrition = 'Yes';
/*=============================================
Observation: There are 237 employees who left the company.
================================================*/

 /*=============================================
Q7. Does lower salary increase employee attrition?
================================================*/
SELECT Attrition , Avg(MonthlyIncome)
FROM  Employees
GROUP BY Attrition;
/*=============================================
Observation: 
Employees who left the company had a lower average monthly income (4,787.09)
than employees who stayed (6,832.74).
================================================*/


 /*=============================================
Q8. Are employees who work overtime more likely to leave?
================================================*/
SELECT OverTime, Attrition , COUNT(*) As total_empolyees
FROM  Employees
GROUP BY OverTime, Attrition;
/*=============================================
Observation: 
127 employees who worked overtime left the company, compared to 110 employees who did not work overtime.
================================================*/


 /*=============================================
Q9. Which department has the highest employee attrition?
================================================*/
SELECT Department, Attrition , COUNT(*) As total_empolyees
FROM  Employees
WHERE Attrition = "Yes"
GROUP BY Department, Attrition
ORDER BY total_empolyees DESC;
/*=============================================
Observation: 
Research & Development has the highest employee attrition with 133 employees leaving the company.
================================================*/


 /*=============================================
Q10. Do Job Satisfaction and Work-Life Balance affect employee attrition?
================================================*/
SELECT JobSatisfaction, WorkLifeBalance, Attrition , COUNT(*) As total_empolyees
FROM  Employees
WHERE Attrition ="Yes" 
GROUP BY JobSatisfaction, WorkLifeBalance, Attrition
ORDER BY  total_empolyees DESC;
/*=============================================
Observation:
Employees with Job Satisfaction level 3 and Work-Life Balance level 3 had the highest attrition (43 employees).
================================================*/

 /*=============================================
Q11. Which Education Level has the Highest Salary?
================================================*/
SELECT Education , Avg(MonthlyIncome) As total_income
FROM  Employees
GROUP BY Education
ORDER BY total_income DESC;
/*=============================================
Observation:
Employees with Education Level 5 have the highest average monthly income (8,277.65).
================================================*/


 /*=============================================
Q12. Does the Distance from Home influence employee attrition?
================================================*/
SELECT Attrition , Avg( DistanceFromHome) As total_distance
FROM  Employees
GROUP BY Attrition;
/*=============================================
Observation:
Employees who left the company had a higher average distance from home (10.63) than employees who stayed (8.92).
================================================*/


 /*=============================================
Q13. Do employees with fewer years at the company have higher attrition?
================================================*/
SELECT Attrition , Avg(YearsAtCompany) As total_year
FROM  Employees
GROUP BY Attrition;
/*=============================================
Observation:
Employees who left the company had  fewer year at the company (5.1308) than employees who stayed (7.3690).
================================================*/

select 
max(MonthlyIncome),
min(MonthlyIncome) from Employees;  # 19999  to 1009
 /*=============================================
Q14. Create Salary Categories (Low, Medium, High)
================================================*/
SELECT MonthlyIncome,
CASE
  WHEN MonthlyIncome < 7000 THEN  'low_salary'
  WHEN  MonthlyIncome BETWEEN 7000 AND 15000 THEN 'medium_salary'
  ELSE 'high_salary'
END AS Salary_Category
FROM  Employees;


 /*=============================================
Q15.How many employees are in each salary category?
================================================*/
SELECT 
CASE
  WHEN MonthlyIncome < 7000 THEN  'low_salary'
  WHEN  MonthlyIncome BETWEEN 7000 AND 15000 THEN 'medium_salary'
  ELSE 'high_salary'
END AS Salary_Category,
COUNT(*) AS total_employees
FROM  Employees
GROUP BY Salary_Category;
/*=============================================
Observation:
Low Salary: 1,035 employees
Medium Salary: 302 employees
High Salary: 133 employees
================================================*/
select max(YearsAtCompany), min(YearsAtCompany) FROM Employees;
 /*=============================================
Q16. Create Experience Categories
================================================*/
SELECT YearsAtCompany,
CASE
  WHEN YearsAtCompany < 10 THEN  'Low Experience'
  WHEN  MonthlyIncome BETWEEN 10 AND 25 THEN 'Medium Experience'
  ELSE 'High_Experience'
END AS experience_Category
FROM  Employees;



 /*=============================================
Q17. Which Experience Category Has Highest Attrition?
================================================*/
SELECT 
CASE
  WHEN YearsAtCompany < 10 THEN  'Low Experience'
  WHEN  YearsAtCompany BETWEEN 10 AND 25 THEN 'Medium Experience'
  ELSE 'High_Experience'
END AS Experience_Category,
Attrition, COUNT(*) AS total_employees
FROM  Employees
WHERE Attrition = 'Yes'
GROUP BY Experience_Category ,Attrition
ORDER BY total_employees DESC;
/*=============================================
Observation:
Low Experience : 199 employees (highest  attrition)
Medium Experience: 34 employees 
High_Experience : 4 employees (lowest  attrition)
================================================*/


/*===============================================
Q18.How can employees be categorized into Low, Medium, and High Attrition Risk?
================================================*/
SELECT EmployeeNumber, JobRole, MonthlyIncome,
CASE 
WHEN  MonthlyIncome < 7000 AND JobSatisfaction = 1 AND  OverTime = 'Yes' THEN 'High Attritin'
WHEN  MonthlyIncome BETWEEN 7000 and 15000 AND JobSatisfaction = 2 AND  OverTime = 'Yes' THEN 'Medium Attritin'
ELSE 'Low Attritin'
END As Employees_Attrition_Risk
FROM Employees;


/*===============================================
Q19.Rank Employees by Salary
================================================*/
SELECT EmployeeNumber, EducationField,Department,MonthlyIncome,
ROW_NUMBER() OVER( ORDER BY MonthlyIncome DESC) As Salary_Rank
FROM Employees;


/*===============================================
Q20.Highest Paid Employee in Each Department
================================================*/
SELECT * FROM
(SELECT EmployeeNumber, EducationField,Department,MonthlyIncome,
ROW_NUMBER() OVER(PARTITION  BY Department   ORDER BY MonthlyIncome DESC) As Salary_Rank
FROM Employees) A 
WHERE Salary_Rank = 1;
/*=============================================
Observation:
The highest-paid employee in Human Resources earns 19,717.
The highest-paid employee in Research & Development earns 19,999.
The highest-paid employee in Sales earns 19,847.
================================================*/

/*===============================================
Q21.Top 2 Highest Paid Employees in Each Department
================================================*/
SELECT * FROM
(SELECT EmployeeNumber, EducationField,Department,MonthlyIncome,
ROW_NUMBER() OVER(PARTITION  BY Department   ORDER BY MonthlyIncome DESC) As Salary_Rank
FROM Employees) A 
WHERE Salary_Rank <=2;


/*===============================================
Q22.Top 2 Highest Paid Employees in Each Department(By Dense Rank)
================================================*/
SELECT * FROM
(SELECT EmployeeNumber, EducationField,Department,MonthlyIncome,
DENSE_RANK () OVER(PARTITION  BY Department   ORDER BY MonthlyIncome DESC) As Salary_Rank
FROM Employees) A 
WHERE Salary_Rank <=2;


/*===============================================
Q23.Previous Employee Salary (LAG)
================================================*/
SELECT EmployeeNumber, MonthlyIncome,
LAG(MonthlyIncome) OVER( ORDER BY MonthlyIncome) AS Pre_Salary
FROM Employees;

/*===============================================
Q24.Next Employee Salary (LEAD)
================================================*/
SELECT EmployeeNumber, MonthlyIncome,
LEAD(MonthlyIncome) OVER( ORDER BY MonthlyIncome) AS Pre_Salary
FROM Employees;


/*=========================================================
Q25.Departments Having Average Salary Greater Than Company Average
===========================================================*/
WITH department_salary AS
(
SELECT Department, AVG(MonthlyIncome) AS avg_salary
FROM Employees
GROUP BY  Department
)
SELECT* FROM department_salary
WHERE avg_salary > (SELECT AVG(MonthlyIncome) FROM Employees);
/*=============================================
Observation:
The Sales department has the highest average salary (6959.17), followed by Human Resources (6654.51). 
Both departments have an average salary higher than the overall company average.
================================================*/


