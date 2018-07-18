project=(Chart)
ids0=(5)
:<<!
project=(Chart Lang Math Time Closure Mockito)
ids0=(3 5 9 13)  
ids1=(44 51 53 58)
ids2=(69 73 81 85)
ids3=(4 7 11 12)
ids4=(61 62 67 72)
ids5=(29 38)
!

start=0
cnt=1

NopolVersion=RFANopol
maxTimeType=30   ##### NOTICE: 300 & 30 have much difference. So I recommend that we use 30 for saving time, as 300 and 30 can both not repair the same suspicious statement (in most cases I guess), but the 300 consumes more time.

timeDir=/home/dehengyang/Nopol/$NopolVersion/
cleanDir=/home/dehengyang/environment/test/defects4j-dale/buggyPrograms/NopolRepairPrograms/
cd $cleanDir
echo "come to dir to clean files for initialization: $PWD"
./allClean.sh
cd $timeDir
echo "come back to start repair: $PWD"


#遍历每个project
for((i=0;i<${#project[*]};i++))
do
	#取到对应的ids,也就是对应的缺陷程序
	eval idName=\${ids${i}[@]} 

	#对每个ids中的数字id进行遍历
	for j in $idName
	do
		wd=/home/dehengyang/environment/test/defects4j-dale/buggyPrograms/NopolRepairPrograms/${project[i]}/${project[i]}_$j/
		d4jDir=/home/dehengyang/environment/test/defects4j-dale/defects4j/framework/projects/
		z3=/home/dehengyang/Nopol/$NopolVersion/lib/z3/z3_for_linux
		jar=/home/dehengyang/Nopol/$NopolVersion/nopol/target/nopol-0.2-SNAPSHOT-jar-with-dependencies.jar

		cd $wd
		buggyResultDir="./testResults/${project[i]}_$j"
		if [ ! -d "./testResults" ]; then
			mkdir ./testResults
	    	fi
		if [ ! -d "$buggyResultDir" ]; then
			mkdir $buggyResultDir
	    	fi
		echo "dale..."
		for((k=$start;k<$cnt;k++))
		do
			startTime=$(date +%s)
			echo "现在时间：`date '+%Y%m%d %H%M%S'`"  
			echo -e "=================================  we are running ${project[i]}_$j ================================= \n\n"
			export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
			if [[ "${project[i]}_$j" == Chart* ]]; then
			#Chart 就这一个情况
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
				--mode repair --maxTime 30 --oracle angelic \
				--type pre_then_cond --flocal gzoltar \
				--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
				--source $wd/source/ \
				--classpath $wd/build/:$wd/build-tests/:$wd/lib/servlet.jar:$jar \
				> $buggyResultDir/${project[i]}_${j}_$k.txt
			elif [[ "${project[i]}_$j" == Time* ]]; then
				if [[ $j -lt 12 ]]; then
					cPath1=$wd/target/classes/
					cPath2=$wd/target/test-classes/
				else
					cPath1=$wd/build/classes/
					cPath2=$wd/build/tests/
				fi
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
					--mode repair --maxTime 30 --oracle angelic \
					--type pre_then_cond --flocal gzoltar --complianceLevel 5 \
					--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
					--source $wd/src/main/java/  \
					--classpath $cPath1:$cPath2:$d4jDir/Time/lib/joda-convert-1.2.jar:$jar \
					> $buggyResultDir/${project[i]}_${j}_$k.txt
			elif [[ "${project[i]}_$j" == Lang* ]]; then
			#Lang 大于42的情况
				if [[ ${j} -lt 21 ]]; then
					src1=$wd/src/main/java/ 
					cPath1=$wd/target/tests/
					complianceLevel=6
				elif [[ ${j} -lt 36 ]]; then
					src1=$wd/src/main/java/ 
					cPath1=$wd/target/test-classes/
					complianceLevel=6
				elif [[ ${j} -lt 42 ]]; then
					src1=$wd/src/java/ 
					cPath1=$wd/target/test-classes/
					complianceLevel=5
				else
					src1=$wd/src/java/ 
					cPath1=$wd/target/tests/
					complianceLevel=3
				fi
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
				--mode repair --maxTime 30 --oracle angelic \
				--type pre_then_cond --flocal gzoltar --complianceLevel $complianceLevel \
				--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
				--source $src1 \
				--classpath $wd/target/classes/:$cPath1:$jar \
				> $buggyResultDir/${project[i]}_${j}_$k.txt
			elif [[ "${project[i]}_$j" == Mockito* ]]; then
				mockitoLib=$d4jDir/Mockito/lib
				echo "mockitoLib is $mockitoLib"
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
				--mode repair --maxTime 30 --oracle angelic \
				--type pre_then_cond --flocal gzoltar --complianceLevel 5 \
				--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
				--source $wd/src/ \
				--classpath target/classes:target/test-classes:$mockitoLib/asm-all-5.0.4.jar:$mockitoLib/cglib-and-asm-1.0.jar:$mockitoLib/fest-assert-1.3.jar:$mockitoLib/hamcrest-all-1.3.jar:$mockitoLib/objenesis-2.1.jar:$mockitoLib/powermock-reflect-1.2.5.jar:$mockitoLib/assertj-core-2.1.0.jar:$mockitoLib/cobertura-2.0.3.jar:$mockitoLib/fest-util-1.1.4.jar:$mockitoLib/objenesis-2.2.jar:$jar \
				> $buggyResultDir/${project[i]}_${j}_$k.txt
			elif [[ "${project[i]}_$j" == Closure* ]]; then
			#Closure 1 2 3 5
				if [[ $j -lt 67 ]]; then
					jarClosure=$wd/build/lib/rhino.jar:$wd/lib/jarjar.jar
				else
					jarClosure=$wd/lib/libtrunk_rhino_parser_jarjared.jar
				fi
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
				--mode repair --maxTime 30 --oracle angelic \
				--type pre_then_cond --flocal gzoltar --complianceLevel 6 \
				--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
				--source $wd/src/ \
				--classpath $wd/build/classes/:$wd/build/test/:$wd/lib/ant.jar:$wd/lib/ant-launcher.jar:$wd/lib/args4j.jar:$wd/lib/guava.jar:$wd/lib/json.jar:$wd/lib/jsr305.jar:$wd/lib/junit.jar:$wd/lib/caja-r4314.jar:$wd/lib/protobuf-java.jar:$jar:$jarClosure \
				> $buggyResultDir/${project[i]}_${j}_$k.txt
			else
			#Math 小于85的情况
				if [[ $j -lt 85 ]]; then
					srcPath=$wd/src/main/java/
				else
					srcPath=$wd/src/java/
				fi
				time java -d64 -Xmx4096m -Xms1g -XX:MaxPermSize=1024m -cp $jar fr.inria.lille.repair.Main \
				--mode repair --maxTime 30 --oracle angelic \
				--type pre_then_cond --flocal gzoltar \
				--solver z3 --solver-path $z3 --maxTimeType $maxTimeType \
				--source $srcPath \
				--classpath $wd/target/classes/:$wd/target/test-classes/:$d4jDir/Math/lib/commons-discovery-0.5.jar:$jar \
				> $buggyResultDir/${project[i]}_${j}_$k.txt
				
			fi
			#前面一行一定要写fi啊。要和if匹配，善始善终
			endTime=$(date +%s)
			repairTime=$(($endTime-$startTime))
			echo "============================ The $k th repair for ${project[i]}_$j running time is: $repairTime s ============================"	
			curTime=$(date +%y%m%d%T)
			curTime2=`date '+%Y%m%d %H%M%S'`
	    	    	echo "============================ The $k th repair for ${project[i]}_$j running time is: $repairTime s ============================" >> $timeDir/time.txt
		    	echo "============================ The current time is  $curTime    $curTime2============================" >> $timeDir/time.txt
			if [ -f "./testResults/info.txt" ]; then    
				mv ./testResults/info.txt $buggyResultDir/repairInfo_${project[i]}_${j}_$k.txt
			else
				touch $buggyResultDir/FailedRepairInfo_${project[i]}_${j}_$k.txt
			fi

			echo "before kill memory is :"
			read mem< <(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/Buffers/{buffers=$2}/^Cached/{cached=$2}END{print (total-free-buffers-cached)/1024}'  /proc/meminfo)
			#mem=awk '/MemTotal/{total=$2}/MemFree/{free=$2}/Buffers/{buffers=$2}/^Cached/{cached=$2}END{print (total-free-buffers-cached)/1024}'  /proc/meminfo
			echo $mem
			echo $mem >>$timeDir/time.txt
			echo >>$timeDir/time.txt
			echo
			echo "before kill: the z3_for_linux pid"
			pgrep z3_for_linux
			pkill -9 z3_for_linux
			echo
			echo "after kill: the z3_for_linux pid"
			pgrep z3_for_linux
			echo
			echo "after kill memory is :"
			read mem< <(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/Buffers/{buffers=$2}/^Cached/{cached=$2}END{print (total-free-buffers-cached)/1024}'  /proc/meminfo)
			echo $mem
			echo $mem >>$timeDir/time.txt
			echo >>$timeDir/time.txt
	    		echo "The $k th repair for ${project[i]}_$j ended:------------"
		done
		if [ -d "/home/dehengyang/Nopol/$NopolVersion/testResults/${project[i]}_$j/" ];then 
			rm -rf /home/dehengyang/Nopol/$NopolVersion/testResults/${project[i]}_$j/
		fi
		mv $buggyResultDir /home/dehengyang/Nopol/$NopolVersion/testResults/
	done
done
