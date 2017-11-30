#!/usr/bin/perl

use warnings;
use strict;

use Getopt::Std;
use File::Copy;

my %opts;
getopts('rt',  \%opts);
my $file = '';

sub massage {
	
	my $line = shift;
	$line =~ s///g;
	return $line;

}

sub test {
	my $line = shift;
	if ( $line  ) {
		return 1;
	} else {
		return 0;
	}
}

open( my $in, '<', $file );
open( my $out, '>', "$file.new" );


my $lineNumber = 1;
while ( my $line = <$in> ) {

	if ( $opts{t} ) {

		if ( test($line) ) {
			print "\n$lineNumber\n";
			print $line;
		}

	} elsif ( $opts{r} ) {

		if ( test($line) ) {
			$line = massage($line);
		}
		print $out $line;

	} else {
		if ( test($line) ) {
			print "\n$lineNumber\n";
			print $line;
			print "-------------------\n";
			$line = massage($line);
			print $line;
		}

	}
	++$lineNumber;
}
close $in;
close $out;

if ( $opts{r} ) {

	my $time = time();
	mkdir 'farBak' if (!-d 'farBak');
	copy($file, "farBak/$file.$time") or die "Could not create farBak/$file.$time as a backup.";
	unlink $file;
	move( "$file.new", $file);
	unlink "$file.new";

}

