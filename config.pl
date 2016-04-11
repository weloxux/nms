#!/usr/bin/perl
# This file defines the configuration for your wiki

# Look and feel
use constant NMS_NAME => 'An nms wiki';	# The name your wiki will use to refer to itself
use constant NMS_THEME => 'wiki';	# The default theme. Included by default: none yet. TODO
use constant NMS_MAIN => 'home';	# The default landing page for your wiki

# Files
use constant FILE_IMG => 'img';		# Location for image files
use constant FILE_JS => 'js';		# Location for JavaScript files
use constant FILE_PAGES => 'pages';	# Location for wiki pages (soy, Markdown or HTML)
use constant FILE_OUT => 'res';		# Location for compiled pages (HTML)

use constant FILE_LANGUAGE => 'soy';	# Markup language to be used. Possible options are soy, markdown and html

1;
