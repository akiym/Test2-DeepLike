use Test2::V0;
use Test2::DeepLike;

cmp_bag([1, 2, 2], [2, 1, 2]);
like intercept { cmp_bag([1, 2, 2], [1, 2, 1, 2]) }, array {
    fail_events Ok => {
        pass => 0,
    };
};

done_testing;
