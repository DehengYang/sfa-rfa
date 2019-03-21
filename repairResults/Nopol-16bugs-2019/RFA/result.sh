project=(Closure Time Math)
ids0=(1 2 3 5 7 8 10 14 15 16 113 120 121 131)
ids1=(18)
ids2=(42) 

:<<!
project=(Closure Time Math)
ids0=(1 2 3 5 7 8 10 14 15 16 113 120 121 131)
ids1=(18)
ids2=(42) 

dirNum=`ls -lR|grep "^d"|wc -l`
if [ $dirNum -eq 0 ]; then
	echo "dirs do not exist and need to be copied"
	cp -rf ../testResults/* ./
else
	echo "dirs exist and do not need cp"
fi
!

for((i=0;i<${#project[*]};i++))
do
	eval idName=\${ids${i}[@]} 
	for j in $idName
	do
		dire1=${project[i]}_$j
		if [ -d "$dire1" ]; then
			if [ -f "experimentData_${project[i]}_$j.txt" ]; then
				rm experimentData_${project[i]}_$j.txt
			fi
		
			cd $dire1
			#echo "now in the dir $dire1"
			dirSize=`find ./ -type f | grep repair | wc -l`
				#`find ./ -type f | wc -l`
			echo "the number of repairtxt in $dire1  is: $dirSize"
			for((k=0;k<dirSize;k++))
			do
				file="repairInfo_${project[i]}_${j}_$k.txt"
				if [ -f "$file" ]; then
					#echo  -e "now in the file $file \n"
					#wc -c $file
					#echo "last 3 lines: "				
					line1=$(tail -4 $file|head -n 1)
					#line2=$(tail -1 $file)	
					line3=$(tail -8 $file|head -n 1)
					#line4=$(tail -7 $file|head -n 1)


	#				line3="$line1"" +    ""$line2"
					#echo "$line1 + $line2"
	#				echo "$line3"
					#num1=`echo $line1 | tr -cd "[0-9]"`
					#echo "$num1"
					#num2=`echo $line2 | tr -cd "[0-9]"`
					#echo "$num2"

					#cat experimentData.txt 

					if [ ! -f "patch_${project[i]}_${j}_${k}.json" ];then
						echo "No Patch"  >> ../experimentData_${project[i]}_$j.txt 
					else
						echo "$line1  $line3" >> ../experimentData_${project[i]}_$j.txt 
					fi
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

