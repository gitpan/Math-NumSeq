# Copyright 2011, 2012, 2013 Kevin Ryde

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


# on_values=>'even' is 2*i gives +1 for "both" and "down", no change to "up"
# on_values=>'odd' is 2*i+1
#   starts 3*(2i+1)+1 = 6i+4 -> 3i+2
#
# i=0 for odd same as Odd->ith() ?

# 2^E(N) = 3^O(N) * N * Res(N)
# log(2^E(N)) = log(3^O(N) * N * Res(N))
# log(2^E(N)) = log(3^O(N)) + log(N) + log(Res(N))
# E(N)*log(2) = O(N)*log(3) + log(N) + log(Res(N))
# log(Res(N)) = O(N)*log(3) - E(N)*log(2) + log(N)

# "Glide" how many steps to get a value < N.
#

package Math::NumSeq::CollatzSteps;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 66;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Collatz Steps');
sub description {
  my ($self) = @_;
  if (ref $self) {
    if ($self->{'step_type'} eq 'up') {
      return Math::NumSeq::__('Number of up steps to reach 1 in the Collatz "3n+1" problem.');
    }
    if ($self->{'step_type'} eq 'down') {
      return Math::NumSeq::__('Number of up steps to reach 1 in the Collatz "3n+1" problem.');
    }
  }
  return Math::NumSeq::__('Number of steps to reach 1 in the Collatz "3n+1" problem.');
}

sub default_i_start {
  my ($self) = @_;
  return (($self->{'on_values'}||'') eq 'odd'
          ? 0
          : 1);
}
sub values_min {
  my ($self) = @_;
  return ($self->{'on_values'} eq 'even'
          ? 1
          : 0);
}
use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;

use constant parameter_info_array =>
  [
   { name      => 'step_type',
     share_key => 'step_type_bothupdown',
     display   => Math::NumSeq::__('Step Type'),
     type      => 'enum',
     default   => 'both',
     choices   => ['both','up','down'],
     choices_display => [Math::NumSeq::__('Both'),
                         Math::NumSeq::__('Up'),
                         Math::NumSeq::__('Down'),
                        ],
     description => Math::NumSeq::__('Which steps to count, the 3*n+1 ups, the n/2 downs, or both.'),
   },
   { name      => 'end_type',
     share_key => 'end_type_1below', # default "both"
     display   => Math::NumSeq::__('End Type'),
     type      => 'enum',
     default   => '1',
     choices   => ['1','below'],
     choices_display => ['1',
                         Math::NumSeq::__('Below'),
                        ],
     # description => Math::NumSeq::__(''),
   },
   # { name      => 'on_values',
   #   share_key => 'on_values_aoe',
   #   display   => Math::NumSeq::__('On Values'),
   #   type      => 'enum',
   #   default   => 'all',
   #   choices   => ['all','odd','even'],
   #   choices_display => [Math::NumSeq::__('All'),
   #                       Math::NumSeq::__('Odd'),
   #                       Math::NumSeq::__('Even')],
   #   description => Math::NumSeq::__('The values to act on, either all integers of just the odd integers.'),
   # },
  ];

#------------------------------------------------------------------------------
# cf A075677 one reduction 3x+1/2^r on the odd numbers
#    A014682 one step 3x+1 or x/2 on the integers
#    A006884 new record for highest point reached in iteration
#    A006885   that record high position
#
#    A102419
#    A217934 new highs of "glide" steps to go below
#    A060412 n where those highs occur
#
#    A074473
#    A075476
#    A075477
#    A075478
#    A075480
#    A075481
#    A075482
#    A075483
#    A060445
#    A060412
#    A217934
#
my %oeis_anum =
  (all  => { up   => 'A006667', # triplings
             # OEIS-Catalogue: A006667 step_type=up

             down => 'A006666', # halvings
             # OEIS-Catalogue: A006666 step_type=down

             both => 'A006577', # both halvings and triplings
             # OEIS-Catalogue: A006577 step_type=both
           },
   even => { both => 'A008908', # +1 from "all"
             # OEIS-Catalogue: A008908 on_values=even
           },
   # But A075680 is OFFSET=1 for odd=1, unlike Lemoine A046927 or Odd A005408
   # odd => { up => 'A075680',  # n=1 for odd=1
   #          # OEIS-Catalogue: A075680 on_values=odd step_type=up
   #        },
  );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'on_values'}}->{$self->{'step_type'}};
}

#------------------------------------------------------------------------------

sub new {
  my $self = shift->SUPER::new(@_);
  $self->{'on_values'} ||= 'all';
  return $self;
}

use constant 1.02 _UV_LIMIT => do {  # version 1.02 for leading underscore
  my $limit = ~0;
  my $bits = 0;
  while ($limit) {
    $bits++;
    $limit >>= 1;
  }
  $bits -= 2;
  (1 << $bits) - 1
};

sub ith {
  my ($self, $i) = @_;
  ### CollatzSteps ith(): $i

  if ($self->{'on_values'} eq 'odd') {
    $i = 2*$i+1;  # i=1 is odd number 1
  } elsif ($self->{'on_values'} eq 'even') {
    $i *= 2;
  }
  my $orig_i = $i;

  if ($i <= 1) {
    return 0;
  }
  if (_is_infinite($i)) {
    return $i;
  }

  my $ups = 0;
  my $downs = 0;
  my $end = ($self->{'end_type'} eq '1' ? 1 : $i);

 OUTER: for (;;) {
    until ($i & 1) {
      $i >>= 1;
      $downs++;
      last OUTER if $i <= $end;
    }
    ### odd: $i

    if ($i > _UV_LIMIT) {
      $i = Math::NumSeq::_to_bigint($i);

      ### using bigint: "$i"
      for (;;) {
        ### odd: "$i"
        $i->bmul(3);
        $i->binc();
        $ups++;
        ### tripled: "$i  count=$count"

        until ($i->is_odd) {
          $i->brsft(1);
          $downs++;
          ### halve: "$i  count=$count"
          last OUTER if $i <= $end;
        }
      }
    }

    $i = 3*$i + 1;
    $ups++;
    ### tripled: "$i  count=$count"
  }

  my $step_type = $self->{'step_type'};
  if ($step_type eq 'up') {
    return $ups;
  }
  if ($step_type eq 'down') {
    return $downs;
  }
  if ($step_type eq 'completeness') {
    return $ups / $downs;
  }
  if ($step_type eq 'residue') {
    # log(Res(N)) = O(N)*log(3) - E(N)*log(2) + log(N)
    return $ups*log(3) - $downs*log(2) + log($orig_i);
  }
  return $ups + $downs;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == int($value)
          && $value >= $self->values_min);
}

1;
__END__

=for stopwords Ryde Math-NumSeq Collatz

=head1 NAME

Math::NumSeq::CollatzSteps -- steps in the "3n+1" problem

=head1 SYNOPSIS

 use Math::NumSeq::CollatzSteps;
 my $seq = Math::NumSeq::CollatzSteps->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The number of steps it takes to reach 1 by the Collatz "3n+1" problem,

    0, 1, 7, 2, 5, 8, 16, 3, 19, 6, 14, 9, 9, 17, 17, 4, 12, 20, 20, ...
    starting i=1

The Collatz problem iterates

    n -> / 3n+1  if n odd
         \ n/2   if n even

For example i=6 takes value=8 many steps to reach 1,

    6 -> 3 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1

It's conjectured that any starting n will always eventually reduce to 1 and
so the number of steps is finite.  There's no limit in the code on how many
steps counted.  C<Math::BigInt> is used if 3n+1 steps go past the usual
scalar integer limit.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::CollatzSteps-E<gt>new ()>

=item C<$seq = Math::NumSeq::CollatzSteps-E<gt>new (step_type =E<gt> $str)>

Create and return a new sequence object.

The optional C<step_type> parameter (a string) selects between

    "up"      upward steps 3n+1
    "down"    downward steps n/2
    "both"    both up and down (the default)

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the number of steps to take C<$i> down to 1.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as a step count.  This is simply C<$value
E<gt>= 0>.

=cut

# i=2^k steps down n->n/2
# n odd n -> 3n+1 want == 2 mod 4
# 3n+1 == 2 mod 4
# 3n == 1 mod 4
# 3*1=3 3*2=6 3*3=9
# so n == 3 mod 4
# 4k+3 is odd -> 3*(4k+3)+1 = 12k+8 -> 3k+2
# 3k+2 == 1 mod 4
# 2,5,8,11  k=4j+1
# 3(4j+1)+2 = 12j+5

=pod

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::JugglerSteps>,
L<Math::NumSeq::ReverseAddSteps>
L<Math::NumSeq::HappySteps>

=head1 HOME PAGE

L<http://user42.tuxfamily.org/math-numseq/index.html>

=head1 LICENSE

Copyright 2011, 2012, 2013 Kevin Ryde

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
