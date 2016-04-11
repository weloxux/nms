#!/usr/bin/perl
# nms is a content management system, similar to a wiki

use strict;
use warnings;
use autodie;

use Switch;

use Data::Dumper; #DEBUG

use lib '.';
BEGIN { require 'config.pl' };

my @html = ("<!doctype html><html><head><title>", "</title><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /></head><body><div id=\"wrapper\">", "</div></body></html>");
my $extension;

sub getextension {
	if (FILE_LANGUAGE eq 'soy') {
		$extension = '.soy';
	} elsif (FILE_LANGUAGE eq 'markdown') {
		$extension = '.md';
	} elsif (FILE_LANGUAGE eq 'html') {
		$extension = '.html';
	} else { die "Unknown markup language specified! Exiting!\n"; }
}


sub checkpages { # Check if necessary files exist
	if (!-e FILE_PAGES) { die "No page folder found! Exiting!\n"; }
	elsif ((!-f FILE_PAGES . "/home" . $extension)) { die "No home page found! Exiting!\n"; }
}

sub getpages { # Get a list of all existing pages
	opendir(D, FILE_PAGES) or die "Can't open page folder! Exiting!\n";
	my @pages = readdir(D);
	closedir(D);
	return @pages;
}

sub build { # Generate html for every page
	foreach my $item (@_) {
		if ($item =~ /\.soy/ ) { # FIX ME FIX ME FIX ME
			makepage($item);
		} elsif (not $item eq '.' || $item eq '..') {
			print "File '$item' does not seem to be in " . FILE_LANGUAGE . " format. Skipping!\n";
		}
	}
}

sub makepage { # Build a page
	if (!($_[0] eq ".") and !($_[0] eq "..")) {
		print "Building page ${_[0]}\n";
		my $page = do {
			local $/ = undef;
			open my $fh, "<", FILE_PAGES . "/${_[0]}" or die "Could not open file! Exiting!";
			<$fh>;
		};

		switch(FILE_LANGUAGE) {
			case 'soy'	{ writefile(soy2html($page, $_[0]), $_[0]); }
			case 'markdown' { writefile(md2html($page, $_[0]), $_[0]); }
			case 'html'	{ writefile(html2html($page, $_[0]), $_[0]); }
		}
	}
}

sub soy2html { # Convert soy files to HTML
	my $content = $_[0];
	(my $title = ${_[1]}) =~ s{\.[^.]+$}{};

	for($content) {
		s{/(.*)/}{<i>$1</i>}g;
		s{_(.*)_}{<b>$1</b>}g;
		s{"(.*)"}{&ldquo;<i>$1</i>&rdquo;}g;

		s{\*\*\*(.*)\*\*\*}{<h3>$1</h3>}g; # headers
		s{\*\*(.*)\*\*}{<h2>$1</h2>}g;
		s{\*(.*)\*}{<h1>$1</h1>}g;
	}

	my $result = $html[0] . $title . $html[1] . $content . $html[2];
	return $result;
}

sub md2html { # Convert (a subset of) markdown to HTML
	my $content = $_[0];
}

sub html2html { # Finish up user-written HTML

}

sub writefile {
	#print "Writing file ${_[1]}. Contents: ${_[0]}\n";
	(my $outfile = FILE_OUT . '/' . ${_[1]}) =~ s{\.[^.]+$}{\.html}; # Remove extension

	open(my $outpage, ">", $outfile) or die "Error writing to file ${_[1]}! Exiting!\n";
	print $outpage $_[0];
	close($outpage);
}

# Program execution starts here
print "Welcome to nms.\n";
getextension();
checkpages();
build(getpages());
