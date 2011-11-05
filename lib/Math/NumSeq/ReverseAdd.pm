# Copyright 2011 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

package Math::NumSeq::ReverseAdd;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 15;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Emirps;
*_reverse_in_radix = \&Math::NumSeq::Emirps::_reverse_in_radix;

# uncomment this to run the ### lines
#use Devel::Comments;


use constant description => Math::NumSeq::__('Reverse-add sequence, reverse the digits and add.');

sub characteristic_monotonic {
  my ($self) = @_;
  # any non-zero start always increases
  return ($self->{'start'} ? 2 : 0);
}
sub values_min {
  my ($self) = @_;
  return $self->{'start'};
}
sub values_max {
  my ($self) = @_;
  # starting from zero never changes, otherwise unbounded
  return ($self->{'start'} ? undef : 0);
}

use Math::NumSeq::Base::Digits;
use constant parameter_info_array =>
  [
   {
    name    => 'start',
    display => Math::NumSeq::__('Start'),
    type    => 'integer',
    default => 1,
    minimum => 0,
    width   => 5,
    description => Math::NumSeq::__('Starting value for the sequence.'),
   },
   Math::NumSeq::Base::Digits->parameter_info_list(),
  ];

#------------------------------------------------------------------------------
my %oeis_anum;

# cf A058042 written out in binary
# ~/OEIS/a058042.txt  on reaching binary palindromes

$oeis_anum{'2'}->{'1'} = 'A035522';
# OEIS-Catalogue: A035522 radix=2 start=1
$oeis_anum{'2'}->{'22'} = 'A061561';
# OEIS-Catalogue: A061561 radix=2 start=22
$oeis_anum{'2'}->{'77'} = 'A075253';
# OEIS-Catalogue: A075253 radix=2 start=77
$oeis_anum{'2'}->{'442'} = 'A075268';
# OEIS-Catalogue: A075268 radix=2 start=442
$oeis_anum{'2'}->{'537'} = 'A077076';
# OEIS-Catalogue: A077076 radix=2 start=537
$oeis_anum{'2'}->{'775'} = 'A077077';
# OEIS-Catalogue: A077077 radix=2 start=775

$oeis_anum{'4'}->{'1'} = 'A035524';
# OEIS-Catalogue: A035524 radix=4 start=1
$oeis_anum{'4'}->{'290'} = 'A075299';
# OEIS-Catalogue: A075299 radix=4 start=290
$oeis_anum{'4'}->{'318'} = 'A075153';
# OEIS-Catalogue: A075153 radix=4 start=318
$oeis_anum{'4'}->{'266718'} = 'A075466';
# OEIS-Catalogue: A075466 radix=4 start=266718
$oeis_anum{'4'}->{'270798'} = 'A075467';
# OEIS-Catalogue: A075467 radix=4 start=270798
$oeis_anum{'4'}->{'1059774'} = 'A076247';
# OEIS-Catalogue: A076247 radix=4 start=1059774
$oeis_anum{'4'}->{'1059831'} = 'A076248';
# OEIS-Catalogue: A076248 radix=4 start=1059831

$oeis_anum{'10'}->{'1'} = 'A001127';
# OEIS-Catalogue: A001127 start=1
$oeis_anum{'10'}->{'3'} = 'A033648';
# OEIS-Catalogue: A033648 start=3
$oeis_anum{'10'}->{'89'} = 'A033670';
# OEIS-Catalogue: A033670 start=89
$oeis_anum{'10'}->{'196'} = 'A006960';
# OEIS-Catalogue: A006960 start=196

# $oeis_anum{'10'}->{''} = '';

sub oeis_anum {
  my ($self) = @_;
  my $start = $self->{'start'};
  if ($start == 0) { return 'A000004'; } # all zeros
  return $oeis_anum{$self->{'radix'}}->{$start};
}
#------------------------------------------------------------------------------

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 0;
  $self->{'value'} = $self->{'start'};
}
sub next {
  my ($self) = @_;
  ### ReverseAdd next(): $self->{'i'}
  ### value: "$self->{'value'}"
  my $ret = $self->{'value'};
  $self->{'value'} += _reverse_in_radix($self->{'value'}, $self->{'radix'});
  return ($self->{'i'}++, $ret);
}

sub ith {
  my ($self, $i) = @_;
  ### ReverseAdd ith(): $i

  if (_is_infinite($i)) {
    return undef;
  }

  my $radix = $self->{'radix'};
  my $value = $self->{'start'};
  while ($i-- > 0) {
    $value += _reverse_in_radix($value, $radix);
  }
  return $value;
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::ReverseAdd -- steps of the reverse-add algorithm

=head1 SYNOPSIS

 use Math::NumSeq::ReverseAdd;
 my $seq = Math::NumSeq::ReverseAdd->new (start => 196);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The reverse-add sequence from a given starting point.  The digit reversal of
a given value is added to make the next.  For example C<start =E<gt> 1>,

    1,2,4,8,16,77,154,605,1111,2222,...

At 16 the reversal is 61, adding those 16+61=77 is the next value.  There's
some interest in whether a palindrome like 77 is ever reached in the
sequence, but the sequence here continues on forever.

The default is digits reversed in decimal, but the C<radix> parameter can
select another base.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::ReverseAdd-E<gt>new (start =E<gt> $n)>

=item C<$seq = Math::NumSeq::ReverseAdd-E<gt>new (start =E<gt> $n, radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>th value in the sequence.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::ReverseAddSteps>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011 Kevin Ryde

Math-NumSeq is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

Math-NumSeq is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

=cut
