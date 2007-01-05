package t::TestPages;
use strict;
use warnings;
use Data::Dumper;

BEGIN {
    eval qq{
        use base qw(Sledge::TestPages);
        use Sledge::Plugin::ShowImage;
        use Sledge::Plugin::Captcha;
    };
    die $@ if $@;
}

my $x;
$x = $t::TestPages::TMPL_PATH = 't/';
$x = $t::TestPages::COOKIE_NAME = 'sid';
$ENV{HTTP_COOKIE}    = "sid=SIDSIDSIDSID";
$ENV{REQUEST_METHOD} = 'GET';
$ENV{QUERY_STRING}   = 'foo=bar';

package Sledge::TestConfig;
sub template_options {}
sub captcha {
    return {
        'new' => {
            width => 180,
            height => 30,
            lines => 5,
            gd_fong => 'giant',
        },
        create => ['normal', 'ec'],
        particle => [100],
        session_name => 'captcha_string',
        out => {force => 'jpeg'},
    };
}

1;
