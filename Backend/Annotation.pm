#!/usr/bin/perl -w
package Annotation;
use strict;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self;

	foreach my $key ( keys %args ) {
		my $value = $args{$key};
		$self->{$key} = $value;
	}

	bless( $self, $class );

	return $self;
}

### Below are simply a bunch of getters

sub getType {
	my $self          = shift;
	my $type = $self->{'-type'};
	return $type;
}

sub getGeneID {
	my $self          = shift;
	my $geneID = $self->{'-geneID'};
	return $geneID;
}

sub getStart {
	my $self          = shift;
	my $start = $self->{'-start'};
	return $start;
}

sub getStop {
	my $self          = shift;
	my $stop = $self->{'-stop'};
	return $stop;
}

sub getTypeID {
	my $self          = shift;
	my $typeID = $self->{'-typeID'};
	return $typeID;
}

sub getProduct {
	my $self          = shift;
	my $product = $self->{'-product'};
	return $product;
}

sub getParent {
	my $self          = shift;
	my $parent = $self->{'-parent'};
	return $parent;
}

sub getName {
	my $self          = shift;
	my $name = $self->{'-name'};
	return $name;
}

1;
