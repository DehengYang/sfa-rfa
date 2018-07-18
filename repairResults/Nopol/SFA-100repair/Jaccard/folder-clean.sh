project=(Chart Lang Math Time Closure Mockito)

for((i=0;i<${#project[*]};i++))
do
	rm -rf ${project[i]}*
done
