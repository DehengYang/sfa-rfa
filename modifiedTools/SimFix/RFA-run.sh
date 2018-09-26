##

:<<!
project=(chart closure math lang)
ids0=(12 20)
ids1=(115)
ids2=(35 50 53 5 63 70 75 85)
ids3=(27 33 41 43 50 )


math  35 53  5 63 75 chart 12  lang 33 
!


project=(chart math lang)
ids0=(12)
ids1=(5 35 53 63 75)
ids2=(33)
# math
start=0
cnt=3

if [ ! -d "RFA-terminalLog/" ]; then
	mkdir RFA-terminalLog/
fi

terminalLog=RFA-terminalLog/

for((k=$start;k<$cnt;k++))
do

for((i=0;i<${#project[*]};i++))
do
	eval idName=\${ids${i}[@]} 
	for j in $idName
	do

		
			startTime=$(date +%s)
			echo "current time is：`date '+%Y%m%d %H%M%S'`"  

			java -jar RFA-simfix.jar --proj_home=/home/dehengyang/SimFix/buggyprograms --proj_name=${project[i]} --bug_id=${j} > $terminalLog/${project[i]}_${j}_${k}.txt


			endTime=$(date +%s)
			repairTime=$(($endTime-$startTime))
			curTime2=`date '+%Y%m%d %H%M%S'`

			echo "============================ The current time is  $curTime    $curTime2============================" >> $terminalLog/time.txt
		    	echo "============================ The $k th repair for ${project[i]}_$j running time is: $repairTime s ============================" >> $terminalLog/time.txt
			echo >> $terminalLog/time.txt
			echo >> $terminalLog/time.txt


			if [ -d "patch/${project[i]}/${j}" ]; then
				mv patch/${project[i]}/${j}  patch/${project[i]}/${j}_${k}
			fi

			if [ -f "log/${project[i]}/${j}.log" ]; then
				mv log/${project[i]}/${j}.log  log/${project[i]}/${j}_${k}.log
			fi
			
		
	done
done
done
