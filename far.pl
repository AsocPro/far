#!/usr/bin/perl

use warnings;
use strict;

use Getopt::Std;
use POSIX qw(strftime);
use File::Copy;

my %opts;
getopts('i:f:r:',  \%opts);
my $file = $opts{i};
my $regex = $opts{f};
my $replace = $opts{r};

mkdir 'farBak' if (!-d 'farBak');
my $time = strftime ("%s", localtime);

copy($file, "farBak/$file.$time") or die "Could not create farBak/$file.$time as a backup.";

open( my $in, '<', $file );
open( my $out, '>', "$file.new" );


while ( my $line = <$in> ) {

    $line =~ s/$regex/$replace/;
    print $out $line;
}
close $in;
close $out;

unlink $in;
move( "$file.new", $file);
