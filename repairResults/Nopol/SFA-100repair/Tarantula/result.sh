project=(Chart Math)
ids0=(17 21 25 26)
ids1=(2 4 7 24 40 49)

:<<!
project=(Chart Lang Math Time Closure Mockito)
ids0=(3 5 9 13)  
ids1=(44 51 53 58)
ids2=(69 73 81 85)
ids3=(4 7 11 12)
ids4=(61 62 67 72)
ids5=(29 38)
!

dirNum=`ls -lR|grep "^d"|wc -l`
if [ $dirNum -eq 0 ]; then
	echo "dirs do not exist and need to be copied"
	cp -rf ../testResults/* ./
else
	echo "dirs exist and do not need cp"
fi

for((i=0;i<${#project[*]};i++))
do
	eval idName=\${ids${i}[@]} 
	for j in $idName
	do
		dire1=${project[i]}_$j
		if [ -d "$dire1" ]; then
			cd $dire1
			echo "now in the dir $dire1"
			dirSize=`find ./ -type f | wc -l`
			echo "the dirSize is: $dirSize"

			# delete the recordFile before new record.
			if [ -f "../experimentData_${project[i]}_$j.txt" ];then
				rm ../experimentData_${project[i]}_$j.txt
			fi

			for((k=0;k<dirSize/2;k++))
			do
				file="repairInfo_${project[i]}_${j}_$k.txt"
				if [ -f "$file" ]; then
					echo  -e "now in the file $file \n"
					#wc -c $file
					#echo "last 3 lines: "				
					line1=$(tail -4 $file|head -n 1)
					line2=$(tail -1 $file)	
					line3=$(tail -9 $file|head -n 1)
					rank=`grep "$line3" $file | head -n 1 | cut -f 1 -d " " | tr -cd "[0-9]"`
	#				line3="$line1"" +    ""$line2"
					#echo "$line1 + $line2"
	#				echo "$line3"
					#num1=`echo $line1 | tr -cd "[0-9]"`
					#echo "$num1"
					#num2=`echo $line2 | tr -cd "[0-9]"`
					#echo "$num2"

					#cat experimentData.txt 
					echo "$line1   $rank  $line2    $line3 " >> ../experimentData_${project[i]}_$j.txt 
					#echo >> 0000experimentData.txt 
				else
					echo "$file does not exist" >> ../experimentData_${project[i]}_$j.txt 		
				fi
			done
			cd ..
			echo "after cd the current dir is : $PWD"
		else 
			echo "$dire1 does not exists"	
		fi
	done
done
