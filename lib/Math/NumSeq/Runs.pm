# Copyright 2011, 2012 Kevin Ryde

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



# cf A010751 - runs incr then decr



package Math::NumSeq::Runs;
use 5.004;
use strict;
use Carp;

use vars '$VERSION','@ISA';
$VERSION = 35;

use Math::NumSeq 21; # v.21 for oeis_anum field
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('Runs of integers of various kinds.');
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;

# d = -1/2 + sqrt(2 * $n + -3/4)
#   = (sqrt(8*$n-3) - 1)/2

use constant parameter_info_array =>
  [
   {
    name    => 'runs_type',
    display => Math::NumSeq::__('Runs Type'),
    type    => 'enum',
    default => '0toN',
    choices => ['0toN','1toN','1to2N','0toNinc',
                'Nto0','Nto1',
                'Nrep','N+1rep','2rep','3rep',
               ],
    # description => Math::NumSeq::__(''),
   },
  ];

# cf A049581 diagonals absdiff, abs(x-y) not plain runs
#
my %runs_type_data
  = ('0toN' => { i_start    => 0,
                 value      => -1, # initial
                 values_min => 0,
                 limit      => 1,
                 vstart     => 0,
                 vstart_inc => 0,
                 value_inc  => 1,
                 c          => 1, # initial
                 count      => 0,
                 count_inc  => 1,
                 oeis_anum  => 'A002262',
                 # OEIS-Catalogue: A002262 runs_type=0toN
               },

     '1toN' => { i_start    => 1,
                 value      => 0, # initial
                 values_min => 1,
                 limit      => 1,
                 vstart     => 1,
                 vstart_inc => 0,
                 value_inc  => 1,
                 c          => 1, # initial
                 count      => 0,
                 count_inc  => 1,
                 oeis_anum  => 'A002260',  # 1 to N, is 0toN + 1
                 # OEIS-Catalogue: A002260 runs_type=1toN
               },
     '1to2N' => { i_start    => 1,
                  value      => 0, # initial
                  values_min => 1,
                  limit      => 1,
                  vstart     => 1,
                  vstart_inc => 0,
                  value_inc  => 1,
                  c          => 2, # initial
                  count      => 1,
                  count_inc  => 2,
                  oeis_anum  => 'A074294',
                  # OEIS-Catalogue: A074294 runs_type=1to2N
                },
     'Nto0' => { i_start    => 0,
                 value      => 1, # initial
                 values_min => 0,
                 vstart     => 0,
                 vstart_inc => 1,
                 value_inc  => -1,
                 c          => 1, # initial
                 count      => 0,
                 count_inc  => 1,
                 oeis_anum  => 'A025581',
                 # OEIS-Catalogue: A025581 runs_type=Nto0
               },
     'Nto1' => { i_start    => 1,
                 value      => 2, # initial
                 values_min => 1,
                 vstart     => 1,
                 vstart_inc => 1,
                 value_inc  => -1,
                 c          => 1, # initial
                 count      => 0,
                 count_inc  => 1,
                 oeis_anum  => 'A004736',
                 # OEIS-Catalogue: A004736 runs_type=Nto1
               },
     'Nrep' => { i_start    => 1,
                 value      => 1,
                 values_min => 1,
                 value_inc  => 0,
                 vstart     => 1,
                 vstart_inc => 1,
                 limit      => 1,
                 c          => 1, # initial
                 count      => 0,
                 count_inc  => 1,
                 oeis_anum  => 'A002024', # N appears N times
                 # OEIS-Catalogue: A002024 runs_type=Nrep
               },
     'N+1rep' => { i_start    => 0,
                   value      => 0,
                   values_min => 0,
                   value_inc  => 0,
                   vstart     => 0,
                   vstart_inc => 1,
                   limit      => 1,
                   c          => 1, # initial
                   count      => 0,
                   count_inc  => 1,
                   oeis_anum  => 'A003056', # N appears N+1 times
                   # OEIS-Catalogue: A003056 runs_type=N+1rep
                 },
     '0toNinc' => { i_start    => 0,
                    value      => -1,
                    values_min => 0,
                    value_inc  => 1,
                    vstart     => 0,
                    vstart_inc => 1,
                    limit      => 1,
                    c          => 1, # initial
                    count      => 0,
                    count_inc  => 1,
                    oeis_anum  => 'A051162',
                    # OEIS-Catalogue: A051162 runs_type=0toNinc
                  },
    );
# {
#   my @a = keys %runs_type_data;
#   ### assert: scalar(@{parameter_info_array()->[0]->{'choices'}}) == scalar(@a)
# }

my @rep_oeis_anum = (undef, # 0rep, nothing

                     'A001477',  # 1rep, integers 0 upwards
                     # OEIS-Other: A001477 runs_type=1rep

                     'A004526', # 2rep, N appears 2 times
                     # OEIS-Catalogue: A004526 runs_type=2rep

                     'A002264', # 3rep, N appears 3 times
                     # OEIS-Catalogue: A002264 runs_type=3rep

                     'A002265', # 4rep
                     # OEIS-Catalogue: A002265 runs_type=4rep

                     'A002266', # 5rep
                     # OEIS-Catalogue: A002266 runs_type=5rep

                     'A152467', # 6rep
                     # OEIS-Catalogue: A152467 runs_type=6rep

                     # no, A132270 has OFFSET=1 (with 7 initial 0s)
                     # 'A132270', # 7rep
                     # # OEIS-Catalogue: A132270 runs_type=7rep

                     # no, A132292 has OFFSET=1 (with 8 initial 0s)
                     # 'A132292', # 8rep
                     # # OEIS-Catalogue: A132292 runs_type=8rep

                    );
sub rewind {
  my ($self) = @_;
  $self->{'runs_type'} ||= '0toN';

  my $data;
  if ($self->{'runs_type'} =~ /^(\d+)rep/) {
    my $rep = $1;
    $data = { i_start    => 0,
              value      => 0,
              values_min => 0,
              value_inc  => 0,
              vstart     => 0,
              vstart_inc => 1,
              limit      => 1,
              c          => $rep,   # initial
              count      => $rep-1,
              count_inc  => 0,
              oeis_anum  => $rep_oeis_anum[$rep],
            };
  } else {
    $data = $runs_type_data{$self->{'runs_type'}}
      || croak "Unrecognised runs_type: ", $self->{'runs_type'};
  }

  %$self = (%$self,
            i => 0,
            %$data);
}

  sub next {
    my ($self) = @_;
    my $i = $self->{'i'}++;
    if (--$self->{'c'} >= 0) {
      return ($i,
              ($self->{'value'} += $self->{'value_inc'}));
    } else {
      $self->{'c'} = ($self->{'count'} += $self->{'count_inc'});
      return ($i,
              ($self->{'value'} = ($self->{'vstart'} += $self->{'vstart_inc'})));
    }
  }

sub ith {
  my ($self, $i) = @_;
  ### Runs ith(): $i

  if ($i < 0) {
    return undef;
  }
  if ($self->{'runs_type'} eq 'Nto0' || $self->{'runs_type'} eq 'Nto1') {
    # d-(i-(d-1)*d/2)
    #   = d-i+(d-1)*d/2
    #   = d*(1+(d-1)/2) - i
    #   = d*((d+1)/2) - i
    #   = (d+1)d/2 - i

    $i -= $self->{'i_start'};
    my $d = int((sqrt(8*int($i)+1) + 1) / 2);
    ### $d
    ### base: ($d-1)*$d/2
    ### rem: $i - ($d-1)*$d/2
    return -$i + ($d+1)*$d/2 - 1 + $self->{'values_min'};

  } elsif ($self->{'runs_type'} eq 'Nrep'
           || $self->{'runs_type'} eq 'N+1rep') {
    $i -= $self->{'i_start'};
    return int((sqrt(8*int($i)+1) - 1) / 2) + $self->{'values_min'};

  } elsif ($self->{'runs_type'} eq '0toNinc') {
    # i-(d-1)d/2 + d
    #   = i-((d-1)d/2 - d)
    #   = i-(d-3)d/2
    my $d = int((sqrt(8*int($i)+1) + 1) / 2);
    return $i - ($d-3)*$d/2 - 1;

  } elsif ($self->{'runs_type'} =~ /^(\d+)rep/) {
    my $rep = $1;
    ### $rep
    if ($rep < 1) {
      return undef;
    }
    return int($i/$rep);

  } elsif ($self->{'runs_type'} eq '1to2N') {
    # N = (d^2 + d)
    #   = (($d + 1)*$d)
    # d = -1/2 + sqrt(1 * $n + 1/4)
    #   = (-1 + 2*sqrt($n + 1/4)) / 2
    #   = (-1 + sqrt(4*$n + 1)) / 2
    #   = (sqrt(4*$n + 1) - 1) / 2

    $i -= 1;
    my $d = int((sqrt(4*int($i)+1) - 1) / 2);

    ### $d
    ### base: ($d-1)*$d/2
    ### rem: $i - ($d-1)*$d/2

    return $i - ($d+1)*$d + $self->{'vstart'};

  } else { # 0toN, 1toN
    $i -= $self->{'i_start'};
    my $d = int((sqrt(8*int($i)+1) + 1) / 2);

    ### $d
    ### base: ($d-1)*$d/2
    ### rem: $i - ($d-1)*$d/2

    return $i - ($d-1)*$d/2 + $self->{'vstart'};
  }
}

sub pred {
  my ($self, $value) = @_;
  ### Runs pred(): $value

  unless ($value == int($value)) {
    return 0;
  }
  if (defined $self->{'values_min'}) {
    return ($value >= $self->{'values_min'});
  } else {
    return ($value <= $self->{'values_max'});
  }
}

1;
__END__

=for stopwords Ryde

=head1 NAME

Math::NumSeq::Runs -- runs of consecutive integers

=head1 SYNOPSIS

 use Math::NumSeq::Runs;
 my $seq = Math::NumSeq::Runs->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is various kinds of runs of integers.  The C<runs_type> parameter (a
string) can be

    "0toN"      0, 0,1, 0,1,2, 0,1,2,3, etc runs 0..N
    "1toN"      1, 1,2, 1,2,3, 1,2,3,4, etc runs 1..N
    "1to2N"     1,2, 1,2,3,4, 1,2,3,4,5,6 etc runs 1..2N
    "Nto0"      0, 1,0, 2,1,0, 3,2,1,0, etc runs N..0
    "Nto1"      1, 2,1, 3,2,1, 4,3,2,1, etc runs N..1
    "0toNinc"   0, 1,2, 2,3,4, 3,4,5,6, etc runs 0..N increasing
    "Nrep"      1, 2,2, 3,3,3, 4,4,4,4, etc N repetitions of N
    "N+1rep"    0, 1,1, 2,2,2, 3,3,3,3, etc N+1 repetitions of N
    "2rep"      0,0, 1,1, 2,2, etc two repetitions of each N
    "3rep"      0,0,0, 1,1,1, 2,2,2, etc three repetitions of N

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::Runs-E<gt>new (runs_type =E<gt> $str)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value from the sequence.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence.  This is merely all integer
C<$value E<gt>= 0> or C<E<gt>= 1> according to the start of the
C<runs_type>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::AllDigits>

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