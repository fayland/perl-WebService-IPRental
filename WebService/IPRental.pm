package WebService::IPERental;

# ABSTRACT: Todoist API

use strict;
use warnings;
use SOAP::Lite;
use Carp 'croak';

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION



=cut

sub new {
    my $class = shift;
    my $args = scalar @_ % 2 ? shift : { @_ };

    $args->{APIkey} or croak 'APIkey is required';
    $args->{APIpass} or croak 'APIpass is required';
    $args->{Username} or croak 'Username is required';
    $args->{Password} or croak 'Password is required';

    bless $args, $class;
}

sub doIpLease {
    my ($self) = @_;


}

1;
