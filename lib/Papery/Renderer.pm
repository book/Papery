package Papery::Renderer;

use strict;
use warnings;

sub render {
    my ($class, $pulp, @options) = @_;
    $pulp->{meta}{_output} = $pulp->{meta}{_content};
    return $pulp;
}

1;
