use strict;
use warnings;
use Module::Build;

my $auto_build;
if ( @ARGV && $ARGV[0] eq 'auto_build' )
{
    shift @ARGV;
    $auto_build = 1;
}

my $builder = Module::Build->new(
                                  module_name       => 'constant::our',
                                  license           => 'perl',
                                  dist_author       => 'Green <Evdokimov.Denis@gmail.com>',
                                  dist_version_from => 'lib/constant/our.pm',
                                  build_requires    => {
                                                      'Test::More' => 0,
                                                      'constant'   => 0,
                                                      'Exporter'   => 0,
                                  },
                                  add_to_cleanup     => ['constant::our-*'],
                                  create_makefile_pl => 'traditional',
);

if ( !$auto_build )
{
    $builder->create_build_script();
}
else
{
    $builder->dispatch('distmeta');
    $builder->dispatch('manifest');
    $builder->dispatch('test');
    $builder->dispatch('dist');
    $builder->dispatch('realclean');
    unlink qw(Makefile.PL MANIFEST MANIFEST.bak MANIFEST.SKIP.bak META.json META.yml);
}
