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

package Math::NumSeq::KaprekarNumbers;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 39;
use Math::NumSeq;
use List::Util 'min';
use Math::NumSeq::Base::IteratePred;
@ISA = ('Math::NumSeq::Base::IteratePred',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;
*_bigint = \&Math::NumSeq::_bigint;

use Math::NumSeq::NumAronson;
*_round_down_pow = \&Math::NumSeq::NumAronson::_round_down_pow;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('Number of steps of the Kaprekar iteration digits ascending + digits descending until reaching a cycle.');
use constant i_start => 1;
use constant characteristic_integer => 1;

use Math::NumSeq::Base::Digits;   # radix
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

use constant values_min => 0;

my @oeis_anum;
$oeis_anum[10] = 'A006886';
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}

use constant _UV_LIMIT => int(sqrt(~0));

sub pred {
  my ($self, $value) = @_;

  if (_is_infinite($value)) {
    return undef;
  }
  if ($value < 0 || $value != int($value)) {
    return 0;
  }

  if ($value > _UV_LIMIT) {
    $value = _bigint()->new("$value");
  }

  my $radix = $self->{'radix'};
  my ($power) = _round_down_pow($value,$radix);
  $power *= $radix;
  ### assert: $power > $value

  my $square = $value * $value;
  return ($value == int($square/$power) + ($square%$power));
}


# sub rewind {
#   my ($self) = @_;
#   $self->{'i'} = $self->i_start;
#   $self->{'queue'} = [0];
#   $self->{'power'} = 1;
# }
# 
# sub next {
#   my ($self) = @_;
#   ### next(): "queue=".($self->{queue}->[0] || '')
# 
#   my $queue = $self->{'queue'};
#   if (! @$queue || $queue->[0] >= $self->{'power'}) {
#     ### extend: $self->{'power'}
# 
#     my $radix = $self->{'radix'};
#     my $power = $self->{'power'};
#     my $next_power = $power * $radix;
#     my %values;
#     @values{@$queue} = (); # hash slice
#     foreach my $n ($power .. $next_power-1) {
#       my $square = $n * $n;
#       $values{int($square/$next_power) + ($square%$next_power)} = undef;
# 
#       ### sum: "n=$n  ".int($square/$next_power)." + ".($square%$next_power)
#     }
#     $self->{'power'} = $next_power;
#     @$queue = sort {$a<=>$b} keys %values;  # ascending
# 
#     ### new queue: join(',',@$queue)
#   }
# 
#   return ($self->{'i'}++, shift @$queue);
# }

1;
__END__

=for stopwords Ryde Math-NumSeq BigInt

=head1 NAME

Math::NumSeq::KaprekarNumbers -- recurrence around a square spiral

=head1 SYNOPSIS

 use Math::NumSeq::KaprekarNumbers;
 my $seq = Math::NumSeq::KaprekarNumbers->new (cbrt => 2);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

I<In progress ...>

This is the Kaprekar numbers, those integers where adding the upper and low
half of the square gives the integer itself.

    1, 9, 45, 55, 99, 297, 703, 999, 2223, 2728, ...

For example 45 is in the sequence because 45*45=2025 and 20+25=45.

In the current code C<next()> is not very efficient, it merely searches all
integers testing with C<pred()>.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::KaprekarNumbers-E<gt>new ()>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Kaprekar number.

=back

=head1 SEE ALSO

L<Math::NumSeq>

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
