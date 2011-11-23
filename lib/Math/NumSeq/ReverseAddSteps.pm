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

package Math::NumSeq::ReverseAddSteps;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 17;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('Reverse Add Steps');
use constant description => Math::NumSeq::__('How many steps of reverse and add until a palindrome is reached (sometimes called the 196-algorithm).');
use constant characteristic_count => 1;
use constant characteristic_monotonic => 0;
use constant values_min => -1;
use constant i_start => 1;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

#------------------------------------------------------------------------------

# cf A015976 - numbers needing 1 iteration to reach palindrome
#    A065206 - 1 iteration to reach palindrome, excluding palindromes
#    A015977 - 2 iterations to reach palindrome
#    A015979 - 3 iterations to reach palindrome
#
#    A023109 - first number requiring n iterations to palindrome
#                suggesting where to make the hard limit ...
#
#    A030547 - num steps to a palindrome in the 196 trajectory A006960
#              ie. how far away each elem is from a palindrome, ongoing
#    
# ~/OEIS/a058042.txt  on reaching binary palindromes
#
my @oeis_anum;
$oeis_anum[10] = 'A016016';  # steps to palindrome, or -1 if infinite
# OEIS-Catalogue: A016016
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}
#------------------------------------------------------------------------------

use constant 1.02;  # for leading underscore
use constant _LIMIT => 100;

sub rewind {
  my ($self) = @_;
  # $self->{'i'} = max(0,$self->{'lo'});

  $self->{'i'} = 1;

  my $radix = $self->{'radix'};
  my $limit = ~0;
  my $digits = -1;
  my $uv_limit = 1;
  while ($limit) {
    $limit = int($limit/$radix);
    $uv_limit *= $radix;
  }
  $self->{'uv_limit'} = $uv_limit;
  ### $uv_limit
}

sub next {
  my ($self) = @_;
  ### ReverseAddSteps next(): $self->{'i'}
  my $i = $self->{'i'}++;
  return ($i, $self->ith($i));
}

sub ith {
  my ($self, $k) = @_;
  ### ReverseAddSteps ith(): $k
  my $radix = $self->{'radix'};
  my $uv_limit = $self->{'uv_limit'};

  my $count = 0;
 OUTER: for ( ; $count < _LIMIT; $count++) {
    my @digits;
    ### $count
    ### k: "$k"

    if ($k >= $uv_limit && ! ref $k) {
      # stringize against Math::BigInt::GMP uv conversion
      $k = Math::NumSeq::_bigint()->new("$k");
    }

    if (ref $k) {
      ### big ...
      my $d = $k->copy;
      while ($d) {
        ### d: "$d"
        push @digits, $d % $radix;
        $d->bdiv($radix);
      }
      @digits = (0) unless @digits;
      ### big digits: join(',',@digits)

      for my $i (0 .. int(@digits/2)) {
        if ($count == 0 || $digits[$i] != $digits[-1-$i]) {
          ### not a palindrome ...

          foreach my $i (0 .. $#digits) {
            $d->bmul($radix);
            $d->badd($digits[$i]);
          }
          ### k: "$k"
          ### d: "$d"
          $k += $d;
          ### sum now: "$k"
          next OUTER;
        }
      }
    } else {
      my $d = $k;
      while ($d) {
        push @digits, $d % $radix;
        $d = int($d/$radix);
      }
      @digits = (0) unless @digits;
      ### small digits: join(',',@digits)

      for my $i (0 .. int(@digits/2)) {
        if ($count == 0 || $digits[$i] != $digits[-1-$i]) {
          ### not a palindrome ...

          foreach my $i (0 .. $#digits) {
            $d *= $radix;
            $d += $digits[$i];
          }
          ### k: "$k"
          ### d: "$d"
          $k += $d;
          ### sum now: "$k"
          next OUTER;
        }
      }
    }
    ### palindrome: $count
    return $count;
  }
  ### limit reached, -1 ...
  return -1;
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0);
}

1;
__END__

=for stopwords Ryde Math-NumSeq repunit infinites recognised

=head1 NAME

Math::NumSeq::ReverseAddSteps -- steps of the reverse-add algorithm

=head1 SYNOPSIS

 use Math::NumSeq::ReverseAddSteps;
 my $seq = Math::NumSeq::ReverseAddSteps->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The number of steps to reach a palindrome by the digit "reverse and add"
algorithm.  For example the i=19 is 2 because 19+91=110 then 110+011=121 is
a palindrome.

At least one reverse-add is applied, so an i which is itself a palindrome is
not value 0, but wherever that minimum one step might end up.  A repunit
like 111...11 reverse-adds to 222...22 so it's always 1 (except in binary).

The default is to reverse decimal digits, or the C<radix> parameter can
select another base.

The number of steps can be infinite.  In binary for example 3 = 11 binary
never reaches a palindrome, and in decimal it's conjectured that 196 doesn't
(and that is sometimes called the 196-algorithm).  In the current code a
hard limit of 100 is imposed on the search - perhaps something better is
possible.  (Some binary infinites can be recognised from their bit pattern
...)

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::ReverseAddSteps-E<gt>new ()>

=item C<$seq = Math::NumSeq::ReverseAddSteps-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of reverse-add steps required to reach a palindrome.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means C<$value
E<gt>= 0> since any count of steps is possible.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::ReverseAdd>,
L<Math::NumSeq::CollatzSteps>,
L<Math::NumSeq::JugglerSteps>

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