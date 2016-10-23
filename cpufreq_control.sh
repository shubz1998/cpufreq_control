#!bin/bash

isRoot()
{
	if [ "$EUID" -ne 0 ]
	then echo "Please run script using sudo"
	exit
	fi
}
check()
{
	b="$(sudo cpupower info)"
	if [ "$?" != "0" ]
	then
	echo "cpupower not installed. Install it first as mentioned in readme file"
	exit
	fi
	echo
}

showinfo()
{
	model="$(sudo cat /proc/cpuinfo | grep -i 'model name'| head -1)"
	freqrange="$(sudo cpupower frequency-info | grep -i 'hardware limits')"
	noofcores="$(sudo cat /proc/cpuinfo | grep -i 'cpu cores'| head -1)"
	logicalprocessor="$(sudo cat /proc/cpuinfo | grep -i 'siblings'| head -1)"
	echo $model
	echo $freqrange
	echo $noofcores
	echo $logicalprocessor

}

currentstatus()
{
	watch grep -i \"cpu MHz\" /proc/cpuinfo
}

reset()
{
	b="$(sudo cpupower frequency-info | grep -i 'hardware limits' )"
	a="${b}"
	min=${a:19:3}
	max=${a:30:3}
	#echo $min $max
	sudo cpupower frequency-set -d "$min"GHz           
	sudo cpupower frequency-set -u "$max"GHz
	sudo cpupower frequency-set -g powersave
	echo
	echo "Everything Set as it was earlier!! :) "
	echo 
}

setfrequency()
{
	freqrange="$(sudo cpupower frequency-info | grep -i 'hardware limits')"
	echo "note that " $freqrange
	echo "Enter Minimum frequency(in MHz)(1GHz = 1000MHz) of cpu you want"
	read min
	echo "Enter Maximum frequency(in MHz) of cpu you want(enter same value as of min if u want cpu to operate at particular value)"
	read max
	cpupower frequency-set -d "$min"MHz
	cpupower frequency-set -u "$max"MHz
	echo
	echo "Frequency Set Succesfully"
	echo
}

changegovernor()
{
	ans=$(sudo cpupower frequency-info | grep -i 'governors')
	echo "For Your Processor" $ans
	echo
	cur=$(sudo cpupower frequency-info | grep -i 'The governor')
	echo "CURRENT CONFIGURATION:" $cur
	echo
	echo "Enter one of availale governor for your cpu"
	read gov
	sudo cpupower frequency-set -g "$gov"
	if [ "$?" == "0" ]
	then
	echo "Governor Change successful"
	echo
	else
	echo "COuldn't Change Governor"
	echo
	fi
}

mainf()
{
	while : 
	do
		echo
		echo "____________CPU FREQ CONTROLLER___________"
		echo
		echo -e "\t1. Show Details About Your CPU"
		echo -e "\t2. See Realtime Frequency of CPU's(Press ctrl+c to come out from page it will take you to)."
		echo -e "\t3. Set frequency of CPU's."
		echo -e "\t4. Change Governor of CPU's"
		echo -e "\t5. Set everything to Default"
		echo -e "\t6. Exit"
		echo
		echo "Enter your choice"
		read choice
		
		case $choice in
			1)
				showinfo
				;;
			2)
				currentstatus
				;;
			3)
				setfrequency
				;;
			4)
				changegovernor
				;;
			5)
				reset
				;;
			6)	exit
				;;
			*)
				echo "Wrong Option"
				;;
		esac
	done
}




isRoot
check
mainf


