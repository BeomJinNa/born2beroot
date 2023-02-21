#!/bin/bash

echo "#Architecture: $(uname -a)"
echo "#CPU physical : $(sort -u /proc/cpuinfo | grep -c 'physical id')"
echo "#vCPU : $(grep -c 'processor' /proc/cpuinfo)"
printf "#Memory Usage: $(free -m | grep Mem | awk '{print$3}')/"
printf "$(free -m | grep Mem | awk '{print$2}')MB ("
free -m | grep Mem | awk '{printf "%.2f%)\n", $3/$2*100}'
printf "#Disk Usage: $(df -BM | grep mapper | awk '{sum +=$3} END {print sum}')/"
printf "$(df -BG | grep mapper | awk '{sum +=$4} END {print sum}')Gb ("
df -BM | grep mapper | awk '{sum1 +=$3} {sum2 +=$4} END {printf "%.f%)\n", sum1/sum2 * 100}'
printf "#CPU load: "
mpstat | grep all | awk '{printf "%.1f%\n", 100.0 - $(NF)}'
who -b | awk '{printf "#Last boot: %s %s\n", $3, $4}'
if [ $(lsblk | grep -c lvm) -gt 0 ]
then
        echo "#LVM use: yes"
else
        echo "#LVM use: no"
fi
echo "#Connections TCP : $(ss -t | grep -c ESTAB) ESTABLISHED"
echo "#User log: $(who | wc -l)"
ip address | grep inet | grep enp0s3 | cut -d / -f 1 | awk '{printf "#Network: IP %s ", $(NF)}'
ip address | grep link/ether | awk '{printf "(%s)\n", $2}'
echo "#Sudo : $(journalctl _COMM=sudo | awk '{print $5}' | sort -u | grep -c sudo) cmd"
