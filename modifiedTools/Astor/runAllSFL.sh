

# change SFL
SFLfile=/home/dehengyang/Astor/Astor/src/main/java/fr/inria/astor/core/faultlocalization/GZoltarFaultLocalization.java
#Jaccard Tarantula Op2 DStar Barinel
SFL=(Ochiai)
#unfinished : Jaccard Tarantula Op2 DStar

for((i=0;i<${#SFL[*]};i++))
do
	cd /home/dehengyang/Astor/Astor

	# cover the SFL file
	cp SFL/${SFL[i]}.java $SFLfile

	# record start time
	startTime=$(date +%s)
	stTime=`date '+%Y%m%d %H%M%S'`
	echo "start time: $stTime"


	# compile and run
	./mvn.sh
	./mutRepairRun

	# record repair time
	endTime=$(date +%s)
	echo "start time: $stTime" >> output_astor/repairTime.txt
	echo "end time: `date '+%Y%m%d %H%M%S'`" >> output_astor/repairTime.txt
	repairTime=$(($endTime-$startTime))
	echo "repairTime of ${SFL[i]} is : $repairTime s" >> output_astor/repairTime.txt

	#deal with output_astor dir
	mv output_astor/ output_astor-MutRepair-${SFL[i]}/
done
