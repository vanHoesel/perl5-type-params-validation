package Type::Params::Validation;

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
        
        try {
            return $check->(@params);
        } catch {
            my $error = $_;
            require Error::TypeTiny::Validation;
            Error::TypeTiny::Validation->throw(
                message => 'One or more exceptions have occurred',
                errors  => { 'account_number' => $error },
            );
        };
    }
    
}

1;
