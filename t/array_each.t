use Test2::V0;
use Test2::DeepLike;

my $re = qr/^wi/;
is([qw( wine wind wibble winny window )], array_each( re($re) ));
isnt([qw( wibble wobble winny window )], array_each( re($re) ));

done_testing;
