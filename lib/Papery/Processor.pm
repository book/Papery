package Papery::Processor;

use strict;
use warnings;

sub process {
    my ($class, $pulp, @options) = @_;
    $pulp->{meta}{_content} = $pulp->{meta}{_text};
    return $pulp;
}

1;

