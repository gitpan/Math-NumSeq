# Copyright 2011 Kevin Ryde

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

package Math::NumSeq::GolombSequence;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 15;

use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;

use constant description => Math::NumSeq::__('Golomb sequence 1,2,2,3,3,4,4,4,etc, its own repetition count.');
use constant characteristic_smaller => 1;
use constant characteristic_monotonic => 1;
use constant values_min => 1;
use constant i_start => 1;

# A001463 golomb partial sums
#
use constant oeis_anum => 'A001462';  # Golomb sequence

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 1;
  @{$self->{'digits'}} = (1);
  @{$self->{'counts'}} = (2);
}

sub next {
  my ($self) = @_;
  ### GolombSequence next(): "$self->{'i'}"

  my $counts = $self->{'counts'};
  my $digits = $self->{'digits'};
  my $pos = -1;
  my $digit;
  for (;;) {
    if (++$pos > $#$counts) {
      ### all zeros to pos: $pos
      if ($pos == 1 && $digits->[0] == 1) {
        ### special case i=2,i=3 digit 2 ...
        $counts->[0] = 2;
        return ($self->{'i'}++, ($digits->[0] = 2));
      }
      ### extend for get i=3 leave i=4 state ...
      push @$counts, 1;
      push @$digits, ($digit = 2);
      last;
    }
    if (--$counts->[$pos]) {
      ### non-zero count at: "pos=$pos digit=$digits->[$pos], remaining count=$counts->[$pos]"
      $digit = $digits->[$pos];
      last;
    }
  }

  while (--$pos >= 0) {
    $counts->[$pos] = $digit;
    $digit = ++$digits->[$pos];
  }
  return ($self->{'i'}++, $digit);

}

1;
__END__

  # my $pending = $self->{'pending'};
  # # unless (@$pending) {
  # #   push @$pending, ($self->{'digit'}) x $self->{'digit'};
  # #   # ($self->{'digit'} ^= 3);
  # # }
  # my $ret = shift @$pending;
  # ### $ret
  # ### append: ($self->{'digit'} ^ 3)
  # 
  # push @$pending, (($self->{'digit'} ^= 3) x $ret);
  # 
  # # A025142
  # # push @$pending, (($self->{'digit'}) x $ret);
  # # $self->{'digit'} ^= 3;
  # 
  # ### now pending: @$pending
  # return ($self->{'i'}++, $ret);


=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::GolombSequence -- sequence is its own run lengths, 1 upwards

=head1 SYNOPSIS

 use Math::NumSeq::GolombSequence;
 my $seq = Math::NumSeq::GolombSequence->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

A sequence 1,2,2,3,3,4,4,4,5,5,5,etc, each run length being given by the
sequence itself at i=n.

Starting from 1,2, at i=2 the values is 2, so there should be a run of two
2s.  Then at i=3 value 2 means two 3s.  Then at i=4 value 3 means a run of
three 4s, and so on.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::GolombSequence-E<gt>new ()>

Create and return a new sequence object.

=back

=head1 SEE ALSO

L<Math::NumSeq>

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
# compile-command: "math-image --values=GolombSequence"
# End:
