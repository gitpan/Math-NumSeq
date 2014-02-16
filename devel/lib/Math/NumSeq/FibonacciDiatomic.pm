# Copyright 2014 Kevin Ryde

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


package Math::NumSeq::FibonacciDiatomic;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 69;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth', 'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
# use Smart::Comments;

# use constant name => Math::NumSeq::__('Fibonacci Diatomic');
use constant description => Math::NumSeq::__('Fibonacci diatomic sequence, the number of representation of i as a sum of distinct Fibonacci numbers.');
use constant default_i_start => 0;
use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant characteristic_increasing => 0;
use constant values_min => 1;

#------------------------------------------------------------------------------
#
use constant oeis_anum => 'A000119';

#------------------------------------------------------------------------------

sub ith {
  my ($self, $i) = @_;
  ### FibonacciDiatomic ith(): $i

  if (_is_infinite($i)) {
    return undef;
  }
  if ($i < 0) { return undef; }
  if ($i <= 2) { return 1; }

  my $count = 0;
  my @fibs;
  my @cumul;
  {
    my $zero = ($i * 0);
    my $f0 = $zero + 1;  # inherit bignum 1
    my $f1 = $zero + 2;  # inherit bignum 2
    @fibs  = ($f1);
    @cumul = ($f1 + 1);  # 2 + 1 = 3
    while ($f0 <= $i-$f1) {
      ($f1, $f0) = ($f1+$f0, $f1);
      push @fibs, $f1;
      push @cumul, $f1 + $cumul[-1];
    }
  }
  ### @fibs

  my @pending = ($i);
  while (@fibs) {
    my $f = pop @fibs;
    my $c = pop @cumul;
    ### at: "f=$f  cumul=$c  pending=".join(',',@pending)

    my @new_pending;
    foreach my $p (@pending) {
      if ($p >= $f) {
        ### sub to: $p-$f
        push @new_pending, $p - $f;
      }
      if ($p < $c) {
        push @new_pending, $p;
      }
    }
    @pending = @new_pending;
  }
  ### final: "count=$count  pending=".join(',',@pending)
  return $count + scalar(grep {$_<=1} @pending);
}

sub pred {
  my ($self, $value) = @_;
  ### FibonacciDiatomic pred(): $value
  return ($value >= 1 && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq radix Moritz

=head1 NAME

Math::NumSeq::FibonacciDiatomic -- Fibonacci's diatomic sequence

=head1 SYNOPSIS

 use Math::NumSeq::FibonacciDiatomic;
 my $seq = Math::NumSeq::FibonacciDiatomic->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the Fibonacci diatomic sequence ...

    1, 1, 1, 2, 1, 2, 2, 1, 3, 2, 2, 3, 1, 3, 3, 2, 4, 2, 3, 3, ...
    starting i=0

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::FibonacciDiatomic-E<gt>new ()>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value of the sequence.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means simply integer
C<$valueE<gt>=1>.

=back

=head1 SEE ALSO

L<Math::NumSeq::Fibonacci>

=head1 HOME PAGE

L<http://user42.tuxfamily.org/math-numseq/index.html>

=head1 LICENSE

Copyright 2014 Kevin Ryde

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
