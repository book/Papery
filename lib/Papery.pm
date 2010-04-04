package Papery;

use warnings;
use strict;
use Carp;

our $VERSION = '0.01';

use Papery::Util qw( merge_meta );

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
    my $config = LoadFile( File::Spec->catfile( $source, '_config.yml' ) );

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

