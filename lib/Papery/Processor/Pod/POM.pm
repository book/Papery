package Papery::Processor::Pod::POM;

use strict;
use warnings;

use Papery::Processor;
our @ISA = qw( Papery::Processor );

use Pod::POM;

sub process {
    my ( $self, $pulp ) = @_;

    # parse the pod
    my $parser = Pod::POM->new( meta => 1 );
    my $pom = $parser->parse_text( $pulp->{meta}{_text} )
        or die $parser->error();

    # process the pod
    my $class = $pulp->{meta}{pod_pom_view} || 'Pod::POM::View::HTML';
    eval "use $class; 1;" or die $@;
    my $view = $class->new();
    my $content = $view->print($pom);

    # post-process the output of HTML views
    if ( $view->isa( 'Pod::POM::View::HTML' ) ) {
        $content =~ s{</?(?:body|html)[^>]*>}{}g;
    }

    # merge the metadata and content
    $pulp->merge_meta( $pom->metadata );
    $pulp->{meta}{_content} = $content;

    return $pulp;
}

1;

