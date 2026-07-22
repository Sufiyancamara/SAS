data travel;
	input country $ numNight costPerNight depDate date9.;
	datalines;
Gambia 29 50 01mar2025
France 10 78 01jul2025
Senegal 5 66 02apr2025
;
run;

proc print data=travel;
	format depDate date9.;
run;

data travel2;
	set travel;
	returnDate=depDate + numNight;
	totalCost=numNight * costPerNight;
	now=today();
	daysLeft=depDate - today();

	if daysLeft <=180 then
		isDue="Yes";
	else
		isDue="No";
	format totalCost costPerNight dollar9.2;
run;

proc print data=travel2(drop=now);
	title "Tour information including the return Date";
	format depDate returnDate date9.;
run;