use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Synopsis::More',
    license             => 'artistic2',
    dist_author         => 'moznion <moznion@gmail.com>',
    dist_version_from   => 'lib/Test/Synopsis/More.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Test-Synopsis-More-*' ],
);

$builder->create_build_script();
