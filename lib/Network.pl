#================================================================================
#                   Network.pl - MAY09 - by. Caldaga
#
#  Licensed under the Creative Commons Attribution-Share-Alike 3.0 US License 
#            http://creativecommons.org/licenses/by-sa/3.0/us/
#
# This library loads the sub routines affiliated with the network socket.  First
# "con_socket" creates the socket, sends the login information, and makes part of
# the GUI appear.  Then we have "dcon_socket" which closes the socket when you
# hit the disconnect button. Then we have "rcon_socket" which makes the bot close
# the socket and then reopen it when you hit the reconnect button. Then we have
# "read_socket" which will read in the information to the socket and pass it to
# be parsed. Last but not least we have "write_socket" which allows us to send
# information to the socket.
#
# Sub routines in this library:
#
# con_socket
# dcon_socket
# rcon_socket
# read_socket
# write_socket
#
#================================================================================

#====================================
# This sub routine first calls the
# timestamp sub routine so I can show
# timestamps while connecting.  Then
# it creates a socket and sends the
# login information.  It pulls the
# login information from the config
# file which writes theconfig through 
# the GUI. At the end it calls the 
# make GUI appear sub routine so you 
# can begin chatting.
#====================================

sub con_socket {

	&timestamp;
	
	$chatwindowcount = "0";
	$chat_window->delete('1.0', 'end');
	$mw->configure(-width=>"800",
				-height=>"600");
				
	unless ($server and $user and $pass and $home) { &config_window; return;}

#================
# Create Socket
#================
	
	$chat_window->insert('end', "[$timestamp] - ");
	$chat_window->insert('end', "Connecting...\n", 'green');
	
	$sock = new IO::Socket::INET->new(PeerAddr => $server,
	     	   				   	      PeerPort => '6112',
						   	    	  Proto    => 'tcp',);
	
#=================
# Make the socket 
# a non-blocking 
# socket
#=================
	
		$mw->fileevent($sock, 'readable', \&read_socket);
		print $sock "\x03\x04$user\r\n$pass\r\n/join $home\r\n";
		

#===========================
# Send Successful Connection
# to the screen
#===========================	
	
		
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "Successfully Connected to server!\n", 'green');
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "Sending Login Information...\n", 'green');
		$chat_window->yview('end');
		
		&make_gui_appear;

}


#=========================================
# This sub routine first calls on the sub
# routine timestamp, so that we can see
# time stamps while we disconnect.  Then
# it disconnects from the server.
#=========================================

sub dcon_socket {

	&timestamp;

	$mw->fileevent(\*$sock, 'readable', "");
	$sock->shutdown(2);
	my $DisconnectMessage = "Disconnected.\n";
	$chat_window->insert('end', "[$timestamp] -");
	$chat_window->insert('end', " $DisconnectMessage", 'red');
	
}

#==============================================
# This sub routine just calls on the disconnect
# and then the connect sub routine. The idea is
# that it will disconnect you from the server,
# and then make you connect again.
#==============================================

sub rcon_button {

	&dcon_socket;
	&con_socket;

}

#==============================================
# This sub routine allows us to recieve info
# from the server.  It also parses the info
# so that when you see it in the bot, it is
# prettier than the raw data sent by the server
# it also counts the lines coming in so our
# chat buffer works.
#==============================================

sub read_socket {
	
	my $line = <$sock>;
	if (!$line) { &dcon_socket; sleep 45; &con_socket; }
	print STDOUT "$line";
	$line =~ s/\r//g;
	if ($line =~ m/^Login\sincorrect\./) { 
		&dcon_socket;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "Incorrect Username or Password. Login Failed.", 'red');
	}
	if ($line =~ m/^2000|^2010/) { return; }
	if ($line =~ m/^1001|^1007|^1019|^1002|^1003|^1018|^1005|^1004|^1010|^1009|^1023|^1006/) { &parse_from_server ($line); return; }

}

#==============================================
# This sub routine allows us to write to the
# socket, sending information to the server.
# We call the timestamp sub routine and the
# count so we can have timestamps and our
# chat buffer will include text we insert
# into the chat window also.
#==============================================

sub write_socket {

	&timestamp;

	if ($text =~ m/^0$/) {
		&count;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user", 'green');
		$chat_window->insert('end', " - $text\n");
		$chat_window->yview('end');
		print $sock "$text\n";
		$text = undef;
		$chat_window->update;
	}
		

	if ($text =~ m/^\//) { &commands_to_server ($text); $text = undef; }
	
	elsif (! $text) { return; }
	
	else {
		&count;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user", 'green');
		$chat_window->insert('end', " - $text\n");
		$chat_window->yview('end');
		print $sock "$text\n";
		$text = undef;
		$chat_window->update;
	}
	$chat_window->yview('end');
}

1;

 
