use Test2::V0 -target => 'Test2::DeepLike::Compare::Isa';
use Test2::DeepLike;
use Test2::DeepLike::Compare::Isa;

subtest 'class' => sub {
    my $obj = bless {}, 'Foo';
    my $one = $CLASS->new(input => 'Foo');
    isa_ok($one, $CLASS, 'Test2::Compare::Base');

    is($one->name, 'Foo', "Got Name");
    is($one->operator, 'ISA', "got operator");

    ok($one->verify(exists => 1, got => $obj), "verified object");
    ok(!$one->verify(exists => 1, got => bless {}, 'Bar'), "different object");
    ok(!$one->verify(exists => 0, got => $obj), "value must exist");

    is(
        [ 'a', $obj ],
        [ 'a', $one ],
        "Did a object check"
    );

    ok(!$one->verify(exists => 1, got => 'a'), "not a object");

    $one->set_input('a');
    ok(!$one->verify(exists => 1, got => $obj), "input not a object");

    like(
        dies { $CLASS->new() },
        qr/'input' is a required attribute/,
        "Need input"
    );
};

subtest 'compare' => sub {
    my $obj = bless {}, 'Foo';

    like(intercept { is($obj, isa('Foo')) }, array {
        event Ok => {
            pass => 1,
        };
    });

    like(intercept { is($obj, isa('Bar')) }, array {
        event Ok => {
            pass => 0,
        };
    });

    like(intercept { is($obj, Isa('Foo')) }, array {
        event Ok => {
            pass => 1,
        };
    });

};

done_testing;
