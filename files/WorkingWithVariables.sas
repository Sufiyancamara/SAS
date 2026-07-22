data conctData;
	set ExamPrep.student testprep.myfirsttable;
run;

data FLnames (drop=name);
	set ExamPrep.student;
	fname = scan(name, 1, " ");
	lname = left(scan(name, 2, " "));
run;

options pagesize=60 linesize=80 pageno=1 nodate;
proc print data=FLnames;
	format startDate ddmmyy10.;
	var studentID fname lname course startDate; 
title 'Students with First and Last names variables';
run;


* Creating new variables;
data stInfo (drop=firstname lastname);
	set testprep.myfirsttable;
	fname = firstname;
	lname = lastname;
run;
 
*Renaming a veriable and droping it;
data stSalary (rename=(tempVar = salary) drop=salary);
	set stInfo;
	tempVar = salary/52/40;
run;

proc contents data=testprep.myfirsttable nods;
run;


*Changing variable value.;
data emIdChange(rename=(ID=studentID));
	set stSalary;
	format salary Dollar6.2;
	if fname = 'Sufiyan' then ID = 1240;
	else if fname = 'Dave' then do;
		ID= 3424;
		fname = 'Ebrima';
		lname='Camara';
	end;
	else ID= 6456;
	
run;


proc sort data=ExamPrep.student;
	by studentID;
run;

proc sort data=emIdChange;	
	by studentID;
run;

proc contents data=ExamPrep.student;
run;

data stVarTyChange(rename=(tempID=studentID)drop=studentID);
	set FLnames;
	tempID = put(studentID, 8.);
run;

proc contents data=stVarTyChange;
run;

proc contents data=stIdChange;
run;

proc print data=stVarTyChange;
run;

*Merging data sets;
data mergeData;
	merge stVarTyChange stIdChange;
	by studentID;
run;

proc print data=mergeData;
	format startDate ddmmyy10.;
	var studentID lname fname course startDate dept title salary;
	title 'Students and department they work for';
run;

proc contents data=testprep._ALL_ nods;
run;

*Running Total of the staff salary;
data totalSalary;
	set mergeData;
	AnnualSal = salary*40*52;
	AccumSal+AnnualSal;
run;


proc print data=totalSalary;
run;

*data total;
*	set totalSalary;
*	if First.AccumSal =0 and Last.AccumSal = 1;
*	keep AccumSal;
*run;


Data lastRow(rename=(AccumSal=TotalSal));
	set mergeData end = last;
	AnnualSal = salary*40*52;
	AccumSal+AnnualSal;
	if last;
	keep AccumSal;
run;





