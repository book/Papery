use strict;
use warnings;
use Test::More;
use File::Spec;
use Papery::Analyzer::Simple;

# test data
my @files = (
    [ 'zlonk.txt', { theme => 'batman', count => 3 }, "zlott powie thwacke" ],
    [ 'bam.txt', {}, "thwapp eee_yow ker_sploosh", ],
    [ 'kapow.txt', { theme => 'barbapapa', count => 0 } ],
);

# generate full filenames
@files = map { $_->[0] = File::Spec->catfile( 't', 'site1', $_->[0] ); $_ }
    @files;

plan tests => 2 * @files + 2;

# test failure
ok( !eval { Papery::Analyzer::Simple->analyze_file('notthere'); 1 },
    'Fail with non-existent file' );
like( $@, qr/^Can't open notthere: /, 'Expected error message' );

# test success
for my $test (@files) {
    my ( $File, $Meta, @Text ) = @$test;
    my ( $meta, @text ) = Papery::Analyzer::Simple->analyze_file($File);

    # testing one-liners to avoid \n issues
    chomp @text;
    is_deeply( $meta,  $Meta,  "meta $File" );
    is_deeply( \@text, \@Text, "text $File" );
}

