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

package Math::NumSeq::Repdigits;
use 5.004;
use strict;

use Math::NumSeq;
use base 'Math::NumSeq';
use Math::NumSeq::Base::Digits;

use vars '$VERSION';
$VERSION = 1;

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Repdigits');
use constant description => Math::NumSeq::__('Numbers which are a "repdigit", meaning 0, 1 ... 9, 11, 22, 33, ... 99, 111, 222, 333, ..., 999, etc.  The default is decimal, or select a radix.');
use constant characteristic_monotonic => 1;
use constant values_min => 1;
use constant parameter_info_array =>
  [ Math::NumSeq::Base::Digits::parameter_common_radix() ];

sub oeis_anum {
  my ($class_or_self) = @_;
  my $radix = (ref $class_or_self
               ? $class_or_self->{'radix'}
               : $class_or_self->parameter_default('radix'));
  return ($radix == 10
          ? 'A010785'  # starting from i=0
          : undef);
}
# OEIS-Catalogue: A010785 radix=10

sub rewind {
  my ($self) = @_;
  my $radix = $self->{'radix'};
  if ($radix < 2) { $radix = $self->{'radix'} = 10; }

  if ($radix == 2) {
    $self->{'i'} = 0;
  } else {
    $self->{'n'} = -1;
    $self->{'inc'} = 1;
    $self->{'digit'} = -1;
  }
}
sub next {
  my ($self) = @_;

  my $i = $self->{'i'}++;
  my $radix = $self->{'radix'};
  if ($radix == 2) {
    return (1 << $i) - 1;

  } else {
    my $n = ($self->{'n'} += $self->{'inc'});
    if (++$self->{'digit'} >= $radix) {
      $self->{'inc'} = $self->{'inc'} * $radix + 1;
      $self->{'digit'} = 1;
      $self->{'n'} = ($n += 1); # not ++$n as that gives warnings on overflow
      ### digit: $self->{'digit'}
      ### inc: $self->{'inc'}
      ### $n
    }
    return ($i, $n);
  }
}

sub pred {
  my ($self, $n) = @_;
  my $radix = $self->{'radix'};
  if ($radix == 2) {
    return ! (($n+1) & $n);
  }
  if ($radix == 10) {
    my $digit = substr($n,0,1);
    return ($n !~ /[^$digit]/);

  } else {
    my $digit = $n % $radix;
    while ($n = int($n/$radix)) {
      if (($n % $radix) != $digit) {
        return 0;
      }
    }
    return 1;
  }
}

sub ith {
  my ($self, $i) = @_;
  my $radix = $self->{'radix'};

  if ($radix == 2) {
    return (1 << $i) - 1;
  }

  if (--$i < 0) {
    return 0;
  }
  my $digit = ($i % ($radix-1)) + 1;
  $i = int($i/($radix-1)) + 1;
  return ($radix ** $i - 1) / ($radix - 1) * $digit;
}

1;
__END__

=for stopwords Ryde Math-NumSeq repdigit repdigits

=head1 NAME

Math::NumSeq::Repdigits -- repdigits 11, 22, 33, etc

=head1 SYNOPSIS

 use Math::NumSeq::Repdigits;
 my $seq = Math::NumSeq::Repdigits->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of repdigit numbers, 1 ... 9, 11, 22, 33, ... 99, 111, 222,
333, ..., 999, etc, comprising repetitions of a single digit.  The default
is decimal or a C<radix> parameter can be given.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::Repdigits-E<gt>new ()>

=item C<$seq = Math::NumSeq::Repdigits-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th repdigit.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a repdigit.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Beastly>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011 Kevin Ryde

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
