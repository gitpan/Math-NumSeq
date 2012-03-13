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

package Math::NumSeq::LucasNumbers;
use 5.004;
use strict;
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 36;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2) starting from 1,3.  This is the same recurrence as the Fibonacci numbers, but a different starting point.');

use constant values_min => 1;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant oeis_anum => 'A000204'; # lucas starting at 1,3,...
use constant i_start => 1;

sub rewind {
  my ($self) = @_;
  ### LucasNumbers rewind() ...
  $self->{'f0'} = 1;
  $self->{'f1'} = 3;
  $self->{'i'} = $self->i_start;
}

my $uv_limit = do {
  # Float integers too in 32 bits ?
  # my $max = 1;
  # for (1 .. 256) {
  #   my $try = $max*2 + 1;
  #   ### $try
  #   if ($try == 2*$max || $try == 2*$max+2) {
  #     last;
  #   }
  #   $max = $try;
  # }
  my $max = ~0;

  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  my $f0 = 1;
  my $f1 = 3;
  my $prev_f0;
  while ($f0 <= $max - $f1) {
    $prev_f0 = $f0;
    ($f1,$f0) = ($f1+$f0,$f1);
  }
  ### $prev_f0
  ### $f0
  ### $f1
  ### ~0 : ~0

  $prev_f0
};

sub next {
  my ($self) = @_;
  ### LucasNumbers next(): "f0=$self->{'f0'}, f1=$self->{'f1'}"

  (my $ret,
   $self->{'f0'},
   $self->{'f1'})
    = ($self->{'f0'},
       $self->{'f1'},
       $self->{'f0'}+$self->{'f1'});
  ### $ret

  if ($ret == $uv_limit) {
    $self->{'f0'} = Math::NumSeq::_bigint()->new("$self->{'f0'}");
    $self->{'f1'} = Math::NumSeq::_bigint()->new("$self->{'f1'}");
  }

  return ($self->{'i'}++, $ret);
}

# ENHANCE-ME: powering ...
sub ith {
  my ($self, $i) = @_;
  ### LucasNumbers ith(): $i
  if ($i <= 1 || _is_infinite($i)) {
    return $i;
  }
  $i--;
  my $f0 = ($i * 0) + 1;  # inherit bignum 1
  my $f1 = $f0 + 2;       # inherit bignum 3
  while (--$i > 0) {
    $f0 += $f1;

    unless (--$i > 0) {
      return $f0;
    }
    $f1 += $f0;
  }
  return $f1;
}

# FIXME: smaller than this
sub value_to_i_estimate {
  my ($self, $value) = @_;
  if (_is_infinite($value)) {
    return $value;
  }
  my $i = 1;
  for (;; $i++) {
    $value = int($value/2);
    if ($value <= 1) {
      return $i;
    }
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::LucasNumbers -- Lucas numbers

=head1 SYNOPSIS

 use Math::NumSeq::LucasNumbers;
 my $seq = Math::NumSeq::LucasNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2)
starting from 1,3.  This is the same recurrence as the Fibonacci numbers,
but a different starting point.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LucasNumbers-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Lucas number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Lucas number.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

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
