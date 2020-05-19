#=================================================================================
#                   commands.pl - MAY09 - by. Caldaga
#
#  Licensed under the Creative Commons Attribution-Share-Alike 3.0 US License 
#            http://creativecommons.org/licenses/by-sa/3.0/us/
#
# This library controls how the bot interprets commands from users on the server
# at any time.  I gave commands thier own library because there is a large
# number of if statements to sort through when doing maintenance on the code.
#
# Sub routines in this library:
#
# command
#
# Commands supported:
#
# say       - The bot will mimic everything after the command say.
# rejoin    - Causes the bot to rejoin the channel.
# add       - Adds a user to the database. (.add USERNAME)
# rem       - Removes a user from the database. (.rem USERNAME)
# ver       - Shows the bot name and the version.
# find      - Shows a list of everyone in the database.
# ban       - Bans everyone in the list that meets your criteria.
# kick      - Kicks everyone in the list that meets your criteria.
# designate - Causes the bot to designate the person of your choice.
# resign    - Causes the bot to forfeit ops.
# join      - Joins the channel of your choosing.
# ?trigger  - The bot returns the trigger.
# cmds      - Print available commands
# uptime    - Provides system uptime.
# ping      - Provides the ping for the current server your connected to.
# place     - Displays the place the bot logged in on the server.
# check     - Displays the operators in a channel.
# server    - Displays the server the bot is currently connected to.
# setserver - Sets the server the bot will connect to after reconnecting.
#
#=================================================================================

sub command {

	my @commandcmds = qw/ say rejoin add rem ver find ban kick designate resign join ?trigger cmds uptime ping place check server setserver /;
	my $line     = $_[0];
	my $name     = $_[1];
	my $user     = $_[2];
	
	chomp($name);

	foreach (@database) {
		chomp;
		if ($name =~ m/^\Q$_\E$/i) {

			if ($line =~ m/^(\Q$trigger\E)(\bsay\b)/i) {
				$line =~ s/(^\Q$trigger\E)(say)\s(.*)/$3/;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - $line\n");
				$chat_window->yview('end');
				print $sock "$line\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)resign\b/i) {
				print $sock "\/resign\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)place\b/i) {
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - I was user $place to login to $server in channel $home.\n");
				$chat_window->yview('end');
				print $sock "I was user $place to login to $server in channel $home.\n";
			}
				
			
			if ($line =~ m/^(\Q$trigger\E)rejoin\b/i) {
				print $sock "\/rejoin\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)uptime\b/i) {
				$uptime = `uptime`;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - $uptime");
				$chat_window->yview('end');
				print $sock "$uptime\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)ping\b/i) {
				@ping = `ping -c 1 "$server"`;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - $ping[1]");
				$chat_window->yview('end');
				print $sock "$ping[1]\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)add\b/i) {
				$line =~ s/(^\Q$trigger\E)(add)\s(.*)/$3/;
				chomp($line);
				push @database, $line;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - I have added $line to the database.\n");
				$chat_window->yview('end');
				print $sock "I have added $line to the Database.\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)rem\b/i) {
				$line =~ s/(^\Q$trigger\E)(rem)\s(.*)/$3/;
				chomp($line);
				@database = grep {! m/\Q$line/i} @database;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - I have removed $line from the database.\n");
				$chat_window->yview('end');
				print $sock "I have removed $line from the Database.\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)ver\b/i) {
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - Current Version: $program_name $program_version by Caldaga\n");
				$chat_window->yview('end');
				print $sock "Current Version: $program_name $program_version by Caldaga\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)find\b/i) {
				chomp($line);
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - @database\n");
				$chat_window->yview('end');
				print $sock "@database\n";

			}
				
			if ($line =~ m/^(\Q$trigger\E)ban\b/i) {
				foreach (@all_items) {
					$line =~ m/^(\Q$trigger\E)(ban)\s(.*)/;
					if ($_ =~ m/\Q$3/i) {
					print $sock "\/ban $_\n";
					}
				}
			}
		
			
			if ($line =~ m/^(\Q$trigger\E)kick\b/i) {
				foreach (@all_items) {
					$line =~ m/^(\Q$trigger\E)(kick)\s(.*)/;
					if ($_ =~ m/\Q$3/i) {
					print $sock "\/kick $_\n";
					}
				}
			}
			
			if ($line =~ m/^(\Q$trigger\E)designate\b/i) {
				$line =~ s/(^\Q$trigger\E)(designate)\s(.*)/$3/;
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - I have designated: $line\n");
				$chat_window->yview('end');
				print $sock "/designate $line\n";
				print $sock "I have designated: $line\n";
			}
			
			if ($line =~ m/^(\?)trigger\b/i) {
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - Trigger: $trigger\n");
				$chat_window->yview('end');
				print $sock "Trigger: $trigger\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)join\b/i) {
				$line =~ s/(^\Q$trigger\E)(join)\s(.*)/$3/;
				print $sock "\/join $line\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)cmds\b/i) {
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - @commandcmds\n");
				$chat_window->yview('end');
				print $sock "@commandcmds\n";
			}
			
#			if ($line =~ m/^(\Q$trigger\E)check\b/i) {
#				$line =~ m/^(\Q$trigger\E)check\s(.*)/;
#				&check_site ($line, $user);
#			}
			
			if ($line =~ m/^(\Q$trigger\E)server\b/i) {
				$chat_window->insert('end', "[$timestamp] - ");
				$chat_window->insert('end', "$user", 'green');
				$chat_window->insert('end', " - Server: $server\n");
				$chat_window->yview('end');
				print $sock "Server: $server\n";
			}
			
			if ($line =~ m/^(\Q$trigger\E)setserver\b\s(.*)/i) {
				if ($2 =~ m/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) {
					$server = $2;
					$chat_window->insert('end', "[$timestamp] - ");
					$chat_window->insert('end', "$user", 'green');
					$chat_window->insert('end', " - Server: $server\n");
					$chat_window->yview('end');
					print $sock "Server: $server\n";
				}
				else { 
					$chat_window->insert('end', "[$timestamp] - ");
					$chat_window->insert('end', "$user", 'green');
					$chat_window->insert('end', " - That is not a valid server ip address.\n");
					$chat_window->yview('end');
					print $sock "That is not a valid server ip address.\n";
				}
			}
		}
	} 
}
1;

