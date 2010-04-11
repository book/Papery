use strict;
use warnings;
use Test::More;
use File::Spec;
use Cwd;
use Papery::Pulp;
use Papery::Analyzer::Simple;

# test data
my @files = (
    [   'zlonk.txt',
        { _processors => {}, theme => 'batman', count => 3 },
        "zlott powie thwacke"
    ],
    [ 'bam.txt', { _processors => {} }, "thwapp eee_yow ker_sploosh", ],
    [ 'kapow.txt', { _processors => {}, theme => 'barbapapa', count => 0 } ],
);

# generate full filenames
my $dir = File::Spec->catdir( 't', 'site1' );
my $src = cwd;
@files = map { $_->[0] = File::Spec->catfile( $dir, $_->[0] ); $_ } @files;

plan tests => 2 * @files + 2;

# test failure
ok( !eval { Papery::Analyzer::Simple->analyze_file( {}, 'notthere' ); 1 },
    'Fail with non-existent file' );
like( $@, qr/^Can't open notthere: /, 'Expected error message' );

# test success
for my $test (@files) {
    my ( $File, $Meta, $Text ) = @$test;
    my $pulp = Papery::Pulp->new( { __source => $src } );
    Papery::Analyzer::Simple->analyze_file( $pulp, $File );

    # remove internal Papery variables
    delete $pulp->{meta}{$_} for grep {/^__/} keys %{ $pulp->{meta} };

    # testing one-liners to avoid \n issues
    chomp $pulp->{meta}{_text} if $pulp->{meta}{_text};
    is_deeply( delete $pulp->{meta}{_text}, $Text, "text $File" );
    is_deeply( $pulp->{meta},               $Meta, "meta $File" );
}

