package WebService::IPERental;

# ABSTRACT: Todoist API

use strict;
use warnings;
use SOAP::Lite;
#use SOAP::Lite +trace => 'all';
use Carp 'croak';

$SOAP::Constants::PREFIX_ENC = 'SOAP-ENC';

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
    
    $args->{TTL} ||= 780;
    $args->{soap} = SOAP::Lite
      ->envprefix( 'SOAP-ENV' )->on_fault( sub { print( Dumper( $_[1]->fault ), "\n" ); } )
      ->on_action( sub { 'urn:IPRentalSoapAPIAction' } )
      ->proxy( 'https://secure.iprental.com/api/',
        timeout => 5 )->ns( 'urn:IPRentalSoapAPI', 'ns1' )
      ->outputxml( 1 )->autotype( 0 );

    bless $args, $class;
}

sub doIpLease {
    my ($self) = @_;

    my @search_request_params;
    foreach my $arg ( qw(APIkey APIpass username password )) {
        push @search_request_params, SOAP::Data->name( $arg )->value( $self->{ucfirst $arg} );
    }
    foreach my $arg ('TTL', 'Location') {
        push @search_request_params, SOAP::Data->name( $arg )->value( $self->{$arg} );
    }

    my $request_params = SOAP::Data->name( 'return' )->value( [@search_request_params] )
      ->attr( { 'xsi:type' => 'ns1:IPRargs' } );

    my $xml  = $self->{soap}->call(
        SOAP::Data->name( 'ns1:doIpLease' )
        $request_params
    );
    
    return $xml;
}

1;
