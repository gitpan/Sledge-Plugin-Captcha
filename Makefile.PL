use strict;
use warnings;
use inc::Module::Install;

name            'Sledge-Plugin-Captcha';
all_from        'lib/Sledge/Plugin/Captcha.pm';

requires 'Sledge::Plugin::ShowImage' => 0;
requires 'GD::SecurityImage' => 0;
requires 'Carp';

author_tests 'xt';
test_requires 'Test::More';
use_test_base;
auto_install;
WriteAll;

