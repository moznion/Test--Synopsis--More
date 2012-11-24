use strict;
use warnings;

BEGIN {
    use Test::More tests => 1;
    use Test::Synopsis::More;
}

plural_synopsis_ok ('t/lib/ContainOption.pm');
