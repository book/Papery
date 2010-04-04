package Papery::Analyzer;

use strict;
use warnings;

sub new {
    my ( $class, @args ) = @_;
    return bless {@args}, $class;
}

sub analyze_file {
    my ( $self, $pulp, $file ) = @_;
    open my $fh, $file or die "Can't open $file: $!";
    local $/;
    my $text = <$fh>;
    close $fh;
    $pulp->{meta}{__file} = $file;
    return $self->analyze( $pulp, $text );
}

1;

