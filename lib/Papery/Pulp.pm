package Papery::Pulp;

use strict;
use warnings;

use Papery::Util;    # do not import merge_meta()
use Storable qw( dclone );

sub new {
    my ( $class, $meta ) = @_;
    return bless { meta => $meta ? dclone($meta) : {} }, $class;
}

sub merge_meta { Papery::Util::merge_meta( $_[0]->{meta}, $_[1] ); }

1;

