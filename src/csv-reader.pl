use strict;
use warnings 'all';
use utf8;


my @result_rows = get_rows();
for my $row (<@result_rows>){
    print "${row}\n";
}


sub get_rows {
    open my $fh, "<:encoding(utf8)", "../test/names.csv" or die "names.csv: $!";
    my @rows;
    while (my $line = <$fh>){
        chomp $line;
        my @fields = split ",", $line;
        #print "${fields[0]}\n";
        push @rows, $fields[0] 
    }
    close $fh;
    return @rows;
}

