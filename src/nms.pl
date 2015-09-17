#!/usr/bin/perl
# nms is a blog/content management system

#use warnings;
use autodie;

use lib '.';
BEGIN { require 'config.pl' };

my @html = ("<!doctype html>\n<html>\n<head>\n<title>", "</title>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />\n</head><body><div id=\"wrapper\">", "</body>\n</html>");
sub determinetype {
	if (FILE_LANGUAGE == 'soy') {
		my $extension = '.soy';
	} elsif (FILE_LANGUAGE == 'markdown') {
		my $extension = '.md';
	} else { print "Unknown markup language! Exiting!\n"; exit; }
}

print "Welcome to nms.\n";

sub checkpages { # Check if necessary files exist
	if (!-e FILE_PAGES) { print "No page folder found! Exiting!\n"; exit; }
	elsif ((!-f FILE_PAGES . "/Home" . $extension)) { print "No home page found! Exiting!\n"; exit; }
}

sub getpages { # Get a list of all existing pages
	opendir(D, FILE_PAGES) or die "Can't open page folder! $!\n";
	my @pages = readdir(D);
	closedir(D);
	return @pages;
}

sub build { # Generate html for every page
	foreach my $item (@_) {
		makepage($item);
	}
}

sub makepage { # Build a page
	if (!($_[0] eq ".") and !($_[0] eq "..")) {
		print "Building page ${_[0]}\n";
		open(my $page, "<", FILE_PAGES . "/${_[0]}") or die "Error reading file ${_[0]} $!\n";
		my @page = <$page>;

		if (FILE_LANGUAGE == 'soy') {
			my $html = soy2html(@page);
		} elsif (FILE_LANGUAGE == 'markdown') {
			my $html = md2html(@page);
		}

		writefile($html, $_[0]);
	}
}

sub soy2html {

}

sub md2html { #TODO: This

}

sub writefile {
	open(my $outpage, ">", FILE_PAGES . "/${_[1]}") or die "Error writing to file ${_[1]} $!\n";
	print $outpage $_[0];
}

# Program execution starts here
determinetype();
checkpages();
my @pages = getpages();
build(@pages);
