#/usr/bin/perl6
# This file defines the configuration for your wiki

# Look and feel
use constant NMS_NAME => 'An nms wiki'; # The name your wiki will use to refer to itself
use constant NMS_THEME => 'wiki'; # The default theme. Included by default: wiki, darkwiki, book.

# Files
use constant FILE_IMG => '../img'; # Location for image files
use constant FILE_JS => '../js'; # Location for JavaScript files
use constant FILE_PAGES => '../pages'; # Location for wiki pages
use constant FILE_LANGUAGE => 'soy'; # Markup language to be used. nms knows soy and markdown.

1;
