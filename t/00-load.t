#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Papery' );
}

diag( "Testing Papery $Papery::VERSION, Perl $], $^X" );
