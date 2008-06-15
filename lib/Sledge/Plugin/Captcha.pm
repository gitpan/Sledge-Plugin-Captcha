package Sledge::Plugin::Captcha;
use strict;
use warnings;
use Carp;
our $VERSION = '0.03';
use GD::SecurityImage;

sub import {
    my $pkg = caller(0);

    no strict 'refs'; ## no critic.
    *{"$pkg\::validate_captcha"} = sub {
        my ($self, $verify) = @_;

        my $string = $self->captcha_string;

        return $string && $verify && $string eq $verify;
    };

    *{"$pkg\::captcha_string"} = sub {
        my ($self, ) = @_;

        my $session_name = $self->create_config->captcha->{session_name} || '';
        return $self->session->param($session_name);
    };

    *{"$pkg\::clear_captcha_string"} = sub {
        my ($self, ) = @_;

        my $session_name = $self->create_config->captcha->{session_name} || '';
        $self->session->remove($session_name);
        return 1;
    };

    *{"$pkg\::show_captcha"} = sub {
        my ($self, ) = @_;

        my $captcha
            = GD::SecurityImage->new( %{ $self->create_config->captcha->{new} } );
        $captcha->random();
        $captcha->create( @{ $self->create_config->captcha->{create} } );
        $captcha->particle( @{ $self->create_config->captcha->{particle} } );

        my ( $image, $mime_type, $captcha_string )
            = $captcha->out( %{ $self->create_config->captcha->{out} } );
        $self->session->param( $self->create_config->captcha->{session_name} => $captcha_string );
        $self->show_image( $image => "image/$mime_type" );
    };
}

1;
__END__

=head1 NAME

Sledge::Plugin::Captcha - create and validate Captcha for Sledge.

=head1 SYNOPSIS

    package Your::Pages;
    use base qw/Sledge::Pages::Compat/;
    use Sledge::Plugin::ShowImage;
    use Sledge::Plugin::Captcha;

    sub dispatch_show_captcha {
        my ($self, ) = @_;

        $self->create_captcha;
    }

    sub valid_post {
        my ($self, ) = @_;

        unless ($self->validate_captcha($self->r->param('captcha'))) {
            $self->valid->set_error(CAPTCHA_ERROR => 'captcha');
        }
    }

    # config.yaml
    common:
      captcha:
        new:
          width:   180
          height:  30
          lines:   5
          gd_font: giant
        create:
          - normal
          - ec
        particle:
          - 100
        session_name: captcha_string
        out:
          force: jpeg


=head1 DESCRIPTION

This plugin create, validate Captcha.

Note: This plugin uses L<GD::SecurityImage>

=head1 METHODS

=head2 show_captcha

Create Captcha image and output it.

=head2 validate_captcha

  $c->validate_captcha($key);

validate key

=head2 captcha_string

Return a string for validation which is stored in session.

=head2 clear_captcha_string

Clear a string which is stored in session.

=head1 CONFIGURATION

=over 4

=item session_name

The keyword for storing captcha string

=item new

=item create

=item particle

=item out

These parameters are passed to each GD::Security's method. Please see L<GD::SecurityImage> for details.

=back

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 THANKS TO

Masahiro Nagano

=head1 SEE ALSO

L<Catalyst::Plugin::Captcha>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

