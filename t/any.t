use Test2::V0;
use Test2::DeepLike;

subtest '|' => sub {
    my $compare = re('a+') | 'b';
    isa_ok $compare, 'Test2::Compare::Base';
};

subtest 'any' => sub {
    is("wine", any("beer", "wine"));
    isnt("whisky", any("beer", "wine"));
    isnt("whisky", any("beer") | "wine");
    is("whisky", re("isky") | "wine");
    isnt("whisky", re("iskya") | "wine");
};

done_testing;
