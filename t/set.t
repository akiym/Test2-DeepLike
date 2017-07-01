use Test2::V0;
use Test2::DeepLike;

is([], set());
is(["a"], set("a", "a"));
is(['a', 'b', 'b', ['c', 'd']], set('b', 'a', ['c', 'd'], 'b'));
isnt(['a', [], 'b', 'b'], set());
isnt([], set('a', [], 'a', 'b'));
isnt(['a', 'a', 'b', [\"c"], "d", []], set({}, 'a', [\"c"], 'd', 'd', "e"));
isnt("a", set());
is(['a',['a', 'b', 'b'], ['c', 'd', 'c','d'], ['a', 'b', 'a']],
    set(set('c', 'd', 'd'), set('a', 'b', 'a'), set('c', 'c', 'd'), 'a')
);
isnt([['a', 'b', 'c'], ['c', 'd', 'c'], ['a', 'b', 'a']],
    set(set('c', 'd', 'c'), set('a', 'b', 'a'), set('b', 'b', 'a'))
);

my $a1 = \"a";
my $b1 = \"b";
my $a2 = \"a";
my $b2 = \"b";

is([[\'a', \'b']], set(set($a2, $b1), set($b2, $a1)));

done_testing;
