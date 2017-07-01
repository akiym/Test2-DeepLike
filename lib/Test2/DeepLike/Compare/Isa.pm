package Test2::DeepLike::Compare::Isa;
use strict;
use warnings;

use base 'Test2::Compare::Base';

use Test2::Util::HashBase qw/input/;

use Scalar::Util qw/blessed/;
use Carp qw/croak/;

sub init {
    my $self = shift;

    croak "'input' is a required attribute"
        unless $self->{+INPUT};

    $self->SUPER::init();
}

sub operator { 'ISA' }

sub name { $_[0]->{+INPUT} }

sub verify {
    my $self = shift;
    my %params = @_;
    my ($got, $exists) = @params{qw/got exists/};

    return 0 unless $exists;

    my $item = $self->{+INPUT};

    return blessed($got) ? $got->isa($item) : ref($got) eq $item;
}

1;

