#===============================================================================
#                   Functions.pl - MAY09 - by. Caldaga
#
#  Licensed under the Creative Commons Attribution-Share-Alike 3.0 US License 
#            http://creativecommons.org/licenses/by-sa/3.0/us/
#
# The Functions.pl library is a collection of a few sub routines that do not
# fit into other libraries.  First "count" sets the buffer for the chat window.
# Then "timestamp" creates the timestamp used throughout the bot. Then we have
# "load_pics" which loads the images for the icons in the channel list. Then
# "channel_count" sets the name of the channel and the number of people in the
# channel at the top of the channel list. The last "check_site" allows us to
# check www.blazednet.com for who has ops in each channel, it uses whatever
# server you are connecting to in your configuration.
#
# Sub Routines in this library:
#
# commands_to_server
# count
# timestamp
# load_pics
# channel_count
# check_site
# F2-F8
# autocomplete
#
#===============================================================================

#==================================
# This includes custom bot commands
# and commands sent to the server.
#==================================

sub commands_to_server {

	my $text = $_[0];
	&timestamp;
	
#	if ($text =~ m/^\/check/) { &check_site ($text) }
	
#	elsif ($text =~ m/^\/getinfo\s(\d)\s(.{1})/) {
	
#		print $sock "/w $botnet[$1] $2server\n";
#		print $sock "/w $botnet[$1] $2delay\n";
#		sleep 3;
#		print $sock "/w $botnet[$1] $2place\n";
#		print $sock "/w $botnet[$1] $2channel\n";
#		sleep 3;
#		print $sock "/w $botnet[$1] $2ping\n";
		
#	}
	
#	elsif ($text =~ m/^\/getinfoall/i) {
		
#		my @commands = qw/server delay place channel ping/;
		
#		foreach (@botnet) {
#			foreach (@commands) {
#				print $sock "/w $_ $bottrigger$_\n";
#				sleep 3;
#			}
#		}
	
#	}
	
	if ($text =~ m/^\/jl\b/) {
		if ($join_leave_notifications == 1) {
			$join_leave_notifications = "0";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Join/Leave Notifications Deactivated\n", 'orange');
		}
		else { 
			$join_leave_notifications = "1";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Join/Leave Notifications Activated\n", 'orange');
		}
	}
	
	elsif ($text =~ m/^\/ff\b/) {
		if ($friend_event == 1) {
			$friend_event = "0";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Friend Event Filtering Deactivated\n", 'orange');
		}
		else {
			$friend_event = "1";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Friend Event Filtering Activated\n", 'orange');
		}
	}
		
	elsif ($text =~ m/^\/cf\b/) {
		if ($capsfilter == 1) {
			$capsfilter = "0";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Caps Filtering Deactivated\n", 'orange');
		}
		else {
			$capsfilter = "1";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Caps Filtering Activated\n", 'orange');
		}
	}
	
	elsif ($text =~ m/^\/filter\b\s(.*)/) {
		push @filter, $1;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user", 'green');
		$chat_window->insert('end', " - $1 has been added to the filter.\n");
		$chat_window->yview('end');
	}	
	
	elsif ($text =~ m/^\/r\b/) {
		$text =~ m/^(\/r)\s(.*)/;
		print $sock "\/w $reply $2\n";
	}
	
	elsif ($text =~ m/^\/clear\b/) {
		$chat_window->delete('1.0', 'end');
		$chatwindowcount = "0";
	}
	
	elsif ($text =~ m/^\/add\b/) {
		$text =~ m/^\/add\b\s(\S+)/;
		my $name = $1;
		chomp($name);
		push @database, $name;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user", 'green');
		$chat_window->insert('end', " - I have added $name to the database.\n");
		$chat_window->yview('end');
		print $sock "I have added $name to the database.\n";
	}
	
	elsif ($text =~ m/^\/rem\b/) {
		$text =~ m/^\/rem\b\s(\S+)/;
		$name = $1;
		chomp($name);
		@database = grep {! m/\Q$name/i} @database;
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user", 'green');
		$chat_window->insert('end', " - I have removed $name from the database.\n");
		$chat_window->yview('end');
		print $sock "I have removed $name from the database.\n";
	}
	
	elsif ($text =~ m/^\/hidewhisp\b/) {
		$mw->gridForget($whisp_window);
	}
	
	elsif ($text =~ m/^\/cmds\b/) {
		$chat_window->insert('end', "[$timestamp] - ");
		$chat_window->insert('end', "$user ", 'green');
		$chat_window->insert('end', "- Custom Bot Commands: /check, /clear, /hidewhisp, /clearwhisp, /add, /rem, /jl, /ff, /cf, /filter, /getinfo\n", 'grey'); 
	}
	
	elsif ($text =~ m/^\/clearwhisp\b/) {
		$whisp_window->delete('1.0', 'end');
	}
	
	elsif ($text =~ m/^\/kick/) {
		foreach (@all_items) {
			$text =~ m/(\/kick)\s(.*)/;
			if ($_->[0] =~ m/\Q$2/i) {
				$name = $_->[0];
				print $sock "\/kick $name\n";
			}
		}
	}
	
	elsif ($text =~ m/^\/ban/) {
		foreach (@all_items) {
			$text =~ m/(\/ban)\s(.*)/;
			if ($_->[0] =~ m/\Q$2/i) {
				$name = $_->[0];
				print $sock "\/ban $name\n";
			}
		}
	}
	
	elsif ($text =~ m/^\//) { 
		print $sock "$text\n"; 
	}
	return;
}

#========================================
# This sub routine creates a buffer for
# the chat window.  After 1000 lines of
# text exist, it begins to delete 1 line
# from the top and replace it with 1 line
# at the bottom.
#========================================

sub count {

	$chatwindowcount++;
	if ($chatwindowcount >= 1000) {
		$chat_window->delete('1.0', '2.0');
		$chatwindowcount--;
	}
}

#====================================
# Creates the timestamp that I use
# throughout the rest of the program.
#====================================
 
sub timestamp {

	$timestamp = localtime;
	$timestamp = ($timestamp =~ m/(.{11})(.{8})(.{5})/);
	$timestamp = $2;
	return $timestamp;

}

#===================================
# This loads the pictures for the
# icons in the channel list.
#===================================

sub load_pics {
	my $dir_to_process = "$dep_path/img";
	opendir DH, $dir_to_process or die "Cannot open $dir_to_process: $!";
	foreach $file (readdir DH) {
		unless ($file eq '.' or $file eq '..') {
		$mw->Photo("$file", -file=>"$dir_to_process/$file", -format=>"jpeg",);
		}
	}
}

#==================================
# Gets the channel count, channel
# name and inserts them every time
# you join a new channel.  It also
# clears the last channel's info
# out of the window.
#==================================

sub channel_count {

		my $line = $_[0];

		if ($line =~ m/1007/) {
			$chan_name->delete("1.0", 'end');
			&canvasListDelete($chan_list, 'all', 20);
			@all_items = ();
			$line =~ m/\"(.*)\"/;
			$name_of_channel = $1;
			$chan_name->insert('end', "$name_of_channel", 'center');
			$chat_window->insert('end', "[$timestamp] -");
			$chat_window->insert('end', " You have joined channel: ", 'blue');
			$chat_window->insert('end', "$1\n", 'blue');
			$chat_window->yview('end');
			$chat_window->update;
			$chan_name->update;
		}
		$chan_name->delete('1.0', 'end');
		my $chancount = scalar @all_items;
		$chan_name->insert('1.0', "$name_of_channel ($chancount)", 'center');
		$chan_name->update;
		
}

#=============================
# Check www.blazednet.com for
# ops in channels when banned
# from those channels on the
# server. /check channel
#=============================

sub check_site {

	&timestamp;
	
		my $text = $_[0];
		my $channelname = undef;
		my $url = undef;
		my $te = undef;
		my $count = 0;
		my @urlresults = undef;
		my $urlscalar = undef;
		my @rows = ();
		my $user = $_[1];
		
		if ($text =~ m/\/check\s(.*)/) {
			$channelname = $1;
		}
		
		elsif ($text =~ m/^(\Q$trigger\E)check\s(.*)/) {
			$channelname = $2;
		}
		
#===================================
# Recieve source from blazednet.com
# based on the server your connected
# to and the channel name you put
# into the /check command
#===================================

		$url = "http://$server:8001/channel/?channel=$channelname";
		@urlresults = get($url);

		if ($urlresults[0]) {

		foreach (@urlresults) {
			$urlscalar = $urlscalar . $_;
		}

#===============================
# Extract the table from the HTML
# put the rows into the array
#===============================


		$te = HTML::TableExtract->new( depth => 1, count => 0, keep_html => 1);
		$te->parse($urlscalar);
		@urlresults = $te->rows;

#===============================
# Parse the people with operator
# status out of the array, print
# them to the chat window
#===============================
		
		foreach (@urlresults) {
			@rows = @{$_};
			if ($rows[0] =~ m/OP.JPG/) {
				$rows[1] =~ s/\n//;
				$rows[1] =~ s/\r//;
				my @ops = split />|</, $rows[1];
				$ops[2] =~ s/\s//g;
				push @opsinchan, $ops[2];
			}
		}
	
		if (@opsinchan == undef) {
			print $sock "There are no operators in channel: $channelname\n";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "$user", 'green');
			$chat_window->insert('end', " - There are no operators in channel: $channelname\n")
		}
	
		elsif ($text =~ m/\/check\s(.*)/) {
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "Operators in $channelname are:\n", 'grey');
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "$opsinchan[0] $opsinchan[1] $opsinchan[2] $opsinchan[3] $opsinchan[4] $opsinchan[5]\n", 'grey');
			@opsinchan = ();
		}
	
		elsif ($text =~ m/^(\Q$trigger\E)check\s(.*)/) {
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "$user", 'green');
			$chat_window->insert('end', " - Operators in $channelname are:\n");
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "$user", 'green');
			$chat_window->insert('end', " - $opsinchan[0] $opsinchan[1] $opsinchan[2] $opsinchan[3] $opsinchan[4] $opsinchan[5]\n");
			print $sock "Operators in $channelname are:\n";
			print $sock "$opsinchan[0] $opsinchan[1] $opsinchan[2] $opsinchan[3] $opsinchan[4] $opsinchan[5]\n";
			@opsinchan = ();
		}
		}
		
		else {
			print $sock "Could not connect to blazednet.com\n";
			$chat_window->insert('end', "[$timestamp] - ");
			$chat_window->insert('end', "$user", 'green');
			$chat_window->insert('end', " - Could not connect to Blazednet.com\n")
		}
}

#============================
# Sets up hotkeys for servers
#============================

sub F2 {

	if (! $server1) { &server_hotkeys; }
	$server = $server1;
	&rcon_button;
	
}
sub F3 {

	if (! $server2) { &server_hotkeys; }
	$server = $server2;
	&rcon_button;
	
}
sub F4 {

	if (! $server3) { &server_hotkeys; }
	$server = $server3;
	&rcon_button;
	
}
sub F5 {

	if (! $server4) { &server_hotkeys; }
	$server = $server4;
	&rcon_button;
	
}
sub F6 { 

	if (! $server5) { &server_hotkeys; }
	$server = $server5;
	&rcon_button;
	
}

sub F7 {

	if (! $server6) { &server_hotkeys; }
	$server = $server6;
	&rcon_button;
	
}

#=======================
# Autocomplete names in
# the entry box.
#=======================

sub autocomplete {

	my $temp = ${$_[1]};
	
	$temp =~ m/(.*\s)?(.*)/i;
	my $line = $1;
	my $name = $2;
	
	foreach (@all_items) {
		if ($_->[0] =~ m/\Q$name\E/i) {
			$wholename = $_->[0];
			$temp = "$line$wholename";
			$main::text = $temp;
			$main_entry->icursor('end');
    		$main_entry->Focus();
		}
	}
	
}
1;
