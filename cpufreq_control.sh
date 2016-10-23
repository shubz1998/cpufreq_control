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
		echo "Cpupower not installed."
		echo "Do you want to install 'CPUPOWER' (y/n)"
		read ans
		case $ans in
			y)
				echo "Installing 'CPUPOWER' "
				echo
				apt update && apt dist-upgrade && apt install linux-tools-common linux-tools-generic linux-cloud-tools-generic
				;;
			Y)
				echo "Installing 'CPUPOWER' "
				echo
				apt update && apt dist-upgrade && apt install linux-tools-common linux-tools-generic linux-cloud-tools-generic
				;;
			n)
				echo "Exiting the script"
				exit
				;;
			N)
				echo "Exiting the script"
				exit
				;;
			*)
				echo "Exiting the script"
				exit
				;;
		esac
	fi
	echo
}

showinfo()
{
	echo
	model="$(sudo cat /proc/cpuinfo | grep -i 'model name'| head -1)"
	freqrange="$(sudo cpupower frequency-info | grep -i 'hardware limits')"
	noofcores="$(sudo cat /proc/cpuinfo | grep -i 'cpu cores'| head -1)"
	logicalprocessor="$(sudo cat /proc/cpuinfo | grep -i 'siblings'| head -1)"
	echo $model
	echo $freqrange
	echo $noofcores
	echo $logicalprocessor
	wait_r
}

currentstatus()
{
	watch grep -i \"cpu MHz\" /proc/cpuinfo
}

reset()
{
	echo
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
	wait_r
}

NumCheck(){
	re='^[0-9]+([.][0-9]+)?$'
	if ! [[ $1 =~ $re ]] ; then
		echo
   		echo "Error: Not a number"
   		return 1
	else
		return 0
	fi
}

setfrequency()
{
	echo
	freqrange="$(sudo cpupower frequency-info | grep -i 'hardware limits')"
	echo "Note that " $freqrange
	echo
	echo "Enter Minimum frequency(in MHz)(1GHz = 1000MHz) of cpu you want"
	read min
	NumCheck $min
	if [ "$?" -ne "0" ]; then
		echo "Please enter a valid number."
		wait_r
		return
	fi
	echo "Enter Maximum frequency(in MHz) of cpu you want(enter same value as of min if u want cpu to operate at particular value)"
	read max
	NumCheck $max
	if [ "$?" -ne "0" ]; then
		echo "Please enter a valid number."
		wait_r
		return
	fi
	echo
	echo "Setting Minimum Frequency"
	cpupower frequency-set -d "$min"MHz
	echo
	echo "Setting Maximum Frequency"
	cpupower frequency-set -u "$max"MHz

	if [ "$?" -ne "0" ]; then
		echo
		echo "Frequency couldn't be set. Please Try Again."
		echo
	else
		echo
		echo "Frequency Set Succesfully"
		echo
		#statements
	fi
	wait_r
}

changegovernor()
{
	echo
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
	echo "Couldn't Change Governor"
	echo
	fi
	wait_r
}

mainf()
{
	while : 
	do
		clear
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
			6)	clear
				exit
				;;
			*)
				echo "Wrong Option"
				;;
		esac
	done
}

wait_r(){
	echo
	echo "Press <Enter> to continue"
	read junk
	return 0
}


isRoot
check
mainf


