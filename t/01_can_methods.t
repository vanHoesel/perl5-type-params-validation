use Test::Most;

use Type::Params::Validation qw/compile_named/;

subtest 'can compile_named' => sub {
    
    can_ok( 'Type::Params::Validation' => 'compile_named' );
    
    can_ok( __PACKAGE__, 'compile_named' );
    
};

done_testing();
