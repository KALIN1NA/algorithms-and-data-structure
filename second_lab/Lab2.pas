 {17. В   некотором   институте   приобретаемые    компьютеры
выделяются   различным   факультетам  поочередно.  В  пределах
факультетов имеются очереди из кафедр.  Факультет,  получивший
компьютер,  перемещается  в  конец очереди,  а соответствующая
кафедра   исключается   из   факультетской   очереди.    Вновь
организованные факультеты и кафедры занимают последние места в
соответствующих очередях.  Составить программу ведения очереди
на компьютеры (9).
Калинина Анна, ПС-21}

PROGRAM ComputerQueueManagement;

TYPE
  Department = RECORD
                  Name: STRING;
                  Next: ^Department
               END;

  Faculty = RECORD
              Name: string;
              Head: ^Department;
              Tail: ^Department;
              Next: ^Faculty
            END;

VAR
  Head: ^Faculty;
  Tail: ^Faculty;
  Choice: INTEGER;
  FacultyName, DepartmentName: STRING;
  InputFile, OutputFile: STRING;
  InFile, OutFile: TEXT;
  Line: STRING;
  SpaceIndex: INTEGER;

PROCEDURE AddFaculty(Name: STRING);
VAR
  newFaculty: ^Faculty;
BEGIN
  NEW(newFaculty);
  newFaculty^.Name := Name;
  newFaculty^.Head := NIL;
  newFaculty^.Tail := NIL;
  newFaculty^.Next := NIL;

  IF Head = NIL
  THEN
    BEGIN
      Head := newFaculty;
      Tail := newFaculty;
    END
  ELSE
    BEGIN
      Tail^.Next := newFaculty;
      Tail := newFaculty;
    END
END;

PROCEDURE AddDepartment(FacultyName, DepartmentName: STRING);
VAR
  newDepartment: ^Department;
  currentFaculty: ^Faculty;
BEGIN
  NEW(newDepartment);
  newDepartment^.Name := DepartmentName;
  newDepartment^.Next := NIL;
  currentFaculty := Head;
  WHILE currentFaculty <> NIL
  DO
    BEGIN
      IF currentFaculty^.Name = FacultyName 
      THEN
        BEGIN
          IF currentFaculty^.Head = NIL
          THEN
            BEGIN
              currentFaculty^.Head := newDepartment;
              currentFaculty^.Tail := newDepartment;
            END
          ELSE
            BEGIN
              currentFaculty^.Tail^.Next := newDepartment;
              currentFaculty^.Tail := newDepartment;
            END;
          EXIT
        END;
      currentFaculty := currentFaculty^.Next
    END;
  AddFaculty(FacultyName);
  AddDepartment(FacultyName, DepartmentName);
END;

PROCEDURE AllocateComputer;
VAR
  AllocatedDepartment, FirstDepartment: ^Department;
  AllocatedFaculty, PrevFaculty: ^Faculty;
BEGIN
  AllocatedDepartment := NIL;
  FirstDepartment := NIL;
  AllocatedFaculty := NIL;
  PrevFaculty := NIL;
  IF Head <> NIL 
  THEN
    BEGIN
      AllocatedFaculty := Head;
      IF Head^.Next <> NIL 
      THEN
        Head := Head^.Next
      ELSE
        Head := NIL;
      PrevFaculty := Tail;
      Tail^.Next := AllocatedFaculty;
      AllocatedFaculty^.Next := NIL;  
      FirstDepartment := AllocatedFaculty^.Head;
      IF FirstDepartment <> NIL
      THEN
        BEGIN
          AllocatedDepartment := FirstDepartment;
          FirstDepartment := FirstDepartment^.Next;
          AllocatedFaculty^.Head := FirstDepartment;
          WRITELN('компьютер выдан факультету ', AllocatedFaculty^.Name, ' с кафедрой ', AllocatedDepartment^.Name);
          Dispose(AllocatedDepartment);
        END;
      IF AllocatedFaculty^.Head = NIL
      THEN
        BEGIN
          IF Head = NIL
          THEN
            Tail := NIL
          ELSE
            Tail := PrevFaculty;
          Dispose(AllocatedFaculty)
        END;
    END
  ELSE
    WRITELN('Нет факультетов в очереди')
END;

PROCEDURE DisplayQueue;
VAR
  currentFaculty: ^Faculty;
  currentDepartment: ^Department;
BEGIN
  currentFaculty := Head;
  WHILE currentFaculty <> NIL
  DO
    BEGIN
      WRITELN('Факультет: ', currentFaculty^.Name);
      currentDepartment := currentFaculty^.Head;
      WHILE currentDepartment <> NIL
      DO
        BEGIN
          WRITELN(' - Кафедра: ', currentDepartment^.Name);
          currentDepartment := currentDepartment^.Next;
        END;
      currentFaculty := currentFaculty^.Next
    END
END;

PROCEDURE DisplayQueueToFile;
VAR
  currentFaculty: ^Faculty;
  currentDepartment: ^Department;
  OutFile: TEXT;
BEGIN
  ASSIGN(OutFile, OutputFile);
  REWRITE(OutFile);
  currentFaculty := Head;
  WHILE currentFaculty <> NIL 
  DO
    BEGIN
      WRITELN(OutFile, 'Факультет: ', currentFaculty^.Name);
      currentDepartment := currentFaculty^.Head;
      WHILE currentDepartment <> NIL 
      DO
        BEGIN
          WRITELN(OutFile, ' - Кафедра: ', currentDepartment^.Name);
          currentDepartment := currentDepartment^.Next
        END;
      currentFaculty := currentFaculty^.Next
    END;
  CLOSE(OutFile)
END;

BEGIN
  Head := NIL;
  Tail := NIL;
  InputFile := '';
  OutputFile := '';
  WRITELN('Введите имя входного файла: ');
  READLN(InputFile);
  WRITELN('Введите имя выходного файла: ');
  READLN(OutputFile);
  IF FileExists(InputFile)
  THEN
    BEGIN
      ASSIGN(InFile, InputFile);
      RESET(InFile);
      WHILE NOT EOF(InFile) 
      DO
        BEGIN
          READLN(InFile, Line);
          SpaceIndex := POS(':', Line);
          FacultyName := TRIM(COPY(Line, 1, SpaceIndex - 1));
          DepartmentName := TRIM(COPY(Line, SpaceIndex + 1, LENGTH(Line) - SpaceIndex));
          AddFaculty(FacultyName);
          WHILE POS(' ', DepartmentName) > 0 
          DO
            BEGIN
              SpaceIndex := POS(' ', DepartmentName);
              AddDepartment(FacultyName, TRIM(COPY(DepartmentName, 1, SpaceIndex - 1)));
              DELETE(DepartmentName, 1, SpaceIndex)
            END;
          AddDepartment(FacultyName, TRIM(DepartmentName))
        END;
      CLOSE(InFile);
      REPEAT
        WRITELN('1. Добавить кафедру');
        WRITELN('2. Выделить компьютер');
        WRITELN('3. Показать факультеты');
        WRITELN('4. Выйти');
        WRITE('Введите цифру: ');
        READLN(Choice);
        CASE Choice OF
          1:
            BEGIN
              WRITE('Название факультета: ');
              READLN(FacultyName);
              WRITE('Название кафедры: ');
              READLN(DepartmentName);
              AddDepartment(FacultyName, DepartmentName)
            END;
          2:
            BEGIN
              AllocateComputer
            END;
          3:
            BEGIN
              DisplayQueue
            END
        END;
      UNTIL Choice = 4;
      DisplayQueueToFile
    END
END.