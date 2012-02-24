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



# David Madore  Oct 24 2004, 8:00 pm
# http://sci.tech-archive.net/Archive/sci.math.research/2004-10/0218.html
#
# Benoit Cloitre followups
# http://sci.tech-archive.net/Archive/sci.math.research/2004-10/0224.html
# http://sci.tech-archive.net/Archive/sci.math.research/2004-11/0015.html
# http://sci.tech-archive.net/Archive/sci.math.research/2004-11/0021.html
#


package Math::NumSeq::ReReplace;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 35;

use Math::NumSeq 7; # v.7 for _is_infinite()
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;

use constant description => Math::NumSeq::__('...');
use constant values_min => 1;
use constant i_start => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;

# 'A100002'
# 0  1  2  3  4  5  6  7  8  9
# 1, 2, 1, 2, 3, 3, 1, 2, 4, 4, 3, 4, 1, 2, 5, 5, 3, 5, 1, 2, 4, 5, 3, 4,
#             1  2        1  2

# cf A100287 - first occurrence of n
#    A101224
#    
use constant oeis_anum => 'A100002';

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  my $count = $self->{'count'} = [undef, [], []];
}
sub next {
  my ($self) = @_;
  ### ReReplace next(): $self->{'i'}

  my $count = $self->{'count'};
  ### $count

  my $value = 1;
  for my $level (2 .. $#$count) {
    ### $level
    ### $value
    ### count: ($count->[$level]->[$value]||0) + 1

    if (++$count->[$level]->[$value] >= $level) {
      $count->[$level]->[$value] = 0;
      $value = $level;
    }
  }

  if ($value >= $#$count-1) {
    push @$count, [ @{$count->[-1]} ];  # array copy
    ### extended to: $count
  }

  ### return: $value
  return ($self->{'i'}++,
          $value);
}

sub pred {
  my ($self, $value) = @_;
  ### Runs pred(): $value

  return ($value >= 1
          && $value == int($value));
}

1;
__END__

=for stopwords Ryde OEIS

=head1 NAME

Math::NumSeq::ReReplace -- sequence of repeated replacements

=head1 SYNOPSIS

 use Math::NumSeq::ReReplace;
 my $seq = Math::NumSeq::ReReplace->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a sequence by David Madore formed by repeatedly replacing every N'th
occurrance of a term with N.

    1, 2, 1, 2, 3, 3, 1, 2, 4, 4, 3, 4, ...

=head2 Algorithm

The generating procedure sieve begins with all 1s,

    initial: 1,1,1,1,1,1,1,1,1,1,1,1,...

Then every second 1 is changed to 2

    replace[2]: 1,2,1,2,1,2,1,2,1,2,1,2,...

Then every third 1 is changed to 3, and every third 2 changed to 3 also,

    replace[3]: 1,2,1,2,3,3,1,2,1,2,3,3,...

Then every fourth 1 becomes 4, fourth 2 becomes 4, fourth 3 becomes 4.

    replace[4]: 1,2,1,2,3,3,1,2,4,4,3,4,...

The replacement of every Nth with N is applied separately to the 1s, 2s, 3s
etc remaining at each stage.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::ReReplace-E<gt>new ()>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence.  This merely means integer
C<$value E<gt>= 1>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::ReRound>

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
