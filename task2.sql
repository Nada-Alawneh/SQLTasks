--task5.1
create table accessCards(
CardId int primary key, 
CardNumber varchar(50) not null unique ,
EmployeeID int foreign key references Employee(EmployeeID)
);

insert into accessCards values (101,1),(102,2),(103,3);

select * from accessCards;


--task5.2
create table project (
projectID int primary key, 
projectName varchar(100) not null
);

insert into project values (1,'AI & Security Training'),(2,'Cloud Migration');

select * from project;


--junctionTable
create table EmployeeProjects(
AssignedDate date,
EmployeeID int foreign key references Employee(EmployeeID),
projectID int foreign key references project(projectID),
primary key (EmployeeID,projectID)
);

insert into EmployeeProjects values (1,1,'2026-10-29'),(1,2,'2026-10-29'),
(2,1,'2026-10-29'),
(3,2,'2026-10-29');

select * from EmployeeProjects



--task6.1
select Employee.FullName,Employee.Salary,Employee.DepartmentID from Employee
inner join Department
on 
Employee.EmployeeID = Department.DepartmentID

--task6.2
select Department.DepartmentName,Employee.FullName
from Department
left Join Employee
on Employee.EmployeeID = Department.DepartmentID

--task6.3
select Employee.FullName, AccessCards.CardNumber
from Employee
inner join AccessCards
on AccessCards.EmployeeID = Employee.EmployeeID


--task6.4
select Employee.FullName ,project.projectName,EmployeeProjects.AssignedDate
from EmployeeProjects
inner join project
on EmployeeProjects.EmployeeID = project.ProjectID
inner join Employee
on EmployeeProjects.ProjectID = project.ProjectID;


--task7.1
select Employee.DepartmentID,sum(Employee.Salary) as TotalSalary,count(Employee.EmployeeID) as EmployeeCount
from Employee
group by Employee.DepartmentID;


--task7.2
select Employee.DepartmentID,avg(Employee.Salary)as AvgSalary
from Employee
group by Employee.DepartmentID
having avg(Employee.Salary)>1000.00

--task7.3
select Employee.FullName,Salary
from Employee
where Salary > (
select avg(Salary) from Employee);

GO
--task7.4
create view vw_EmployeeDetails as
select EmployeeID ,Employee.FullName,Employee.Email , Department.DepartmentName
from Employee
inner join Department
on Employee.DepartmentID = Department.DepartmentID;

GO

--task7.5
create procedure sp_GetEmployeesByDepartment
    @DeptID int
as
begin
    select *
    from Employee
    where DepartmentID = @DeptID
    order by FullName;
end;

GO

--task7.6
create table EmployeeAudit (
    AuditID int primary key identity(1,1),
    EmployeeID int,
    Action varchar(50),
    ActionDate datetime
);

GO

create trigger trg_EmployeeDelete
on Employee
after delete
as
begin
    insert into EmployeeAudit (EmployeeID, Action, ActionDate)
    select EmployeeID, 'DELETE', GETDATE()
    from deleted;
end;

