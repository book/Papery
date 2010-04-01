package Papery::Analyzer::Simple;

use strict;
use warnings;
use Papery::Analyzer;
our @ISA = qw( Papery::Analyzer );

use YAML::Tiny qw( Load );

sub analyze {
    my ( $class, $text ) = @_;
    my $meta;
    my @text = $text;
    if ( $text =~ /\A---\n/ ) {
        ( undef, $meta, @text ) = split /^---\n/m, $text, 3;
        $meta = Load($meta);
    }
    return ( $meta || {}, @text );
}

1;

