#!/usr/bin/perl -w
use strict;
use CGI;
use DBI;

# Setup database connection variables
my $user     = "gartneac";
my $password = "bio466";
my $host     = "localhost";
my $driver   = "mysql";

### Connect to database
my $dsn = "DBI:$driver:database=gartneac;host=$host";
my $dbh = DBI->connect( $dsn, $user, $password );

### Setup CGI handle
my $cgi = new CGI;

### Now process user input and fetch their requested info.

# Start HTML
print $cgi->header;
print $cgi->start_html('Query Results');

print $cgi->h1('Query Results')."\n";

# Get some params from user query
my @params = $cgi->param();
my $tableName = $cgi->param('type');

print "<p>You selected file type: ".$tableName."</p>";


print $cgi->end_html();

$dbh->disconnect();
