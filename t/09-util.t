use strict;
use warnings;
use Test::More;

use Papery::Util qw( merge_meta );

my @tests = (
    [ 'empty empty empty', {}, {}, {} ],
    [ 'add to empty', {}, { zlonk => 'bam' }, { zlonk => 'bam' } ],
    [ 'add empty', { zlonk => 'bam' }, {}, { zlonk => 'bam' } ],
    [   'append string',
        { zlonk    => 'bam' },
        { 'zlonk+' => ' kapow' },
        { zlonk    => 'bam kapow' }
    ],
    [   'append string to naught',
        { },
        { 'zlonk+' => 'kapow' },
        { zlonk    => 'kapow' }
    ],
    [   'prepend string',
        { zlonk    => 'bam' },
        { 'zlonk-' => 'kapow ' },
        { zlonk    => 'kapow bam' }
    ],
    [   '',
        {   zlonk => { bam => 'kapow', awk => 'zzzzzwap' },
            aie   => 'clunk_eth'
        },
        { 'zlonk+' => { bam => 'vronk', 'awk+' => ' urkkk' } },
        {   zlonk => { bam => 'vronk', 'awk' => 'zzzzzwap urkkk' },
            aie   => 'clunk_eth'
        },
    ],
);

plan tests => 3 * @tests;

for my $t (@tests) {
    my ( $desc, $meta, $extra, $expected ) = @$t;
    my @refs = ( "$meta", "$extra" );
    is_deeply( merge_meta( $meta, $extra ),
        $expected, "Merged meta ($desc)" );
    is( $refs[0], "$meta", "... in the same hash reference" );
    is( $refs[1], "$extra", "... without modifying the extra hash" );
}

