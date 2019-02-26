package Error::TypeTiny::Validation;

require Error::TypeTiny;
our @ISA = 'Error::TypeTiny';

sub errors { $_[0]{errors} }

1;
