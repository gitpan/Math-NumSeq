# Copyright 2012 Kevin Ryde

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

package Math::NumSeq::LemoineCount;
use 5.004;
use strict;
use List::Util 'max';

use vars '$VERSION', '@ISA';
$VERSION = 34;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Primes;

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('The number of ways i can be represented as P+2*Q for primes P and Q.');
use constant default_i_start => 1;
use constant values_min => 0;
use constant characteristic_count => 1;

# "one_as_prime" secret undocumented parameter ...
# some sort of odd i only option too maybe ...
#
my @oeis_anum = ('A046924',  # including 1 as a prime
                 'A046926',  # not including 1 as a prime
                 # OEIS-Catalogue: A046926
                 # OEIS-Catalogue: A046924 one_as_prime=1
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[!$self->{'one_as_prime'}];
}

sub rewind {
  my ($self) = @_;
  ### LemoineCount rewind() ...
  $self->{'i'} = $self->i_start;
  $self->{'array'} = [];
  $self->{'size'} = 500;
}

sub next {
  my ($self) = @_;
  ### next(): "i=$self->{'i'}"

  unless (@{$self->{'array'}}) {
    $self->{'size'} = int (1.08 * $self->{'size'});

    my $lo = $self->{'i'};
    my $hi = $lo + $self->{'size'};
    ### range: "lo=$lo to hi=$hi"
    my @array;
    $array[$hi-$lo] = 0; # array size
    my @primes = (($self->{'one_as_prime'} ? (1) : ()),
                  Math::NumSeq::Primes::_primes_list (0, $hi));
    {
      my $qamax = $#primes;
      foreach my $pa (0 .. $#primes-1) {
        foreach my $qa (reverse $pa .. $qamax) {
          my $sum = $primes[$pa] + 2*$primes[$qa];
          ### at: "p=$primes[$pa] q=$primes[$qa]  sum=$sum  incr ".($sum-$lo)
          if ($sum > $hi) {
            $qamax = $qa-1;
          } elsif ($sum < $lo) {
            last;
          } else {
            $array[$sum-$lo]++;
          }
        }
      }
    }
    {
      my $qamax = $#primes;
      foreach my $pa (0 .. $#primes-1) {
        foreach my $qa (reverse $pa+1 .. $qamax) {
          my $sum = 2*$primes[$pa] + $primes[$qa];
          ### at: "p=$primes[$pa] q=$primes[$qa]  sum=$sum  incr ".($sum-$lo)
          if ($sum > $hi) {
            $qamax = $qa-1;
          } elsif ($sum < $lo) {
            last;
          } else {
            $array[$sum-$lo]++;
          }
        }
      }
    }
    ### @array
    $self->{'array'} = \@array;
  }
  return ($self->{'i'}++,
          shift @{$self->{'array'}} || 0);
}

sub ith {
  my ($self, $i) = @_;
  ### ith(): $i

  if ($i < 3) {
    return 0;
  }
  unless ($i >= 0 && $i <= 0xFF_FFFF) {
    return undef;
  }

  my $count = 0;
  my @primes = (($self->{'one_as_prime'} ? (1) : ()),
                Math::NumSeq::Primes::_primes_list (0, $i-1));
  ### @primes
  {
    my $pa = 0;
    my $qa = $#primes;
    while ($pa <= $qa) {
      my $sum = $primes[$pa] + 2*$primes[$qa];
      if ($sum <= $i) {
        ### at: "p=$primes[$pa] q=$primes[$qa]  count ".($sum == $i)
        $count += ($sum == $i);
        $pa++;
      } else {
        $qa--;
      }
    }
  }
  {
    my $pa = 0;
    my $qa = $#primes;
    while ($pa < $qa) {
      my $sum = 2*$primes[$pa] + $primes[$qa];
      if ($sum <= $i) {
        ### at: "p=$primes[$pa] q=$primes[$qa]  count ".($sum == $i)
        $count += ($sum == $i);
        $pa++;
      } else {
        $qa--;
      }
    }
  }
  return $count;
}

1;
__END__

=for stopwords Ryde  PlanePath Math-NumSeq Lemoine

=head1 NAME

Math::NumSeq::LemoineCount -- number of representations as P+2*Q for primes P,Q

=head1 SYNOPSIS

 use Math::NumSeq::LemoineCount;
 my $seq = Math::NumSeq::LemoineCount->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a count of how many ways i can be represented as P+2*Q for primes
P,Q, starting from i=1.

    0, 0, 0, 0, 0, 1, 1, 1, 2, 0, 2, 1, 2, 0, 2, 1, 4, 0, ...

For example i=6 is 2+2*2, just 1 way.  Or i=9 is 3+2*3=9 and 5+2*2=9 so 2
ways.

Lemoine conjectured circa 1894 that all odd i E<gt>= 7 can be represented as
P+2*Q, ie. a count E<gt>=1.

An even i must have P even, ie. P=2 as i=2+2*Q.  So for even i the count is
is 1 if i/2-1 is a prime or 0 if not.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::LemoineCount-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of ways C<$i> can be represented as P+2*Q for primes P,Q.

This requires checking all primes up to C<$i> and the current code has a
hard limit of 2**24 in the interests of not going into a near-infinite loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as a count.  All counts 0 up occur so this
is simply integer C<$value E<gt>= 0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::GoldbachCount>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2012 Kevin Ryde

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
