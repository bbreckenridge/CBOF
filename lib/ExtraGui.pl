#===============================================================================
#                   ExtraGui.pl - MAY09 - by Caldaga
#
#  Licensed under the Creative Commons Attribution-Share-Alike 3.0 US License 
#            http://creativecommons.org/licenses/by-sa/3.0/us/
#
# This library holds sub routines that add to the GUI and make part of the GUI
# appear at certain times.  The first sub routine "config_window" creates the
# preferences window when you choose preferences from the Settings drop down
# menu.  The second sub routine "filter_window" creates the filter GUI when you
# choose the filter button from the Settings drop down menu.  The third sub
# routine "database_window" creates the database GUI when you choose database
# from the Settings drop down menu.  Then the "make_gui_appear" sub routine
# creates the rest of the GUI after you choose connect from the Server drop
# down menu. Then the "print_about" sub routine prints the "about" contents
# when you click the About button on the main menu.
#
# Sub routines in this library:
#
# config_window
# filter_window
# database_window
# make_gui_appear
# print_about
# help
# server_hotkeys
#
#===============================================================================

#=======================================
# The following sub routine creates the
# preferences GUI when you choose pref-
# erences from the Settings menu.
#=======================================

sub config_window {

	if (! $config_window) {
		my $config_window = $mw->Toplevel(-background=>"black",);
		$config_window->title("$program_name Preferences");
		$config_window->resizable(0,0);
		
#========================
# Labels for Config GUI
#========================

		my $user_label = $config_window->Label(-text=>"Username:",
									    	   -background=>"black",
									    	   -foreground=>"white",);
		$user_label->grid(-column=>"0",
					   	  -row=>"0",
					   	  -sticky=>"w",
					   	  -padx=>"3",
					   	  -pady=>"3");

		my $password_label = $config_window->Label(-text=>"Password:",
									        	   -background=>"black",
									        	   -foreground=>"white",);
		$password_label->grid(-column=>"0",
						  	  -row=>"1",
					   	  	  -sticky=>"w",
					   	  	  -padx=>"3",
					   	  	  -pady=>"3");

		my $server_label = $config_window->Label(-text=>"Server:",
									      		 -background=>"black",
									      		 -foreground=>"white",);
		$server_label->grid(-column=>"0",
							-row=>"2",
					        -sticky=>"w",
					        -padx=>"3",
					        -pady=>"3");

		my $channel_label = $config_window->Label(-text=>"Home Channel:",
									       		  -background=>"black",
									       		  -foreground=>"white",);
		$channel_label->grid(-column=>"0",
						     -row=>"3",
					         -sticky=>"w",
					         -padx=>"3",
					         -pady=>"3");

		my $backup_label = $config_window->Label(-text=>"Backup Channel:",
									      		 -background=>"black",
									      		 -foreground=>"white",);
		$backup_label->grid(-column=>"0",
						 	-row=>"4",
					        -sticky=>"w",
					        -padx=>"3",
					        -pady=>"3");

		my $joinleave_label = $config_window->Label(-text=>"Join/Leave (1 or 0):",
									         	    -background=>"black",
									         	    -foreground=>"white",);
		$joinleave_label->grid(-column=>"2",
						   	   -row=>"0",
					           -sticky=>"w",
					 	       -padx=>"3",
					 	       -pady=>"3");
		
		my $friend_event_label = $config_window->Label(-text=>"Friend Event (1 or 0):",
									         		   -background=>"black",
									         		   -foreground=>"white",);
		$friend_event_label->grid(-column=>"2",
						   		  -row=>"1",
					        	  -sticky=>"w",
					 	   		  -padx=>"3",
					 	   		  -pady=>"3");
		
		my $capsfilter_label = $config_window->Label(-text=>"Caps Filter (1 or 0):",
									          		 -background=>"black",
									          		 -foreground=>"white",);
		$capsfilter_label->grid(-column=>"2",
						   		-row=>"2",
					        	-sticky=>"w",
					 	   		-padx=>"3",
					 	   		-pady=>"3");
		
		my $font_label = $config_window->Label(-text=>"Font Size:",
									    	   -background=>"black",
									    	   -foreground=>"white",);
		$font_label->grid(-column=>"2",
					   	  -row=>"3",
					   	  -sticky=>"w",
					   	  -padx=>"3",
					   	  -pady=>"3");

		my $trigger_label = $config_window->Label(-text=>"Trigger:",
									       		  -background=>"black",
									       		  -foreground=>"white",);
		$trigger_label->grid(-column=>"2",
					   		 -row=>"4",
					   		 -sticky=>"w",
					   		 -padx=>"3",
					   		 -pady=>"3");

#=======================
# Buttons for CONFIG GUI
#=======================

		my $savebutton = $config_window->Button(-text => "Save",
												-width => "12",
						   			     		-command => sub { 
													open CONFIG, ">$config_path/Config.pl";
													print CONFIG '$server =';
													print CONFIG " \'$server\'\;\n";
													print CONFIG '$user =';
													print CONFIG " \'$user\'\;\n";
													print CONFIG '$pass =';
													print CONFIG " \'$pass\'\;\n";
													print CONFIG '$home =';
													print CONFIG " \'$home\'\;\n";
													print CONFIG '$backupchannel =';
													print CONFIG " \'$backupchannel\'\;\n";
													print CONFIG '$font =';
													print CONFIG " \'$font\'\;\n";
													print CONFIG '$trigger =';
													print CONFIG " \'$trigger\'\;\n";
													print CONFIG '$join_leave_notifications =';
													print CONFIG " \'$join_leave_notifications\'\;\n";
													print CONFIG '$friend_event =';
													print CONFIG " \'$friend_event\'\;\n";
													print CONFIG '$capsfilter =';
													print CONFIG " \'$capsfilter\'\;\n";
													close CONFIG;
													$config_window->withdraw });
		$savebutton->grid(-column=>"0",
					   	  -row=>"5",
					   	  -padx=>"5",
					   	  -pady=>"5");

		my $closebutton = $config_window->Button(-text => "Close",
						   			   	 		 -command => sub { $config_window->withdraw },
										 		 -width => "12");
		$closebutton->grid(-column=>"1",
					       -row=>"5",
					       -padx=>"5",
					       -pady=>"5");

#===========================
# Entry Boxes for CONFIG GUI
#===========================

		my $user_entry = $config_window->Entry(-textvariable=>\$user,
									    	   -borderwidth=>"1",
			   						    	   -width=>"15",
			   						    	   -background=>"white",
			   						    	   -foreground=>"black",
			   						    	   -highlightcolor=>"white",);
		$user_entry->grid(-column=>"1",
					   	  -row=>"0",
					   	  -padx=>"3",
					   	  -pady=>"3");

		my $password_entry = $config_window->Entry(-textvariable=>\$pass,
									        	   -borderwidth=>"1",
			   						        	   -width=>"15",
			   						        	   -background=>"white",
			   						        	   -foreground=>"black",
			   						        	   -highlightcolor=>"white",);
		$password_entry->grid(-column=>"1",
					       	  -row=>"1",
					   	  	  -padx=>"3",
					  	  	  -pady=>"3");

		my $server_entry = $config_window->Entry(-textvariable=>\$server,
						    			         -borderwidth=>"1",
			   						      	     -width=>"15",
			   						      		 -background=>"white",
			   						      		 -foreground=>"black",
			   						      		 -highlightcolor=>"white",);
		$server_entry->grid(-column=>"1",
					     	-row=>"2",
					     	-padx=>"3",
					     	-pady=>"3");


		my $channel_entry = $config_window->Entry(-textvariable=>\$home,
						    			       	  -borderwidth=>"1",
			   						       		  -width=>"15",
			   						       		  -background=>"white",
			   						       		  -foreground=>"black",
			   						       		  -highlightcolor=>"white",);
		$channel_entry->grid(-column=>"1",
					      	 -row=>"3",
					   	 	 -padx=>"3",
					  	 	 -pady=>"3");

		my $backup_entry = $config_window->Entry(-textvariable=>\$backupchannel,
						    			      	 -borderwidth=>"1",
			   						      		 -width=>"15",
			   						      		 -background=>"white",
			   						      		 -foreground=>"black",
			   						      		 -highlightcolor=>"white",);
		$backup_entry->grid(-column=>"1",
					     	-row=>"4",
					   		-padx=>"3",
					  		-pady=>"3");


		my $joinleave_entry = $config_window->Entry(-textvariable=>\$join_leave_notifications,
						    			         	-borderwidth=>"1",
			   						         		-width=>"2",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$joinleave_entry->grid(-column=>"3",
					           -row=>"0",
					   	   	   -padx=>"3",
					  	   	   -pady=>"3");
					  	   
		my $friend_event_entry = $config_window->Entry(-textvariable=>\$friend_event,
						    			         	   -borderwidth=>"1",
			   						         		   -width=>"2",
			   						         		   -background=>"white",
			   						         		   -foreground=>"black",
			   						         		   -highlightcolor=>"white",);
		$friend_event_entry->grid(-column=>"3",
					        	  -row=>"1",
					   	   	      -padx=>"3",
					  	   	      -pady=>"3");
		
		my $capsfilter_entry = $config_window->Entry(-textvariable=>\$capsfilter,
						    			          	 -borderwidth=>"1",
			   						          		 -width=>"2",
			   						          		 -background=>"white",
			   						          		 -foreground=>"black",
			   						          		 -highlightcolor=>"white",);
		$capsfilter_entry->grid(-column=>"3",
					         	-row=>"2",
					   	    	-padx=>"3",
					  	    	-pady=>"3");

		my $font_entry = $config_window->Entry(-textvariable=>\$font,
						    			       -borderwidth=>"1",
			   						    	   -width=>"2",
			   						    	   -background=>"white",
			   						    	   -foreground=>"black",
			   						    	   -highlightcolor=>"white",);
		$font_entry->grid(-column=>"3",
					   	  -row=>"3",
					   	  -padx=>"3",
					   	  -pady=>"3");

		my $trigger_entry = $config_window->Entry(-textvariable=>\$trigger,
						    			       	  -borderwidth=>"1",
			   						       		  -width=>"2",
			   						       		  -background=>"white",
			   						       	  	  -foreground=>"black",
			   						       		  -highlightcolor=>"white",
			   						       		  -insertbackground=>"white",);
			   						       
		$trigger_entry->grid(-column=>"3",
					      	 -row=>"4",
					      	 -padx=>"3",
					      	 -pady=>"3");

	}

#=========================
# If you try to open the
# window and it is already
# open, this makes the
# window pop up.
#=========================

	else {
		$config_window->deiconify();
		$config_window->raise();
	}
}

#=========================================
# This sub routine creates the chat filter
# GUI when you choose Filter from the Set-
# tings menu.
#=========================================

sub filter_window {

	if (! Exists($filter_window)) {
		my $filter_window = $mw->Toplevel(-background=>"black",);
		$filter_window->title("$program_name Chat Filter");
		$filter_window->resizable(0,0);

#=======================
# Frame in filter window
# contains buttons
#=======================

		my $frame = $filter_window->Frame(-background=>"black");
		$frame->grid(-column=>"1",
				     -row=>"0",
			 	     -rowspan=>"3",
			 	     -padx=>"5",
			 	     -pady=>"5");

#=======================
# Filter window list box
#=======================

		my $filter_list_1 = $filter_window->Scrolled('Listbox',
													 -background=>"black",
													 -scrollbars=>'oe',
													 -foreground=>"white");
		$filter_list_1->grid(-column=>"0",
					         -row=>"0",
					         -padx=>"5",
					         -pady=>"5");
					      
		$filter_list_1->Subwidget("yscrollbar")->configure( -activebackground=>"#A9A9A9",
  							 								-borderwidth=>"1",
  							 								-background=>"#A9A9A9",
  							 								-activerelief=>"flat",
  							 								-troughcolor=>"black",
  							 								-width=>"8");

		foreach (@filter) {
			chomp;
			$filter_list_1->insert('end', "$_");
			}

#==========================
# Buttons for filter window
#==========================

		my $closebutton = $frame->Button(-text => "Close",
							        	 -command => sub { $filter_window->withdraw; },
								    	 -width=>"7");
								    
		$closebutton->grid(-column=>"1",
				 	       -row=>"2",
					       -sticky=>"n");

		$addbutton = $frame->Button(-text => "Add",
							   		-width=>"7",
							   		-command=>sub { if (! $newfilter) { return; }
										    push @filter, $newfilter;
										    $filter_list_1->insert('end', "$newfilter");
										    $newfilter = "";
										   });
								
		$addbutton->grid(-column=>"1",
				 	  	 -row=>"0",
					  	 -sticky=>"n");

		my $removebutton = $frame->Button(-text => "Remove",
								    	  -width=>"7",
								    	  -command=>sub { @selected = $filter_list_1->curselection;
												@filter = grep !/\Q$filter[$selected[0]]/i, @filter;
												$filter_list_1->delete("@selected");
											   });
		$removebutton->grid(-column=>"1",
				 	     	-row=>"1",
							-sticky=>"n");

#============================
# Entry Box for filter window
#============================

		my $entry_box = $filter_window->Entry(-textvariable=>\$newfilter,
									   		  -width=>"22",
									   		  -background=>"white",
									   		  -insertbackground=>"black",);
		$entry_box->grid(-column=>"0",
					     -row=>"1",
					     -padx=>"5",
					     -pady=>"5");

	}

#=========================
# If you try to open the
# window and it is already
# open, this makes the
# window pop up.
#=========================

	else {
		$filter_window->deiconify();
		$filter_window->raise();
	}
}

#=========================================
# This sub routine creates the database
# GUI when you choose Database from the
# Settings menu.
#=========================================

sub database_window {

	if (! Exists($database_window)) {
		my $database_window = $mw->Toplevel(-background=>"black",);
		$database_window->title("$program_name Database");
		$database_window->resizable(0,0);

#=============================
# Frame containing the buttons
# for the Database window
#=============================

		my $frame = $database_window->Frame(-background=>"black");
		$frame->grid(-column=>"1",
				     -row=>"0",
			 	     -rowspan=>"3",
			 	     -padx=>"5",
			 	     -pady=>"5");
 
#=================================
# List box for the database window
#=================================

		my $database_list_1 = $database_window->Scrolled('Listbox',
											    		 -background=>"black",
											    		 -scrollbars=>'oe',
											    		 -foreground=>"white");
		$database_list_1->grid(-column=>"0",
					       	   -row=>"0",
					       	   -padx=>"5",
					       	   -pady=>"5");
					       
		$database_list_1->Subwidget("yscrollbar")->configure( -activebackground=>"#A9A9A9",
  							 								  -borderwidth=>"1",
  							 								  -background=>"#A9A9A9",
  							 								  -activerelief=>"flat",
  							 								  -troughcolor=>"black",
  							 								  -width=>"8");
					       
		foreach (@database) {
			chomp;
			$database_list_1->insert('end', "$_");
			}

#================================
# Buttons for the database window
#================================

		my $closebutton = $frame->Button(-text => "Close",
							        	 -command => sub { $database_window->withdraw },
								   		 -width=>"7");
		$closebutton->grid(-column=>"1",
				 	       -row=>"2",
					       -sticky=>"n");

		my $addbutton = $frame->Button(-text => "Add",
								 	   -width=>"7",
								 	   -command=> sub { if (! $newuser) { return; }
													   	push @database, $newuser;
												       	$database_list_1->insert('end', "$newuser");
											           	$newuser = "";
											       });
		$addbutton->grid(-column=>"1",
				 	  	 -row=>"0",
					  	 -sticky=>"n");

		my $removebutton = $frame->Button(-text => "Remove",
								    	  -width=>"7",
								    	  -command=> sub {
														@selected = $database_list_1->curselection;
														@database = grep ! /\Q$database[$selected[0]]/i, @database;
														$database_list_1->delete("@selected");
											    	 });
		$removebutton->grid(-column=>"1",
				 	     	-row=>"1",
							-sticky=>"n");

#==================================
# Entry box for the database window
#==================================

		my $entry_box = $database_window->Entry(-textvariable=>\$newuser,
									     		-width=>"22",
												-background=>"white",
												-insertbackground=>"black",);
		$entry_box->grid(-column=>"0",
					  	 -row=>"1",
					  	 -padx=>"5",
					  	 -pady=>"5");

	}

#================================
# If the window is already open
# bring it to the top and show it
#================================

	else {
		$database_window->deiconify();
		$database_window->raise();
	}
}

#================================
# Creates the About window
#================================

sub about_window {
	
	if (! Exists($about_window)) {
		my $about_window = $mw->Toplevel(-background=>"black",);
		$about_window->title("$program_name Information");
		$about_window->resizable(0,0);
	
	my $about_frame = $about_window->Frame(-background=>"black",
								    	   -borderwidth=>"0",
								    	   -highlightcolor=>"white",
								    	   -foreground=>"white",);

	$about_frame->grid(-column=>"0",
				       -row=>"0",
				       -pady=>"5",
				       -padx=>"5");
	
	$about_frame->Photo('icon',
						-file=>"$dep_path/CBOF.jpg",
						-format=>"jpeg");

	my $icon_label = $about_frame->Label(-image=>'icon',
								  		 -borderwidth=>"0");
	
	$icon_label->grid(-column=>"0",
				   	  -row=>"0");
	
	my $about_text_box = $about_frame->Scrolled('ROText',
									    		-scrollbars=>'oe',
						    			    	-wrap=>"word",
				 	    	    			    -background=>"black",
				 	    	    			    -borderwidth=>"0",
				 	    	    			    -highlightthickness=>"0",
			      	    		    		    -width=>"61",
			      	    		    		    -height=>"17");
	
	$about_text_box->Subwidget("yscrollbar")->configure(-activebackground=>"#A9A9A9",
  										 	  			-borderwidth=>"1",
  										 	  			-background=>"#A9A9A9",
  										 	  			-activerelief=>"flat",
  										 	  			-troughcolor=>"black",
  										 	  			-width=>"8");

	$about_text_box->grid(-column=>"0",
				       	  -row=>"1",);
				       	
	$about_text_box->tagConfigure('centerblue',
								  -justify=>'center',
								  -foreground=>'#0E9AF1');
	$about_text_box->tagConfigure('centergrey',
								  -justify=>'center',
								  -foreground=>'#A9A9A9');
	
	$about_text_box->insert('end', "Current Version: $program_name $program_version\nChat Bot of the Future\nCreated by: Caldaga\n\n", 'centerblue');
	$about_text_box->insert('end', "***License***\n\nLicensed under the Creative Commons Attribution-Share-Alike 3.0 US License\nhttp://creativecommons.org/licenses/by-sa/3.0/us/\n\n", 'centergrey');
	$about_text_box->insert('end', "***Special Thanks***\n\nMrFSL for motivation, advice, and his work on the channel list.\nteLe for creating RocketBot, my motivation to build a better chat bot for linux.\n\n", 'centergrey');
	$about_text_box->insert('end', "***Alpha Testers***\n\nZeDNOR, noki, and Gaidal", 'centergrey');
	
	}
	
#================================
# If the window is already open
# bring it to the top and show it
#================================
				    
	else {
		$about_window->deiconify();
		$about_window->raise();
	}
}

#=============
# Help Window
#=============

sub help {
	
	if (! Exists($help_window)) {
		my $help_window = $mw->Toplevel(-background=>"black",);
		$help_window->title("$program_name Help");
		$help_window->resizable(0,0);
	
		
		my $help_frame = $help_window->Frame(-background=>"black",
							    	         -borderwidth=>"0",
								       		 -highlightcolor=>"white",
								       		 -foreground=>"white",);

		$help_frame->grid(-column=>"0",
				 	   	  -row=>"3",
				 	   	  -pady=>"5",
				 	   	  -padx=>"5");	
				    
		my $icon_label = $help_frame->Label(-image=>'icon',
					     			 		-borderwidth=>"0");
		
		$icon_label->grid(-column=>"0",
					   	  -row=>"0");
				    
		my $help_text_box = $help_frame->Scrolled('ROText',
									     		  -wrap=>"word",
									     		  -scrollbars=>'oe',
				 	    				 		  -background=>"black",
				 	    				 		  -borderwidth=>"0",
				 	    				 		  -highlightthickness=>"0",
			      	    				 		  -width=>"50",
			      	    				 		  -height=>"15");
			      	    				 
		$help_text_box->grid(-column=>"0",
				      	 	 -row=>"1",);
		
		$help_text_box->Subwidget("yscrollbar")->configure( -activebackground=>"#A9A9A9",
  										 					-borderwidth=>"1",
  										 					-background=>"#A9A9A9",
  										 					-activerelief=>"flat",
  										 					-troughcolor=>"black",
  										 					-width=>"8");
  										 
				    
		$help_text_box->tagConfigure('centergrey',
									 -justify=>'center',
									 -foreground=>'#A9A9A9');
		$help_text_box->tagConfigure('ucenterwhite',
									 -justify=>'center',
									 -underline=>'1', 
									 -foreground=>'white');
		$help_text_box->tagConfigure('grey',
									 -foreground=>'#A9A9A9');
		$help_text_box->tagConfigure('white',
									 -foreground=>'white');
	     $help_text_box->tagConfigure('centerblue',
	     							  -justify=>'center',
	     							  -foreground=>'#0E9AF1');
		
		$help_text_box->insert('end', "Current Version: $program_name $program_version\nChat Bot of the Future\nCreated by: Caldaga\n\n", 'centerblue');
		$help_text_box->insert('end', "CUSTOM COMMANDS:\n\n", 'ucenterwhite');
		$help_text_box->insert('end', "/check\n\n", 'white');
		$help_text_box->insert('end', "\tQueries www.blazednet.com for\n\toperators in the specified channel\n", 'grey');
		$help_text_box->insert('end', "\tSyntax: /check channelname\n\n", 'grey');
		$help_text_box->insert('end', "/clear\n\n", 'white');
		$help_text_box->insert('end', "\tClears the chat window.\n\n", 'grey');
		$help_text_box->insert('end', "/hidewhisp\n\n", 'white');
		$help_text_box->insert('end', "\tHides the whisper window. It will reappear\n\twhen yousend or recieve a new whisper\n\n", 'grey');
		$help_text_box->insert('end', "/clearwhisp\n\n", 'white');
		$help_text_box->insert('end', "\tClears the whisper window.\n\n", 'grey');
		$help_text_box->insert('end', "/add\n\n", 'white');
		$help_text_box->insert('end', "\tSyntax: /add name.\n", 'grey');
		$help_text_box->insert('end', "\tAdds the user to the Database.\n\n", 'grey');
		$help_text_box->insert('end', "/rem\n\n", 'white');
		$help_text_box->insert('end', "\tSyntax: /rem name.\n", 'grey');
		$help_text_box->insert('end', "\tRemoves the user from the Database.\n\n", 'grey');
		$help_text_box->insert('end', "/jl\n\n", 'white');
		$help_text_box->insert('end', "\tToggles Join/Leave Notifications.\n\n", 'grey');
		$help_text_box->insert('end', "/ff\n\n", 'white');
		$help_text_box->insert('end', "\tToggles Friend Event Messages.\n\n", 'grey');
		$help_text_box->insert('end', "/cf\n\n", 'white');
		$help_text_box->insert('end', "\tToggles Caps Filtering.\n\n", 'grey');
		$help_text_box->insert('end', "/filter\n\n", 'white');
		$help_text_box->insert('end', "\tSyntax: /filter EwR will filter everyone with EwR \n\tin their name, not caps sensitive.\n\n", 'grey');
		$help_text_box->insert('end', "/getinfoall\n\n", 'white');
		$help_text_box->insert('end', "\tGets the information for every bot in the\n\tbotnet list. This may take a few minutes.\n\n", 'grey');
		$help_text_box->insert('end', "/getinfo\n\n", 'white');
		$help_text_box->insert('end', "\tSyntax: /getinfo # trigger\n\tThe # can be 0-9 referring to the bot in the list,\n\t 0 being the first. The trigger is the bot's \n\ttrigger you are getting the info on.\n\tThis command will get the info for 1 bot at a time.\n\n", 'grey');

#================================
# If the window is already open
# bring it to the top and show it
#================================
	}		    
	else {
		$help_window->deiconify();
		$help_window->raise();
	}
}

#==================================================
# This sub routine makes the channel list and entry
# box appear after you hit connect under the Server
# menu.
#==================================================

sub make_gui_appear {

	@Test_Frame1 = $mw->gridSlaves(-column=>"1");

	if (! @Test_Frame1) {
		$Frame1->grid(-column=>"1",
			      	  -row=>"0",
			      	  -rowspan=>"3",
			      	  -sticky=>"ns",
			      	  -padx=>"5",
			      	  -pady=>"5",);

	}

	@Test_Entry1 = $mw->gridSlaves(-row=>"2",
							 	   -column=>"0");
							 
	if (! @Test_Entry1) {
		$main_entry->grid(-column=>"0",
			 	   	  	  -row=>"2",
			 	   	  	  -sticky=>"sew",
				   	  	  -pady=>"5",
			 	   	  	  -padx=>"5",);
	}

	$chat_window->configure( -borderwidth=>"1",
			      			 -highlightthickness=>"1",
			      			 -highlightcolor=>"white");
	
	$icon->DESTROY();

	$main_entry->focus();
}

#====================
# Server hotkey setup
#====================

sub server_hotkeys {

		if (! Exists($server_hotkey_window)) {
			my $server_hotkey_window = $mw->Toplevel(-background=>"black",);
			$server_hotkey_window->title("$program_name Server Hotkeys");
			$server_hotkey_window->resizable(0,0);
			
		my $f2_label = $server_hotkey_window->Label(-text=>"F2:",
									 	    		-background=>"black",
										    		-foreground=>"white",);
		$f2_label->grid(-column=>"0",
					    -row=>"0",
					    -sticky=>"w",
					    -padx=>"3",
					    -pady=>"3");
					   
		my $f3_label = $server_hotkey_window->Label(-text=>"F3:",
									    	    	-background=>"black",
									         		-foreground=>"white",);
		$f3_label->grid(-column=>"0",
					 	-row=>"1",
					 	-sticky=>"w",
					 	-padx=>"3",
				      	-pady=>"3");
					   
		my $f4_label = $server_hotkey_window->Label(-text=>"F4:",
									    	    	-background=>"black",
									 	    		-foreground=>"white",);
		$f4_label->grid(-column=>"0",
					 	-row=>"2",
					 	-sticky=>"w",
					 	-padx=>"3",
					 	-pady=>"3");
					   
		my $f5_label = $server_hotkey_window->Label(-text=>"F5:",
									 	    	    -background=>"black",
									 	    		-foreground=>"white",);
		$f5_label->grid(-column=>"0",
					 	-row=>"3",
					 	-sticky=>"w",
					 	-padx=>"3",
					 	-pady=>"3");
					   
		my $f6_label = $server_hotkey_window->Label(-text=>"F6:",
										    		-background=>"black",
										    		-foreground=>"white",);
		$f6_label->grid(-column=>"0",
					 	-row=>"4",
					 	-sticky=>"w",
					 	-padx=>"3",
					 	-pady=>"3");
					   
		my $f7_label = $server_hotkey_window->Label(-text=>"F7:",
									 	    		-background=>"black",
									 	    		-foreground=>"white",);
		$f7_label->grid(-column=>"0",
					 	-row=>"5",
					 	-sticky=>"w",
					 	-padx=>"3",
					 	-pady=>"3");
		
		my $f2_entry = $server_hotkey_window->Entry(-textvariable=>\$server1,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f2_entry->grid(-column=>"1",
					 	-row=>"0",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $f3_entry = $server_hotkey_window->Entry(-textvariable=>\$server2,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f3_entry->grid(-column=>"1",
					 	-row=>"1",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $f4_entry = $server_hotkey_window->Entry(-textvariable=>\$server3,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f4_entry->grid(-column=>"1",
					 	-row=>"2",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $f5_entry = $server_hotkey_window->Entry(-textvariable=>\$server4,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f5_entry->grid(-column=>"1",
					 	-row=>"3",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $f6_entry = $server_hotkey_window->Entry(-textvariable=>\$server5,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f6_entry->grid(-column=>"1",
					 	-row=>"4",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $f7_entry = $server_hotkey_window->Entry(-textvariable=>\$server6,
						    			         	-borderwidth=>"1",
			   						         		-width=>"15",
			   						         		-background=>"white",
			   						         		-foreground=>"black",
			   						         		-highlightcolor=>"white",);
		$f7_entry->grid(-column=>"1",
					 	-row=>"5",
					 	-padx=>"3",
					 	-pady=>"3");
					 
		my $savebutton = $server_hotkey_window->Button(-text => "Save & Close",
											  		   -width => "15",
						   			     	  		   -command => sub { 
																		open SERVCONFIG, ">$config_path/server.pl";
																		print SERVCONFIG '$server1 =';
																		print SERVCONFIG " \'$server1\'\;\n";
																		print SERVCONFIG '$server2 =';
																		print SERVCONFIG " \'$server2\'\;\n";
																		print SERVCONFIG '$server3 =';
																		print SERVCONFIG " \'$server3\'\;\n";
																		print SERVCONFIG '$server4 =';
																		print SERVCONFIG " \'$server4\'\;\n";
																		print SERVCONFIG '$server5 =';
																		print SERVCONFIG " \'$server5\'\;\n";
																		print SERVCONFIG '$server6 =';
																		print SERVCONFIG " \'$server6\'\;\n";
																		close SERVCONFIG;
																		$server_hotkey_window->withdraw });
		$savebutton->grid(-column=>"1",
					   	  -row=>"6",
					   	  -padx=>"5",
					   	  -pady=>"5");
		
	}
	
}

1;
