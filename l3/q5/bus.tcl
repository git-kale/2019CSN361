# create a simulator object
set ns [new Simulator]

# define different colors for data flows (for NAM)
$ns color 0 blue
$ns color 1 red
$ns color 2 cyan
$ns color 3 green
$ns color 4 yellow
$ns color 5 violet

# open the nam trace file
set nf [open bus.nam w]
$ns namtrace-all $nf

# define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the trace file
    close $nf
    #Execute nam on the trace file
    exec nam bus.nam &
    exit
}

# take N as input
puts "Enter N"
set data [gets stdin]
scan $data "%d" N

# create N new nodes
for {set i 0} {$i < $N} {incr i} {
    set n($i) [$ns node]
}

set str "$n(0)"
for {set i 1} {$i < $N} {incr i} {
    append str " $n($i)"
}

$ns make-lan $str 0.5Mb 40ms LL Queue/DropTail Mac/802_3

# take K as input
puts "Enter K"
set data [gets stdin]
scan $data "%d" K

puts "Enter K pairs of nodes: <source> <sink>"
for {set i 0} {$i < $K} {incr i} {

    # take source and sink as input
    set data [gets stdin]
    scan $data "%d %d" j k

    # create a TCP agent and attach it to node n(j)
    set tcp($i) [new Agent/TCP]
    $ns attach-agent $n($j) $tcp($i)

    # create a TCP Sink agent (delayed ACK TCP) for TCP and attack it to node n(k)
    set sink($i) [new Agent/TCPSink/DelAck]
    $ns attach-agent $n($k) $sink($i)

    # connect the traffic source with traffic sink
    $ns connect $tcp($i) $sink($i)

    # set different color by using flow ID
    $tcp($i) set fid_ $i
}

# create a FTP and attach to tcp
for {set i 0} {$i < $K} {incr i} {
    set ftp($i) [new Application/FTP]
    $ftp($i) attach-agent $tcp($i)
}

#Schedule events for the FTP agents
for {set i 0} {$i < $K} {incr i} {
    $ns at 0.5 "$ftp($i) start"
    $ns at 3.5 "$ftp($i) stop"
}

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run
