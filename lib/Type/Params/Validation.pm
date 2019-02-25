package Type::Params::Validation;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw/&compile_named/;

sub compile_named { return sub { return +{ } } }

1;
