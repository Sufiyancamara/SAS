/*
	Read data from dataset called in pg1.eu_occ and create a new dataset
	that extract year and month values from YearMon column and create a new 
	column stores month and year in mdy format and sum the values from three columns
*/

data eu_occ_total;
	set pg1.eu_occ;
	Year = substr(YearMon, 1, 4);
	Month = substr(YearMon, 6, 2);
	ReportDate = mdy(Month, 1, Year);
	Total = sum(Hotel, ShortStay, Camp);
	format Hotel ShortStay Camp Total comma17. ReportDate monyy7.;
	keep Country Hotel ShortStay Camp ReportDate Total;
run;

proc print data=pg1.eu_occ;
run;
	
proc print data=eu_occ_total;
run;