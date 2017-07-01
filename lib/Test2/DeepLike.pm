package Test2::DeepLike;
use strict;
use warnings;

our $VERSION = "0.01";

use Carp qw/croak confess/;
use Importer;
use Scalar::Util;

use Test2::API qw/context release/;
use Test2::Compare qw/build get_build/;
use Test2::Compare::Array();
use Test2::Compare::Bag();
use Test2::Compare::Hash();
use Test2::Compare::Object();
use Test2::Compare::Pattern();
use Test2::Compare::Wildcard();
use Test2::Tools::Compare();
use Test2::Util::Ref qw/render_ref/;

use Test2::DeepLike::Compare::Isa();
use Test2::DeepLike::Compare::Set();

%Carp::Internal = (
    %Carp::Internal,
    'Test2::DeepLike::Compare::Isa' => 1,
);

our @EXPORT = qw/
    cmp_deeply
    cmp_bag
    cmp_set
    cmp_methods
    eq_deeply
    cmp_details
    ignore
    methods
    re
    all
    any
    Isa
    isa
    array_each
    hash_each
    str
    num
    bool
    set
    supersetof
    subsetof
    noneof
    bag
    superbagof
    superhashof
/;

sub import {
    my $class = shift;

    my $caller = caller;

    no warnings 'redefine';
    _reset_prototype($caller, qw/set bag/);

    Importer->import_into($class, $caller, @_);
}

sub _reset_prototype {
    my ($caller, @names) = @_;
    Scalar::Util::set_prototype(\&{"$caller\::$_"}, undef) for @names;
}

*cmp_deeply = *Test2::Tools::Compare::is;

sub cmp_bag {
    my $ctx = context();
    return release $ctx, Test2::Tools::Compare::is(shift, bag(@{shift()}), shift);
}

sub cmp_set {
    my $ctx = context();
    return release $ctx, Test2::Tools::Compare::is(shift, set(@{shift()}), shift);
}

sub cmp_methods {
    my $ctx = context();
    return release $ctx, Test2::Tools::Compare::is(shift, methods(@{shift()}), shift);
}

sub eq_deeply {
    my ($d1, $d2) = @_;

    my ($ok) = cmp_details($d1, $d2);

    return $ok
}

sub cmp_details {
    my ($got, $exp, $name, @diag) = @_;
    my $ctx = context();

    my $delta = compare($got, $exp, \&strict_convert);

    return (!$delta, undef);
}

*ignore = *Test2::Tools::Compare::E;

sub methods {
    my (%methods) = @_;
    return build('Test2::Compare::Object', sub {
        my $build = get_build();
        for my $method (sort keys %methods) {
            $build->add_call(
                $method,
                Test2::Compare::Wildcard->new(expect => $methods{$method}),
                undef,
                'scalar',
            );
        }
    });
}

sub listmethods { ... }

sub shallow { ... }

sub noclass { ... }

sub useclass { ... }

sub re($) {
    my @caller = caller;
    return Test2::Compare::Pattern->new(
        file    => $caller[1],
        lines   => [$caller[2]],
        pattern => $_[0],
    );
}

*all = *Test2::Tools::Compare::check_set;
*any = *Test2::Tools::Compare::in_set;

sub Isa($) {
    my @caller = caller;
    return Test2::DeepLike::Compare::Isa->new(
        file  => $caller[1],
        lines => [$caller[2]],
        input => $_[0],
    );
}

*isa = *Isa;

sub obj_isa { ... }

sub array_each {
    my ($each) = @_;
    return build('Test2::Compare::Array', sub {
        my $build = get_build();
        $build->add_for_each($each);
        $build->set_ending(0);
    });
}

sub hash_each {
    my ($each) = @_;
    return build('Test2::Compare::Hash', sub {
        my $build = get_build();
        $build->add_for_each_val($each);
        $build->set_ending(0);
    });
}

*str = *Test2::Tools::Compare::string;
*num = *Test2::Tools::Compare::number;
*bool = *Test2::Tools::Compare::bool;

sub code { ... }

sub set {
    my (@set) = @_;
    return build('Test2::DeepLike::Compare::Set', sub {
        my $build = get_build();
        for my $set (@set) {
            $build->add_item(
                Test2::Compare::Wildcard->new(expect => $set)
            );
        }
        $build->set_relaxed(0);
    });
}

sub supersetof {
    my (@set) = @_;
    return build('Test2::DeepLike::Compare::Set', sub {
        my $build = get_build();
        for my $set (@set) {
            $build->add_item(
                Test2::Compare::Wildcard->new(expect => $set)
            );
        }
        $build->set_relaxed(1);
    });
}

sub subsetof { ... }

*noneof = *Test2::Tools::Compare::not_in_set;

sub bag {
    my (@bag) = @_;
    return build('Test2::Compare::Bag', sub {
        my $build = get_build();
        for my $bag (@bag) {
            $build->add_item(
                Test2::Compare::Wildcard->new(expect => $bag)
            );
        }
        $build->set_ending(1);
    });
}

sub superbagof {
    my (@bag) = @_;
    return build('Test2::Compare::Bag', sub {
        my $build = get_build();
        for my $bag (@bag) {
            $build->add_item(
                Test2::Compare::Wildcard->new(expect => $bag)
            );
        }
        $build->set_ending(0);
    });
}

sub subbagof { ... }

sub superhashof {
    my ($hash) = @_;
    return build('Test2::Compare::Hash', sub {
        my $build = get_build();
        for my $key (sort keys %$hash) {
            $build->add_field(
                $key,
                Test2::Compare::Wildcard->new(expect => $hash->{$key}),
            );
        }
        $build->set_ending(0);
    });
}

sub subhashof { ... }

sub deep_diag { ... }

package Test2::Compare::Base;

use overload '&'      => \&_make_all,
             '|'      => \&_make_any,
             fallback => 1;

sub _make_all {
    my ($e1, $e2) = @_;

    if ($e1->isa('Test2::Compare::Base') && $e2->isa('Test2::Compare::Base')) {
        return Test2::DeepLike::all($e1, $e2);
    } else {
        return $e1 && $e2;
    }
}

sub _make_any {
    my ($e1, $e2) = @_;
    if ($e1->isa('Test2::Compare::Base') && $e2->isa('Test2::Compare::Base')) {
        return Test2::DeepLike::any($e1, $e2);
    } else {
        return $e1 || $e2;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Test2::DeepLike - Test::Deep like interface for Test2

=head1 SYNOPSIS

    use Test2::V0;
    use Test2::DeepLike;

    {
        package Foo;
        sub new { bless {}, shift }
        sub foo { 'FOO' }
    }

    is $foo, isa('Foo') & methods(foo => 'FOO');

=head1 DESCRIPTION

Test2::DeepLike is ...

=head1 SUPPORTED FUNCTIONS

=over 4

=item cmp_deeply

=item cmp_bag

=item cmp_set

=item cmp_methods

=item eq_deeply

=item cmp_details

=item ignore

=item methods

=item re

=item all

=item any

=item Isa

=item isa

=item array_each

=item hash_each

=item str

=item num

=item bool

=item set

=item supersetof

=item subsetof

=item noneof

=item bag

=item superbagof

=item superhashof

=back

=head1 LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym@gmail.comE<gt>

=cut

