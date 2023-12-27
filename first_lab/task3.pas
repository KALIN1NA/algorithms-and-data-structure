{   14. В некоторых строках текстового файла имеются выражения,
состоящие   из   двух   целых   чисел,   разделенных    знаком
арифметической   операции ('+','-','*','/'). Первое  из  чисел
может быть отрицательным. В строке может содержаться несколько
выражений. Перед  выражением  и  после него  могут  находиться
произвольные символы. Требуется  выделить  строку,  в  которой
значение выражения максимально. Вывести найденное максимальное
значение (7).

Калинина Анна, ПС-21}

PROGRAM MaxExpressionValue; //(INPUT, OUTPUT);
{Программа ищет во входном файле выражение с числами, высчитывает его и выводит максимальное значение со строкой в выходной файл}

USES  
  FindMaxValue;  
  
VAR 
  InputFile, OutputFile: STRING;
  InFile, OutFile: TEXT;
  
BEGIN {MaxExpressionValue}
  WRITELN('Введите имя входного файла: ');
  READLN(InputFile);
  ASSIGN(InFile, InputFile);
  IF FileExists(InputFile)
  THEN
    BEGIN
      WRITELN('Введите имя выходного файла: ');
      READLN(OutputFile);
      ASSIGN(OutFile, OutputFile); 
      IF FileExists(OutputFile)
      THEN
        BEGIN
          RESET(InFile);
          REWRITE(OutFile);
          WHILE NOT EOF(InFile)
          DO
            BEGIN
              SearchForExpressions(InFile);
              CalculatingValues
            END;
          OutputOfTheResult(OutFile);
          CLOSE(InFile);
          CLOSE(OutFile)
        END
      ELSE
        WRITELN(OUTPUT, 'Некорректное имя выходного файла')
    END
  ELSE
    WRITELN(OUTPUT, 'Некорректное имя входного файла')
END. {MaxExpressionValue}

