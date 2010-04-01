package Papery::Analyzer;

use strict;
use warnings;

sub analyze_file {
    my ( $self, $file, $options ) = @_;
    open my $fh, $file or die "Can't open $file: $!";
    local $/;
    my $text = <$fh>;
    close $fh;
    return $self->analyze( $text, $options );
}

1;

