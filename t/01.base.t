use strict;
use warnings;
use Test::Base;

BEGIN {
    eval q[use t::TestPages];
    plan skip_all => "t::TestPages required for testing base: $@" if $@;
};
plan tests => 2*blocks;

run {
    my $block = shift;

    no warnings 'once';
    local *t::TestPages::dispatch_foo = sub {
        my $self = shift;
        eval $block->input;
        die $@ if $@;
    };

    my $page = t::TestPages->new;
    $page->dispatch('foo');
    like($page->output, qr{Content-Type: jpeg}, 'image output');
    like($page->output, qr{JFIF}, 'image');
};

__END__

=== simple
--- input
$self->show_captcha;
