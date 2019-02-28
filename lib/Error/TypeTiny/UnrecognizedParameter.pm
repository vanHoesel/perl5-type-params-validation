package Error::TypeTiny::UnrecognizedParameter;

require Error::TypeTiny;
our @ISA = 'Error::TypeTiny';

sub named_param{ $_[0]->{named_param} }

sub _build_message{
    my $e = shift;
    return "Unrecognized parameter: " . $e->named_param()
}

1;
