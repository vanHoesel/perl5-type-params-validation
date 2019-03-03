package Error::TypeTiny::Validation;

require Error::TypeTiny;
our @ISA = 'Error::TypeTiny';

sub errors { $_[0]{errors} }

sub _build_message { 'One or more exceptions have occurred' }

1;
