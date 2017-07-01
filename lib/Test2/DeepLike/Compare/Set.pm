package Test2::DeepLike::Compare::Set;
use strict;
use warnings;

# This code taken from Test2::Compare::Bag almost

use base 'Test2::Compare::Base';

use Test2::Util::HashBase qw/items relaxed/;

use Carp qw/croak confess/;
use Scalar::Util qw/reftype/;

sub init {
    my $self = shift;

    $self->{+ITEMS} ||= [];

    $self->SUPER::init();
}

sub name { '<SET>' }

sub verify {
    my $self = shift;
    my %params = @_;

    return 0 unless $params{exists};
    my $got = $params{got} || return 0;
    return 0 unless ref($got);
    return 0 unless reftype($got) eq 'ARRAY';
    return 1;
}

sub add_item {
    my $self = shift;
    my $check = pop;
    my ($idx) = @_;

    push @{$self->{+ITEMS}}, $check;
}

sub deltas {
    my $self = shift;
    my %params = @_;
    my ($got, $convert, $seen) = @params{qw/got convert seen/};

    my @deltas;
    my $state = 0;
    my @items = @{$self->{+ITEMS}};

    # Make a copy that we can munge as needed.
    my @list = @$got;
    my %unmatched = map { $_ => $list[$_] } 0..$#list;

    while (@items) {
        my $item = shift @items;

        my $check = $convert->($item);

        my $match = 0;
        for my $idx (0..$#list) {
            my $val = $list[$idx];
            my $deltas = $check->run(
                id      => [ARRAY => $idx],
                convert => $convert,
                seen    => $seen,
                exists  => 1,
                got     => $val,
            );

            unless ($deltas) {
                $match++;
                delete $unmatched{$idx};
                # Test2::DeepLike: don't skip here, check all items to match
            }
        }
        unless ($match) {
            push @deltas => $self->delta_class->new(
                dne      => 'got',
                verified => undef,
                id       => [ARRAY => '*'],
                got      => undef,
                check    => $check,
            );
        }
    }

    # if elements are left over, and relaxed is false, we have a problem!
    if (!$self->{+RELAXED} && keys %unmatched) {
        for my $idx (sort keys %unmatched) {
            my $elem = $list[$idx];
            push @deltas => $self->delta_class->new(
                dne      => 'check',
                verified => undef,
                id       => [ARRAY => $idx],
                got      => $elem,
                check    => undef,
            );
        }
    }

    return @deltas;
}

1;
