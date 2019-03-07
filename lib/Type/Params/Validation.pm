package Type::Params::Validation;

=head1 NAME

Type::Params::Validation - Type::Params-like validation reporting all errors

=head1 DESCRIPTION

This module will give the L<Type::Params> nice features to validate the
paramters passed into a subroutine, but on top if that will throw a
C<Error::TypeTine::Validation> exception that will report all C<errors>.

There are several ways to check the parameters passed into your subroutines. And
there are several very useful modules already available.

L<Type::Params> is desigend to be used with L<Type::Tiny> and has a very clean
and short syntax. But it's key-feautre of being fast means it also bails out
on the first validation error.

Other modules - that can report on every failure in the passed paramtersdo - do
have verbose syntax and or offer complicated conditionals.

=cut

use strict;
use warnings;

use Type::Params ();

use Exporter 'import';
our @EXPORT_OK = qw/&compile_named/;

use Try::Tiny;

sub compile_named {
    my @checks = @_;
    my $check = Type::Params::compile_named(@checks);
    
    return sub {
        my @params = @_;
        
        my $args = try {
            $check->(@params);
        };
        return $args if defined $args;
        
        my %params =
            scalar @params == 1 && ref($params[0]) eq "HASH" ?
                %{ $params[0] }
            :
                @params
        ; # original params
        my %checks = _split_compile(@checks);
        
        my %errors;
        foreach my $check_param ( keys %checks ) {
            
            my $check_value = $params{$check_param};
            my $check_check = $checks{$check_param};
            
            try {
                my $value = $check_check->(
                    exists( $params{$check_param} ) ?
                    ( $check_param => $check_value ) : ()
                );
                # seems to be all fine
            } catch {
                my $exception = $_;
                my $error;
                if ( $exception->message =~ /missing/i ) {
                    require Error::TypeTiny::MissingRequired;
                    $error = Error::TypeTiny::MissingRequired->new(
                        named_param => $check_param,
                    );
                } else {
                    $error = $exception;
                }
                $errors{$check_param} = $error;
            };
            
            delete $params{$check_param};
        }
        
        foreach my $check_param ( keys %params ) {
            require Error::TypeTiny::UnrecognizedParameter;
            my $error = Error::TypeTiny::UnrecognizedParameter->new(
                named_param => $check_param,
            );
            $errors{$check_param} = $error;
        }
        
        require Error::TypeTiny::Validation;
        Error::TypeTiny::Validation->throw(
            errors  => { %errors },
        );
    }
    
}

sub _split_compile {
    my @checks = @_;
    
    my %checks;
    while ( @checks ) {
        my $param = shift @checks;
        my $check = shift @checks;
        my $check_check = Type::Params::compile_named( $param => $check );
        $checks{$param} = $check_check;
    }
    
    return %checks
}

=head1 SEE ALSO

L<Type::Params>

=head1 AUTHOR

Theo van Hoesel E<lt>Th.J.v.Hoesel@gmail.comE<gt>.

=head1 CREDITS

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=over

=item for nurturing Type::Tiny and Type::Params

=back

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014, 2017-2019 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

=cut

1;
