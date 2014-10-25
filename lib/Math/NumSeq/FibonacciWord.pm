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


package Math::NumSeq::FibonacciWord;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 54;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

use Math::NumSeq::Fibbinary;

# uncomment this to run the ### lines
#use Smart::Comments;


sub description {
  my ($self) = @_;
  return (ref $self && $self->{'fibonacci_word_type'} eq 'dense'
          ? Math::NumSeq::__('0/1/2 dense Fibonacci word taking pairs from the plain word.')
          : Math::NumSeq::__('0/1 values related to Fibonacci numbers, 0,1,0,0,1,0,1,0,etc.'));
}
use constant default_i_start => 0;
use constant characteristic_integer => 1;
use constant values_min => 0;
sub values_max {
  my ($self) = @_;
  return ($self->{'fibonacci_word_type'} eq 'dense' ? 2 : 1);
}

use constant parameter_info_array =>
  [
   { name    => 'fibonacci_word_type',
     display => Math::NumSeq::__('Fibonacci Word Type'),
     type    => 'enum',
     default => 'plain',
     choices => ['plain','dense'],
     choices_display => [Math::NumSeq::__('Plain'),
                         Math::NumSeq::__('Dense'),
                        ],
     description => Math::NumSeq::__('Which of the pair of values to show.'),
   },
  ];

#------------------------------------------------------------------------------

# cf A003842 same with values 1/2 instead of 0/1
#    A014675 same with values 2/1 instead of 0/1
#    A001468 values 2/1 instead of 0/1, skip leading 0, self-referential
#    A005614 inverse 1/0, starting from 1
#
#    A003622 positions of 1s
#    A000201 positions of 0s
#    A089910 positions of 1,1 pairs
#    A114986 characteristic of A000201, with extra 1 ??
#    A096270 expressed as 01 and 011, is inverse with leading 0
#    A036299 values 0/1 inverse, bignum concatenating
#    A008352 values 1/2 inverse, bignum concatenating
#
#    A189479 0->01 1->101
#    A007066 positions of 0s
#    A076662 first diffs of positions, values 3/2 with extra leading 3
#
#    A135817 whythoff repres 0s
#    A135818 whythoff repres 1s
#    A189921 whythoff form
#    A135817 whythoff length A+B
#

# A003849 OFFSET=0 values 0,1, 0,0, 1,0, 1,0, etc
# A143667 OFFSET=1 values 1,0,2,2,etc
#
my %oeis_anum
  = (
     # OEIS-Catalogue array begin
     plain => 'A003849', #
     'dense,i_start=1,i_offset=-1' => 'A143667', # fibonacci_word_type=dense i_start=1 i_offset=-1
     # OEIS-Catalogue array end
    );
sub oeis_anum {
  my ($self) = @_;
  my $key = $self->{'fibonacci_word_type'};
  my $i_start = $self->i_start;
  if ($i_start != $self->default_i_start) {
    $key .= ",i_start=$i_start";
  }
  if ($self->{'i_offset'}) {
    $key .= ",i_offset=$self->{'i_offset'}";
  }
  return $oeis_anum{$key};
}

#------------------------------------------------------------------------------
# i_offset is a hack to number A143667 starting OFFSET=1, whereas otherwise
# here start i=0

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'value'} = 0;
  $self->{'i_offset'} ||= 0;
}
sub next {
  my ($self) = @_;
  ### FibonacciWord next() ...

  if ($self->{'fibonacci_word_type'} eq 'dense') {
    my $v = $self->{'value'};
    my $high = ($v & 1) << 1;

    my $filled = ($v >> 1) | $v;
    my $mask = (($filled+1) ^ $filled) >> 1;
    $v = ($v | $mask) + 1;

    $filled = ($v >> 1) | $v;
    $mask = (($filled+1) ^ $filled) >> 1;
    $self->{'value'} = ($v | $mask) + 1;

    return ($self->{'i'}++, $high | ($v & 1));

  } else {
    my $v = $self->{'value'};
    my $filled = ($v >> 1) | $v;
    my $mask = (($filled+1) ^ $filled) >> 1;
    $self->{'value'} = ($v | $mask) + 1;

    ### value : sprintf('0b %6b',$v)
    ### filled: sprintf('0b %6b',$filled)
    ### mask  : sprintf('0b %6b',$mask)
    ### bit   : sprintf('0b %6b',$mask+1)
    ### newv  : sprintf('0b %6b',$self->{'value'})

    return ($self->{'i'}++, $v & 1);
  }
}

sub ith {
  my ($self, $i) = @_;
  ### FibonacciWord ith(): $i

  $i = $i + $self->{'i_offset'};

  # if $i is inf or nan then $f0=$i*0 is nan and the while loop zero-trips
  # and return is nan

  my $f0 = ($i * 0) + 1;  # inherit bignum 1
  my $f1 = $f0 + 1;       # inherit bignum 2
  my $level = 0;
  ### start: "$f1,$f0  level=$level"

  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  while ($f0 <= $i-$f1) {
    ($f1,$f0) = ($f1+$f0,$f1);
    $level++;
  }
  ### above: "$f1,$f0  level=$level"


  if ($self->{'fibonacci_word_type'} eq 'dense') {
    my $v = Math::NumSeq::Fibbinary->ith(2*$i);
    my $high = ($v & 1) << 1;

    my $filled = ($v >> 1) | $v;
    my $mask = (($filled+1) ^ $filled) >> 1;
    $v = ($v | $mask) + 1;

    return ($high | ($v & 1));

  } else {

    do {
      ### at: "$f1,$f0  i=$i"
      if ($i >= $f1) {
        $i -= $f1;
      }
      ($f1,$f0) = ($f0,$f1-$f0);
    } while ($level--);

    ### assert: $i == 0 || $i == 1
    ### ret: $i
    return $i;
  }
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 0 || $value == 1
          || ($self->{'fibonacci_word_type'} eq 'dense'
              && $value == 2));
}

1;
__END__

=for stopwords Ryde Fibbinary Zeckendorf Math-NumSeq

=head1 NAME

Math::NumSeq::FibonacciWord -- 0/1 related to Fibonacci numbers

=head1 SYNOPSIS

 use Math::NumSeq::FibonacciWord;
 my $seq = Math::NumSeq::FibonacciWord->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a sequence of 0s and 1s formed from the Fibonacci numbers.

    starting i=0
    0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, ...

The initial values are 0,1 then Fibonacci number F(k) many values are copied
from the start to extend, so

    0,1                                         initial
    0,1,0                                       append 1 value
    0,1,0,0,1                                   append 2 values
    0,1,0,0,1,0,1,0                             append 3 values
    0,1,0,0,1,0,1,0,0,1,0,0,1                   append 5 values
    0,1,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,1,0,1,0   append 8 values
    etc

The same sequence is had by starting with 0 and then repeatedly expanding

    0 -> 0,1
    1 -> 0

The result is also the Fibbinary numbers modulo 2.  This can be seen most
easily from the Zeckendorf base interpretation of those numbers since the
base breakdown there works backwards from the above expansion subtracting
Fibonacci numbers F(k) until reaching 0 or 1.  (See
L<Math::NumSeq::Fibbinary/Zeckendorf Base>.)

=head2 Dense Fibonacci Word

Option C<fibonacci_word_type =E<gt> "dense"> selects the dense Fibonacci
word

    1,0,2,2,1,0,2,2,1,1,0,2,1,1,...

This is the above plain word taken two values at a time encoded as

    plain    dense
     0,0       0    
     0,1       1
     1,0       2

For example the plain Fibonacci word starts 0,1 so the dense form starts 1.
Adjacent 1,1 never occurs in the plain Fibonacci word, so there's no value 3
in the dense form.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::FibonacciWord-E<gt>new ()>

=item C<$seq = Math::NumSeq::FibonacciWord-E<gt>new (fibonacci_word_type =E<gt> "dense")>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value in the sequence.  The first value is at i=0.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means 0 or 1,
or for the dense Fibonacci word 0, 1 or 2.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::Fibbinary>

L<Math::PlanePath::FibonacciWordFractal>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

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
