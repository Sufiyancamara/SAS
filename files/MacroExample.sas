* Micro variable example;


%let categoryM = Bird;
*%let cateoryBird = Bird;

data Mammal;
	set pg1.np_species;
	where Category = "&categoryM";
	drop Abundance Seasonality Conservation_Status;
run;
proc freq data=Mammal;
	table Record_Status;
run;
	