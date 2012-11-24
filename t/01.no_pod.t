use strict;
use warnings;

BEGIN {
    use Test::Most tests => 1;
    use Test::Synopsis::More;
}

dies_ok { plural_synopsis_ok('t/lib/NotContainPod.pm') };
