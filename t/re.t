use Test2::V0;
use Test2::DeepLike;

is("fergal", re(qr/ferg/));
isnt("feargal", re(qr/ferg/));
is("fergal", re('ferg'));
isnt("feargal", re('ferg'));

done_testing;
