use Test2::V0;
use Test2::DeepLike;

is(['a', 'a', 'b', 'c', 'b'], noneof('d', 'e', 'f'));
is(['a', 'a', 'b', 'c', 'b'], noneof('b', 'c', 'd', 'e'));

done_testing;
