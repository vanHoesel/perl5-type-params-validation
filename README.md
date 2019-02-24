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
 
use Type::Params qw( compile );
use Types::Standard qw( slurpy Str ArrayRef Num );
   
sub deposit_monies
{
   state $check = compile( Str, Str, slurpy ArrayRef[Num] );
   my ($sort_code, $account_number, $monies) = $check->(@_);
    
   my $account = Local::BankAccount->new($sort_code, $account_number);
   $account->deposit($_) for @$monies;
}
 
deposit_monies("12-34-56", "11223344", 1.2, 3, 99.99);
```
