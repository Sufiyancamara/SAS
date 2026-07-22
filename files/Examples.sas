 data firstLetter;
	set examprep.student;
	where Lower(name) =: 's';
run;

data lnameint;
	set examprep.student;
	lint = scan(name, 2, ' ');
	if lint <=: 'J' then lname = trim(lint) || ", " || scan(name, 1, " ");
run;


proc export data='testprep';



*Reading a file in data step;
data tourInfo;
	infile '/home/u63449653/SASExam/tour.txt' dlm="," FIRSTOBS=1;
	input City $ Cost Num_Night Vendor $;
run;

data tourDat;
	infile '/home/u63449653/SASExam/tour.dat' dlm=",";
	input City $ Cost Num_Night;
run;

data tabDLM;
	infile '/home/u63449653/SASExam/tourTab.txt' dlm=' ';
	input City $ Cost Night Vendor $;
run;

proc sort data=tourInfo out=sortedTour;
	by Vendor;
run;

DATA totalBV;*(Keep= Vendor NVBooking);
	set sortedTour;
	by Vendor;
	N_Booking+Num_Night;
	
	if First.Vendor then  NVBooking =0;
	NVBooking+Num_Night;
	
	if last.Vendor;
run;
	
options pagesize=60 linesize=80 pageno=1 nodate;
proc print data=totalBV;
title 'Total Booking of each Tour';
run;


data expensiveTour;
	set tourInfo end = lastObs;
	TotalCost = Cost * Num_Night;
	retain MostExp ExpCity;
	if MostExp < TotalCost then do;
		MostExp = TotalCost;
		ExpCity = City;
	end;
	if lastObs;
run;

proc print data=expensivetour;
	var ExpCity MostExp;
	format MostExp dollar10.2;
run;
	

data maxvalue;
	set tourInfo;
	TotalCost = Cost*Num_Night;
run;

data maxvalue2;
	set maxsorted end = lastobs;
	if lastobs;
run;

proc sort data=maxvalue out=maxsorted;
	by TotalCost;
run;

	
proc freq data=maxvalue;
	table City;
run;

proc gplot data=maxvalue;
	symbol i=spline v=circle h=2;
	plot TotalCost * city;
run;

ods noproctitle;
proc means data=maxvalue min max mean median;
title 'This is the first one';
run;
ods proctitle;



data final(drop=count);
	set maxvalue;
	array group{2} Num_Night TotalCost;
	do count = 1 to 2;
		if group(count) =. then group(count) = 0;
	end;
	if Vendor = " " then Vendor = "TBD";
run;


proc export data=final outfile='/home/u63449653/SASExam/fianl.xlsx' dbms=xls;
run;

proc export data=final outfile='/home/u63449653/SASExam/final.csv' dbms=csv;
	delimiter=",";
run;

proc export data=final outfile='/home/u63449653/SASExam/final2.txt' dbms=tab;
	delimiter="tab";
run;


ods excel file="/home/u63449653/SASExam/final34.xlsx" options(SHEET_NAME="First Page");
	proc print data=final noobs;
	run;
	
	ods excel options(SHEET_NAME="Second page");
		proc print data=maxvalue noobs;
		run;
		
ods excel close;


data dates;
	input fname $ lname $ bday :date9. startHi :date9. gradHi :date9. startCol :date9. gradCol :date9.;
	label bday="Birthdat" startHi="High School Start Date" gradHi="High School Graduatution Date";
	format bday startHi gradHi startCol gradCol date9.;
	datalines;
	Sufiyan Camara 22sep1988 04sep2004 24jun2008 27aug2008 01jun2015
	Kaka Manneh 30sep1989 04sep2004 24jun2008 27aug2008 01jun2015
	;
run;

options yearcutoff=1987;
data datecheck;
	set dates;
	HSAge = ceil(yrdif(bday, startHi, 'Actual'));
	month = month(bday);
	year = year(bday);
	day = day(bday);
	
	age = yrdif(bday, today(), 'Age');
	nDays = today() - bday;
	weday = weekday(bday);
	wname = put(bday, downame.);
	mname = put(bday, monname4.);
run;


proc format;
	value $genfmt 'M' = 'Male'
				  'F' ='Female';
				  
proc print data=examprep.student;
	format Gender $genfmt.;
run;

proc contents data=examPrep.student;
run;


proc print data=examprep.stsaving label;
run;


data stmonsaving;
	set examprep.stsaving;
	mSaving = 0;
	do month = 1 to 12;
		mSaving+amount;
	output;
	end;
run;

proc print data=stmonsaving;
run;
		
data styrmoSaving;
	set examprep.stsaving;
	mSaving = 0;
	do year = 1 to 5;
		do month = 1 to 12;
			mSaving+amount;
			mSaving+(amount*0.10);
		output;
		end;
	*output;	
	end;
run;

proc print data=styrmoSaving;
run;


proc sort data= styrmoSaving out=sortedstyrmoSaving;
 	by studentID;
run;

data yr5saving;
	set sortedstyrmoSaving;
	by studentID;
	if last.studentID;
	drop month year;
run;

proc print data=yr5saving;
	format amount mSaving dollar10.2;
	title 'Students Saving After Five Years';
run;


data dowithcondition(drop=month);
	set examprep.stsaving;
	Saving =0;
	do year = 1 to 8 until (Saving > 30000);
		do month = 1 to 12;
			Saving+amount;
			Saving+(amount*0.10);
		end;
	output;
	end;
run;

proc print data=dowithcondition noobs;
run;

ods noproctitle;
ods excel file='/home/u63449653/SASExam/stSaving.xlsx' options(SHEET_NAME='PAGE1');
proc print data=dowithcondition;
run;
ods excel close;	
	
ods pdf file='/home/u63449653/SASExam/stSaving.pdf';
proc print data=dowithcondition noobs;
format Saving dollar10.2;
run;

proc means data=dowithcondition max min median maxdec=2;
	var amount Saving;
run;

ods pdf close;
ods proctitle;
	

data minsaving;
	set examprep.stsaving;
	Saving = 0;
	do year = 1 to 10;
		Saving+Amount;
	end;	
run;

*Finding the minimum Value;
data minsaving2;
	set minsaving;
	retain MinSav;
	if _N_ = 1 then MinSav = Saving;
	else if minSav > Saving then minSav = Saving;
	putlog 'Warning Always Initialize your retain vslue if you want the minimum value';
	name = tranwrd(name, 'Davis', 'Mark');
	if findw(name, 'Ebrima')>0 then name = 'Ebrima Manneh';
	if find(name, 'Susan')>0 then name = 'Justin Walker';
run;
	
proc sort data=minsaving2 out= mins;
 by name;
run;

proc transpose data=mins out=transposeddata;
	by name;
	Id studentId;
	var amount;
run;

proc transpose data=transposeddata out=backtrans;
	by studentID;
run;



data sample;
	datetime = '12may2024:10:27:14'dt;
	date2 = '23jun1983'd;
	date3 = '11sep1938'd;
	date_only = datepart(datetime);
	time_only = timepart(datetime);
	datetime_format = put(datetime, datetime20.);
	
	year = year(date_only);
	month = month(date_only);
	day = day(date_only);
	weekday = weekday(date_only);
	dayname = put(date_only, downame9.);
	
	nyears = intck('year', date3, date2);
	
	
	format date_only date2 date3 date9. time_only time9.;
run;

proc print data=sample;
run;
	



proc format library=examprep;
	value runner 1 = 'Yes'
				  0 = 'No';
	value singer 1 = 'Yes'
				  0 = 'No'
				  3 = 'Former';
run;
/*%include '/home/u63449653/SASExam/format1.sas';*/
data survey;
	set examprep.stsaving;
	format agreed runner. smoker singer.;
run;

proc sort data=survey out=sortedsurvey;
	by _all_;
run;

	
	
	
