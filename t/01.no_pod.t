use strict;
use warnings;

BEGIN {
    use Test::Most tests => 1;
    use Test::Synopsis::More;
}

plural_synopsis_ok('t/lib/NotContainPod.pm');
