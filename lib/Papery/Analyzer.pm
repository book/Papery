package Papery::Analyzer;

use strict;
use warnings;

sub analyze_file {
    my ( $class, $pulp, $file, @options ) = @_;

    open my $fh, $file or die "Can't open $file: $!";
    local $/;
    my $text = <$fh>;
    close $fh;

    $pulp->{meta}{__file} = $file;
    return $self->analyze( $pulp, $text );
}

1;

