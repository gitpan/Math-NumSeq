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

package Math::NumSeq::Odd;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 52;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Odd Integers');
use constant description => Math::NumSeq::__('The odd integers 1, 3, 5, 7, 9, etc, 2i+1.');
use constant values_min => 1;
use constant default_i_start => 0;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant oeis_anum => 'A005408'; # odd 1,3,5,...

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;   # int ($self->{'lo'} / 2);
}
sub seek_to_i {
  my ($self, $i) = @_;
  $self->{'i'} = $i;
}
sub seek_to_value {
  my ($self, $value) = @_;
  $self->seek_to_i($self->value_to_i_ceil($value));
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, 2*$i+1);
}
sub ith {
  my ($self, $i) = @_;
  return 2*$i+1; # $self->{'lo'} + 2*$i;
}
sub pred {
  my ($self, $value) = @_;
  ### Odd pred(): $value
  return ($value == int($value)
          && ($value % 2));
}

sub value_to_i {
  my ($self, $value) = @_;
  my $int = int($value);
  if ($value == $int
      && ($int % 2) == 1) {
    return ($int-1)/2;
  }
  return undef;
}
sub value_to_i_floor {
  my ($self, $value) = @_;
  if (($value -= 1) < 0) {
    my $i = int($value/2);
    if (2*$i > $value) {
      return $i-1;
    } else {
      return $i;
    }
  } else {
    return int($value/2);
  }
}
sub value_to_i_ceil {
  my ($self, $value) = @_;
  $value -= 1;
  my $i = int($value/2);
  if (2*$i < $value) {
    return $i+1;
  } else {
    return $i;
  }
}
sub value_to_i_estimate {
  my ($self, $value) = @_;
  return int(($value-1)/2);
}

# sub new {
#   my ($class, %self) = @_;
#   if (defined $self{'lo'}) {
#     $self{'lo'} = ceil($self{'lo'});     # next integer
#     $self{'lo'} += ! ($self{'lo'} & 1);  # next odd, if not already odd
#   } else {
#     $self{'lo'} = 1;
#   }
#   my $self = bless \%self, $class;
#   $self->rewind;
#   return $self;
# }

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Odd -- odd integers

=head1 SYNOPSIS

 use Math::NumSeq::Odd;
 my $seq = Math::NumSeq::Odd->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The odd integers 1, 3, 5, 7, etc.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Odd-E<gt>new ()>

Create and return a new sequence object.

=item C<$seq-E<gt>seek_to_i($i)>

Move the current sequence position to C<$i>.  The next call to C<next()>
will return C<$i> and corresponding value.

=item C<$seq-E<gt>seek_to_value($value)>

Move the current i so that C<next()> gives C<$value> on the next call, or if
C<$value> is an even integer then the next higher even.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return C<2*$i + 1>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is odd.

=item C<$i = $seq-E<gt>value_to_i_ceil($value)>

=item C<$i = $seq-E<gt>value_to_i_floor($value)>

Return (value-1)/2 rounded up or down to the next integer.

=item C<$i = $seq-E<gt>value_to_i_estimate($value)>

Return an estimate of the i corresponding to C<$value>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Even>,
L<Math::NumSeq::All>

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
