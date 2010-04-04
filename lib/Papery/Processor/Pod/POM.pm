package Papery::Processor::Pod::POM;

use strict;
use warnings;

use Papery::Processor;
our @ISA = qw( Papery::Processor );

use Pod::POM;

sub process {
    my ( $self, $pulp, $text ) = @_;

    # parse the pod
    my $parser = Pod::POM->new( meta => 1 );
    my $pom = $parser->parse_text($text) or die $parser->error();

    # process the pod
    my $class = $pulp->{meta}{pod_pom_view} || 'Pod::POM::View::HTML';
    eval "use $class" or die "Can't load $class";
    my $view = $class->new();
    my $content = $view->print($pom);

    # post-process the output of HTML views
    if ( $view->isa( 'Pod::POM::View::HTML' ) {
        $content =~ s/\A.*//;        # remove first line
        $content =~ s/^.*?\z//sm;    # remove last line
    }

    # merge the metadata and content
    $pulp->merge_meta( %{ $pom->metadata } );
    $pulp->{meta}{_content} = $content;

    return $pulp;
}

1;

