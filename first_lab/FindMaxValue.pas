UNIT FindMaxValue;
INTERFACE
 
  PROCEDURE SearchForExpressions(VAR InFile: TEXT);
  PROCEDURE OutputOfTheResult(VAR OutFile: TEXT);  
  PROCEDURE CalculatingValues;
  
IMPLEMENTATION

USES
  FindMaxValue;

TYPE
  ExpressionOfStr = RECORD
                        ValueOfOperand1: INTEGER;
                        ValueOfOperand2: INTEGER;
                        ValueOfOperator: CHAR
                    END;

CONST
  MaxExprLen = 100;  // максимальная длина выражения
  MaxLineLen = 1000; // максимальная длина строки
  
VAR
  Expressions: ARRAY OF ExpressionOfStr;
  ExprCount, N, Val, Ind: INTEGER;
  Line: STRING;
  MaxExprValue, MaxExprIndex: INTEGER;
  Lines: ARRAY[1 .. MaxLineLen] OF STRING; 
  Indices: INTEGER;

FUNCTION CalculateExpression(Expr: ExpressionOfStr): INTEGER; {CalculateExpression}
BEGIN
  CASE Expr.ValueOfOperator OF
    '+': CalculateExpression := Expr.ValueOfOperand1 + Expr.ValueOfOperand2;
    '-': CalculateExpression := Expr.ValueOfOperand1 - Expr.ValueOfOperand2;
    '*': CalculateExpression := Expr.ValueOfOperand1 * Expr.ValueOfOperand2;
    '/': IF (Expr.ValueOfOperand2 <> 0)
         THEN
           CalculateExpression := Expr.ValueOfOperand1 DIV Expr.ValueOfOperand2
  END
END; {CalculateExpression}

PROCEDURE FindMax(VAR MaxV: INTEGER; VAR MaxI: INTEGER);
BEGIN
  Val := MaxV;
  IF MaxV > Val
  THEN 
    BEGIN
      Val := MaxV;
      Ind := MaxI
    END
END;

PROCEDURE CalculatingValues;
VAR
  CurValue: INTEGER;
BEGIN {CalculatingValues}  
  FOR K: INTEGER := 0 TO (ExprCount - 1) 
  DO
    BEGIN
      CurValue := CalculateExpression(Expressions[K]);
      IF CurValue > MaxExprValue
      THEN
        BEGIN
          MaxExprValue := CurValue;
          MaxExprIndex := K;
          FindMax(MaxExprValue, MaxExprIndex)
        END
    END
END; {CalculatingValues}

PROCEDURE SearchForExpressions(VAR InFile: TEXT);
VAR 
  I, J, Len: INTEGER;
BEGIN {SearchForExpressions}
  I := 1;
  Len := 0;
  J := 0;
  READLN(InFile, Line);
  Len := Length(Line);
  SetLength(Expressions, MaxLineLen DIV MaxExprLen);
  WHILE I <= Len 
  DO
    BEGIN 
      IF (Line[I] IN ['-']) OR (Line[I] IN ['0'..'9'])
      THEN
        BEGIN
          J := I + 1;
          IF ((Line[I] IN ['-']) AND (Line[J] IN ['0'..'9'])) OR (Line[I] IN ['0'..'9'])
          THEN
            BEGIN
              WHILE (J <= Len) AND (Line[J] IN ['0'..'9'])
              DO
                INC(J);
              IF (J <= Len) AND (Line[J] IN ['+', '-', '*', '/']) 
              THEN
                BEGIN
                  Expressions[ExprCount].ValueOfOperand1 := StrToInt(Copy(Line, I, J - I));
                  Expressions[ExprCount].ValueOfOperator := Line[J];
                  I := J + 1;
                  J := I + 1;
                  WHILE (J <= Len) AND (Line[J] IN ['0'..'9']) 
                  DO
                    INC(J);
                  Expressions[ExprCount].ValueOfOperand2 := StrToInt(Copy(Line, I, J - I));
                  INC(ExprCount);
                  I := J;
                  CalculatingValues;
                END          
            END
        END;
      Lines[I] := Line;
      INC(I)
    END
END; {SearchForExpressions}

PROCEDURE OutputOfTheResult(VAR OutFile: TEXT);
BEGIN {OutputOfTheResult}
  IF MaxExprIndex <> -1 
  THEN
    BEGIN
//      WRITELN(OutFile, 'Строка, в которой найдено выражение: ', PresentStr);
      WRITELN(OutFile, 'Максимальное значение выражения: ', Val);
      WRITELN(OutFile, 'Выражение: ', Expressions[Ind].ValueOfOperand1, ' ', Expressions[Ind].ValueOfOperator, ' ', Expressions[Ind].ValueOfOperand2)
    END
  ELSE
    WRITELN('В строке не найдено выражений')
END; {OutputOfTheResult}

BEGIN
  MaxExprIndex := -1;
  MaxExprValue := 0;
  ExprCount := 0;
  Line := '';
END.