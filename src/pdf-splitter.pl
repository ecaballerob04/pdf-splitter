use strict;
use warnings 'all';
use utf8;
use PDF::API2;
use Text::CSV;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS);

my ($pdfFileName, $csvFileName, $destDir, $destFile ) = @ARGV;

if( not defined $pdfFileName) {
    die "PDF file need it";
}
if( not defined $csvFileName) {
    die "CSV file need it";
}
if( not defined $destDir) {
    die "Directorry destination need it";
}
if( not defined $destFile) {
    die "Destination file need it";
}

mkdir($destDir) 
    or $!{EEXIST}
    or die "Cannot create directory";

my @rows = get_rows($csvFileName);
split_file($pdfFileName, @rows);
zip_files($destDir, $destFile);


sub zip_files {
    my ($dest, $destFileName) = @_;
    my $zip = Archive::Zip->new();
    $zip->addTreeMatching( $dest, undef, '\.pdf$');
    unless ( $zip->writeToFileNamed($destFileName) == AZ_OK ) {
        die 'Error to compress files';
    }
}

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
