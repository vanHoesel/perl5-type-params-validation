use Test::Most;

BEGIN { use Type::Params::Validation qw/compile_named/ };

use Types::Standard qw/Str/;

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
    
};

done_testing();
