#===============================================================================
#                   canvasList.pl v1.6 - MAY09 - by. MrFSL
#
#  Licensed under the Creative Commons Attribution-Share-Alike 3.0 US License 
#            http://creativecommons.org/licenses/by-sa/3.0/us/
#
#===============================================================================
# Canvas list is a group of subroutines that you can use to make something
#           similar to a list box with Text and Pictures.
#
# To use, create a Canvas widget in your application. Set all options you want
# for your canvas and then use these subroutines to add, remove, etc items to 
#                           your canvas
#
#
# Examples
# &canvasListAdd( Canvas Ref, Pic, Label, X Spacing, Y Spacing );
# &canvasListDelete( Canvas Ref, Item To Delete, Y Spacing );
# &canvasListAddTop( Canvas Ref, Pic, Label, X Spacing, Y Spacing);
# Provides
# @all_items which holds references to each line on the canvas
#===============================================================================

 
sub canvasListAdd {

    # Set/Get Variables
    unless ( $#_ == 4 ) { die "&canvasListAdd: Incorrect # of args!\n"; }
    my $canvas      = $_[0]; # 0) Canvas Reference
    my $pic         = $_[1]; # 1) Picture Name
    my $label       = $_[2]; # 3) Label (Name/Text)
    my $x_spacing   = $_[3]; # 4) Horizontal Spacing
    my $y_spacing   = $_[4]; # 5) Vertical Spacing
    
    # Find the number of items already on the canvas
    my @all_indexes = $canvas->find('all');
    
    # Calculate Y Coordinate
    $y_spacing = @all_indexes / 2 * $y_spacing;
    
    my $pic_index = $canvas->createImage( '0', $y_spacing,  
                            			 -image => $pic,);
                        
    my $label_index = $canvas->createText( $x_spacing, $y_spacing, 
                            			  -text => $label, 
                            			  -fill => 'white', 
                            			  -font => "arial $font", 
                            			  -anchor => 'w',);
    
    # Pack an Array with array refs holding all important info
     @{$all_items[$#all_items + 1]} = ($label, $pic_index, $label_index);
    
    # Bind Double-Click to both items on the line                        
	$canvas->bind( $pic_index, '<Double-1>', [\&double_click_item, $label] );
	$canvas->bind( $label_index, '<Double-1>', [\&double_click_item, $label] );
    
    # Adjusts the scrollbar's scroll area
     $canvas->configure(-scrollregion => [ $canvas->bbox("all") ]);


} ##-- END canvasListAdd() --##


sub canvasListDelete {

    # Set/Get Variables
    unless ( $#_ == 2 ) { die "&canvasListDelete: Incorrect # of args!\n"; }
    my $canvas          = $_[0]; # 0) Canvas Reference
    my $label           = $_[1]; # 1) Tag of item to delete
    my $y_spacing       = $_[2]; # 2) Y Spacing
    my $item_to_delete  = '';
    
    # Find which refrence holds $label
    foreach (@all_items) {
        if ($_->[0] eq $label) {
            $item_to_delete = $_;
        }
    }
    
    # Remove the reference that holds $label
    @all_items = grep !($_->[0] eq $label ) , @all_items;
    
    # If we delete 'all'
    if ($label eq 'all') {
        $canvas->delete( 'all' );
        @all_items = ();
        return;
    }
    
    # Get a list of all items below our item to delete
    my @item_bb = $canvas->bbox($item_to_delete->[1]);
    return unless @item_bb;
    my @all_bb = $canvas->bbox("all");
    my @list_to_move = $canvas->find( 'enclosed', $all_bb[0], $item_bb[1], $all_bb[2], $all_bb[3] + 1000 );
    
    # Delete item
    $canvas->delete( $item_to_delete->[1] );
    $canvas->delete( $item_to_delete->[2] );
    
    # Move list
    foreach my $index ( @list_to_move ) {
        $canvas->move( $index, 0, -$y_spacing );
    }
    
    # Adjusts the scrollbar's  scroll area
    $canvas->configure(-scrollregion => [ $canvas->bbox("all") ] ) if $canvas->bbox("all"); 

    

} ##-- END canvasListDelete() --##


sub canvasListAddTop {

    # Set/Get Variables
    unless ( $#_ == 4 ) { die "&canvasListAdd: Incorrect # of args!\n"; }
    my $canvas      = $_[0]; # 0) Canvas Reference
    my $pic         = $_[1]; # 1) Picture Name
    my $label       = $_[2]; # 3) Label (Name/Text)
    my $x_spacing   = $_[3]; # 4) Horizontal Spacing
    my $y_spacing   = $_[4]; # 5) Vertical Spacing

    # If item exists delete it
    &canvasListDelete( $canvas, $label, $y_spacing );
    
    # Get all indexes
    my @indexes_all = $canvas->find( 'all' );
    
    # Add item to the top
    &canvasListAdd( $canvas, $pic, $label, $x_spacing, '0' );
    
    # Move list
    foreach my $index (@indexes_all) {
	    $canvas->move( $index, 0, $y_spacing );
	}
    
	# Adjusts the scrollbar's  scroll area
    $canvas->configure(-scrollregion => [ $canvas->bbox("all") ]);
    
} ##-- END canvasListAddTop() --##


sub double_click_item {

    # Edit this item to have action on item double click
    my $item = $_[1]; # 1) Item to manipulate
    $text = "$text$item";
    $main_entry->icursor('end');
    $main_entry->focus();
} ##- END double_click_item --##

1;

