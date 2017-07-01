use Test2::V0;
use Test2::DeepLike;

is {a => 'a', b => 'b'}, {a => 'a', b => ignore()};
is {a => 'a', b => undef}, {a => 'a', b => ignore()};
isnt {a => 'a'}, {a => 'a', b => ignore()};

done_testing;
