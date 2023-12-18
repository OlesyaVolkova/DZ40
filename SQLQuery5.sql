--1. Вывести количество преподавателей кафедры “Software Development”.
SELECT COUNT(*) FROM Teachers WHERE Surname = 'Software Development'
--2. Вывести количество лекций, которые читает преподаватель “Dave McQueen”.
SELECT COUNT(*) FROM Lectures INNER JOIN Teachers ON Lectures.TeacherId = Teachers.Id INNER JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId WHERE Teachers.Name = 'Dave McQueen';
--3. Вывести количество занятий, проводимых в аудитории “D201”.
SELECT COUNT(*) FROM Lectures WHERE LectureRoom = 'D201'
--4. Вывести названия аудиторий и количество лекций, проводимых в них.
SELECT LectureRoom, COUNT(*) FROM Lectures GROUP BY LectureRoom
--6. Вывести среднюю ставку преподавателей факультета “Computer Science”.
SELECT AVG(Salary) FROM Teachers INNER JOIN Departments ON Teachers.Surname = Departments.Name WHERE Departments.FacultyId = 'Computer Science';
--7. Вывести минимальное и максимальное количество лекции среди всех групп.
SELECT MIN(LecturesCount) AS MinCount, MAX(LecturesCount) AS MaxCount FROM ( SELECT COUNT(Lectures.Id) AS LecturesCount FROM Groups INNER JOIN GroupsLectures ON Groups.Id = GroupsLectures.GroupId INNER JOIN Lectures ON GroupsLectures.LectureId = Lectures.Id GROUP BY Groups.Id ) AS LecturesCount;
--8. Вывести средний фонд финансирования кафедр.
SELECT AVG(Financing) FROM Departments
--9. Вывести полные имена преподавателей и количество читаемых ими дисциплин.
SELECT t.Name + ' ' + t.Surname AS "Teacher", COUNT(l.Id) AS "Lectures"
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
GROUP BY t.Name, t.Surname
--10. Вывести количество лекций в каждый день недели.
SELECT DayOfWeek, COUNT(*) FROM Lectures GROUP BY DayOfWeek
--11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.
SELECT LectureRoom, COUNT(DISTINCT GroupId) AS NumGroups FROM Lectures INNER JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId GROUP BY LectureRoom;
--12.Вывести названия факультетов и количество дисциплин, которые на них читаются.
SELECT Faculties.Name, COUNT(DISTINCT Subjects.Id) AS NumSubjects FROM Departments INNER JOIN Subjects ON Departments.Name = Subjects.Name INNER JOIN Faculties ON Departments.FacultyId = Faculties.Id GROUP BY Faculties.Name;
--13 Вывести количество лекций для каждой пары преподаватель-аудитория.
SELECT Teachers.Name, Lectures.LectureRoom, COUNT(DISTINCT Lectures.Id) AS NumLectures FROM Lectures INNER JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId INNER JOIN Groups ON GroupsLectures.GroupId = Groups.Id INNER JOIN Teachers ON Lectures.TeacherId = Teachers.Id GROUP BY Teachers.Name, Lectures.LectureRoom;

--База данных Академия(Academy)
﻿﻿create database Academy

use Academy 

--1. Кафедры (Departments)
--■ Идентификатор (Id). Уникальный идентификатор кафедры.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Финансирование (Financing). Фонд финансирования кафедры.
--▷ тип данных money
--▷ Не может содержать null-значения.
--▷ Не может быть меньше 0.
--▷ Значение по умолчанию 0
--■ Название (Name). Название кафедры.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
--■ Идентификатор факультета (FacultyId). Факультет, в состав которого входит кафедра.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Departments
(
	Id int not null primary key identity(1,1),
	Financing money not null check(Financing>=0) default 0,
	Name nvarchar(100) not null check(Name <> '') unique, 
	FacultyId int not null FOREIGN KEY REFERENCES Faculties(Id)
)

--2. Факультеты (Faculties)
--■ Идентификатор (Id). Уникальный идентификатор факультета.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Название (Name). Название факультета.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
create table Faculties
(
	Id int not null primary key identity(1,1),
Name nvarchar(100) not null check(Name <> '') unique,
)

--3. Группы (Groups)
--■ Идентификатор (Id). Уникальный идентификатор группы.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Название (Name). Название группы.
--▷ тип данных nvarchar(10)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
--■ Курс (Year). Курс (год) на котором обучается группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Должно быть в диапазоне от 1 до 5.
--■ Идентификатор кафедры (DepartmentId). Кафедра, в состав которой входит группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Groups
(
	Id int not null primary key identity(1,1),
	Name nvarchar(10) not null check(Name <> '') unique,
	Year int not null check(Year>=1 and Year<=5),
	DepartmentId int not null FOREIGN KEY REFERENCES Departments(Id)
)

--4. Группы и лекции (GroupsLectures)
--■ Идентификатор (Id). Уникальный идентификатор группы и лекции.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Идентификатор группы (GroupId). Группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
--■ Идентификатор лекции (LectureId). Лекция.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table GroupsLectures
(
	Id int not null primary key identity(1,1),
	GroupId int not null FOREIGN KEY REFERENCES Groups(Id), 
	LectureId int not null FOREIGN KEY REFERENCES Lectures(Id), 
)

--5. Лекции (Lectures)
--■ Идентификатор (Id). Уникальный идентификатор лекции.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ День недели (DayOfWeek). День недели, в который читается лекция.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Должен быть в диапазоне от 1 до 7.
--■ Аудитория (LectureRoom). Аудитория в которой читается лекция.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--■ Идентификатор дисциплины (SubjectId). Дисциплина, по которой читается лекция.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
--■ Идентификатор преподавателя (TeacherId). Преподаватель, который читает лекцию.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Lectures
(
	Id int not null primary key identity(1,1),
    DayOfWeek int not null check(DayOfWeek>=1 and DayOfWeek<=7),
	LectureRoom nvarchar(max) not null check(LectureRoom <> ''),
	SubjectId int not null FOREIGN KEY REFERENCES Subjects(Id),
	TeacherId int not null FOREIGN KEY REFERENCES Teachers(Id)
)

--6. Дисциплины (Subjects)
--■ Идентификатор (Id). Уникальный идентификатор дисциплины.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Название (Name). Название дисциплины.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
create table Subjects
(
	Id int not null primary key identity(1,1),
	Name nvarchar(100) not null check(Name <> '') unique
)

--7. Преподаватели (Teachers)
--■ Идентификатор (Id). Уникальный идентификатор преподавателя.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Имя (Name). Имя преподавателя.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--■ Ставка (Salary). Ставка преподавателя.
--▷ тип данных money
--▷ Не может содержать null-значения.
--▷ Не может быть меньше либо равно 0.
--■ Фамилия (Surname). Фамилия преподавателя.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
create table Teachers
(
	Id int not null primary key identity(1,1),
	Name nvarchar(max) not null check(Name <> ''),
	Salary money not null check(Salary>=0),
	Surname nvarchar(max) not null check(Surname <> '')
)
