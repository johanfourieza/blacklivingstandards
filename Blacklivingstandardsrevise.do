*Black heights (Fourie, Inwood and Mpeta)

/////////////////////////////World War////////////////////////////////

use "C:\Users\johanf\Dropbox\1 Research\3 LIVING STANDARDS\FIM Black living standards\Revise\MilitaryCleaned.dta", clear

recode ethnic (34=33)
recode ethnic (4=43)
recode ethnic (8=43)
recode ethnic (43=".")

gen birthyeardum = .
replace birthyeardum = 1900 if birth_year>1895 & birth_year<1901
replace birthyeardum = 1905 if birth_year>1900 & birth_year<1906
replace birthyeardum = 1910 if birth_year>1905 & birth_year<1911
replace birthyeardum = 1915 if birth_year>1910 & birth_year<1916
replace birthyeardum = 1920 if birth_year>1915 & birth_year<1921
replace birthyeardum = 1925 if birth_year>1920 & birth_year<1926

histogram height_cm, kdensity bin(22)

gen sa = .
replace sa = 1 if res_prov == 1 | res_prov == 2 | res_prov == 3 | res_prov == 4

///Prepare for merge

gen mine = .
replace mine = 1 if prior_occup == 15

gen ethnicdum = .
replace ethnicdum = 1 if ethnic==26
replace ethnicdum = 2 if ethnic==30
replace ethnicdum = 3 if ethnic==33
replace ethnicdum = 4 if ethnic==36
replace ethnicdum = 5 if ethnic==40
replace ethnicdum = 6 if ethnic==42
replace ethnicdum = 7 if ethnic==44
replace ethnicdum = 8 if ethnic==45
replace ethnicdum = 9 if ethnic==49

keep birth_year height_cm ethnicdum sa mine age


eststo clear
quietly bysort birthyeardum: eststo: estpost sum height_cm if sa == 1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

/////////////////////////////Cadavers////////////////////////////////

use "C:\Users\johanf\Dropbox\1 Research\3 LIVING STANDARDS\FIM Black living standards\Revise\Cadaver.dta", clear

drop if age<18
drop if age>49
drop if popgroup=="."

gen birthyeardum = .

replace birthyeardum = 1905 if birthyear>1900 & birthyear<1906
replace birthyeardum = 1910 if birthyear>1905 & birthyear<1911
replace birthyeardum = 1915 if birthyear>1910 & birthyear<1916
replace birthyeardum = 1920 if birthyear>1915 & birthyear<1921
replace birthyeardum = 1925 if birthyear>1920 & birthyear<1926
replace birthyeardum = 1930 if birthyear>1925 & birthyear<1931
replace birthyeardum = 1935 if birthyear>1930 & birthyear<1936
replace birthyeardum = 1940 if birthyear>1935 & birthyear<1941
replace birthyeardum = 1945 if birthyear>1940 & birthyear<1946
replace birthyeardum = 1950 if birthyear>1945 & birthyear<1951
replace birthyeardum = 1955 if birthyear>1950 & birthyear<1956
replace birthyeardum = 1960 if birthyear>1955 & birthyear<1961
replace birthyeardum = 1965 if birthyear>1960 & birthyear<1966

gen black = .
replace black = 1 if popgroupdum!=3 & popgroupdum!=2

eststo clear
quietly bysort birthyeardum: eststo: estpost sum height if black==1 & gender==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

///By population group
eststo clear
quietly bysort popgroupdum: eststo: estpost sum height if black==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )


///Prepare for merge

gen lung = strpos(causeofdeath, "Lung") | strpos(causeofdeath, "lung") | strpos(causeofdeath, "Pneumonia") | strpos(causeofdeath, "respiratory") | strpos(causeofdeath, "Respiratory")

drop if gender==2
drop if age<18
drop if age>49
drop if popgroup=="."

drop if popgroupdum==2
drop if popgroupdum==3
drop if birthyear<1896

gen ethnicdum = .
replace ethnicdum = 1 if popgroupdum==4
replace ethnicdum = 2 if popgroupdum==5
replace ethnicdum = 3 if popgroupdum==6
replace ethnicdum = 4 if popgroupdum==7
replace ethnicdum = 5 if popgroupdum==8
replace ethnicdum = 6 if popgroupdum==9
replace ethnicdum = 7 if popgroupdum==10
replace ethnicdum = 8 if popgroupdum==11
replace ethnicdum = 9 if popgroupdum==12

keep birthyear height ethnicdum lung age


////////////////////////////////////NIDS///////////////////////////////

use "C:\Users\johanf\Dropbox\1 Research\3 LIVING STANDARDS\FIM Black living standards\Revise\NIDS.dta", clear

drop if birthyear<1956
drop if birthyear>1990
drop if best_height<125
//drop if best_height<(168.3283-4*9.474336) | best_height>(168.3283+4*9.474336) & best_height!=.

sum height
histogram height, kdensity

gen birthyeardum = .

replace birthyeardum = 1960 if birthyear>1955 & birthyear<1961
replace birthyeardum = 1965 if birthyear>1960 & birthyear<1966
replace birthyeardum = 1970 if birthyear>1965 & birthyear<1971
replace birthyeardum = 1975 if birthyear>1970 & birthyear<1976
replace birthyeardum = 1980 if birthyear>1975 & birthyear<1981
replace birthyeardum = 1985 if birthyear>1980 & birthyear<1986
replace birthyeardum = 1990 if birthyear>1985 & birthyear<1991

eststo clear
quietly bysort birthyeardum: eststo: estpost sum best_height [w=weight] if race==1 & gender==1 & country_birth==.
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

///Time trend --> little variation over time
eststo clear
quietly bysort birthyeardum: eststo: estpost sum best_height [w=weight] if race==4 & gender==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

///Language --> some variation, Xhosa typically shorter than Zulu, who is shorter than Swati
eststo clear
quietly bysort language: eststo: estpost sum best_height [w=weight] if race==1 & gender==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

///Province --> not a lot of variation, those born outside South Africa shorter
eststo clear
quietly bysort province_birth: eststo: estpost sum best_height [w=weight] if race==1 & gender==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

///Occupation --> strong correlation with ordinal ranking
eststo clear
quietly bysort occupation: eststo: estpost sum best_height [w=weight] if race==1 & gender==1
esttab est*, label nodepvar cells( mean(fmt(2)) sd(par fmt(2)) )

/// Following miners only
tabstat best_height if race==1 & gender==1, by(industry) stat(mean n)

///Prepare for unified dataset

drop if birthyear<1956
drop if birthyear>1990
gen sa = .
replace sa = 1 if country_birth == .

//drop if best_height<(168.3283-4*9.474336) | best_height>(168.3283+4*9.474336) & best_height!=.

keep if gender==1
keep if race==1
drop if age<18
drop if age>49

gen mine = .
replace mine = 1 if industry == 2

gen ethnicdum = .
replace ethnicdum = 1 if language==1
replace ethnicdum = 2 if language==4
replace ethnicdum = 3 if language==5
replace ethnicdum = 4 if language==7
replace ethnicdum = 5 if language==9
replace ethnicdum = 6 if language==6
replace ethnicdum = 7 if language==8
replace ethnicdum = 8 if language==2
replace ethnicdum = 9 if language==3

keep birthyear best_height ethnicdum mine sa age

///Men and women

twoway (lpolyci best_height birthyear if race==1 & gender==1) (lpolyci best_height birthyear if race==1 & gender==2) (lpolyci best_height birthyear if race==4 & gender==1) (lpolyci best_height birthyear if race==4 & gender==2), legend(pos(6) col(2) order(2 3 4 5) label(2 "Black male") label(3 "Black female") label(4 "White male") label(5 "White female"))


///////////////////////////Summary stats////////////////////////////////

//Black data
tabstat height if black==1 & sa==1, by(data) stat(n mean sd min max)
tabstat height if black==1 & sa==1 & age>22, by(data) stat(n mean sd min max)

//Ethnicity
tabstat height if black==1 & sa==1, by(ethnicdum) stat(n mean sd min max)
tabstat height if black==1 & sa==1 & age>22, by(ethnicdum) stat(n mean sd min max)

//Whites
tabstat height if black==2, by(data) stat(n mean sd min max)

///////////////////////////Combined data////////////////////////////////

histogram height if black==1 & sa==1, by(data) kdensity bin(28)

drop if data == 4

preserve
drop if black == 2

//Basic
twoway (lpolyci height birthyear if sa==1), xline (1932) xline (1948) xlabel(1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(2) order(2 1) label(2 "Black male heights"))

//Age > 22
twoway (lpolyci height birthyear if sa==1)  (lpolyci height birthyear if sa==1 & age>22), xline (1932) xline (1948) xlabel(1890 1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(2) order(2 3) label(2 "18 < Age < 50") label(3 "23 < Age < 50"))

drop if age<23
//Individual datasets
twoway (lpolyci height birthyear if data==2 & sa==1 & birthyear>1919 & birthyear<1970) (lpolyci height birthyear if data==1 & sa==1)  (lpolyci height birthyear if data==3 & sa==1), xline (1932) xline (1948) xlabel(1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(3) order(3 2 4) label(3 "WW2") label(2 "Wits") label(4 "NIDS"))

//Mining
twoway (lpolyci height birthyear) if mine==1, xline (1932) xline (1948) xlabel(1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(2) order(2 1) label(2 "Smoothed fit"))

//Ethnicity
twoway (lpoly height birthyear if ethnicdum==3)(lpoly height birthyear if ethnicdum==8) (lpoly height birthyear if ethnicdum==9), xline (1932) xline (1948) xlabel(1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(3) order(1 2 3) label(1 "Sotho") label(2 "Xhosa") label(3 "Zulu"))

//Remuneration
twoway (lpolyci height birthyear if birthyear > 1909 & birthyear < 1971 & black == 1, yaxis(1)) (line fiverem fiveyear, yaxis(2)), xlabel(1910 1920 1930 1940 1950 1960 1970) legend(pos(6) col(2) order(2 1 3) label(2 "Smoothed fit") label(3 "Gold mining remuneration"))


//White comparison
restore

drop if data==4
drop if birthyear<1880

drop if age<23
twoway (lpolyci height birthyear if black ==1 & sa==1) (lpolyci height birthyear if black==2 & sa==1), xline (1932) xline (1948) xlabel(1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(2) order(2 3) label(2 "Black") label(3 "White"))

twoway histogram birthyear, by(black)  xlabel(1870 1900 1930 1960 1990)

///////////////////////////Whites//////////////////////////////////////

////WW1///
//Import 'data' from White living standards project

keep height birthyear nationalitydum age
drop if age<18
drop if age>49
keep if nationalitydum==4

///Cadavers///

drop if gender==2
drop if age<18
drop if age>49
drop if popgroup=="."

keep if popgroupdum==3

keep birthyear height age

///NIDS///
use "C:\Users\johanf\Dropbox\1 Research\3 LIVING STANDARDS\FIM Black living standards\Revise\NIDS.dta", clear

drop if birthyear<1956
drop if birthyear>1990
drop if best_height<125
//drop if best_height<(178.238-4*7.408339) | best_height>( 178.238+4*7.408339) & best_height!=.

keep if gender==1
keep if race==4
drop if age<18
drop if age>49

keep birthyear best_height age

///WW2///

*use from WW2 Excel file

keep if birco=="rsa"
drop if nationality=="cape coloured"
gen height=.
replace height= htft*30.48+ htin*2.54

drop if height>210
drop if height<125
drop if age>49
drop if age<18
drop if biryr>27 & biryr<90
//drop if biryr<0

gen birthyear = .
replace birthyear = 1900 + biryr if biryr<89
replace birthyear = 1800 + biryr if biryr>89

keep birthyear height age

/// All

drop if data == 4
drop if birthyear<1890

twoway (lpolyci height birthyear if black ==1)  (lpolyci height birthyear if black==2), xline (1932) xline (1948) xlabel(1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980 1990) legend(pos(6) col(2) order(2 3) label(2 "Black") label(3 "White"))
