# Copyright 2010, 2011 Kevin Ryde

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


package Math::NumSeq::FibonacciWord;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 15;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


use constant values_min => 0;
use constant values_max => 1;
use constant description => Math::NumSeq::__('0/1 values related to Fibonacci numbers, 0,1,0,0,1,0,1,0,etc.');

# cf A003842 same with values 1/2 instead of 0/1
#    A014675 same with values 2/1 instead of 0/1
#    A001468 values 2/1 instead of 0/1, skip leading 0, self-referential
#    A000201 positions of 0s
#
#    A005614 inverse 1/0, starting from 1
#
#    A114986 characteristic of A000201, with extra 1 ??
#    A096270 expressed as 01 and 011, is inverse with leading 0
#    A076662 3/2 values with extra leading 3
#    A003622 positions of 1s ??
#    A036299 values 0/1 inverse, concatenating
#    A008352 values 1/2 inverse, concatenating
#
use constant oeis_anum => 'A003849';  # 0/1 values Fibonacci word starting 0,1

use Math::NumSeq::Fibbinary;
*rewind = \&Math::NumSeq::Fibbinary::rewind;
sub next {
  my ($self) = @_;
  my ($i, $value) = $self->Math::NumSeq::Fibbinary::next;
  return ($i, $value & 1);
}

sub ith {
  my ($self, $i) = @_;
  ### FibonacciWord ith(): $i

  # if $i is inf or nan then $i*0 is nan, while loop zero-trips and return
  # is nan

  my $f0 = ($i * 0) + 1;  # inherit bignum 1
  my $f1 = $f0 + 1;       # inherit bignum 2
  my $level = 0;
  ### start: "$f1,$f0  level=$level"

  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  while ($f0 <= $i-$f1) {
    ($f1,$f0) = ($f1+$f0,$f1);
    $level++;
  }
  ### above: "$f1,$f0  level=$level"

  do {
    ### at: "$f1,$f0  i=$i"
    if ($i >= $f1) {
      $i -= $f1;
    }
    ($f1,$f0) = ($f0,$f1-$f0);
  } while ($level--);

  ### ret: $i
  return $i;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 0 || $value == 1);
}

1;
__END__

=for stopwords Ryde Fibbinary Zeckendorf NumSeq

=head1 NAME

Math::NumSeq::FibonacciWord -- 0/1 related to Fibonacci numbers

=head1 SYNOPSIS

 use Math::NumSeq::FibonacciWord;
 my $seq = Math::NumSeq::FibonacciWord->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a sequence of 0s and 1s formed from the Fibonacci numbers.  The
start is 0,1 then a Fibonacci number F(k) many values are copied from the
start to the end to extend, so

    0,1                                         initial
    0,1,0                                       append 1 value
    0,1,0,0,1                                   append 2 values
    0,1,0,0,1,0,1,0                             append 3 values
    0,1,0,0,1,0,1,0,0,1,0,0,1                   append 5 values
    0,1,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,1,0,1,0   append 8 values
    etc

The same is had by starting 0 and then replacing 0 -E<gt> 0,1 and 1 -E<gt> 0
to expand.

The result is also the Fibbinary numbers modulo 2.  This can be seen most
easily from the Zeckendorf base interpretation of those numbers since the
base breakdown there works backwards from the above expansion subtracting
Fibonacci numbers until reaching 0 or 1.  (See
L<Math::NumSeq::Fibbinary/Zeckendorf Base>.)

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::FibonacciWord-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value in the sequence.  The first value is at i=0.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means 0 or 1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::Fibbinary>

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

# Local variables:
# compile-command: "math-image --values=FibonacciWord"
# End:
