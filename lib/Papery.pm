package Papery;

use warnings;
use strict;
use Carp;

our $VERSION = '0.01';

use Papery::Util qw( merge_meta );
use Papery::Pulp;

use File::Spec;
use YAML::Tiny qw( LoadFile );
use Storable qw( dclone );

my %defaults = (
    _analyzer => 'Simple',
);

sub new {
    my ( $class, $source, $destination, %args ) = @_;

    # checks
    croak "Source directory '$source' doesn't exist"
        if !-e $source;
    croak "Source '$source' is not a directory"
        if !-d $source;

    # read the configuration file
    my ($config) = LoadFile( File::Spec->catfile( $source, '_config.yml' ) );

    # create object
    return bless {
        __source      => $source,
        __destination => $destination,
        __stash       => {},
        __meta        => {
            %defaults, %$config, %args,
            __source      => $source,
            __destination => $destination,
        },
    }, $class;
}

sub generate {
    my ($self) = @_;
    $self->process_dir( dclone( $self->{__meta} ), '' );
}

# $dir is relative to __source
sub process_tree {
    my ( $self, $meta, $dir ) = @_;
    my $absdir = File::Spec->catdir( $self->{__source}, $dir );
    $dir ||= File::Spec->curdir;

    # local metafile for directory
    if ( -e ( my $metafile = File::Spec->catfile( $absdir, '_meta.yml' ) ) ) {
        merge_meta( $meta, LoadFile($metafile) );
    }

    # special directories
    merge_meta(
        $meta,
        {   map      {@$_}             # back to key/value pairs
                grep { -d $_->[1][0] }    # skip non-existing dirs
                map {
                chop( my $name = $_ );
                [ $_ => [ File::Spec->catdir( $absdir, $name ) ] ]
                } qw( _templates- _lib- _hooks+ )
        }
    );

    # process directory
    opendir my $dh, $absdir or die "Can't open $absdir for reading: $!";

FILE:
    for my $file ( File::Spec->no_upwards( readdir($dh) ) ) {


        # always ignore _ files (reserved for Papery)
        next if $file =~ /^_/;

        # relative and absolute path for the file
        my $path    = File::Spec->catfile( $dir,    $file );
        my $abspath = File::Spec->catfile( $absdir, $file );

        # check against ignore list
        for my $check ( @{ $meta->{_ignore} } ) {
            if ( $file =~ /$check/ ) {
                next FILE;
            }
        }

        # recurse into directory
        if ( -d $abspath ) {
            $self->process_tree( $meta, $path );
        }
        else {
            $self->process_file( $meta, $path );
        }
    }
}

sub process_file {
    my ( $self, $meta, $file ) = @_;
    return
        map    { $_->save() }                 # will create final files
        map    { $_->render() }               # may insert Papery::Pulp
        map    { $_->process() }              # may insert Papery::Pulp
        map    { $_->analyze_file($file) }    # may insert Papery::Pulp
        Papery::Pulp->new($meta);             # clone $meta
}

'Vélin';

__END__

=head1 NAME

Papery - The great new Papery!

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Papery;

    my $foo = Papery->new();
    ...

=head1 DESCRIPTION


=head1 AUTHOR

Philippe Bruhat (BooK), C<< <book at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-papery at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Papery>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Papery


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Papery>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Papery>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Papery>

=item * Search CPAN

L<http://search.cpan.org/dist/Papery>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT


Copyright 2010 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

