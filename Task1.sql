-- TemporaryStaff table 
create table TemporaryStaff (
StaffID int primary key,
StaffName varchar(250),
HireDate Date,
);


select * from TemporaryStaff
drop table TemporaryStaff



-- Departments table 
create table Department(
DepartmentID int primary key,
DepartmentName varchar(250) not null unique,
);

select * from Department

insert into Department values (1, 'IT')
insert into Department values (2, 'HR')
insert into Department values (3, 'Finance')



-- Employees Table
create table Employee(
EmployeeID int primary key,
FullName VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
Salary DECIMAL(10,2),
DepartmentID INT
);


select * from Employee
select FullName , Salary  from Employee

select sum(Salary)as TotalSalaries from Employee
select avg(Salary)as AverageSalary from Employee
select max(Salary)as HighestSalary from Employee
select min(Salary)as LowestSalary from Employee
select count(*)as TotalEmployees from Employee



alter table Employee ADD PhoneNumber varchar(20)

insert into Employee values (1,'Ahmad Ali', 'ahmad@techworld.com' , 1200.00 , 1  )
insert into Employee values (2,'Sara Hassan', 'sara@techworld.com' , 950.00  , 2  )
insert into Employee values (3,'Zaid Omar', 'zaid@techworld.com'  , 1500.00 , 1  )
insert into Employee values (4,'Mona Khaled' , 'mona@techworld.com'   , 800.00  , 3  )


update Employee set Salary = 1350.00 where EmployeeID = 1

delete from Employee where EmployeeID = 4

