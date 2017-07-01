use Test2::V0;
use Test2::DeepLike;

is([], bag());
is(['a', 'b', 'b', ['c', 'd']], bag('b', 'a', ['c', 'd'], 'b'));
isnt(['a', [], 'b', 'b'], bag());
isnt([], bag('a', [], 'a', 'b'));
isnt(['a', 'a', 'b', [\"c"], "d", []], bag({}, 'a', [\"c"], 'd', 'd', "e"));
isnt("a", bag());
is(['a', ['a', 'b', 'b'], ['c', 'd', 'c'], ['a', 'b', 'a']],
    bag(bag('c', 'c', 'd'), bag('a', 'b', 'a'), bag('a', 'b', 'b'), 'a')
);
isnt(['a', ['a', 'b', 'b'], ['c', 'd', 'c'], ['a', 'b', 'a']],
    bag(bag('c', 'd', 'd'), bag('a', 'b', 'a'), bag('a', 'b', 'b'), 'a')
);

done_testing;
