use Test2::V0;
use Test2::DeepLike;

my $re = qr/^wi/;
is({ a => 'wine', b => 'wind', c => 'wibble'}, hash_each(re($re)));
isnt({ a => 'wine', b => 'wand', c => 'wibble'}, hash_each(re($re)));

done_testing;
