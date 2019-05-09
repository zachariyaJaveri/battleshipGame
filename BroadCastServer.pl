#!/usr/bin/perl
use strict;
use warnings;
use IO::Select;
use IO::Socket;

#######################################################################
# MAXIMUM OF TWO PLAYERS, IF ONE QUITS, BOTH CONNECTIONS ARE DISABLED
#######################################################################

# ----------------------------------------------------------------------------
# set up port #
# ----------------------------------------------------------------------------
my $port = shift @ARGV;
$port = 8080 unless $port;

# ----------------------------------------------------------------------------
# set up
# ----------------------------------------------------------------------------

# keep track of client ips, and player numbers and names
my %clients;
my %pending_clients;
my $max_players = 2;


# ----------------------------------------------------------------------------
# create a listening socket
# ----------------------------------------------------------------------------
my $socket = new IO::Socket::INET( Listen => 1, LocalPort => $port );

# ----------------------------------------------------------------------------
# create a IO select object
# ----------------------------------------------------------------------------
# - used to know if the socket currently has something available to read
my $read_writable = new IO::Select($socket);

# ----------------------------------------------------------------------------
# wait until we have something to read, then read it
# ----------------------------------------------------------------------------
while ( my @readables = $read_writable->can_read ) {

    # loop over each file (or socket/client) that has stuff waiting to be read
    foreach my $readable (@readables) {

        # --------------------------------------------------------------------
        # if the data to be read is the socket itself, that means we
        # have a new client request.
        # --------------------------------------------------------------------
        if ( $readable == $socket ) {

                # is this client acceptable (ha ha)
                my $pending_client = is_acceptable($readable);

                # add this client to list of things to read from
                $read_writable->add($pending_client) if $pending_client;
        }

        # --------------------------------------------------------------------
        # if the readable file is not the socket, then it is one of the
        # clients
        # --------------------------------------------------------------------
        else {

            # Read data from the client
            my $data;
            my $rv = $readable->recv( $data, 2048, 0 );

            # no data? shut down connection
            next unless valid_data($rv,$data,$readable);

            # is this client a pending client, then set to active client
            $data = set_to_active_if_pending($readable,$data);

            # broadcast data, if any data left
            my $header = construct_header($readable,"msg");
            broadcast($header.$data) if $data;

        }
    }
}

# ----------------------------------------------------------------------------
# process if a pending client
# return any unconsumed data (assuming \n separating messages)
# ----------------------------------------------------------------------------
sub set_to_active_if_pending {
    my $client = shift;
    my $data = shift;

    if ($pending_clients{$client}) {
        
        print "you are a pending client\n";

        # get name from sent data
        my @bits = split "\n",$data;
        my $name = shift @bits;
        chomp $name;
        $data = join("\n",@bits);
        $name = $name || "server:no name given";
        print "your name is: $name\n";

        # remove from pending list, and add to accepted listening
        my $details = delete $pending_clients{$client};
        pop @$details;
        push @$details,$name;
        $clients{$client} = $details;

        # send to yourself to confirm your connection
        my $header = construct_header($client,"Connected");
        send_to_client($client,$header."You have connected");
        print "yare are no officially connected\n";

        # broadcast to all clients that we have a new connection
        $header = construct_header ($client,"NewConnection");
        broadcast($header."Player $name has joined");
        print "$header:pending connection for player $name\n";

        # how many connections do we have
        $header = construct_header ($client,"NumberConnections");
        broadcast($header . number_of_players());
        print "number of connections: ",number_of_players(),"\n";
    }

    return $data
}

# ----------------------------------------------------------------------------
# valid read request
# ----------------------------------------------------------------------------
# no data? shut down connection
sub valid_data {
    my $rv = shift;
    my $data = shift;
    my $client = shift;

    # not readable, shutdown system
    unless ( defined $rv && length($data) ) {
        
        # remove client from everything, and close
        close_client($client);

        # send disconnection info to everyone else
        my $header = construct_header($client,"Disconnection");
        print "Closing connection: $header\n";
        my $name = get_player_name($client);
        broadcast($header."$name disconnected");
        
        # how many connections do we have now?
        $header = construct_header ($client,"NumberConnections");
        broadcast($header . number_of_players());
        print "number of connections: ",number_of_players(),"\n";
        return 0;
        
      }
      return 1;
}


# ----------------------------------------------------------------------------
# process of accepting a new client
# ----------------------------------------------------------------------------
sub is_acceptable {
    my $socket = shift;

    # Accept the new client
    my ($new_client, $paddr) = $socket->accept;
    my($port,$iaddr) = sockaddr_in($paddr);
    my $ip = inet_ntoa($iaddr);

    # maximum number of players is 2, so if you are the third, I am gonna
    # kick you out!
    if (number_of_players() > $max_players - 1) {
        my $header = construct_header ($new_client,"Error");
        send_to_client($new_client, $header."Sorry, only two players allowed!\n");
          close_client($new_client);
          print ("Excess Players detected ... he he!\n");
          return
    }

    # we have a new valid connection
    my $player_number = get_new_player_number();
    print "pending connection for player $player_number\n";

    $pending_clients{$new_client}=[$port,inet_ntoa($iaddr),$player_number,"no name"];

    # let client know that we want their name
    my $header = construct_header ($new_client,"NameRequest");
    send_to_client($new_client,$header."Please send your name");

    return $new_client
}

# ----------------------------------------------------------------------------
# closing client
# ----------------------------------------------------------------------------
sub close_client {
    my $client = shift;
    $read_writable->remove($client);
    $client->close;
    delete $clients{$client};
    delete $pending_clients{$client};
}

# ----------------------------------------------------------------------------
# send data to all clients
# ----------------------------------------------------------------------------
sub broadcast {
    my $data = shift;
    my $chomped = $data;
    chomp($chomped);
    print "broadcast <$chomped>\n";

    my @writables = $read_writable->can_write(1);
    foreach my $writable (@writables) {
        no warnings;
        next if $writable == $socket;
        send_to_client($writable,$data,1);
    }
}

# ----------------------------------------------------------------------------
# send data to specific client
# ----------------------------------------------------------------------------
sub send_to_client {
    my $client = shift;
    my $data = shift;
    my $broadcast = shift;
    print "no broadcast <$data>\n" unless $broadcast;
    $client->send($data."\n");
}

# ----------------------------------------------------------------------------
# get player name
# ----------------------------------------------------------------------------
sub get_player_name {
    my $client = shift;
    my ($port, $ip, $player, $name) = ('0','0','0','nobody');
    ($port, $ip, $player, $name) = @{$clients{$client}} if $clients{$client};
    ($port, $ip, $player, $name) = @{$pending_clients{$client}} if $pending_clients{$client};

    return $name;
}

# ----------------------------------------------------------------------------
# create header for broadcasting data
# ----------------------------------------------------------------------------
sub construct_header {
    my $client = shift;
    my $type = shift;
    my ($port, $ip, $player, $name) = ('0','0','0','nobody');
    ($port, $ip, $player, $name) = @{$clients{$client}} if $clients{$client};
    ($port, $ip, $player, $name) = @{$pending_clients{$client}} if $pending_clients{$client};

    return "$ip:$port:$player:$name:$type:";
}



# ----------------------------------------------------------------------------
# number of players
# ----------------------------------------------------------------------------
sub number_of_players {
    return scalar(keys %clients)+scalar(keys %pending_clients)
}

# ----------------------------------------------------------------------------
# list of player numbers that are already being used
# ----------------------------------------------------------------------------
sub currently_used_player_numbers {
    my %used;
    foreach my $detail (values %clients, values %pending_clients) {
        my (undef,undef,$player) = @$detail;
        $used{$player} = $player;
    }
    return %used
}

# ----------------------------------------------------------------------------
# get a valid play number
# ----------------------------------------------------------------------------
sub get_new_player_number() {
    if (number_of_players() == 0 ) {
        return 1
    }
    elsif (number_of_players() != $max_players) {
        my %used = currently_used_player_numbers();
        foreach my $i  (1 .. $max_players) {
            return $i unless defined $used{$i}
        }
    }
    return 0
}
