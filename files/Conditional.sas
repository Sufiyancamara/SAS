/*

  Create two dataset from np_summary where Type
  park type is either National Parks (NP) or National Monuments (NM)
  and add all NPs to parks dataset and NMs to monumnets dataset
  
*/



data parks monuments;
	set pg1.np_summary (where=(Type in ('NP', 'NM')));
	Campers = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
	format Campers comma17.;
	length ParkType $ 8.;
	select(Type);
		when('NP') do;
			ParkType = 'Park';	
			output parks;
		end;
		otherwise do;
			ParkType = 'Monuments';
			output monuments;
		end;
	end;
	keep Reg ParkName Type DayVisits OtherLodging Campers ParkType;
	
run;