# Copyright 2010, 2011, 2012 Kevin Ryde

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

package Math::NumSeq::Palindromes;
use 5.004;
use strict;
use List::Util 'max';

use vars '$VERSION', '@ISA';
$VERSION = 45;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;


# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Palindromes');
use constant description => Math::NumSeq::__('Numbers which are "palindromes" reading the same backwards or forwards, like 153351.  Default is decimal, or select a radix.');
use constant i_start => 1;
use constant values_min => 0;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;

use Math::NumSeq::Base::Digits
  'parameter_info_array';   # radix parameter


#------------------------------------------------------------------------------
# cf A002385 - prime palindromes
#    A029732 - prime palindromes in base 16, written in base 10
#    A110784 - palindrom and digits in ascending order
#    A029731 - palindromes in both decimal and hexadecimal
#    A029733 - n where n^2 hex palindrome
#    A029734 - squares which are hex palindromes
#    A016038 - not palindrome in any base, up to n-2

my @oeis_anum = (
                 # OEIS-Catalogue array begin
                 undef,     # 0
                 undef,     # 1
                 'A006995', # radix=2
                 'A014190', # radix=3
                 'A014192', # radix=4
                 'A029952', # radix=5
                 'A029953', # radix=6
                 'A029954', # radix=7
                 'A029803', # radix=8
                 'A029955', # radix=9
                 'A002113', #
                 'A029956', # radix=11
                 'A029957', # radix=12
                 'A029958', # radix=13
                 'A029959', # radix=14
                 'A029960', # radix=15
                 'A029730', # radix=16
                 # OEIS-Catalogue array end
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}

#------------------------------------------------------------------------------


  # my @digits;
  # while ($lo > 0) {
  #   push @digits, $lo % $radix;
  #   $lo = int ($lo / $radix);
  # }
  # my $td = int((@digits+1)/2);
  # splice @digits, 0, int(@digits/2);  # delete low half
  # my $i = 0;
  # while (@digits) {
  #   $i = $i*$radix + pop @digits;
  # }
  # ...
sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;

  my $radix = $self->{'radix'};
  if ($radix < 2) { $radix = 10; }
  $self->{'radix'} = $radix;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $self->ith($i));
}

sub ith {
  my ($self, $i) = @_;
  ### Palindrome ith(): $i

  if (_is_infinite($i)) {  # don't loop forever if $value is +/-infinity
    return undef;
  }

  my $radix = $self->{'radix'};

  if ($i < 1) {
    return 0;
  }
  $i -= 2;

  my $digits = 1;
  my $limit = $radix-1;
  my $add = 1;
  my $ret;
  for (;;) {
    if ($i < $limit) {
      ### first, no low
      $i += $add;
      $ret = int($i / $radix);
      last;
    }
    $i -= $limit;
    if ($i < $limit) {
      ### second
      $i += $add;
      $ret = $i;
      last;
    }
    $i -= $limit;
    $limit *= $radix;
    $add *= $radix;
    $digits++;
  }
  ### $limit
  ### $add
  ### $i
  ### $digits
  ### push under: $ret
  while ($digits--) {
    $ret = $ret * $radix + ($i % $radix);
    $i = int($i / $radix);
  }
  ### $ret
  return $ret;
}

sub pred {
  my ($self, $value) = @_;

  if (_is_infinite($value)  # don't loop forever if $value is +/-infinity
      || $value != int($value)) {
    return 0;
  }

  my $radix = $self->{'radix'};
  my @digits;
  while ($value) {
    push @digits, $value % $radix;
    $value = int ($value / $radix);
  }
  for my $i (0 .. int(@digits/2)-1) {
    if ($digits[$i] != $digits[-$i-1]) {
      return 0;
    }
  }
  return 1;
}

1;
__END__

# sub _my_cnv {
#   my ($n, $radix) = @_;
#   if ($radix <= 36) {
#     require Math::BaseCnv;
#     return Math::BaseCnv::cnv($n,10,$radix);
#   } else {
#     my $ret = '';
#     do {
#       $ret = sprintf('[%d]', $n % $radix) . $ret;
#     } while ($n = int($n/$radix));
#     return $ret;
#   }
# }


=for stopwords Ryde Math-NumSeq ie

=head1 NAME

Math::NumSeq::Palindromes -- palindrome numbers like 15351

=head1 SYNOPSIS

 use Math::NumSeq::Palindromes;
 my $seq = Math::NumSeq::Palindromes->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The palindrome numbers which read the same backwards and forwards.

    0 .. 9, 11, 22, ..., 99, 101, 111, 121, ... 191, 202, ...

The default is decimal or the
C<radix> parameter can select another base.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Palindromes-E<gt>new ()>

=item C<$seq = Math::NumSeq::Palindromes-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th palindrome number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a palindrome, ie. its digits read the same
forwards and backwards (in the given C<radix>).

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Repdigits>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011, 2012 Kevin Ryde

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
