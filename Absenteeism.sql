--- connect employee with compensation then with Reasons using join
select * from employee as a
left join compensation as b
on a.ID = b.ID
left join Reasons as r
on a.Reason_for_absence = r.Number
;

--- display the employees with lower absent count, with normal bmi who are non-smokers and non-drinkers - the measure for healthy person for the Healthy Bonus Program
select * from employee
where
Social_drinker = 0 and
Social_smoker = 0 and
Absent_time_in_h < (select avg(Absent_time_in_h) from employee) and
Body_mass_index >= 18.5 and Body_mass_index<=24.9
order by Body_mass_index asc
;

---Wage Increase or annual compensation for Non-Smokers; Insurance Budget of $983,221 for all Non-Smokers
---display total number of non-smokers; total # = 686
SELECT
Social_smoker,
count(*) as total_#
FROM employee
GROUP BY Social_smoker
ORDER BY Social_smoker ASC
;

--- calculate the amount of increase in the rate per hour for the 686 qualified employees
--- total # of non-smokers = (select count(*) from employee where Social_smoker = 0)
--- budget = 983221/year = 18908/week (52 weeks) = 3781/workday(5 days) = 472 / hr for 686 qualified employees = $0.68 per hour increase per qualified employee
select 983221 / (8*5*52)
select 983221 / 52
select 18908 / 5
select 3781 / 8

--- FINAL / OPTIMIZED QUERY
select 
a.ID,
Age,
Service_time,
b.comp_hr,
Absent_time_in_h,
r.Reason Reason_for_Absence,
Month_of_absence,
case
	when Month_of_absence in(12,1,2) then 'Winter'
	when Month_of_absence in(3,4,5) then 'Spring'
	when Month_of_absence in(6,7,8) then 'Summer'
	when Month_of_absence in(9,10,11) then 'Fall'
	else 'Unknown' end Season_of_Absence,
Weight,
Height,
Body_mass_index,
case
	when Body_mass_index < 18.5 then 'Underwheight'
	when Body_mass_index >=18.5 and Body_mass_index <= 24.9 then 'Healthy'
	when Body_mass_index >=25 and Body_mass_index <= 29.9 then 'Overwheight'
	when Body_mass_index >=30 and Body_mass_index <= 39.9 then 'Obese'
	when Body_mass_index >=40 then 'Severly Obese'
	else 'Unkown' end as BMI_Category,
case
	when Social_drinker = 0 then 'Without Alcohol Drinking Habit'
	when Social_drinker = 1 then 'With Alcohol Drinking Habit'
	else 'Unknown' end as Social_Drinking_Habit,
case
	when Social_smoker = 0 then 'Without Smoking Habit'
	when Social_smoker = 1 then 'With Smoking Habit'
	else 'Unknown' end as Social_Smoking_Habit,
Day_of_the_week,
Disciplinary_failure,
Dis_from_Res_to_Work,
Transport_expense,
Workload_Ave_day,
Hit_target,
Education,
Son Number_of_Children,
Pet Number_of_pets
from employee as a
left join compensation as b
on a.ID = b.ID
left join Reasons as r
on a.Reason_for_absence = r.Number
;
