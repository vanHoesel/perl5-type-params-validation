use Test::Most;

BEGIN { use Type::Params::Validation qw/compile_named/ };

subtest 'positives empty' => sub {
    my $check = compile_named();
    
    is( ref($check) , 'CODE',
        "Returns a 'CodeRef'"
    );
};

done_testing();
