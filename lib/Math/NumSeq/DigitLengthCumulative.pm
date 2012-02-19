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

package Math::NumSeq::DigitLengthCumulative;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 34;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

# uncomment this to run the ### lines
#use Smart::Comments;


use vars '$VERSION';
$VERSION = 34;

# use constant name => Math::NumSeq::__('Digit Length Cumulative');
use constant description => Math::NumSeq::__('Cumulative length of numbers 0,1,2,3,etc written out in the given radix.  For example binary 1,2,4,6,9,12,15,18,22,etc, 2 steps by 2, then 4 steps by 3, then 8 steps by 4, then 16 steps by 5, etc.');
use constant i_start => 0;
use constant values_min => 1;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;

# cf A117804 - natural position of n in 012345678910111213
#    A064223 - accumulating lengths of its own values
#
my @oeis_anum;
$oeis_anum[2] = 'A083652';   # 2 binary
# OEIS-Catalogue: A083652 radix=2

sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}

sub rewind {
  my ($self) = @_;
  ### DigitLengthCumulative rewind(): $self

  $self->{'i'} = $self->i_start;
  $self->{'length'} = 1;
  $self->{'limit'} = $self->{'radix'};
  $self->{'total'} = 0;
}
sub next {
  my ($self) = @_;
  ### DigitLengthCumulative next(): $self
  ### count: $self->{'count'}
  ### bits: $self->{'bits'}

  my $i = $self->{'i'}++;
  if ($i >= $self->{'limit'}) {
    $self->{'limit'} *= $self->{'radix'};
    $self->{'length'}++;
    ### step to
    ### length: $self->{'length'}
    ### remaining: $self->{'limit'}
  }
  return ($i, ($self->{'total'} += $self->{'length'}));
}

sub ith {
  my ($self, $i) = @_;
  ### DigitLengthCumulative ith(): $i

  if (_is_infinite($i)) {
    return $i;  # don't loop forever if $i is +infinity
  }
  my $ret = 1;
  my $length = 1;
  my $radix = $self->{'radix'};
  my $power = ($i*0)+1; # inherit bignum 1
  for (;;) {
    ### $ret
    ### $length
    ### $power
    my $next_power = $power * $radix;
    if ($i < $next_power) {
      ### final extra: $length * ($i - $power + 1)
      return $ret + $length * ($i - $power + 1);
    }
    ### add: $length * $next_power
    $ret += $length++ * ($next_power - $power);
    $power = $next_power;
  }
}

# sub pred {
#   my ($self, $value) = @_;
#   if ($value < 2) { return $value; }
# 
#   my $base = 2;
#   my $bits_each = 2;
#   my $valueums = 2;
#   for (;;) {
#     my $next_base = $base + $valueums*$bits_each;
#     last if ($next_base > $value);
#     $base = $next_base;
#     $bits_each++;
#     $valueums <<= 1;
#   }
#   $value -= $base;
#   ### offset: $value
#   my $pos = (-1-$value) % $bits_each;
#   $value = int($value / $bits_each) + $valueums;
#   ### $base
#   ### $bits_each
#   ### $valueums
#   ### $pos
#   ### val: sprintf('%#X',$value)
#   return (($value >> $pos) & 1);
# }

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::DigitLengthCumulative -- total length in digits of numbers 1 to i

=head1 SYNOPSIS

 use Math::NumSeq::DigitLengthCumulative;
 my $seq = Math::NumSeq::DigitLengthCumulative->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The total length of numbers 0 to i, for example ternary 1,2,3,5,7,9,etc,
representing ternary numbers 0,1,2,10,11,12.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::DigitLengthCumulative-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return length in digits of C<$i>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>

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
