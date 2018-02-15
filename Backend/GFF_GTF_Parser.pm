#!/usr/bin/perl -w
package GFF_GTF_Parser;
use strict;
use Annotation;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self = { -annotations => {}, };

	foreach my $key ( keys %args ) {
		my $value = $args{$key};
		$self->{$key} = $value;
	}

	bless( $self, $class );

	return $self;
}

sub parse {
	my $self      = shift;
	my $file      = $self->{'-file_name'};
	my $file_type = $self->{'-file_type'};
	my $file_src  = $self->{'-file_src'};
	my %annotations;

	### We only parse .gff, so if .gtf parameter given, exit:
	if ( $file_type eq 'GTF' ) {
		print "\nWe only support GFF parsing -- try again with a GFF file!\n";
		exit;
	}

	### Parse file
	open( FILE, "<$file" ) or die "Cannot open $file for processing!\n";
	my @targetLines =
	  <FILE>;    # save the tab-delimited file into array line by line

	my @tab_values;
	my @semi_values;
	my $type, my $typeID, my $start, my $stop, my $geneID, my $product,
	  my $parent, my $name;
	my $annotationNum = 0;
	for ( my $i = 0 ; $i <= $#targetLines ; $i++ ) {
		chomp( $targetLines[$i] );
		### Make sure it's not a metadata line beginning with '#'
		if ( substr( $targetLines[$i], 0, 1 ) ne '#' ) {
			@tab_values = split( '\t', $targetLines[$i] );
			### Check that its a line of type mRNA, tRNA, or gene
			if (   $tab_values[2] eq 'mRNA'
				|| $tab_values[2] eq 'gene'
				|| $tab_values[2] eq 'tRNA' )
			{
				### Grab the start, stop, and type
				$type  = $tab_values[2];
				$start = $tab_values[3];
				$stop  = $tab_values[4];

				@semi_values = split( ';', $tab_values[8] );
				### Loop over all the data about the gene/MRNA/TRNA and extract it
				for ( my $i = 0 ; $i <= $#semi_values ; $i++ ) {
					### Check for typeID
					if (   index( $semi_values[$i], 'ID=gene' ) != -1
						|| index( $semi_values[$i], 'ID=rna' ) != -1 )
					{
						my $temp = substr( $semi_values[$i], 3, (length $semi_values[$i]) - 3 );
						$typeID = $temp;
					}
					### Check for geneID
					elsif ( index( $semi_values[$i], 'GeneID:' ) != -1 ) {
						$geneID = $semi_values[$i];
					}
					### Check for product
					elsif ( index( $semi_values[$i], 'product=' ) != -1 ) {
						$product = $semi_values[$i];
					}
					### Check for the parent (only exists for RNA)
					elsif ( index( $semi_values[$i], 'Parent=' ) != -1 ) {
						
						my $temp = substr( $semi_values[$i], 7, (length $semi_values[$i]) - 7 );						
						$parent = $temp;
					}
					### Check for the Gene name
					elsif ( index( $semi_values[$i], 'Name=' ) != -1 ) {
						
						my $temp = substr( $semi_values[$i], 5, (length $semi_values[$i]) - 5 );						
						$name = $temp;
					}
				}

				### Get ready to create our 'Annotation' object
				my $annotation = Annotation->new(
					-type    => $type,
					-start   => $start,
					-stop    => $stop,
					-typeID  => $typeID,
					-geneID  => $geneID,
					-product => $product,
					-parent  => $parent,
					-name	 => $name
				);

				### Add it to our hash of annotations
				$annotations{$annotationNum} = $annotation;
				$annotationNum++;
			}
		}
	}

	### Reassign the whole hash of annotations to the self
	$self->{'-annotations'} = \%annotations;
}

sub getAnnotations {
	my $self        = shift;
	my $annoHashRef = $self->{'-annotations'};

	return $annoHashRef;
}

1;
