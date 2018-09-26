:<<!
project=(chart math lang)
ids0=(12)
ids1=(35 53 5 63 75)
ids2=(33)

!

project=(chart lang)
ids0=(12)
ids1=(33)
for((i=0;i<${#project[*]};i++))
do
	eval idName=\${ids${i}[@]} 
	for j in $idName
	do
		timeout 3600 /home/dehengyang/SimFix/sbfl/sbfl.sh ${project[i]} $j /home/dehengyang/SimFix/buggyprograms/${project[i]}/${project[i]}_${j}_buggy

	done
done


#/home/dehengyang/SimFix/sbfl/analysis/pipeline-scripts/crush-matrix
# /home/dehengyang/SimFix/sbfl/analysis/pipeline-scripts/previously-studied-flts
#/home/dehengyang/SimFix/sbfl/gzoltar
