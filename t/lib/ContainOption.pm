package Test::Synopsis::More::__ContainPod;

use strict;
use warnings;

use version; $VERSION = qw/0.0.1/;

1;

__END__

=head1 NAME

ContainPod - for test


=head1 VERSION

This document describes Test::Synopsis::More::__ContainPod


=head1 SYNOPSIS

    use strict;
    use warnings;

=for test_synopsis_more option begin
my $x;
=for test_synopsis_more option end
=for test_synopsis_more option begin
my $y;
=for test_synopsis_more option end

    $x = 'FOO';
    $y = 'BAR';


=head1 DESCRIPTION

Foo Bar.
