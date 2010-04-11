package Papery::Analyzer;

use strict;
use warnings;

use File::Spec;
use YAML::Tiny qw( Load );

sub analyze_file {
    my ( $class, $pulp, $path ) = @_;
    my $meta = $pulp->{meta};

    # $file is relative to __source
    my $abspath = File::Spec->catfile( $meta->{__source}, $path );

    open my $fh, $abspath or die "Can't open $path: $!";
    local $/;
    my $source = <$fh>;
    close $fh;

    # compute file extension
    my $ext = ( split /\./, $path )[-1];
    $meta->{_processor} = $meta->{_processors}{$ext}
        if exists $meta->{_processors}{$ext};

    # update meta
    $meta->{__source_path}    = $path;
    $meta->{__source_abspath} = $abspath;
    $meta->{_source}          = $source;
    return $class->analyze($pulp);
}

sub analyze {
    my ( $class, $pulp ) = @_;
    my $text = $pulp->{meta}{_source};

    # take the metadata out
    if ( $text =~ /\A---\n/ ) {
        ( undef, my $meta, $text ) = split /^---\n/m, $text, 3;
        $pulp->merge_meta( Load($meta) );
    }

    $pulp->{meta}{_text} = $text;
    return $pulp;
}

1;

