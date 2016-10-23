# cpufreq_control
Change/Control CPU frequency in Linux OS.

#How to Run
1. install linux-common-tools. sudo apt install linux-tools-common
2. write sudo cpupower in terminal , it would ask to install one more package specific to your kernel. Install that also.
3. Clone/Download the sh file
4. Run the following command in terminal sudo bash cpufreq_control.sh

#About
Since new intel processors have only two pstates : powersave and performance , Both of which are two extremem ends.
Powersave mode doesn't give that good performance while performance mode keep all the cores at their max frequency which 
raises the temperature of laptop.

Hence using above script file, u can acheive cpu frequencies as you want

