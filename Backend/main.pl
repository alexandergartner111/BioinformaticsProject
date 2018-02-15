#!/usr/bin/perl -w
use strict;
use GFF_GTF_Parser;
use Annotation;
use DBI;

if ( $#ARGV != 0 ) {
	die "Wrong parameter!\nUsage: Need 1 inputs! \n";
}

my $file = $ARGV[0];

my $obj = GFF_GTF_Parser->new(
	-file_name => $file,
	-file_type => 'GFF',
	-file_src  => 'NCBI'
);
$obj->parse();
my $annoRef = $obj->getAnnotations();

# Dereference to get our hash of annocations
my %annotations = %$annoRef;

### Now put the annotations into the DB.
# Setup database connection variables
my $user     = "gartneac";
my $password = "bio466";
my $host     = "localhost";
my $driver   = "mysql";

### Connect to database
my $dsn = "DBI:$driver:database=gartneac;host=$host";
my $dbh = DBI->connect( $dsn, $user, $password );

### Insert annotations into DB.
### Loop through all annotation objects and compile an sql statement for each,
### Then insert it.
foreach my $key ( keys(%annotations) ) {

### it's a gene and doesn't have a 'parent' value
	if ( $annotations{$key}->getType() eq 'gene' ) {

		my $sql =
"insert into gartneac.GENE (Name, Organism, TypeID, Type, Start, Stop, GeneID, Product) values ('"
		. $annotations{$key}->getName() . "', 'CandidaAlbicans', '"		  
		. $annotations{$key}->getTypeID() . "', '"
		  . $annotations{$key}->getType() . "', '"
		  . $annotations{$key}->getStart() . "', '"
		  . $annotations{$key}->getStop() . "', '"
		  . $annotations{$key}->getGeneID() . "', '"
		  . $annotations{$key}->getProduct() . "')";
		my $query_handle = $dbh->prepare($sql);
		$query_handle->execute();
		print $sql . "\n\n";
	}

### it's an RNA and has a parent value
	else {

		my $sql =
"insert into gartneac.RNA (TypeID, Organism, Parent, Type, Start, Stop, GeneID, Product) values ('"
		  . $annotations{$key}->getTypeID() . "', 'CandidaAlbicans', '"
		  . $annotations{$key}->getParent() . "', '"
		  . $annotations{$key}->getType() . "', '"
		  . $annotations{$key}->getStart() . "', '"
		  . $annotations{$key}->getStop() . "', '"
		  . $annotations{$key}->getGeneID() . "', '"
		  . $annotations{$key}->getProduct() . "')";
		my $query_handle = $dbh->prepare($sql);
		$query_handle->execute();
		print $sql . "\n\n";
	}

}


$dbh->disconnect();
