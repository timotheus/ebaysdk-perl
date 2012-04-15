package Fake;

=head1 NAME

Fake 

=head1 DESCRIPTION

eBay::API::Simple subclass for testing purposes. This module is a
quick and dirty hack to allow the test scripts to work without
performing live HTTP calls.

The eBay::API::Simple subclass to be subclassed by this module should
be set in the test script before instantiation. Only the
_execute_http_request method is overridden, which preserves most of
the behavior of the original module. Before calling the execute
method, the $request->{request_content} member variable should be set
to the desired content.

=head1 USAGE

  use eBay::API::Simple::HTML;
  use Fake;

  @Fake::ISA = qw(eBay::API::Simple::HTML);
  my $call = Fake->new();

  $call->{response_content} = '<html><body><h1>OMG!</h1></body></html>';

  $call->execute( 'http://www.example.com/', { utm_campaign =>'simple_test' } );

  print $call->request_content;
  print "\n";
  print $call->response_content;
  print "\n";
  print $call->response_hash->{body}{h1};
  print "\n";

=cut

our @ISA;

sub _execute_http_request {
    my $self = shift;

    unless ( defined $self->{request_agent} ) {
        $self->{request_agent} = $self->_get_request_agent();
    }

    unless ( defined $self->{request_object} ) {
        $self->{request_object} = $self->_get_request_object();
    }

    # allow to set in test scripts:
    $self->{response_content} ||= '<xml>hello, world!</xml>';

    $self->{response_hash} = undef;
    $self->{response_dom} = undef;

    return $self->{response_content};
}

42;

=head1 BUGS

This whole thing could be considered a bug since it's based on abuse
of Perl OO conventions. This module was not intended to be used for
anything but test scripts. It does not provide a complete test of all
scenarios. Notably, it does not flag errors.

=head1 AUTHOR

Andrew Dittes <adittes@gmail.com>

=cut
