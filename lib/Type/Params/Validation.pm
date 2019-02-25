package Type::Params::Validation;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw/&compile_named/;

sub compile_named { return sub { return +{ sort_code => '12-34-56' } } }

1;
