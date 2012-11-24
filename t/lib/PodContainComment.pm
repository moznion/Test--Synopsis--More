package Test::Synopsis::More::__PodContainComment;
use strict;
use warnings;

use version; $VERSION = qw/0.0.1/;

1;

__END__

=head1 NAME

PodContainComment - for test


=head1 VERSION

This document describes Test::Synopsis::More::__PodContainComment


=head1 SYNOPSIS

    use strict;
    use warnings;

    print "Hello, test!";

=for test_synopsis_more comment begin

THIS IS COMMENT FOR TEST

=for test_synopsis_more comment end


=head1 DESCRIPTION

Foo Bar.
