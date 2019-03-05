use Test::Most;

BEGIN { use Type::Params::Validation qw/compile_named/ };

use Types::Standard qw/Str ArrayRef Num/;

subtest 'positives empty' => sub {
    my $check = compile_named();
    
    is( ref($check) , 'CODE',
        "Returns a 'CodeRef'"
    );
    
    my $args;
    lives_ok{
        $args = $check->()
    } "... and does run without problems";
    
    is( ref($args) , 'HASH',
        "... which returns a HASH ref"
    );
    
};

subtest 'positives simple' => sub {
    my $check = compile_named( sort_code => Str );
    
    is( ref($check) , 'CODE',
        "Returns a 'CodeRef'"
    );
    
    my $args;
    lives_ok{
        $args = $check->( sort_code => '12-34-56' )
    } "... and does run without problems";
    
    is( ref($args) , 'HASH',
        "... which returns a HASH ref"
    );
    
    is( $args->{sort_code}, '12-34-56',
        "... and returns the expected value"
    );
    
    $args = $check->( sort_code => '98-76-54' );
    is( $args->{sort_code}, '98-76-54',
        "... and returns another expected value"
    );
    
};

subtest 'negative simple' => sub {
    my $check = compile_named( monies => ArrayRef[Num] );
    
    is( ref($check) , 'CODE',
        "Returns a 'CodeRef'"
    );
    
    my $args;
    lives_ok{
        $args = $check->( monies => [12.34, 56,78] )
    } "... and does run without problems";
    
    cmp_deeply( $args =>
        {
            monies => [ 12.34, 56,78 ]
        },
        "... and has some numbers"
    );
    
    dies_ok{
        $args = $check->( monies => ["abc"] )
    } "... dies when passing bad values";
    
    isa_ok( $@, 'Error::TypeTiny' );
    
};

subtest 'error_typetiny_validation' => sub {
    my $check = compile_named( account_number => Num );
    
    my $args;
    dies_ok{
        $args = $check->( account_number => '123.456.789' )
    } "... dies when passing bad values";
    
    my $exception = $@;
    
    isa_ok( $exception, 'Error::TypeTiny::Validation' );
    
    like( $exception->message, qr/One or more exceptions have occurred/,
        "... And has a message about 'One or more exceptions'"
    );
    
    ok( $exception->errors,
        "... and has errors"
    );
    
    is( ref($exception->errors), 'HASH',
        "... which is an HASH reference"
    );
    
    my $errors = $exception->errors();
    
    cmp_deeply( $errors =>
        {
            account_number => isa('Error::TypeTiny'),
        },
        "... and has 'Error::TypeTiny' for parameter"
    );
    
    like( $errors->{account_number}->message, qr/123.456.789/,
        "... and has a useful message"
    );
    
    my $other = compile_named( sort_code => Num );
    throws_ok{
        $args = $other->( sort_code => '12-34-56' )
    } qr/One or more exceptions have occurred/,
    "Throws exception with correct stringification";
    
    $errors = $@->errors;
    cmp_deeply( $errors =>
        {
            sort_code => isa('Error::TypeTiny'),
        },
        "... and it is for another parameter"
    );
    
};

subtest 'multiple constraint errors' => sub {
    my $check = compile_named(
        sort_code      => Str,
        account_number => Num,
        monies         => ArrayRef[Num],
    );
    
    throws_ok{
        $check->(
            sort_code      => undef,
            account_number => 'abc',
            monies         => [1, 2]
        );
    } qr/One or more exceptions have occurred/,
    "Throws exception";
    
    my $errors = $@->errors;
    
    cmp_deeply( $errors =>
        {
            sort_code      => isa('Error::TypeTiny::Assertion'),
            account_number => isa('Error::TypeTiny::Assertion')
        },
        "... and contains multiple Error::TypeTiny exceptions"
    );
    
};

subtest 'missing required parameters' => sub {
    my $check = compile_named( sort_code => Str );
    
    throws_ok{
        $check->( );
    } qr/One or more exceptions have occurred/,
    "Throws exception";
    
    my $errors = $@->errors;
    
    cmp_deeply( $errors =>
        {
            sort_code      => isa('Error::TypeTiny::MissingRequired'),
        },
        "... and contains Error::TypeTiny::MissingRequired exception"
    );
    
    like( $errors->{sort_code}->message, qr/Missing .* sort_code/i,
        "... and has a nice 'missing' message"
    );
    
};

subtest 'unrecognized parameters' => sub {
    my $check = compile_named( );
    
    throws_ok{
        $check->( foo => 1 )
    } qr/One or more exceptions have occurred/,
    "Throws exception";
    
    my $errors = $@->errors;
    
    cmp_deeply( $errors =>
        {
            foo => isa('Error::TypeTiny::UnrecognizedParameter'),
        },
        "... and contains Error::TypeTiny::UnrecognizedParameter exception"
    );
    
};

subtest 'accept hashref as params to check' => sub {
    my $check = compile_named( foo => Num, bar => Num );
    
    cmp_deeply(
        $check->(  foo => 3, bar => 5  ) =>
        { foo => 3, bar => 5, },
        "Accepts params as a hash"
    );
    
    cmp_deeply(
        $check->( {foo => 3, bar => 5} ) =>
        { foo => 3, bar => 5, },
        "... and accepts params as a hashref too"
    );
    
    throws_ok{
        $check->( {foo => undef, baz => 5 } )
    } qr/One or more exceptions have occurred/,
    "Throws exception for a hashref that";
    
    my $errors = $@->errors;
    
    cmp_deeply( $errors =>
        {
            foo => isa('Error::TypeTiny::Assertion'),
            bar => isa('Error::TypeTiny::MissingRequired'),
            baz => isa('Error::TypeTiny::UnrecognizedParameter'),
        },
        "... and contains multiple exceptions"
    );
    # this would otherwise be an error, missing 'foo' and 'bar' and:
    # message       "Unrecognized parameter: HASH(0x7f9b3390a2c8)"
    
};

done_testing();
