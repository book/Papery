package Papery::Analyzer::Simple;

use strict;
use warnings;

use Papery::Analyzer;
our @ISA = qw( Papery::Analyzer );

use YAML::Tiny qw( Load );

sub analyze {
    my ( $class, $pulp ) = @_;
    my $text = $pulp->{meta}{_text};

    # take the metadata out
    if ( $text =~ /\A---\n/ ) {
        ( undef, my $meta, $text ) = split /^---\n/m, $text, 3;
        $pulp->merge_meta( Load($meta) );
    }

    # update the text
    $pulp->{meta}{_text} = $text;
    return $pulp;
}

1;

