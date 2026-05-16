Create Database HospitalData;

drop Table if exists Hospital;
create Table Hospital(
	Name varchar(100),
	Location Varchar(100),
	Department Varchar(100),
	Doctors_Count int,
	Patients_count int,
	Admission_Date Date,
	Discharge_Date Date,
	Medical_Expenses float
)

Select * from Hospital

Copy Hospital(Name,Location,Department,Doctors_count,Patients_count,Admission_date,Discharge_date,Medical_expenses)
from 'C:\Users\Public\Hospital_Data.csv'
CSV HEader

--1.Total Number of Patients
--Write an SQL query to find the total number of patients across all hospitals.
Select Distinct(Name),Sum(Patients_count) from Hospital
group by name


--2.Average Number of Doctors per Hospital
--Retrieve the average count of doctors available in each hospital.
Select Distinct(name),Round(Avg(Doctors_count),2) from Hospital
group by name


--3.Top 3 Departments with the Highest Number of Patients
--Find the top 3 hospital departments that have the highest number of patients.
Select Distinct Department,sum(Patients_count) as total_patients from Hospital
group by department
order by total_patients desc limit 3


--4.Hospital with the Maximum Medical Expenses
--Identify the hospital that recorded the highest medical expenses.
Select distinct name,sum(Medical_expenses) as total_exp from hospital
group by name
order by total_exp desc  limit 1


--5.Daily Average Medical Expenses
--Calculate the average medical expenses per day for each hospital.
Select name,Avg
	(medical_expenses/Nullif((Discharge_date-admission_date),0)
	)as Avg_daily_exp from hospital
group by name


--6.Longest Hospital Stay
--Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date.
Select name,(Discharge_date-admission_date) as Days_stayed from hospital
order by days_stayed desc limit 1


--7.Total Patients Treated Per City
---Count the total number of patients treated in each city.
Select distinct location,sum(Patients_count) as total_patients_treated from hospital
group by location
order by total_patients_treated desc 

--8.Average Length of Stay Per Department
---Calculate the average number of days patients spend in each department.
Select department,Round(Avg(
	Discharge_date - admission_date),2
) as Avg_num_days from hospital
group by department
order by avg_num_days desc


--9.Identify the Department with the Lowest Number of Patients
--Find the department with the least number of patients.
Select Department,sum(patients_count) as Patients_num from hospital
group by department
order by Patients_num asc limit 1


--10.Monthly Medical Expenses Report
--Group the data by month and calculate the total medical expenses for each month.
Select Trim(to_char(admission_date,'month')) as month,
Sum(medical_expenses) as Total_expenses
from hospital

group by month,extract(month from Admission_date)
order by extract(month from admission_date)