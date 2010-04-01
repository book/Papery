use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Papery',
    license             => 'perl',
    dist_author         => 'Philippe Bruhat (BooK) <book@cpan.org>',
    dist_version_from   => 'lib/Papery.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Papery-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
