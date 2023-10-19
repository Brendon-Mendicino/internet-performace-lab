# numero di ripetizioni
N=20
# intervallo tra ripetizioni
I=0,02

# il mio target
TARGETS="172.16.14.2"

# Scegli le lunghezza da usare
myLenShort=`seq 72 100 1472`
myLenFine=`seq 1473 1 1573`
myLenLong=`seq 1580 100 8000`

#ripeti il ping per ogni lunghezza e per ogni host, estraendo il RTT minimo e la lunghezza
for host in $TARGETS; do
  #cancella i file vecchi per evitare problemi
  rm -f len${host}.dat rtt${host}.dat all${host}.dat
  for len in $myLenShort $myLenFine $myLenLong; do
    echo "pinging host $host with len $len"
    echo $len >> len${host}.dat
    sudo ping $host -s $len -c $N -i $I |grep min| cut -d '=' -f 2 | cut -d '/' -f 1,2,3 |tr '/' ' ' >> rtt${host}.dat
  done
  #incolla le lunghezze e i rispettivi RTT minimi
  paste len${host}.dat rtt${host}.dat >> all${host}.dat
done
