package Papery::Util;

use strict;
use warnings;

use Exporter;
our @ISA       = qw( Exporter );
our @EXPORT_OK = qw( merge_meta );

sub merge_meta {
    my ( $meta, $extra ) = @_;

    # __ keys are ignored
    my @__keys = grep {/^__/} keys %$extra;
    my @__values = delete @{$extra}{@__keys};

    # keys postfixed with + or - are updates
    my @keys = grep {/[-+]$/} keys %$extra;
    my @values = delete @{$extra}{@keys};

    # others are replacement
    @{$meta}{ keys %$extra } = values %$extra;

    # process the updates
    while ( my $key = shift @keys ) {
        my $where = chop $key;
        my $value = shift @values;

        if ( ref $value eq 'ARRAY' ) {
            if ( $where eq '+' ) { push @{ $meta->{$key} }, @$value; }
            else                 { unshift @{ $meta->{$key} }, @$value; }
        }
        elsif ( ref $value eq 'HASH' ) {
            merge_meta( $meta->{$key}, $value );    # recursive update!
        }
        else {                                      # assume string
            if ( $where eq '+' ) { $meta->{$key} .= $value; }
            else {
                $meta->{$key}
                    = $value . ( defined $meta->{$key} ? $meta->{$key} : '' );
            }
        }
    }

    return $meta;
}

1;

