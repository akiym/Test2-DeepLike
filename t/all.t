use Test2::V0;
use Test2::DeepLike;

subtest '&' => sub {
    my $compare = isa('Foo') & methods(foo => 'foo');
    isa_ok $compare, 'Test2::Compare::Base';
};

subtest 're' => sub {
    is(["wine"], all([re(qr/^wi/)], [re(qr/ne$/)], ["wine"]));
    isnt(["wine"], all( [re(qr/^wi/)], [re(qr/ne$/)], ["wines"]));
    is("wine", all(re("^wi")) & re('ne$'));
    isnt("wine", all(re("^wi")) & re('na$'));
    is("wine", re("^wi") & re('ne$'));
    isnt("wine", re("^wi") & re('na$'));
};

subtest 'isa & method' => sub {
    {
        package Foo;

        sub new { bless {}, shift }

        sub foo { 'foo' }
        sub bar { 'bar' }
    }

    my $obj = bless {}, 'Foo';
    is($obj, all(isa('Foo'), methods(foo => 'foo', bar => 'bar')));
    is($obj, isa('Foo') & methods(foo => 'foo', bar => 'bar'));
};

done_testing;
