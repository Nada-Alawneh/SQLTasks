--Stage 1
CREATE TABLE TempInstructors (
    TempID INT PRIMARY KEY,
    TempName VARCHAR(50), 
    JoinedDate DATE
);

--Stage 2
--Task 2.1
CREATE TABLE Departments(
    DepartmentID INT PRIMARY KEY, 
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

--Task 2.2 (1:N with Departments)
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    GPA DECIMAL(3,2), 
    DEPID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

--Task 2.3 (1:1 Relation with Students)
CREATE TABLE StudentProfiles (
    ProfileID INT PRIMARY KEY, 
    STUID INT UNIQUE FOREIGN KEY REFERENCES Students(StudentID),
    Address VARCHAR(200),
    EmergencyPhone VARCHAR(20)
);

--Task 2.4 (1:N with Departments)
CREATE TABLE Courses(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL, 
    Credits INT, 
    DEPID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

--Task 2.5(M:N Junction Table)
CREATE TABLE StudentCourses(
    STUID INT FOREIGN KEY REFERENCES Students(StudentID),
    COURID INT FOREIGN KEY REFERENCES Courses(CourseID),
    EnrollmentDate DATE DEFAULT CAST(GETDATE() AS DATE),
    PRIMARY KEY(STUID, COURID)
);

--Task 2.6: ALTER & DROP Operations
ALTER TABLE Students ADD Age INT;
DROP TABLE TempInstructors;

--Stage 3 Data Insertion & Updates 
--Task 3.1: Insert Departments
INSERT INTO Departments VALUES 
(1, 'Computer Science'), 
(2, 'Software Engineering'), 
(3, 'Business Administration');

SELECT * FROM Departments; 

--Task 3.2: Insert Students
INSERT INTO Students VALUES 
(101,'Ali Smadi','ali@coursehub.com',3.80,1,22),
(102,'Omar Ahmad','omar@coursehub.com',2.90,1,21),
(103,'Laila Hassan','laila@coursehub.com',3.50,2,23),
(104,'Tariq Zaid','tariq@coursehub.com',2.10,3,20);

SELECT * FROM Students; 

--Task 3.3: Insert Student Profiles (1:1)
INSERT INTO StudentProfiles VALUES 
(1, 101, 'Amman, Jordan', '0791111111'),
(2, 102, 'Irbid, Jordan', '0792222222'),
(3, 103, 'Zarqa, Jordan', '0793333333');

--Task 3.4: Insert Courses
INSERT INTO Courses VALUES 
(201, 'Database Systems', 3, 1),
(202, 'Web Development', 3, 1),
(203, 'Software Architecture', 3, 2);

--Task 3.5: Enroll Students in Courses (M:N)
INSERT INTO StudentCourses (STUID, COURID) VALUES 
(101, 201), (101, 202), (102, 201), (103, 203); 

SELECT * FROM StudentCourses; 

--Task 3.6: Update & Delete Operations
UPDATE Students SET GPA = 2.50 WHERE StudentID = 104;
DELETE FROM Students WHERE StudentID = 104;

--Stage 4: Multi-Table Joins & Relations 
--Task 4.1
SELECT FullName, GPA, DepartmentName 
FROM Students
INNER JOIN Departments ON Students.DEPID = Departments.DepartmentID;

--Task 4.2
SELECT Departments.DepartmentName, Students.FullName 
FROM Departments
LEFT JOIN Students ON Departments.DepartmentID = Students.DEPID;

--Task 4.3
SELECT FullName, Address, EmergencyPhone 
FROM StudentProfiles
INNER JOIN Students ON StudentProfiles.STUID = Students.StudentID;

--Task 4.4 
SELECT FullName, CourseName, EnrollmentDate 
FROM Students 
INNER JOIN StudentCourses ON Students.StudentID = StudentCourses.STUID
INNER JOIN Courses ON StudentCourses.COURID = Courses.CourseID;

--Stage 5: Aggregations, Grouping & Filtering 
--Task 5.1
SELECT count(StudentID) AS TotalStudents, avg(GPA) AS AverageGPA, max(GPA) AS HighestGPA, min(GPA) AS LowestGPA 
FROM Students;

--Task 5.2
SELECT DEPID, avg(GPA) AS AverageGPA, count(StudentID) AS TotalStudents 
FROM Students
GROUP BY DEPID;

--Task 5.3
SELECT DEPID, avg(GPA) AS AverageGPA 
FROM Students
GROUP BY DEPID
HAVING avg(GPA) > 3.00;

--Task 5.4
SELECT DEPID, count(StudentID) AS TotalStudents 
FROM Students
WHERE GPA >= 2.50
GROUP BY DEPID
HAVING count(StudentID) > 1;

--Indexing 
--Task 6.1: The column 'StudentID' has a Clustered Index by default because it is the Primary Key.

--Task 6.2: Create a Non-Clustered Index
CREATE NONCLUSTERED INDEX IX_Students_Email ON Students(Email);
EXEC sp_helpindex 'Students'; 

--Stage 7: Advanced SQL Objects 
--Task 7.1
SELECT FullName, GPA FROM Students
WHERE GPA > (SELECT AVG(GPA) FROM Students);
GO

--Task 7.2
CREATE VIEW vw_StudentAcademicDetails AS
SELECT 
    Students.StudentID, 
    Students.FullName, 
    Students.GPA, 
    Departments.DepartmentName 
FROM Students
INNER JOIN Departments ON Students.DEPID = Departments.DepartmentID;
GO

SELECT * FROM vw_StudentAcademicDetails; 
GO

--Task 7.3
CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
    SELECT * 
    FROM Students 
    WHERE DEPID = @DeptID;
END;
GO

EXEC sp_GetStudentsByDepartment @DeptID = 1; 
GO