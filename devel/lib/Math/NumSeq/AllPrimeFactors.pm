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

package Math::NumSeq::AllPrimeFactors;
use 5.004;
use strict;
use Math::Prime::XS 0.23 'is_prime'; # version 0.23 fix for 1928099
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()

use vars '$VERSION', '@ISA';
$VERSION = 40;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::NumSeq 7; # v.7 for _is_infinite()
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Primes;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('All Prime Factors');
use constant description => Math::NumSeq::__('Prime factors of the integers.');
use constant default_i_start => 1;
use constant characteristic_smaller => 2;

use constant parameter_info_array =>
  [
   {
    name      => 'order',
    display   => Math::NumSeq::__('Order'),
    share_key => 'order_as',
    type      => 'enum',
    default   => 'ascending',
    choices   => ['ascending','descending'],
    choices_display => [Math::NumSeq::__('Ascending'),
                        Math::NumSeq::__('Descending'),
                       ],
    description => Math::NumSeq::__('Order for the digits within each integer.'),
   },
   { name    => 'multiplicity',
     display => Math::NumSeq::__('Multiplicity'),
     type    => 'enum',
     choices => ['repeated','distinct'],
     choices_display => [Math::NumSeq::__('Repeated'),
                         Math::NumSeq::__('Distinct'),
                        ],
     default => 'repeated',
     description => Math::NumSeq::__('Whether to include repeated prime factors, or only distinct prime factors.'),
   },
   {
    name    => 'on_values',
    display => Math::NumSeq::__('On Values'),
    type    => 'enum',
    default => 'all',
    choices => ['all','composites','odd','even'],
    choices_display => [Math::NumSeq::__('All'),
                        Math::NumSeq::__('Composites'),
                        Math::NumSeq::__('Odd'),
                        Math::NumSeq::__('Even')],
     description => Math::NumSeq::__('The values to take prime factors from, either all integers or just composites, odds or evens.'),
   },
  ];

my %values_min = (all        => 2,
                  composites => 2,
                  odd        => 3,
                  even       => 2);
sub values_min {
  my ($self) = @_;
  return $values_min{$self->{'on_values'}};
}

#------------------------------------------------------------------------------
# cf A033308 - concatenate primes digits

my %oeis_anum;
# $oeis_anum{'repeated'}->{'ascending'} = 'A';

sub oeis_anum {
  my ($self) = @_;
  ### $self
  return $oeis_anum{$self->{'multiplicity'}}->{$self->{'order'}};
}

#------------------------------------------------------------------------------

my %n_step = (all        => 1,
              composites => 1,
              odd        => 2,
              even       => 2);
my %n_start = (all        => 2-1,
               composites => 2-1,
               odd        => 3-2,
               even       => 2-2);
sub rewind {
  my ($self) = @_;
  my $i_start = $self->i_start;
  $self->{'n_step'} = $n_step{$self->{'on_values'}};
  $self->{'n'} = $n_start{$self->{'on_values'}};
  $self->{'pending'} = [ ];
}
sub next {
  my ($self) = @_;
  ### AllDigits next(): $self->{'i'}

  my $value;
  unless (defined ($value = shift @{$self->{'pending'}})) {
    my $pending = $self->{'pending'};
    my $n = ($self->{'n'} += $self->{'n_step'});

    if ($self->{'on_values'} eq 'composites') {
      while (is_prime($n)) {
        $n = ++$self->{'n'};
      }
    }

    @$pending = prime_factors($n);
    if ($self->{'multiplicity'} eq 'distinct') {
      my $prev = 0;
      @$pending = grep { $_ == $prev ? () : ($prev=$_) } @$pending;
    }
    my $order = $self->{'order'};
    if ($order eq 'descending') {
      @$pending = reverse @$pending;
    }
    $value = shift @$pending;
  }
  return ($self->{'i'}++, $value);
}

sub pred {
  my ($self, $value) = @_;
  if ($self->{'on_values'} eq 'odd' && $value < 3) {
    return 0;
  }
  return Math::NumSeq::Primes->pred($value);
}

1;
__END__

=for stopwords Ryde Math-NumSeq radix

=head1 NAME

Math::NumSeq::AllPrimeFactors -- prime factors of the integers

=head1 SYNOPSIS

 use Math::NumSeq::AllPrimeFactors;
 my $seq = Math::NumSeq::AllPrimeFactors->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the prime factors of integers 2, 3, 4, etc

    # starting i=1
    2, 3, 2, 2, 5, 2, 3, 7, 2, 2, 2, 3, 3, 2, 5, 11, ...

=head2 Order

The optional C<order> parameter (a string) can control the order of the
primes of each integer,

    "ascending"     the default
    "descending"

For example desending rearranges the values to

    2, 3, 2, 2, 5, 3, 2, 7, 2, 2, 2, 3, 3, 5, 2, 11, ...

The first difference is at 5,3,2 instead of 5,2,3, those 2,3 being the prime
factors of 6 either ascending or descending.

=head2 Multiplicity

Option C<multiplicity =E<gt> "distinct"> can give just one copy of each
prime factor.  For example with 9=3*3 gives just one value 3 in the sequence
instead of two.

    2, 3, 2, 5, 2, 3, 7, 2, 3, 2, 5, 11, ...

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Digit-E<gt>new ()>

=item C<$seq = Math::NumSeq::Digit-E<gt>new (radix =E<gt> $r, order =E<gt> $o)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means C<$value> is a
prime, or for C<on_values=E<gt>'odd'> an odd prime.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::PrimeFactorCount>,
L<Math::NumSeq::AllDigits>,
L<Math::NumSeq::SqrtPrimeFactors>

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
