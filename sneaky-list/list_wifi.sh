#! /bin/sh

## written by Arnaud Meauzoone april 2017

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

filePath='/usr/local/sneaky-wifi'
filePathSneaky_list='/usr/local/sneaky-wifi/sneaky-list'

progress()
{
  echo -n '[                                        ](10%)\r\c'
  sleep 1

  echo -n '[####>                                   ](10%)\r\c'
  sleep 1

  echo -n '[########>                               ](20%)\r\c'
  sleep 1

  echo -n '[############>                           ](30%)\r\c'
  sleep 1

  echo -n '[################>                       ](40%)\r\c'
  sleep 1

  echo -n '[####################>                   ](50%)\r\c'
  sleep 1

  echo -n '[########################>               ](60%)\r\c'
  sleep 1

  echo -n '[############################>           ](70%)\r\c'
  sleep 1

  echo -n '[################################>       ](80%)\r\c'
  sleep 1

  echo -n '[####################################>   ](90%)\r\c'
  sleep 1

  echo -n '[########################################](100%)\r\c'
  sleep 1

  echo -n '\n'
}

clean() {
  echo "Cleaning up"

  if [ -f $filePathSneaky_list/tmp-01.csv ]
  then
    rm $filePathSneaky_list/tmp-01.csv
  fi

  if [ -f $filePathSneaky_list/list.txt ]
  then
    rm $filePathSneaky_list/list.txt
  fi
}

clear
clean

interface=`airmon-ng | grep "Atheros" | awk '{print $2}'`

if [ "$interface" = "" ]
then
  echo "${RED}ERROR${NC}: Wifi device not found"
  echo "${RED}ERROR${NC}: insert a wifi key compatible with monitor mode "
  echo "${RED}ERROR${NC}: For now we only support the TL-WN722N"
  echo "${RED}ERROR${NC}: Quitting !! "
  exit 0
fi

ifconfig $interface down

echo "${GREEN}OK${NC}: Wifi device found ... going on !"

if iwconfig $interface mode monitor ; then
  echo "${GREEN}OK${NC}: wifi device now in monotor mode"
else
  exit 0
fi

ifconfig $interface up

echo "Scanning wifi please wait ..."

timeout 10 nohup airodump-ng --output-format csv -w $filePathSneaky_list/tmp $interface > /dev/null 2>&1 &

progress

python $filePathSneaky_list/parse.py $filePathSneaky_list/tmp-01.csv > $filePath/list.txt 2>/dev/null

if [ -f $filePathSneaky_list/tmp-01.csv ]
then
  rm $filePathSneaky_list/tmp-01.csv
fi

echo "List done, please check: $filePath/list.txt"
