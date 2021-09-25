use strict;
use warnings 'all';
use utf8;
use PDF::API2;

my $mainFile = '../test/test.pdf';
my $csvFile = "../test/names.csv";

split_file($mainFile);

sub split_file {
    my ($file) = @_;
    my $oldPdf = PDF::API2->open($file);
    my @rows = get_rows($csvFile);
    for my $numPage ( 1 .. $oldPdf->pages() ) {
        my $newPdf = PDF::API2->new();
        my $page = $newPdf->import_page($oldPdf,$numPage);
        $newPdf->saveas("../test/test-${numPage}.pdf");
        $newPdf->release();
    }
    $oldPdf->release();
}

sub get_rows {
    my ($file) = @_;
    open my $fh, "<:encoding(utf8)", $file or die "names.csv: $!";
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


