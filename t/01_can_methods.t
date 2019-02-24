use Test::Most;

use Type::Params::Validation;

subtest 'can compile_named' => sub {
    
    can_ok( 'Type::Params::Validation' => 'compile_named' );
};

done_testing();
