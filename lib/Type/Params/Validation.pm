package Type::Params::Validation;

use strict;
use warnings;

use Type::Params ();

use Exporter 'import';
our @EXPORT_OK = qw/&compile_named/;

sub compile_named {
    my @checks = @_;
    my $check = Type::Params::compile_named(@checks);
    
    return sub {
        return $check->(@_)
    }
    
}

1;
