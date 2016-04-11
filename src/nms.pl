#!/usr/bin/perl
# nms is a content management system, similar to a wiki

#use warnings;
use autodie;

use lib '.';
BEGIN { require 'config.pl' };

my @html = ("<!doctype html>\n<html>\n<head>\n<title>", "</title>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />\n</head><body><div id=\"wrapper\">", "</div></body>\n</html>");

sub getextension {
	if (FILE_LANGUAGE eq 'soy') {
		my $extension = '.soy';
	} elsif (FILE_LANGUAGE eq 'markdown') {
		my $extension = '.md';
	} else { print "Unknown markup language specified! Exiting!\n"; exit; }
}


sub checkpages { # Check if necessary files exist
	if (!-e FILE_PAGES) { die "No page folder found! Exiting!\n"; }
	elsif ((!-f FILE_PAGES . "/Home" . $extension)) { die "No home page found! Exiting!\n"; }
}

sub getpages { # Get a list of all existing pages
	opendir(D, FILE_PAGES) or die "Can't open page folder! Exiting!\n";
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
		open(my $page, "<", FILE_PAGES . "/${_[0]}") or die "Error reading file ${_[0]}! Exiting! \n";
		my $page = <$page>;

		if (FILE_LANGUAGE eq 'soy') {
			my $html = soy2html($page);
		} elsif (FILE_LANGUAGE eq 'markdown') {
			my $html = md2html($page);
		}

		writefile($html, $_[0]);
	}
}

sub soy2html { # Convert soy files to HTML
	my $soy = $_[0];
}

sub md2html { # Convert (a subset of) markdown to HTML
	my $md = $_[0];
}

sub writefile {
	open(my $outpage, ">", FILE_PAGES . "/${_[1]}") or die "Error writing to file ${_[1]}! Exiting!\n";
	print $outpage $_[0];
	close($outpage);
}

# Program execution starts here
print "Welcome to nms.\n";
getextension();
checkpages();
build(getpages());
