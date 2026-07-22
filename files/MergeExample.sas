* Merge Example;

proc sort data=pg2.np_codelookup out=codelookupSort;
	by ParkCode;
run;

proc sort data=pg2.np_2016 out=np_2016Sort;
	by ParkCode;
run;

data parkStats(keep = ParkCode ParkName Year Month DayVisits) parkOther(keep =
		ParkCode ParkName);
	merge np_2016Sort(IN=a) codelookupSort(IN=b);
	by ParkCode;

	if a=1 and b=1 then output parkStats;
	else
		output parkOther;
run;