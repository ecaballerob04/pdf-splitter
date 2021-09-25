use strict;
use warnings 'all';
use utf8;
use PDF::API2;

my $pdfFileName = '../test/test.pdf';
my $csvFileName = "../test/names.csv";

split_file($pdfFileName, $csvFileName );

sub split_file {
    my ($pdfFile, $csvFile) = @_;
    my $oldPdf = PDF::API2->open($pdfFile);
    my @rows = get_rows($csvFile);
    for my $numPage ( 1 .. $oldPdf->pages() ) {
        my $newPdf = PDF::API2->new();
        my $page = $newPdf->import_page($oldPdf,$numPage);
        $newPdf->saveas("../test/test-${rows[$numPage - 1]}.pdf");
        $newPdf->release();
    }
    $oldPdf->release();
}

sub get_rows {
    my ($csvFile) = @_;
    open my $fh, "<:encoding(utf8)", $csvFile or die "names.csv: $!";
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


