use strict;
use warnings 'all';
use utf8;
use PDF::API2;
use Text::CSV;

my ($pdfFileName, $csvFileName, $destDir) = @ARGV;

if( not defined $pdfFileName) {
    die "PDF file need it";
}
if( not defined $csvFileName) {
    die "CSV file need it";
}
if( not defined $destDir) {
    die "Destination Folder need it";
}



my @rows = get_rows($csvFileName);
split_file($pdfFileName, @rows);

sub split_file {
    my ($pdfFile, @rows) = @_;
    my $oldPdf = PDF::API2->open($pdfFile);
    for my $numPage ( 1 .. $oldPdf->pages() ) {
        my $newPdf = PDF::API2->new();
        my $page = $newPdf->import_page($oldPdf,$numPage);
        $newPdf->saveas("${destDir}/${rows[$numPage - 1]}.pdf");
        $newPdf->release();
    }
    $oldPdf->release();
}
sub get_rows {
    my ($csvFile) = @_;
    my $csv = Text::CSV->new();
    open my $fh, "<:encoding(utf8)", $csvFile or die "${csvFile}: $!";
    my @rows;
    while (my $line = <$fh>){
        chomp $line;
        
        if($csv->parse($line)) {
            my @fields = $csv->fields();
            push @rows, $fields[0] 
        }
    }
    close $fh;
    return @rows;
}
