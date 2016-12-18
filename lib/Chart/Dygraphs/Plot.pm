package Chart::Dygraphs::Plot;

use strict;
use warnings;
use utf8;

use Moose;
 
# VERSION

# ABSTRACT: Collection of series plotted in the same plot

=encoding utf-8

=cut

has 'options' => (
	is => 'rw',
	isa => 'HashRef',
	default => sub {
		return {showRangeSelector => 1 }}
);

has 'data' => (
	is => 'rw',
	isa => 'ArrayRef',
	default => sub { [[1, 1], [2, 4], [3, 9], [4, 16]] }
);

1;
