# 2017 10 27
project=(Chart Lang Math Time Closure Mockito)
ids0=(3 5 9 13 17 21 25 26)  
ids1=(44 51 53 58)
ids2=(69 73 81 85 2 4 7 24 40 49 78)
ids3=(4 7 11 12)
ids4=(1 2 3 5 61 62 67 72)
ids5=(29 38)

length=${#project[*]}



echo "the tests size is $length==================="

for((i=0;i<${#project[*]};i++))   
do
	eval idName=\${ids${i}[@]} 
	for j in $idName
	do
	wd=./testResults/${project[i]}_$j
	if [ -d "$wd/" ]; then
  		echo "rm $wd now..."	
		rm -rf $wd
		echo "$wd is removed..."
	fi
	
	infoTxt="testResults/info.txt"
	if [  -f "$infoTxt" ]; then
  		echo "rm $infoTxt now..."	
		rm -f $infoTxt
		echo "$infoTxt is removed..."
	fi

	if [[ -f "debug.log" ]] || [[ -f "diagnostics.log" ]]; then
  		echo "rm "debug.log" now..."	
		rm -f "debug.log" "diagnostics.log" "patch_1.diff" "solver.out.z3" "output.json" 
		echo "debug.log & some other Z3 files are removed..."
	fi

	timeTxt="time.txt"
	if [  -f "$timeTxt" ]; then
  		echo "rm $timeTxt now..."	
		rm -f $timeTxt "recordBoth.txt"
		echo "$timeTxt is removed..."
	fi
	done
done
