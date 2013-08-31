# Copyright 2013 Kevin Ryde

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


# Math::PlanePath::ZOrderCurve


package Math::NumSeq::HafermanCarpet;
use 5.004;
use strict;
use Math::PlanePath::Base::Digits 'digit_split_lowtohigh';

use vars '$VERSION', '@ISA';
$VERSION = 63;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
# use Smart::Comments;

use constant description => Math::NumSeq::__('0,1 of Haferman carpet.');
use constant default_i_start => 0;
use constant values_min => 0;
use constant values_max => 1;
use constant characteristic_integer => 1;

# 000 all zeros
# 001 infs are box fractal
# 010 evens  is plain starting from 1
# 011      odd=1 even=0 inf=0  is inverse of plain
# 100 odds odd=0 even=1 inf=1  is plain starting from 0
# 101 inverse of evens
# 110 inverse of infs box fractal
# 111 all ones

# start0     carpet 0
# start0 inv carpet 0 inverse
# start1     carpet 1
# start1 inv carpet 1 inverse
# box
# box inverse

use constant parameter_info_array =>
  [
   { name    => 'haferman_type',
     display => Math::NumSeq::__('Type'),
     type    => 'enum',
     default => 'start0',
     choices => ['start0','start1','box'],
   },
   { name    => 'inverse',
     display => Math::NumSeq::__('Inverse'),
     type    => 'boolean',
     default => 0,
   },
  ];

#------------------------------------------------------------------------------

# 000 all zeros
# 001 infs are box fractal
# 010 evens inverse of starting from 1
# 011      odd=1 even=0 inf=0  is inverse of plain
# 100 odds odd=0 even=1 inf=1  is plain starting from 0
# 101                          is plain starting from 1
# 110 inverse of infs box fractal
# 111 all ones
#
my %odd_by_type  = (start0 => 1,
                    start1 => 1,
                    box    => 0);
my %even_by_type = (start0 => 0,
                    start1 => 0,
                    box    => 0);
my %inf_by_type  = (start0 => 0,
                    start1 => 1,
                    box    => 1);
sub ith {
  my ($self, $i) = @_;
  ### ith(): $i

  if ($i < 0 || _is_infinite($i)) {  # don't loop forever if $i is +infinity
    return undef;
  }

  my $value = 0;
  for (;;) {
    if ($i) {
      my $digit = _divrem_mutate($i,9) & 1;
      if ($digit) {
        # stop at odd digit
        if ($value) {
          $value = $even_by_type{$self->{'haferman_type'}};
        } else {
          $value = $odd_by_type{$self->{'haferman_type'}};
        }
        last;
      } else {
        # count even digit
        $value ^= 1;
      }
    } else {
      # no more digits, all even
      $value = $inf_by_type{$self->{'haferman_type'}};
      last;
    }
  }
  if ($self->{'inverse'}) {
    $value ^= 1;
  }
  return $value;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 0 || $value == 1);
}

#------------------------------------------------------------------------------

# return $remainder, modify $n
# the scalar $_[0] is modified, but if it's a BigInt then a new BigInt is made
# and stored there, the bigint value is not changed
sub _divrem_mutate {
  my $d = $_[1];
  my $rem;
  if (ref $_[0] && $_[0]->isa('Math::BigInt')) {
    ($_[0], $rem) = $_[0]->copy->bdiv($d);  # quot,rem in array context
    if (! ref $d || $d < 1_000_000) {
      return $rem->numify;  # plain remainder if fits
    }
  } else {
    $rem = $_[0] % $d;
    $_[0] = int(($_[0]-$rem)/$d); # exact division stays in UV
  }
  return $rem;
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::HafermanCarpet -- bits of the Haferman carpet

=head1 SYNOPSIS

 use Math::NumSeq::HafermanCarpet;
 my $seq = Math::NumSeq::HafermanCarpet->new (haferman_type => 'start0');
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

I<In progress ...>

X<Haferman, Jeff>This sequence is 0,1 bits of of the Haferman carpet pattern
as suitable for plotting in Z-Order and similar.

    0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,..
    starting i=0 

Plotted in Z-Order radix=3 the result is as follows.  At a bigger size an
attractive pattern of interlocking loops can be seen.

=cut

# math-image --text --values=HafermanCarpet,haferman_type=start0 --path=ZOrderCurve,radix=3 --size=63x27

=pod

     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
    * ** ** ***** ***** ** ** ** ** ** ***** ***** ** ** ** ** ** *
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
     *  *  *  * *** *  *  *  *  *  *  *  * *** *  *  *  *  *  *  * 
    * ** ** ** ***** ** ** ** ** ** ** ** ***** ** ** ** ** ** ** *
     *  *  *  * *** *  *  *  *  *  *  *  * *** *  *  *  *  *  *  * 
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
    * ** ** ***** ***** ** ** ** ** ** ***** ***** ** ** ** ** ** *
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
    *** * *** *  *  * *** * ****** * *** *  *  * *** * ****** * ***
    **** ***** ** ** ***** ******** ***** ** ** ***** ******** ****
    *** * *** *  *  * *** * ****** * *** *  *  * *** * ****** * ***
     * *** *  *  *  *  * *** *  * *** *  *  *  *  * *** *  * *** * 
    * ***** ** ** ** ** ***** ** ***** ** ** ** ** ***** ** ***** *
     * *** *  *  *  *  * *** *  * *** *  *  *  *  * *** *  * *** * 
    *** * *** *  *  * *** * ****** * *** *  *  * *** * ****** * ***
    **** ***** ** ** ***** ******** ***** ** ** ***** ******** ****
    *** * *** *  *  * *** * ****** * *** *  *  * *** * ****** * ***
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
    * ** ** ***** ***** ** ** ** ** ** ***** ***** ** ** ** ** ** *
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
     *  *  *  * *** *  *  *  *  *  *  *  * *** *  *  *  *  *  *  * 
    * ** ** ** ***** ** ** ** ** ** ** ** ***** ** ** ** ** ** ** *
     *  *  *  * *** *  *  *  *  *  *  *  * *** *  *  *  *  *  *  * 
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 
    * ** ** ***** ***** ** ** ** ** ** ***** ***** ** ** ** ** ** *
     *  *  * *** * *** *  *  *  *  *  * *** * *** *  *  *  *  *  * 

The pattern is formed by a "morphism" where 0,1 bits expand to a 3x3 array

          1  1  1             0  1  0
    0 ->  1  1  1       1 ->  1  0  1
          1  1  1             0  1  0

For the purpose of this sequence those arrays are flattened so

    0  -> 1,1,1,1,1,1,1,1,1
    1  -> 0,1,0,1,0,1,0,1,0

The sequence starts from a single value 0.  The expansion rules are applied
twice to grow it to 9*9=81 values, then the rules applied twice again to
9^4=6561 values, and so on indefinitely.  At each expansion the rules leave
the previous values unchanged.

An even number of expansion steps is necessary to ensure the previous values
are unchanged.  It can be seen for example the first bit goes 0->1 and then
1->0, so it would be flipped if an odd number of expansions were applied.
This even number of expansions can also be expressed as each bit morphing
into an 81-long run.

    0  -> 0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,..
    1  -> 1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,0,...

=head2 Start 1

Option C<haferman_type =E<gt> 'start1'> option can start the sequence from
value 1 instead.

    # haferman_type => "start1"
    1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,0,...

When plotted in Z-Order this is

=cut

math-image --text --values=HafermanCarpet,haferman_type=start1 --path=ZOrderCurve,radix=3 --size=63x27

=pod

    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
    **** ******** ******** ***** ** ** ***** ***** ** ** ***** ****
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
     * *** *  * *** *  * *** *  *  *  *  * *** *  *  *  *  * *** * 
    * ***** ** ***** ** ***** ** ** ** ** ***** ** ** ** ** ***** *
     * *** *  * *** *  * *** *  *  *  *  * *** *  *  *  *  * *** * 
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
    **** ******** ******** ***** ** ** ***** ***** ** ** ***** ****
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
    *** * ****** * ****** * ****** * *** *  *  * *** * ****** * ***
    **** ******** ******** ******** ***** ** ** ***** ******** ****
    *** * ****** * ****** * ****** * *** *  *  * *** * ****** * ***
     * *** *  * *** *  * *** *  * *** *  *  *  *  * *** *  * *** * 
    * ***** ** ***** ** ***** ** ***** ** ** ** ** ***** ** ***** *
     * *** *  * *** *  * *** *  * *** *  *  *  *  * *** *  * *** * 
    *** * ****** * ****** * ****** * *** *  *  * *** * ****** * ***
    **** ******** ******** ******** ***** ** ** ***** ******** ****
    *** * ****** * ****** * ****** * *** *  *  * *** * ****** * ***
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
    **** ******** ******** ***** ** ** ***** ***** ** ** ***** ****
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
     * *** *  * *** *  * *** *  *  *  *  * *** *  *  *  *  * *** * 
    * ***** ** ***** ** ***** ** ** ** ** ***** ** ** ** ** ***** *
     * *** *  * *** *  * *** *  *  *  *  * *** *  *  *  *  * *** * 
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***
    **** ******** ******** ***** ** ** ***** ***** ** ** ***** ****
    *** * ****** * ****** * *** *  *  * *** * *** *  *  * *** * ***


=head2 Box Fractal

The C<haferman_type =E<gt> 'box'> option gives the bits of the box fractal,

    # haferman_type => "box"
    1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,...

This is value=1 whenever i contains only even digits 0,2,4,6,8 when written
in base-9.  When plotted in Z-Order this is

=cut

# math-image --text --values=HafermanCarpet,haferman_type=box --path=ZOrderCurve,radix=3 --size=27

=pod

    * *   * *         * *   * *
     *     *           *     * 
    * *   * *         * *   * *
       * *               * *   
        *                 *    
       * *               * *   
    * *   * *         * *   * *
     *     *           *     * 
    * *   * *         * *   * *
             * *   * *         
              *     *          
             * *   * *         
                * *            
                 *             
                * *            
             * *   * *         
              *     *          
             * *   * *         
    * *   * *         * *   * *
     *     *           *     * 
    * *   * *         * *   * *
       * *               * *   
        *                 *    
       * *               * *   
    * *   * *         * *   * *
     *     *           *     * 
    * *   * *         * *   * *

=head2 Inverse

The C<inverse =E<gt> 1> option (a boolean) can invert the 0,1 bits as
0E<lt>-E<gt>1.  This can be applied to any of the types, for example on the
default "start0",

    # inverse => 1
    1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,1,0,1,0,1,...

=head2 Z-Order

The Z-Order curve (per for example L<Math::PlanePath::ZOrderCurve>) numbers
its sub-parts

    +---+---+---+
    | 6 | 7 | 8 |
    +---+---+---+
    | 3 | 4 | 5 |
    +---+---+---+
    | 0 | 1 | 2 |
    +---+---+---+

This suits the sequence here because they're numbered alternately odd and even,

    +------+------+------+
    | even | odd  | even |
    +------+------+------+
    | odd  | even | odd  |
    +------+------+------+
    | even | odd  | even |
    +------+------+------+

X<Peano curve>X<Kochel curve>X<Wunderlich>X<Gray code path>Any self-similar
expansion which numbers in an odd/even alternation like this gives the same
result.  This includes the Peano curve, Wunderlich's serpentine and meander,
Kochel curve, reflected Gray code path (in radix=3).

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::HafermanCarpet-E<gt>new (haferman_type =E<gt> $str, inverse =E<gt> $bool)>

Create and return a new sequence object.  The C<haferman_type> option can be
strings

    "start0"     initial value 0 (the default)
    "start1"     initial value 1
    "box"        box fractal

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value from the sequence.

=back

=head1 FORMULAS

=head2 Ith

The effect of the morphism described above is to count the number of
trailing even digits (0,2,4,6,8) when i is written in base-9.

                       count trailing base-9 digits 0,2,4,6,8 
    haferman_type           odd    even    infinite
    -------------           ---    ----    --------
      "start0"               1       0         0
      "start1"               1       0         1
      "box"                  0       0         1

For example i=339 is "416" in base-9 and it has 1 trailing digit 0,2,4,6,8,
so "odd" count and thus value=1 in the default "start0".

Or i=609 is "746" in base-9 and it has 2 trailing even digits, so "even"
count and thus value=0 (in all the sequence types).

If i consists entirely of even digits 0,2,4,6,8 then there's no odd digit to
stop the counting of trailing evens and the count is reckoned as infinite.
For example i=58 is "64" in base-9 which is entirely even digits and thus
value=0 in the default "start0".

The "infinite" count i positions form the box fractal (L</Box Fractal> shown
above).  It's interesting to note the only difference between starting the
morphism at 0 or starting it at 1 is whether these box fractal bits are set
to 0 or to 1.

The three i positions odd/even/infinite can each be 0 or 1 giving a total 8
combinations.  The three "start0", "start1" and "box" and the inverse option
are the 6 combinations.  The remaining 2 are 0,0,0 for value=0 always, or
1,1,1 for value=1 always which are not very interesting.

=head1 SEE ALSO

L<Math::NumSeq>

L<Math::PlanePath::ZOrderCurve>

=head1 HOME PAGE

L<http://user42.tuxfamily.org/math-numseq/index.html>

=head1 LICENSE

Copyright 2012, 2013 Kevin Ryde

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

# Local variables:
# compile-command: "math-image --wx --values=HafermanCarpet --path=ZOrderCurve,radix=3 --scale=5"
# End:
#
