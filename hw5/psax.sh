#!/usr/bin/env bash

#Заголовок
printf  '%7s %-7s %-7s %-7s  %s %-10s\n' "PID" "TTY" "STAT" "TIME" "COMMAND"

#Получаем системную переменную 'Clock ticks' для того чтоб потом спомощью неё преобразовать время в человеческое 
clk_tck=$(getconf CLK_TCK)

#Получаем PID и просматриваем все содержимое папок на получение сведений о каждого процесса  
for pid in $(ls -l /proc | awk '{print $9}' | grep -s "^[0-9]*[0-9]$"| sort -n );
do

#tty - Терминал с которым связан процесс (Смотрим поле, если не 0 то просматриваем директорию fd на наличие терминала или псевдотерминала)
	tty_t=`ls -l 2>/dev/null /proc/$pid/fd/ | grep -E '\/dev\/tty|pts' | cut -d\/ -f3,4`
	tty=`awk '{ if ($7 == 0) {printf "?"} else { printf "'"$tty_t"'" }}' /proc/$pid/stat 2>/dev/null`

#stat - Статусы процесса
	stat=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $3}')

#time - Процессорное время потраченное на процесс ( utime + stime и поделить на ClockTicks )
	utime=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $14}')
	stime=$(cat  2>/dev/null /proc/$pid/stat | awk '{print $17}')
	time=$(((utime + stime) / clk_tck))

# command - имя запущенного процесса
	cmd=$(cat 2>/dev/null /proc/$pid/status | head -1 | cut -d' ' -f1 |  awk '{print $2}')

#Вывод данных
printf  '%7d %-7s %-7s %-7s %s %-10s\n' "$pid" "$tty" "$stat" "$time" "$cmd"
done


#Вывод времени работы системы
uptime=$(awk '{printf("%d:%02d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60))}' /proc/uptime)
echo "uptime:  $uptime"