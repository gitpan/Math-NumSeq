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


package Math::NumSeq::FibonacciWord;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 32;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('0/1 values related to Fibonacci numbers, 0,1,0,0,1,0,1,0,etc.');
use constant i_start => 0;
use constant values_min => 0;
use constant values_max => 1;
use constant characteristic_integer => 1;

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
#    A135817 whythoff repres 0s
#    A135818 whythoff repres 1s
#    A189921 whythoff form
#    A135817 whythoff length A+B
#
use constant oeis_anum => 'A003849';  # 0/1 values Fibonacci word starting 0,1

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'value'} = 0;
}
sub next {
  my ($self) = @_;
  ### FibonacciWord next() ...

  my $v = $self->{'value'};
  my $filled = ($v >> 1) | $v;
  my $mask = (($filled+1) ^ $filled) >> 1;
  $self->{'value'} = ($v | $mask) + 1;

  ### value : sprintf('0b %6b',$v)
  ### filled: sprintf('0b %6b',$filled)
  ### mask  : sprintf('0b %6b',$mask)
  ### bit   : sprintf('0b %6b',$mask+1)
  ### newv  : sprintf('0b %6b',$self->{'value'})

  return ($self->{'i'}++, $v & 1);
}

sub ith {
  my ($self, $i) = @_;
  ### FibonacciWord ith(): $i

  # if $i is inf or nan then $i*0 is nan and the while loop zero-trips and
  # return is nan

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

=for stopwords Ryde Fibbinary Zeckendorf Math-NumSeq

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

L<Math::PlanePath::FibonacciWordFractal>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

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
