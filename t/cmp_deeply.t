use Test2::V0;
use Test2::DeepLike;

cmp_deeply 1, 1;
cmp_deeply bless({}, 'Foo'), isa('Foo');

done_testing;
