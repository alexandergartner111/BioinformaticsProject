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
print $cgi->start_html('Overview Results');
print $cgi->h1('Overview Results')."\n";
print $cgi->p('There are 12191 Genes and 12014 Transcripts in the genome annotations of these two yeasts.')."\n";


print $cgi->h2('Bakers Yeast')."\n";
print $cgi->h4('Sorted by start position.')."\n";

my $sql = "select Name, TypeID, Start, Stop, GeneID, Product from GENE where Organism = 'BakersYeast' order by convert(Start, decimal)";
	
	my $rowsref = $dbh->selectall_arrayref($sql) || die $dbh->errstr;
	my @rows=@{$rowsref};
	if ($#rows>=0) {
  	print '<table border=1 cellspacing=0 cellpadding=1><tr>' .
                "<th>Name</th><th>TypeID</th><th>Start</th><th>Stop</th><th>GeneID</th><th>Product</th></tr>";
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
	
print $cgi->h2('<em>C. albicans</em>')."\n";
print $cgi->h4('Sorted by start position.')."\n";

$sql = "select Name, TypeID, Start, Stop, GeneID, Product from GENE where Organism = 'CandidaAlbicans' order by convert(Start, decimal)";

	my $rowsref = $dbh->selectall_arrayref($sql) || die $dbh->errstr;
	my @rows=@{$rowsref};
	if ($#rows>=0) {
  	print '<table border=1 cellspacing=0 cellpadding=1><tr>' .
                "<th>Name</th><th>TypeID</th><th>Start</th><th>Stop</th><th>GeneID</th><th>Product</th></tr>";
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


print $cgi->end_html();
$dbh->disconnect();
