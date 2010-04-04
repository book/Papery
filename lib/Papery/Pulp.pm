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

#
# Steps handlers
#

# utility method
sub _class_args {
    my ( $self, $which ) = @_;

    # compute the base class name
    my $base = $which;
    $base =~ s/^_//;
    $base = 'Papery::' . ucfirst $base;

    # get the values from the meta
    $which = $self->{meta}{$which};
    my ( $class, @args ) = ref $which eq 'ARRAY' ? @{$which} : $which;

    return "$base\::$class", @args;
}

sub analyze_file {
    my ( $self,  $file )    = @_;
    my ( $class, @options ) = $self->_class_args('_analyzer');
    eval "require $class";
    return $class->new(@options)->analyze_file( $self, $file );
}

sub process {
    my ($self) = @_;
    my ( $class, @options ) = @{ $self->{meta}{_processor} };
    eval "require $class";
    return $class->new(@options)->process($self);
}

sub render {
    my ($self) = @_;
    my ( $class, @options ) = @{ $self->{meta}{_renderer} };
    eval "require $class";
    return $class->new(@options)->render($self);
}

1;

