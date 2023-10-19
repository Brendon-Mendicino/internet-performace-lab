# compute the size at the physical layer of transmitted data
# add 1 UDP header of 8 bytes
# and k IP+ETH enters for k fragments
# the function (ceil((s+8-1)/1480) counts the number of IP fragments.

D(s)= (s+8)+(20+38)*(1+floor((s+8-1)/1480))

# compute the eventual padding on the last fragment.
padding(x) = ((x)<46)?(46-x):(0)

# and put everything together.
# the size of the last fragment would be ((s+8)%1480 + 20) where the % is the modulus operator
# that returns the remainder of the division by 1480

Dtot(s)= D(s) + padding(floor(s+8)%1480+20)

set term png
set out "RTT-10Mbps.png"

set xlabel "S [bytes]"
set ylabel "RTT [ms]"
set key left
plot 'all172.16.14.2.dat' using ($1):2 title "RTT Min" with lines,\
     'all172.16.14.2.dat' using ($1):3 title "avg RTT" w lines,\
     'all172.16.14.2.dat' using ($1):4 title "RTT max" w lines,\
     'all172.16.14.2.dat' using ($1):(8*2*Dtot($1)/10000.0) title "theoretical RTT min" with lines
#caso con switch:
#    'all172.16.14.2.dat' using ($1):(8*(2*Dtot($1)+2*($1 < 1473 ? Dtot($1):1538))/10000.0) title "theoretical RTT min" with lines

# compute the speed now
speed(d,rttMin) = 8*(2*Dtot(d))/rttMin/1000
#caso con switch:
#speed(d,rttMin) = 8*(2*Dtot(d)+2*($1 < 1473 ? Dtot(d):1538))/rttMin/1000
     
set term png
set out "speed-10Mbps.png"

set xlabel "S [bytes]"
set ylabel "C [Mb/s]"

plot 'all172.16.14.2.dat' using ($1):(speed($1, $2)) title "real" with lines
