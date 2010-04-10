package Papery::Renderer::Template;

use strict;
use warnings;

use Papery::Renderer;
our @ISA = qw( Papery::Renderer );

use Template;

sub render {
    my ( $class, $pulp, @args ) = @_;
    my $template
        = Template->new( @args, INCLUDE_PATH => $pulp->{meta}{_templates} )
        or die Template->error();

    die "No _layout for $pulp->{meta}{__source_file}"
        if !$pulp->{meta}{_layout};

    local $Template::Stash::PRIVATE;    # we want to see "private" vars
    $template->process( $pulp->{meta}{_layout},
        $pulp->{meta}, \( $pulp->{meta}{_output} = '' ) )
        or die $template->error;

    return $pulp;
}

1;

