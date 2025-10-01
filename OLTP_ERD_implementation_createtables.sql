USE dw_haydenhatch;

CREATE TABLE [Advisor] (
  [AdvisorID] INT,
  [AdvFName] VARCHAR(50),
  [AdvLName] VARCHAR(50),
  [Email] VARCHAR(50),
  [Phone] VARCHAR(50),
  [Salary] INT,
  PRIMARY KEY ([AdvisorID])
);

CREATE TABLE [Major] (
  [MajorID] INT,
  [AdvisorID] INT,
  [ReqCredits] INT,
  [Department] VARCHAR(50),
  PRIMARY KEY ([MajorID]),
  CONSTRAINT [FK_Major_AdvisorID]
    FOREIGN KEY ([AdvisorID])
      REFERENCES [Advisor]([AdvisorID])
);

CREATE TABLE [Student] (
  [StudentID] INT,
  [Lname] VARCHAR(50),
  [Fname] VARCHAR(50),
  [DOB] DATE,
  [Gender] VARCHAR(50),
  [State] CHAR(2),
  [HHI] INT,
  PRIMARY KEY ([StudentID])
);

CREATE INDEX [Key] ON  [Student] ([DOB], [Gender], [State], [HHI]);

CREATE TABLE [Student_Major] (
  [StudentID] INT,
  [MajorID] INT,
  [CreditsCompleted] INT,
  PRIMARY KEY ([StudentID], [MajorID]),
  CONSTRAINT [FK_Student_Major_StudentID]
    FOREIGN KEY ([StudentID])
      REFERENCES [Student]([StudentID]),
  CONSTRAINT [FK_Student_Major_MajorID]
    FOREIGN KEY ([MajorID])
      REFERENCES [Major]([MajorID])
);

CREATE INDEX [Fk] ON  [Student_Major] ([MajorID]);

CREATE TABLE [Course] (
  [CourseID] INT,
  [MajorID] INT,
  [CourseCode] VARCHAR(50),
  [Credits] INT,
  [CourseFees] INT,
  [TotalCost] INT,
  PRIMARY KEY ([CourseID]),
  CONSTRAINT [FK_Course_MajorID]
    FOREIGN KEY ([MajorID])
      REFERENCES [Major]([MajorID])
);

CREATE TABLE [Teacher] (
  [TeacherID] INT,
  [TeacherLname] VARCHAR(50),
  [TeacherFname] VARCHAR(50),
  [TeacherEmail] VARCHAR(50),
  [TeacherPhone] VARCHAR(50),
  [TeacherSalary] INT,
  PRIMARY KEY ([TeacherID])
);

CREATE TABLE [Course_Section] (
  [CRN] INT,
  [CourseID] INT,
  [TeacherID] INT,
  [Delivery] VARCHAR(50),
  [Classroom] INT,
  [WeekDays] VARCHAR(50),
  [TimeofClass] TIME,
  PRIMARY KEY ([CRN]),
  CONSTRAINT [FK_Course_Section_CourseID]
    FOREIGN KEY ([CourseID])
      REFERENCES [Course]([CourseID]),
  CONSTRAINT [FK_Course_Section_TeacherID]
    FOREIGN KEY ([TeacherID])
      REFERENCES [Teacher]([TeacherID])
);

CREATE TABLE [Enrollment] (
  [CRN] INT,
  [StudentID] INT,
  [TuitionPaid] VARCHAR(50),
  PRIMARY KEY ([CRN], [StudentID]),
  CONSTRAINT [FK_Enrollment_StudentID]
    FOREIGN KEY ([StudentID])
      REFERENCES [Student]([StudentID]),
  CONSTRAINT [FK_Enrollment_CRN]
    FOREIGN KEY ([CRN])
      REFERENCES [Course_Section]([CRN])
);

CREATE TABLE [Student_Phone] (
  [StudentPhoneID] INT,
  [StudentID] INT,
  [PhoneNumber] VARCHAR(50),
  [Type] VARCHAR(50),
  PRIMARY KEY ([StudentPhoneID]),
  CONSTRAINT [FK_Student_Phone_StudentID]
    FOREIGN KEY ([StudentID])
      REFERENCES [Student]([StudentID])
);
