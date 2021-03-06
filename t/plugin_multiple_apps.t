# plugin_multiple_apps.t

use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Ref::Util qw<is_coderef>;

{
    package App;

    BEGIN {
        use Dancer2;
        set session => 'Simple';
    }

    use lib '.';
    use t::lib::SubApp1 with => { session => engine('session') };

    use t::lib::SubApp2 with => { session => engine('session') };
}

my $app = Dancer2->psgi_app;
ok( is_coderef($app), 'Got app' );

test_psgi $app, sub {
    my $cb = shift;

    is( $cb->( GET '/subapp1' )->content, 1, '/subapp1' );
    is( $cb->( GET '/subapp2' )->content, 2, '/subapp2' );
};

done_testing;
