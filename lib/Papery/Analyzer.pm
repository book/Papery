package Papery::Analyzer;

use strict;
use warnings;

use File::Spec;

sub analyze_file {
    my ( $class, $pulp, $path, @options ) = @_;

    # $file is relative to __source
    my $abspath = File::Spec->catfile( $pulp->{meta}{__source}, $path );

    open my $fh, $abspath or die "Can't open $path: $!";
    local $/;
    my $text = <$fh>;
    close $fh;

    # update meta
    $pulp->{meta}{__source_path}    = $path;
    $pulp->{meta}{__source_abspath} = $abspath;
    return $class->analyze( $pulp, $text );
}

1;

