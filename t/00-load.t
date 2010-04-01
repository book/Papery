use strict;
use warnings;
use Test::More;

my @modules = qw(
    Papery
    Papery::Analyzer
    Papery::Analyzer::Simple
);

plan tests => scalar @modules;

diag("Testing Papery, Perl $], $^X");

use_ok($_) for @modules;

