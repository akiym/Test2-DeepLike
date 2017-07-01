use Test2::V0;
use Test2::DeepLike;

is({key1 => "a", key2 => "c"}, superhashof({key1 => "a"}));

done_testing;
