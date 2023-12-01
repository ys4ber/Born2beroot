#!/bin/bash
while true; do
	uname -a | wall

	echo "Physizal processors : "
	lscpu | grep "Socket(s)" | awk '{print $2}'
	echo ""

	echo "Virtual processors :"
	nproc
	echo ""

	total_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
	used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
	avai_ram=$(free -m | awk '$1 == "Mem:" {print $7}')
	usage_percent=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

	echo "Total RAM : $total_ram MB"
	echo "Available RAM : $avai_ram MB"
	echo "RAM Utilization : $usage_percent%"
	echo ""

	full_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
	usage_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
	disk_usage=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

	echo "FULL DISK : $full_disk MB"
	echo "USAGE DISK : $usage_disk MB"
	echo "DISK USAGE : $disk_usage%"
	echo ""

	cpu_utilization=$(top -bn1 | grep '%Cpu' | awk '{print $2}' | cut -d '.' -f1)
	echo "CPU Utilization: $cpu_utilization%"
	echo ""

	last_reboot=$(who -b | awk '{print $3, $4}')
	echo "Last Reboot: $last_reboot"
	echo ""

	lvm=$(lsblk | grep "lvm" | wc -l)
	lvm_status=$(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)
	echo "Is LVM Active ? : $lvm_status"
	echo ""

	active_con=$(netstat -tun | grep -c 'ESTABLISHED')
	echo "Num of Active Connections: $active_con"
	echo ""

	num_users=$(who | wc -l)
	echo "Number of Users Logged In: $num_users"
	echo ""

	mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
	echo "MAC ADDRESS : $mac"
	echo ""

	sudo_cmds=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)
	echo "The number of commands executed with the sudo program : $sudo_cmds"
	echo ""

	sleep 100000;

done
