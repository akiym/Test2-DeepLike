use Test2::V0;
use Test2::DeepLike;

is(['a', 'b', 'c', 'a'], supersetof('b', 'a', 'b'));
isnt(['a', 'b', 'c', 'a'], supersetof('d', 'b', 'd'));

done_testing;
