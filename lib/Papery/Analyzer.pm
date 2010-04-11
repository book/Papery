package Papery::Analyzer;

use strict;
use warnings;

use File::Spec;

sub analyze_file {
    my ( $class, $pulp, $path, @options ) = @_;
    my $meta = $pulp->{meta};

    # $file is relative to __source
    my $abspath = File::Spec->catfile( $meta->{__source}, $path );

    open my $fh, $abspath or die "Can't open $path: $!";
    local $/;
    my $text = <$fh>;
    close $fh;

    # compute file extension
    my $ext = ( split /\./, $path )[-1];
    $meta->{_processor} = $meta->{_processors}{$ext}
        if exists $meta->{_processors}{$ext};

    # update meta
    $meta->{__source_path}    = $path;
    $meta->{__source_abspath} = $abspath;
    $meta->{_text}            = $text;
    return $class->analyze($pulp);
}

1;

