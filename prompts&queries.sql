/*
#1) Jean Chavis, the advisor for economics, has been complaining that
her workload is much more than that of the other advisors. To
determine if this is the case, write a query that displays the number of
students each advisor oversees. The output should include each
Advisor's ID, first and last name, and the number of students they
advise (Hint: if an advisor advises multiple majors, that advisor
should still only appear once in your output). Order your results by
the number of students in descending order.
 */

SELECT 
    a.AdvisorID,
    a.AdvFName,
    a.AdvLName,
    COUNT(DISTINCT sm.StudentID) AS NumStudents
FROM Advisor a
JOIN Major m 
    ON a.AdvisorID = m.AdvisorID
JOIN Student_Major sm 
    ON m.MajorID = sm.MajorID
GROUP BY a.AdvisorID, a.AdvFName, a.AdvLName
ORDER BY NumStudents DESC;


/*
 #2) The registrar's office wants to notify students nearing graduation to
submit their graduation applications. Write a query that, for each
student in a declared major, displays the student's first and last name,
the name of their major, and how many credits they have completed
in that major. If a student has completed fewer than 30 credits in a
major, exclude them from the output. If a student has completed
between 30 and 44 credits (inclusive), indicate that they need to
begin their graduation application. If a student has completed 45 or
more credits, indicate that they need to submit their graduation
application. Order your results alphabetically by last name.
 */

SELECT 
    s.Fname,
    s.Lname,
    m.Department AS MajorName,
    sm.CreditsCompleted,
    CASE 
        WHEN sm.CreditsCompleted BETWEEN 30 AND 44 
            THEN 'Begin Graduation Application'
        WHEN sm.CreditsCompleted >= 45 
            THEN 'Submit Graduation Application'
    END AS GraduationStatus
FROM Student s
JOIN Student_Major sm 
    ON s.StudentID = sm.StudentID
JOIN Major m 
    ON sm.MajorID = m.MajorID
WHERE sm.CreditsCompleted >= 30
ORDER BY s.Lname, s.Fname;

/*
 #3) Write a query that displays each students' ID, their first and last
name, how many credits each student is enrolled in, how much
tuition they owe, and whether they have paid. Format the tuition
owed as a currency. Only include students taking between 9 and 15
credits. Order your output by tuition owed from least to greatest.
 */

SELECT 
    s.StudentID,
    s.Fname,
    s.Lname,
    SUM(c.Credits) AS TotalCredits,
    FORMAT(SUM(c.TotalCost), 'C', 'en-US') AS TuitionOwed,
    MAX(e.TuitionPaid) AS TuitionPaidStatus
FROM Student s
JOIN Enrollment e 
    ON s.StudentID = e.StudentID
JOIN Course_Section cs 
    ON e.CRN = cs.CRN
JOIN Course c 
    ON cs.CourseID = c.CourseID
GROUP BY s.StudentID, s.Fname, s.Lname
HAVING SUM(c.Credits) BETWEEN 9 AND 15
ORDER BY SUM(c.TotalCost);

/*
 #4) A company based in the northwestern United States has offered to
fund the education of students who may have financial need and are
from Idaho, Washington, or Oregon. The school's financial aid office
wants to compile a list of students who may qualify. Return the
StudentID, first name, last name, and household income of all
students from the above states (DO NOT use the "or" operator) and
whose household income is less than or equal to 40% of the school's
average household income. DO NOT calculate this value separately
and hard code it into your query. Generate a column that contains the
full state name that each student is from. Order your output
alphabetically by last name.
 */

SELECT 
    s.StudentID,
    s.Fname,
    s.Lname,
    s.HHI AS HouseholdIncome,
    CASE 
        WHEN s.State = 'ID' THEN 'Idaho'
        WHEN s.State = 'WA' THEN 'Washington'
        WHEN s.State = 'OR' THEN 'Oregon'
    END AS StateName
FROM Student s
WHERE s.State IN ('ID', 'WA', 'OR')
  AND s.HHI <= 0.40 * (SELECT AVG(HHI) FROM Student)
ORDER BY s.Lname, s.Fname;


/*
 #5) ESC wants to see how much they are paying their advisors, especially
per student. Write a query that shows each advisor, their salary, the
total number of students they are assigned, and generate a new
generate a new column that shows their salary per student. 
 */

SELECT 
    a.AdvisorID,
    a.AdvFName,
    a.AdvLName,
    a.Salary,
    COUNT(DISTINCT sm.StudentID) AS NumStudents,
    CASE 
        WHEN COUNT(DISTINCT sm.StudentID) = 0 
            THEN NULL
        ELSE CAST(a.Salary AS DECIMAL(10,2)) / COUNT(DISTINCT sm.StudentID)
    END AS SalaryPerStudent
FROM Advisor a
LEFT JOIN Major m 
    ON a.AdvisorID = m.AdvisorID
LEFT JOIN Student_Major sm 
    ON m.MajorID = sm.MajorID
GROUP BY a.AdvisorID, a.AdvFName, a.AdvLName, a.Salary
ORDER BY SalaryPerStudent DESC;


/*
 #6) Holly is a new student looking to join ESC. However, she lives in
California, so she needs to take all online classes. She has asked a
question that necessitates you to write a query that includes the
CourseID, the teachers first and last
name in a single cell, the teacher’s email, and the course’s total cost.
Only include classes that are online courses in the output. List by total
cost in ascending order.
 */

SELECT 
    c.CourseID,
    t.TeacherFname + ' ' + t.TeacherLname AS TeacherName,
    t.TeacherEmail,
    c.TotalCost
FROM Course c
JOIN Course_Section cs 
    ON c.CourseID = cs.CourseID
JOIN Teacher t 
    ON cs.TeacherID = t.TeacherID
WHERE cs.Delivery = 'Online'
ORDER BY c.TotalCost ASC;

/*
#7) The economics department would like to know more about how much
money its faculty earns. Using a subquery, output the number of
teachers currently teaching economics classes, as well as the
maximum, minimum, and average salary. Additionally, find the
standard deviation of the salaries. Format all dollar amounts as
currencies in your output. 
 */

SELECT 
    COUNT(*) AS NumTeachers,
    FORMAT(MAX(T.TeacherSalary), 'C', 'en-US') AS MaxSalary,
    FORMAT(MIN(T.TeacherSalary), 'C', 'en-US') AS MinSalary,
    FORMAT(AVG(T.TeacherSalary), 'C', 'en-US') AS AvgSalary,
    FORMAT(STDEV(T.TeacherSalary), 'C', 'en-US') AS SalaryStdDev
FROM Teacher T
WHERE T.TeacherID IN (
    SELECT DISTINCT cs.TeacherID
    FROM Course_Section cs
    JOIN Course c ON cs.CourseID = c.CourseID
    JOIN Major m ON c.MajorID = m.MajorID
    WHERE m.Department = 'Economics'
);


/*
 #8) The marketing team at ESC is looking to expand upon their
recruitment opportunities. They have bought an advertisement spot
at the local ski resort and must choose one out of the four offered
majors to highlight. Write a query that lists each major title and the
total number of students that have declared the given major. In
addition, output the Advisor's first name and last name (in a single
column), phone number (formatted), and email. Including this
contact information will give the marketing team the opportunity to
contact the advisor about program highlights that should be
emphasized on the billboard. Order the results by the total number of
students in descending order. As this opportunity may come up more
than once and enrollment numbers may change, create a stored
procedure to allow for quick analysis when need be.
 */

CREATE PROCEDURE GetMajorEnrollmentSummary
AS
BEGIN
    SELECT 
        m.Department AS MajorTitle,
        COUNT(DISTINCT sm.StudentID) AS NumStudents,
        a.AdvFName + ' ' + a.AdvLName AS AdvisorName,
        STUFF(STUFF(a.Phone, 4, 0, ') '), 1, 0, '(') AS AdvisorPhone,
        a.Email AS AdvisorEmail
    FROM Major m
    JOIN Advisor a 
        ON m.AdvisorID = a.AdvisorID
    LEFT JOIN Student_Major sm 
        ON m.MajorID = sm.MajorID
    GROUP BY m.Department, a.AdvFName, a.AdvLName, a.Phone, a.Email
    ORDER BY NumStudents DESC;
END;

EXEC GetMajorEnrollmentSummary;


/*
 #9) Create an encrypted view that shows the number of classes each
teacher is teaching. Include the TeacherID and first and last
name. Use a subquery to only include classes that take place
before 12:00 p.m. Order the results alphabetically first name.
 */

CREATE VIEW EncryptedTeacherClasses
WITH ENCRYPTION
AS
SELECT 
    t.TeacherID,
    t.TeacherFname,
    t.TeacherLname,
    (
        SELECT COUNT(*)
        FROM Course_Section cs
        WHERE cs.TeacherID = t.TeacherID
          AND cs.TimeofClass < '12:00:00'
    ) AS NumClasses
FROM Teacher t;


/*
 #10) Your turn! Create one insightful business problem/prompt and
write a query to address the problem/prompt. Please include the
prompt, query, and output below. 

Prompt: 

ESC wants to figure out which majors have the students that are the
furthest along in their studies. The idea is that if most students in a
program are close to graduating, the school may need to start planning
extra senior-level classes. Show the top 3 majors with the highest average
credits completed, along with the advisor for each major.
 */


SELECT TOP 3
    m.Department AS MajorTitle,
    a.AdvFName + ' ' + a.AdvLName AS AdvisorName,
    AVG(sm.CreditsCompleted) AS AvgCreditsCompleted
FROM Major m
JOIN Advisor a 
    ON m.AdvisorID = a.AdvisorID
JOIN Student_Major sm 
    ON m.MajorID = sm.MajorID
GROUP BY m.Department, a.AdvFName, a.AdvLName
ORDER BY AvgCreditsCompleted DESC;





