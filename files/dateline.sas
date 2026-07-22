libname ExamPrep '/home/u63449653/SASExam';
options fmtsearch=(ExamPrep);

data ExamPrep.student;
input studentID 1-4 name $ 6-20 course $ 22-29 Gender $31  startDate ddmmyy10.;
*format startDate ddmmyy10.;
datalines;
1240 Sufiyan Camara  CMP340   M  27/08/2023
3424 Ebrima Camara   MATH200  M  27/08/2024
5346 Sarjo Sillah    CIS101   F  28/01/2025
7543 John Davis      PHY100   M  28/12/2022
;
run;


data ExamPrep.stSaving;
input studentID 1-4 name $ 6-20 amount Agreed  smoker;
datalines;
1240 Sufiyan Camara  650  1  0
4324 Ebrima Camara   432  1  3
7543 John Davis      243  0  0
4356 Yoyo Kaka       426  1  3
7945 Susan Mendez    535  0  1
;
run;



