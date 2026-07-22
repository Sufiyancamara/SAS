
/* Read pg1.np_summary and create a new dataset called np_summary2
  and also create a new column PayType with last word from ParkName column
  and keep only four columns from the pg.np_summanry
 */

data np_summary2;
	set pg1.np_summary;
	ParkType = scan(ParkName, -1);
	keep Reg Type ParkName ParkType;
run;

proc print data= np_summary2;
run;