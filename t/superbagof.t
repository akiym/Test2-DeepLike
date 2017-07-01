use Test2::V0;
use Test2::DeepLike;

is(['a', 'b', 'c', 'a', 'a', 'b'], superbagof('b', 'a', 'b'));
isnt(['a', 'b', 'c', 'a'], superbagof('d', 'b', 'd', 'b'));

done_testing;
