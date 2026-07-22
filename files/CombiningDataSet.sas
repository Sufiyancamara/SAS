7options pagesize=60 linesize=80 pageno=1 nodate;

data mydata;
	input empID fname $ lname $ dept $ salary;
	datalines;
234 Dembo Camara IT 200000
342 Wallace John EMT 89000
456 Tanja Monta Construction 75000

;
run;

data management;
	input id fname $ lname $ position $ salary empID;
	datalines;
564 Sufiyan Camara Manager 435000 234
454 Joshua Mendez manager  334000 342
642 Karasa Chen Supervisor 265000 456
;
run;

data combineDataSets;
	set mydata management;
run;

proc sort data=mydata out=mydatasorted;
	by id;
run;

proc sort data=management out=managementsorted;
	by id;
run;

data interLeavingData;
	set mydatasorted managementsorted;
	by id;
run;

proc print data=interLeavingData;
run;

data mergedata;
	merge management mydata;
	by empID;
run;

proc print data=mergedata;
	var id fname lname position dept salary empID;
run;

proc print data=combineDataSets;
run;