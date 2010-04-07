package Papery::Analyzer::Simple;

use strict;
use warnings;

use Papery::Analyzer;
our @ISA = qw( Papery::Analyzer );

use YAML::Tiny qw( Load );

sub analyze {
    my ( $class, $pulp, $text ) = @_;
    my $meta;
    if ( $text =~ /\A---\n/ ) {
        ( undef, $meta, $text ) = split /^---\n/m, $text, 3;
        $pulp->merge_meta( Load($meta) );
    }
    $pulp->{meta}{_text} = $text;
    return $pulp;
}

1;

