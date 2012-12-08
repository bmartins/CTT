package CTT;

use 5.006;
use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request::Common;
use Mojo::DOM;
use Data::Dumper;
use Encode;


=head1 NAME

CTT - Interface to Portuguese Post Office services

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This modules provides a few methods that queries CTT (Portugues Postal Office) website.

Perhaps a little code snippet.

    use CTT;

    my $ctt = CTT->new();
	my $package = $ctt->get_package_details($package_ref);
	my $status = $package->{'status'};
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 get_package_details

=cut

sub new {
    my ( $this, @args ) = @_;

    my $class = ( ref($this) or $this );
    my $self = {};
    bless $self, $class;
    return $self;
}

sub get_package_details {
    my ($self, $ref) = @_;
    my $url = 'http://www.ctt.pt/feapl_2/app/open/objectSearch/cttObjectSearch.jspx';

    my %args = (
        'pesqObjecto.objectoId' => $ref,
        'showResults'           => 'true',
    );
    my $req = POST $url, \%args;

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($req);

    if ($response->is_success) {
        return $self->parse_package_data($response->content);
    } else {
		warn "Got an error geting package info";
		return undef;
    }

}

sub parse_package_data {
    my ($self, $html) = @_;

	my %map_keys = (
        'Local'   => 'place',
        'Hora'    => 'time',
        'Data'    => 'date',
        'Recetor' => 'receiver',
        'Motivo'  => 'reason',
        'Estado'  => 'status',
    );

    my @package_data = ();
    my $dom = Mojo::DOM->new($html);
    my $skidiv;
    my @keys = ();
    my $div = $dom->find('div[class="tableSmall"]')->[1];

    my @trs = $div->find('tr')->each;
    my $header = shift @trs;
    for my $key ($header->find('th')->each) {
        push @keys, $map_keys{$key->text};
    }

    for my $tr (@trs) {
        my %row_data;
        my @tds = $tr->find('td')->each;

        my $l = @tds;
        $l--;
        for my $i(0..$l) {
            $row_data{$keys[$i]} = encode("utf8", $tds[$i]->text);
        }
        unshift @package_data, \%row_data;
    }

    return \@package_data;

}

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Bruno Martins, C<< <bscmartins at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ctt at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CTT>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CTT


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CTT>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CTT>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CTT>

=item * Search CPAN

L<http://search.cpan.org/dist/CTT/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Bruno Martins.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of CTT
