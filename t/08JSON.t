use Test::More;
use strict; no warnings;
#use LWP::Debug qw(+);
use Data::Dumper;
use lib qw/lib t/;
use Fake;

BEGIN {
    my @skip_msg;

    eval {
        use eBay::API::Simple::JSON;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::Simple::JSON, skipping test';
    }
    if ( scalar( @skip_msg ) ) {
        plan skip_all => join( ' ', @skip_msg );
    }
    else {
        plan qw(no_plan);
    }    
}

@Fake::ISA = qw(eBay::API::Simple::JSON);
my $call = Fake->new();

$call->{response_content} = <<END;
{
    "meta": {
        "limit": 20,
        "next": null,
        "offset": 0,
        "previous": null,
        "total_count": 4
    },
    "objects": [{
        "code": "ca",
        "id": "2",
        "locale": "en-ca",
        "name": "Canada",
        "resource_uri": "/green/api/green_v1/site/2/"
    },
    {
        "code": "us",
        "id": "1",
        "locale": "en-us",
        "name": "United States",
        "resource_uri": "/green/api/green_v1/site/1/"
    }]
} 
END

$call->execute( 'http://www.example.com/', { utm_campaign =>'simple_test' } );

#diag $call->request_content();
#diag $call->response_content();

is( ref $call->response_hash(), 'HASH', 'response hash' );

is( $call->response_hash->{meta}{limit}, 
    '20', 
    'hash test' 
);



