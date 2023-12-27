{1. Изделие задано  с  помощью  дерева.  В  листьях  указаны
значения  массы  соответствующих деталей.  Масса сборного узла
определяется как сумма масс составляющих деталей. Требуется:
   1) рассчитать массу всего изделия;
   2) организовать  обход  листьев,  запрашивая новые значения
массы и сообщая, как при этом меняется масса изделия (8).
Калинина Анна, ПС-21}

PROGRAM Masscalculation(INPUT, OUTPUT);

TYPE
  Nodeptr = ^Node;
  Node = RECORD
            Name: STRING;
            Num: INTEGER;
            Left: Nodeptr;
            Right: Nodeptr;
            Fath: Nodeptr;
            Asterisks: STRING
         END;

VAR
  Root: Nodeptr;
  Totalmass: INTEGER;
  Currentnode: Nodeptr;
  InputFile, OutputFile: STRING;
  InFile, OutFile: Text;
  Option: INTEGER;
  Choise: CHAR;

FUNCTION Createnode(Name: STRING; Num: INTEGER; Fath: Nodeptr; Asterisks: STRING): Nodeptr;
VAR
  Kon: Nodeptr;
BEGIN
  NEW(Kon);
  Kon^.Name := Name;
  Kon^.Left := NIL;
  Kon^.Right := NIL;
  Kon^.Num := Num;
  Kon^.Fath := Fath;
  Kon^.Asterisks := Asterisks;
  Createnode := Kon;
END;

PROCEDURE Readtreefromfile(VAR F: TEXT; VAR Ro: Nodeptr);
VAR
  I, M, K, Len, Num: INTEGER;
  R, S: STRING;
  P, T, Kon: Nodeptr;
BEGIN
  WHILE NOT EOF(F) 
  DO
    BEGIN
      READLN(F, S);
      K := 0;
      Len := Length(S);
      IF S[1] = '*' THEN
      BEGIN
        WHILE S[K + 1] = '*' 
        DO
          INC(K);
      END;
      IF POS(' ', S) > 0 
      THEN
        BEGIN
          R := Copy(S, K + 1, POS(' ', S) - K);
          Num := StrToInt(Copy(S, POS(' ', S) + 1, Len - POS(' ', S)))
        END
      ELSE
        BEGIN
          R := COPY(S, K, Len - K + 1);
          Num := 0
        END;
      NEW(Kon);
      Kon^.Name := R;
      Kon^.Left := NIL;
      Kon^.Right := NIL;
      Kon^.Num := Num;
      Kon^.Asterisks := StringOfChar('*', K); 
      IF K = 0 
      THEN
        BEGIN
          Ro := Kon;
          Kon^.Fath := NIL;
          M := 0;
          T := Kon;
          CONTINUE
        END;
      IF K > M 
      THEN
        BEGIN
          T^.Left := Kon;
          Kon^.Fath := T;
        END
      ELSE IF K = M 
      THEN
        BEGIN
          T^.Right := Kon;
          Kon^.Fath := T^.Fath
        END
      ELSE
        BEGIN
          P := T;
          FOR I := 1 TO M - K 
          DO
            P := P^.Fath;
          Kon^.Fath := P^.Fath;
          P^.Right := Kon
        END;
      M := K;
      T := Kon
    END;
END;

PROCEDURE ToFile(VAR F: TEXT; T: Nodeptr);
VAR
  J: INTEGER;
  St: STRING;
  P: Nodeptr;
BEGIN
  IF T <> NIL 
  THEN
    BEGIN
      St := T^.Asterisks + T^.Name; 
      P := T;
      FOR J := 1 TO T^.Num 
      DO
        BEGIN
          IF P^.Fath <> NIL 
          THEN
            P := P^.Fath
        END;
      IF T^.Num <> 0 
      THEN
        WRITELN(F, St, ' ', T^.Num)
      ELSE
        WRITELN(F, St);
      ToFile(F, T^.Left);
      ToFile(F, T^.Right)
    END
END;

FUNCTION CalculateTotalMass(Node: NodePtr): INTEGER;
BEGIN
  IF Node = NIL THEN
    CalculateTotalMass := 0
  ELSE
    CalculateTotalMass := Node^.Num + CalculateTotalMass(Node^.Left) + CalculateTotalMass(Node^.Right);
END;

PROCEDURE TraverseTree(Node: NodePtr);
VAR
  NewMass: INTEGER;
  Counter: INTEGER;
BEGIN
  IF Node <> NIL 
  THEN
    BEGIN
      IF (Node^.Right <> NIL) AND (Node^.Num <> 0) 
      THEN
        BEGIN
          WRITELN('текущие данные: ', Node^.Name, ' ', Node^.Num);
          WRITELN('Меняем массу детали? Y/N');
          READLN(Choise);
          IF (Choise = 'Y') OR (Choise = 'y')
          THEN
            BEGIN
              WRITE('Введите новое значение массы для детали: ');
              READLN(NewMass);
              WRITELN('Новый вес: ', NewMass);
              IF NewMass - Node^.Num >= 0
              THEN
                WRITELN('Разница: ', NewMass - Node^.Num)
              ELSE
                WRITELN('Разница меньше 0');
              TotalMass := TotalMass + NewMass - Node^.Num;
              Node^.Num := NewMass;
              WRITELN('Масса всего изделия: ', TotalMass)
            END
          ELSE
            WRITELN('Масса детали осталась прежней')
        END
      ELSE
        IF (Node^.Left = NIL) AND (Node^.Right = NIL) AND (Node^.Num <> 0)
        THEN
          BEGIN
          WRITELN('текущие данные: ', Node^.Name, ' ', Node^.Num);
          WRITELN('Меняем массу детали? Y/N');
          READLN(Choise);
          IF (Choise = 'Y') OR (Choise = 'y')
          THEN
            BEGIN
              WRITE('Введите новое значение массы для детали: ');
              READLN(NewMass);
              WRITELN('Новый вес: ', NewMass);
              IF NewMass - Node^.Num >= 0
              THEN
                WRITELN('Разница: ', NewMass - Node^.Num)
              ELSE
                WRITELN('Разница меньше 0');
              TotalMass := TotalMass + NewMass - Node^.Num;
              Node^.Num := NewMass;
              WRITELN('Масса всего изделия: ', TotalMass)
            END
          ELSE
            WRITELN('Масса детали осталась прежней')
        END;
      TraverseTree(Node^.Left);  
      TraverseTree(Node^.Right) 
    END
END;

PROCEDURE ClearTree(Node: NodePtr);
BEGIN
  IF Node <> NIL 
  THEN
    BEGIN
      ClearTree(Node^.Left);  
      ClearTree(Node^.Right);  
      DISPOSE(Node)
    END
END;

BEGIN
  WRITELN('введите имя входного файла: ');
  READLN(InputFile);
  WRITELN('введите имя выходного файла: ');
  READLN(OutputFile);  
  IF FileExists(InputFile) 
  THEN
    BEGIN
      IF FileExists(OutputFile) 
      THEN
        BEGIN
          ASSIGN(InFile, InputFile);
          RESET(InFile);
          ASSIGN(OutFile, OutputFile);
          Readtreefromfile(InFile, Root);
          CLOSE(InFile);
          WRITELN('расчет массы изделия');
          REPEAT
            WRITELN;
            WRITELN('текущая масса всего изделия: ', Calculatetotalmass(Root));
            WRITELN;
            WRITELN('1 - просмотреть дерево деталей');
            WRITELN('2 - обновить массу детали');
            WRITELN('3 - выход');
            WRITELN;
            WRITE('введите номер действия: ');
            READLN(Option);            
            CASE Option OF
              1:
              BEGIN
                WRITELN;
                ToFile(OUTPUT, Root)
              END;
              2:
              BEGIN
                Totalmass := Calculatetotalmass(Root);
                Traversetree(Root)
              END;
              3: WRITELN('выход')
            END;
          UNTIL Option = 3
        END
      ELSE
        WRITELN('выходной файл не найден')
    END
  ELSE
    WRITELN('входной файл не найден');
  REWRITE(OutFile);
  ToFile(OutFile, Root);
  CLOSE(OutFile);
  ClearTree(Root)
END.