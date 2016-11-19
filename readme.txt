I used the code provided in the minimal file and changed the cup/Parser.cup and jflex/Scanner.jflex files to JSON specifications. In the jflex/Scanner.jflex file I needed to change the "usercode" section and the "options and declarations" section to properly handle strings. In the file cup/Parser.cup I also had to change the starting part to include some "import". The other changes were made to the parts that should be changed and are appropriately commented on in the files.

The tests were done by changing the input.test file several times. Sometimes with valid and sometimes invalid JSON formats. When running the program (by the command java -jar jar/Compiler.jar input.test), if the format is considered valid no output is displayed, otherwise some error message will be displayed.

In the correct format the input must contain a single valid value for the JSON format. This can be a number, a string, a Boolean value, null, an array of values, or an object. An object consists of a list of key-value pairs, where key must be a string and value can assume any valid value in JSON format.

Some valid input ​​that have been tested are:
[3E-1, 2e+3, 4.2e1, "\u0061", "Love's\tPower", "Love's\nPower", "Love's\/Power", [{}], -5,true,false,null]

[{}]

{"bool1":true,"bool2":false,"bool3":null}

"Love's\nPower"

true

null

-4

-4.23

-4.23e1

{"bool1":true,"bool2":false,"bool3":null, "array":[3E-1, 2e+3, 4.2e1, "\u0061", "Love's\tPower", "Love's\nPower", "Love's\/Power", [{}], -5,true,false,null]}

Some invalid input ​​that have been tested are:
Love's\nPower

3E-1, 2e+3, 4.2e1

"bool1":true,"bool2":false,"bool3":null
