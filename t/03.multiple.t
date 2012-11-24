use strict;
use warnings;

BEGIN {
    use Test::More tests => 2;
    use Test::Synopsis::More;
}

plural_synopsis_ok('t/lib/MultiplePod.pm');
