# NAME

Test2::DeepLike - Test::Deep like interface for Test2

# SYNOPSIS

    use Test2::V0;
    use Test2::DeepLike;

    {
        package Foo;
        sub new { bless {}, shift }
        sub foo { 'FOO' }
    }

    is $foo, isa('Foo') & methods(foo => 'FOO');

# DESCRIPTION

Test2::DeepLike is ...

# SUPPORTED FUNCTIONS

- cmp\_deeply
- cmp\_bag
- cmp\_set
- cmp\_methods
- eq\_deeply
- cmp\_details
- ignore
- methods
- re
- all
- any
- Isa
- isa
- array\_each
- hash\_each
- str
- num
- bool
- set
- supersetof
- subsetof
- noneof
- bag
- superbagof
- superhashof

# LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takumi Akiyama <t.akiym@gmail.com>
