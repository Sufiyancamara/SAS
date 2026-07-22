libname examples '/home/u63449653/trials';


/*
data;
input id fname $ lname $ Dept $;
datalines;
124 Camara Sulaiman OPS
;
run;

proc print data = data1;
*/

data examples.Temp;
input id name $ salary dept $ DOJ Date9.;
format DOJ Date9. ;
Datalines;
1 Rick 653.3 IT 02apr2001
2 Dan 435.3 OPS 11jul2012
3 Rasmi 722.5 FIN 13sep2014
;
run;

proc print data = examples.temp;
run;


data examples.string_example;
length string1 $ 6 string2 $ 5;
	string1 = 'Hello';
	string2 = 'World';
join_strings = string1 || string2;
run;

proc print data = examples.string_example;
run;



/*You do not put the character width if you
 do not use the lenggth keyword*/

data examples.string_example2;
input string1 $ string2 $;
join_strings = string1 || string2;
datalines;
Hello World
Nice day
;
run; 

proc print data=examples.string_example2;
run;

data examples.substring;
length firstname $ lastname $;
	firstname = 'Omar';
	lastname = 'Sillah';
initals = substrn(firstname, 1, 1) || substrn(lastname, 1, 1);

firstname_length = lengthc(firstname);
lastname_length = lengthc(lastname);

fname_trimmed = lengthc(trimn(firstname));
lname_trimmed = lengthc(trimn(lastname));
run;

proc print data = examples.substring;
run;


proc contents data = sashelp.cars;
run;

Data array_sample;
input a1 $ a2 $ a3 $ a4 $ a5 $;
array colours(5) $ a1-a5;
mix = a1 || '+' || a2;
Datalines;
Yellow Pink Orange Green Blue
;
Run;

proc print data = array_sample;
run;

Data array_sample2;
array age[5] (12 18 5 62 44);

proc print data = array_sample2;
run; 


data array_sample3;
array countries[0:8] $ a b c d e f g h i;
datalines;
gam usa senegal mali egypt somalia sudan ghana was
;
run;

proc print data = array_sample3;
run;



data array_sample4;
input a1 a2 a3 a4;
array A(4) a1-a4;
	A_sum = sum(OF A(*));
	A_mean = mean(OF A(*));
	A_min = min(OF A(*));
Datalines;
21 4 53 11
92 25 42 6
;
run;

proc print data = array_sample4;
run;


data array_sample5;
input b1 $ b2 $ b3 $;
array Banana(3) $ b1-b3;
	IF 'Yellow' IN Banana THEN available = 'yes';
	ELSE available = 'no';
Datalines;
Orange Yellow Blue
;
run;

proc print data = array_sample5;
run;



data formatting;
input var 6. var2 7.;
format var 5.2 var2 Dollar10.2;
Label var2 ='Dollar format';
datalines;
8722  8722
93.2  93.2
.1122 .1122
15.116 15.116
;
run;

proc print data = formatting;
run;

proc contents data = formatting;
run;


*Exporting into a txt file.;
proc export data = sashelp.cars
	outfile = '/home/u63449653/outfiles_d/cars.txt' dbms = dlm;
	delimiter =  ' ';
run;



*Exporting as a csv file.;
proc export data = sashelp.cars
	outfile = '/home/u63449653/outfiles_d/cars.csv' dbms = csv;
run;

proc export data = sashelp.cars
	outfile = '/home/u63449653/outfiles_d/cars2.csv' dbms = csv;
	delimiter = ',';
run;


*Exporting as a tab delimited file;
proc export data = sashelp.cars
	outfile = '/home/u63449653/outfiles_d/cars_tab.txt' dbms = dlm;
	delimiter = 'tab';
run;


proc contents data = sashelp.cars;
run;

*Reading data from Hierarchical file.;
data employees(drop=Type);
length Type $ 4 Department
	empID $ 3 empName $ 10 empSal 3;
retain Department;
infile '/home/u63449653/infiles_u/employees.txt' dlm = ':';
input Type $ @;
IF Type = 'DEPT' THEN
	input Department $;
ELSE DO; 
	input empID $ empName $ empSal;
	output;
end;
run;

proc print data = employees;
run;


data sample;
infile '/home/u63449653/corporate.csv' dlm = ',' firstobs = 2;
	input name $ Boxes DateOfMove $ Office;
run;

proc print data = sample;
run;

/*Concatenating Data sets with different variable length and 
  different number of columns.*/
Data table1;
input ID 1-3 fname $ 4-10 lname $ 11-18 Dept $ 19-22 Salary 23-30;
comm = salary * 0.25;
Label comm = 'Commission' Dept = 'Department';

Datalines;
13 Camara Sufiyan IT  120000
24 Manneh Mustafa OPS 22134
31 John   Mendez  HR  56201
;
run;


Data table2;
input ID 1-3 fname $ 4-10 lname $ 11-20 Dept $ 21-24 Salary 25-32;
Datalines;
5  Sullay  AdamuJohn HR  75000
12 Leroy   Jacob    OPS 65000
54 Susan   Lilia    IT  115000
;
run;


data conTables;
set table1 table2;
run;

proc print data = conTables;


data concatTable2;
length lname $ 9;
set table1 table2;
run;

proc print data = concatTable2;
run;


*Data sets with different variable names;
Data withFullVarName;
input ID 1-3 fname $ 4-10 ltname $ 11-18 Dept $ 19-22 Salary 23-30;
comm = salary * 0.25;
Label comm = 'Commission' Dept = 'Department';

Datalines;
13 Camara Sufiyan IT  120000
24 Manneh Mustafa OPS 22134
31 John   Mendez  HR  56201
;
run;


Data withNotFullVarName;
input ID 1-3 fname $ 4-10 lname $ 11-20 Dept $ 21-24 Salary 25-32;
Datalines;
5  Sullay  AdamuJohn HR  75000
12 Leroy   Jacob    OPS 65000
54 Susan   Lilia    IT  115000
;
run;


data mergeData;
set withFullVarName withNotFullVarName;
run;

proc print data = concatData;
run;

data concatDataWithSameName;
set withFullVarName(RENAME=(ltname=LastName)) withNotFullVarName(RENAME=(lname=LastName));
run;

proc print data=concatDataWithSameName;
run;


*Merging data sets;
Data mergeDataSet1;
input ID 1-3 lname $ 4-10 fname $ 11-18 Salary 19-29;
comm = salary * 0.25;
Label comm = 'Commission' Dept = 'Department';

Datalines;
13 Camara Sufiyan    120000
24 Manneh Mustafa    22134
31 John   Mendez     56201
5  Sullay John       75000
12 Leroy  Jacob      65000
54 Susan  Lilia      115000
19
;
run;


Data mergeDataSet2;
input ID 1-3 Dept $ 4-7 DOH Date9.;
format DOH Date9.;
Datalines;
12 OPS 05jul2021
31 OPS 05jul2021
24 HR  10sep2006
13 IT  15dec1998
   HR  12mar2012
54 IT  19feb2020
5  HR  12mar2023
;
run;


proc sort data = mergeDataset1;* out = all_data;
	by ID;
run;

proc sort data = mergeDataSet2;
	by id;
run;

proc print data = mergeDataSet1;
run;

proc print data = mergeDataSet2;
run;


data data_merged;
	merge mergeDataSet1 mergeDataSet2;
	by ID;
run;
proc print data = data_merged;
run;

*Merging only the valued variables;
data merge_valueData;
	merge mergeDataSet1(IN = a) mergeDataSet2(IN = b);
	by ID;
	if a = 1 and b = 1;
run;
proc print data = merge_valueData;
run;


*Subsetting;

Data subsettingKeep;
	SET merge_valueData;
	KEEP lname salary DOH;
run;
proc print data = subsettingKeep;
run;

data subsettingDrop;
	SET merge_valueData;
	DROP salary comm;
run;
proc print data = subsettingDrop;
run;

data subsettingDelete;
	SET merge_valueData;
	IF salary <= 57000 THEN DELETE;
run;
proc print data = subsettingDelete;
run;

	


















