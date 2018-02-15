#!/usr/bin/perl -w
use strict;
use CGI;
use DBI;
use CGI::Carp 'fatalsToBrowser';

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

# Get some params from user query
my $tableName = $cgi->param('type');
my $organism = $cgi->param('organism');
my $geneID = $cgi->param('gene_id');
my $geneName = $cgi->param('gene_name');
my $transcriptID = $cgi->param('transcript_id');


### Now process user input and fetch their requested info.

# Start HTML
print $cgi->header();
print $cgi->start_html('Query Results');

print $cgi->h1('Query Results')."\n";
print $cgi->h3('Note: GeneID is not present at all in the Candida Albicans file.')."\n";

my $sql = "select * from ".$tableName." where Organism = '".$organism."'";

if ($tableName eq 'GENE') {
	
	if ($geneID ne "") {
		$sql .= " AND TypeID = '".$geneID."'";
	}
	if ($geneName ne "") {
		$sql .= " AND Name = '".$geneName."'";
	}

	my $rowsref = $dbh->selectall_arrayref($sql) || die $dbh->errstr;
	my @rows=@{$rowsref};
	if ($#rows>=0) {
  	print "<table border=1 cellspacing=0 cellpadding=3><tr>" .
                "<th>Name</th><th>Organism</th><th>TypeID</th><th>Type</th><th>Start</th><th>Stop</th><th>GeneID</th><th>Product</th></tr>";
  	for (my $i=0; $i<=$#rows; $i++) {
    		my @row=@{$rows[$i]};
    		print "<tr>";
    		for (my $j=0; $j<=$#row; $j++) {
     			print "<td>$row[$j]</td>";
    		}
    	print "</tr>";
 	}
  	print "</table>\n";
	}
	else {
 		 print "<p><i>No matches found</i></p>\n";
	}
	
}
else {

	if ($transcriptID ne "") {
		$sql .= " AND TypeID = '".$transcriptID."'";
	}

	my $rowsref = $dbh->selectall_arrayref($sql) || die $dbh->errstr;
	my @rows=@{$rowsref};
	if ($#rows>=0) {
  	print "<table border=1 cellspacing=0 cellpadding=3><tr>" .
                "<th>TypeID</th><th>Organism</th><th>Parent</th><th>Type</th><th>Start</th><th>Stop</th><th>GeneID</th><th>Product</th></tr>";
  	for (my $i=0; $i<=$#rows; $i++) {
    		my @row=@{$rows[$i]};
    		print "<tr>";
    		for (my $j=0; $j<=$#row; $j++) {
     			print "<td>$row[$j]</td>";
    		}
    	print "</tr>";
 	}
  	print "</table>\n";
	}
	else {
 		 print "<p><i>No matches found</i></p>\n";
	}

}

print $cgi->end_html();
$dbh->disconnect();
