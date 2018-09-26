# less than 10 minutes: chart  20   lang 27 lang 33 41 43 50 58 63 math 1 35 50 53 5 63 70  75 85 
# closure 115
#less than 15 minutes: chart 12 math 71 98  closure 57 73 



source /etc/profile
#otherwise defects4j will not be recognized in the Root Terminal

project=(Chart Closure Math Lang)
ids0=(12)
ids1=(115)
ids2=(1 35 50 53 5 63 70 75 85)
ids3=(27 33 41 43 50 63 )

project1=(chart closure math lang)

#遍历每个project
for((i=0;i<${#project[*]};i++))   
do
	#取到对应的ids
	eval idName=\${ids${i}[@]} 
	#对每个ids中的数字id进行遍历
	for j in $idName
	do
		echo "getting bug ${project[i]}-$j----------------"
		echo "i is : $i, and j is $j. "
		wd=${project1[i]}_${j}_buggy
		defects4j checkout -p ${project[i]} -v ${j}b -w ${wd}
		#cd ${wd}
		#defects4j compile
		#defects4j test | tee > testInfo.txt
		#cd ../
		echo "Successfully downloads bug ${project[i]}-$j----------------"
	done
done

