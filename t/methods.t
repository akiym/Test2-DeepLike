use Test2::Bundle::Extended;
use Test2::DeepLike;

{
    package Foo;

    sub new { bless {}, shift }

    sub foo { 'foo' }
    sub bar { 'bar' }
}

subtest 'compare' => sub {
    my $obj = bless {}, 'Foo';

    like(intercept { is($obj, methods(foo => 'foo', bar => 'bar')) }, array {
        event Ok => {
            pass => 1,
        };
    });

    like(intercept { is($obj, methods(foo => undef)) }, array {
        event Ok => {
            pass => 0,
        };
    });
};

done_testing;
