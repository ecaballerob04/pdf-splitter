use strict;
use warnings 'all';
use utf8;
use Text::CSV;
use PDF::API2;

my $mainFile = '../test/test.pdf';

split_file($mainFile);

sub split_file {
    my ($file) = @_;
    my $oldPdf = PDF::API2->open($file);
    for my $numPage ( 1 .. $oldPdf->pages() ) {
        my $newPdf = PDF::API2->new();
        my $page = $newPdf->import_page($oldPdf,$numPage);
        $newPdf->saveas("../test/test-${numPage}.pdf");
        $newPdf->release();
    }
    $oldPdf->release();
}
