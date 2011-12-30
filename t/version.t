#!perl -T

use strict;
use warnings;

use Test::More tests => 6;

use constant::our();

my $RegExp_match_version = qr/\b(\d+\.\d+)\b/;
my $real_version         = $constant::our::VERSION;
my ($root_dir) = $INC{'constant/our.pm'} =~ m!^(.*)/lib/constant/our.pm$!;
$root_dir =~ s!/blib$!!;
pod_version();
changes_version();
meta_yml_version();
meta_json_version();
################################################################################
sub pod_version
{
    my $text = read_file('lib/constant/our.pm');
    my ($version) = $text =~ /=head1 VERSION\n\nVersion $RegExp_match_version\n=cut/;
    is( $version, $real_version );
}
################################################################################
sub changes_version
{
    my $text = read_file("Changes");
    my ($version) = $text =~ /^$RegExp_match_version \d{4}-\d{2}-\d{2}$/m;
    is( $version, $real_version );
}
################################################################################
sub meta_yml_version
{
    my $text = read_file("META.yml");
    while ( $text =~ /file: (.*)\n\s*version: $RegExp_match_version/g )
    {
        is( $2, $real_version, "META.yml file: $1" );
    }
    my ($version) = $text =~ /^version: $RegExp_match_version$/m;
    is( $version, $real_version );
}
################################################################################
sub meta_json_version
{
    my $text = read_file("META.json");
    while ( $text =~ /"file" : "(.*)",\n\s*"version" : "$RegExp_match_version"/g )
    {
        is( $2, $real_version, "META.json file: $1" );
    }
    my $version;
    foreach ( $text =~ /"version" : "$RegExp_match_version"/g )
    {
        $version = $_;
    }
    is( $version, $real_version );
}
################################################################################
sub read_file
{
    my $file = $root_dir . '/' . shift;
    open( my $FILE, '<', $file ) or die "Can't open file[$file]: $!";
    local $/;
    return scalar <$FILE>;
}
################################################################################
