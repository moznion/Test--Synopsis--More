package Test::Synopsis::More;

use warnings;
use strict;
use Carp;
use Exporter;

use Test::Synopsis;
use ExtUtils::Manifest qw/maniread/;

use vars qw/$VERSION @ISA @EXPORT/;

BEGIN {
    $VERSION = '0.01';
    @ISA     = qw/Exporter Test::Synopsis/;
    @EXPORT  = qw/plural_all_synopsis_ok/;    # TODO implement
}

sub plural_all_synopsis_ok {    # TODO Should discuss about function name
    my $manifest = maniread();
    my @files = grep m!^lib/.*\.p(od|m)$!, keys %$manifest;
    # TODO should I specify the number of tests?
    plural_synopsis_ok(@files);
}

sub plural_synopsis_ok {        # TODO Should discuss about function name
    my @modules = @_;

    for my $module (@modules) {
        my ( $synopsis_codes, $lines, @options_each_synopsis, @global_option ) = extract_synopsis($module);
        unless ($synopsis_codes) {
            __PACKAGE__->builder->ok( 1, "No SYNOPSIS code" );
            next;
        }

        my $index = 0;
        foreach my $synopsis (@$synopsis_codes) {
            my $global_option = join( ";", @global_option );
            my $option = ";";
            if (defined ($options_each_synopsis[0][$index])) {
                $option = join(";", @{$options_each_synopsis[0][$index]});
            }
            my $test   = qq(#line $lines->[$index] "$module"\n$global_option; \n$option; sub { $synopsis });
            my $ok     = _compile($test);
            __PACKAGE__->builder->ok( $ok, $module );
            __PACKAGE__->builder->diag($@) unless $ok;
            $index++;
        }
    }
}

sub _compile {
    package Test::Synopsis::Sandbox;
    eval $_[0];    ## no critic
}

sub extract_synopsis {
    my $file = shift;

    my $content = do {
        local $/;
        open my $fh, "<", $file or die "$file: $!";
        <$fh>;
    };

    my $synopsis = ( $content =~ m/^=head1\s+SYNOPSIS(.+?)^=head1/ms )[0];

    # Remove comments in SYNOPSIS section
    $synopsis =~ s/^=for\s+test_synopsis_more\s+comment\s+begin(.+?)^=for\s+test_synopsis_more\s+comment\s+end//msg;

    my $line = ( $` || '' ) =~ tr/\n/\n/;
    my @lines;
    my @synopsis_codes;
    my @options_each_synopsis;

    my $line_locally = 1;
    while (1) {
        push @lines, ( $line + $line_locally );
        if ( my($this_synopsis, $next_synopsis) = $synopsis =~ m/(.+?)^=for\s+test_synopsis_more\s+divide(.+)/ms ) {
            push @options_each_synopsis, _extract_individual_synopsis_options(\$this_synopsis);
            push @synopsis_codes, $this_synopsis;
            $synopsis = $next_synopsis;
            $line_locally += ( $this_synopsis =~ tr/\n/\n/ );
        }
        else {
            push @options_each_synopsis, _extract_individual_synopsis_options(\$synopsis);
            push @synopsis_codes, $synopsis;
            last;
        }
    }

    return \@synopsis_codes, \@lines, \@options_each_synopsis, ($content =~ m/^=for\s+test_synopsis\s+(.+?)^=/msg);
    #       |_synopsis        |_line of occuring error             |_global options
}

sub _extract_individual_synopsis_options {
    my $code = shift;

    my $locally_options;
    while ($$code =~ m/^=for\s+test_synopsis_more\s+option\s+begin(.+?)^=for\s+test_synopsis_more\s+option\s+end/msg) {
        push @$locally_options, $1;
        $$code =~ s/^=for\s+test_synopsis_more\s+option\s+begin(.+?)^=for\s+test_synopsis_more\s+option\s+end//ms; # FIXME Is this redundant?
    }

    return $locally_options;
}

1;
__END__

=head1 NAME

Test::Synopsis::More - [One line description of module's purpose here]


=head1 VERSION

This document describes Test::Synopsis::More version 0.01


=head1 SYNOPSIS

    use Test::Synopsis::More;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

Test::Synopsis::More requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-test-synopsis-more@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

moznion  C<< <moznion@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, moznion C<< <moznion@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
