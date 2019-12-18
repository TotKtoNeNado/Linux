#Разместить в /opt/monlog.sh
#!/bin/bash
WORD=$1
LOG=$2


DATE=`date +%d/%b/%Y:%T" "%z`


grep --quiet $WORD $LOG

# Проверяем exit code предыдущей команды и если он равен 0, то делаем свои дела
if [[ $? -eq 0 ]]; then
    logger "$DATE: LogMon - I found $WORD, in $LOG my Master"
    exit 0
    else
    exit 0
fi

exit 0