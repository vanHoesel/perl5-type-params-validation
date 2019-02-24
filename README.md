# Type::Params::Validation

## Type::Params Validation for all named params

- Because Type::Params is cool and has a simple syntax.
- Because Type::Tiny is a cool type-system.
- Because Type::Params does not tell what else might have gone wrong

## SYNOPSIS

```perl
use v5.10;
use strict;
use warnings;
 
use Type::Params::Validatoin qw( compile_named );
use Types::Standard qw( slurpy Str ArrayRef Num );
   
sub deposit_monies
{
   state $check = compile_named(
      sort_code      => Str,
      account_number => Str,
      monies         => ArrayRef[Num],
   );
   my $args = $check->(@_);
    
   my $account = Local::BankAccount->new($args->{sort_code}, $args->{account_number});
   $account->deposit($_) for @{$args->{monies}};
}
 
deposit_monies(
   sort_code      => "12-34-56",
   account_number => "11223344",
   monies         => [ 1.2, 3, 99.99 ],
);
```
