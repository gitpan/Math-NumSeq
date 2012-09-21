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


# period(period(...period(m)))
# p^(w+1)[m]=p^w[m]  at w=Fibonacci frequency, for w>=1
# A001178 Fibonacci frequency of n.
#


package Math::NumSeq::FibonacciFrequency;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 51;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

use Math::NumSeq::PisanoPeriod;
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('Fibonacci frequency, how many applications of the PisanoPeriod to reach an unchanging value.');
use constant i_start => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant characteristic_count => 1;

use constant values_min => 0;

#------------------------------------------------------------------------------

use constant oeis_anum => 'A001178';

#------------------------------------------------------------------------------

# sub ith {
#   my ($self, $i) = @_;
#   ### FibonacciFrequency ith(): $i
# 
#   if (_is_infinite($i)) {
#     return $i;
#   }
# 
#   $i = $self->Math::NumSeq::PisanoPeriod::ith($i);
#   if (! defined $i) {
#     return undef;
#   }
#   my $count = 1;
# 
#   for (;;) {
#     my $p = $self->Math::NumSeq::PisanoPeriod::ith($i);
#     if (! defined $p) {
#       return undef;
#     }
#     if ($p == $i) {
#       return $count;
#     }
#     $i = $p;
#     $count++;
#   }
# }

use vars '%cache';
my $tempdir;
use constant::defer _cache => sub {
  require SDBM_File;
  require File::Temp;
  $tempdir = File::Temp->newdir;
  ### $tempdir
  ### tempdir: $tempdir->dirname
  tie (%cache, 'SDBM_File',
       File::Spec->catfile ($tempdir->dirname, "cache"),
       Fcntl::O_RDWR()|Fcntl::O_CREAT(),
       0666)
    or die "Couldn't tie SDBM file 'filename': $!; aborting";

  END {
    if ($tempdir) {
      ### unlink cache ...
      untie %cache;
      my $dirname = $tempdir->dirname;
      unlink File::Spec->catfile ($dirname, "cache.pag");
      unlink File::Spec->catfile ($dirname, "cache.dir");
    }
  }
  # END {
  #   if ($tempdir) {
  #     ### cache diagnostics ...
  #     my $count = 0;
  #     while (each %cache) {
  #       $count++;
  #     }
  #     untie %cache;
  #     my $dirname = $tempdir->dirname;
  #     print "cache final $count file sizes cache.pag ",
  #       (-s File::Spec->catfile($dirname,"cache.pag")),
  #         " cache.dir ",
  #           (-s File::Spec->catfile($dirname,"cache.dir")),
  #             "\n";
  #   }
  # }
  return \%cache;
};

sub ith {
  my ($self, $i) = @_;
  ### FibonacciFrequency ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  if ($i == 1) {
    return 0;
  }

  my $c = _cache()->{$i};
  if (! defined $c) {
    ### calculate ...

    $c = -1; # default undef for outside range
    my @pending = ($i);
    if (defined ($i = $self->Math::NumSeq::PisanoPeriod::ith($i))) {
      for (;;) {
        ### at: "i=$i"

        my $p = $self->Math::NumSeq::PisanoPeriod::ith($i);
        if (! defined $p) {
          ### outside range of PisanoPeriod ...
          last;
        }
        if ($p == $i) {
          ### same: "i=$i p=$p"
          $c = 0;
          last;
        }
        ### not same: "i=$i p=$p"

        if (defined ($c = $cache{$i})) {
          ### found cache: "i=$i cache=$c"
          last;
        }
        push @pending, $i;
        $i = $p;
      }

      ### @pending
      foreach (reverse @pending) {
        if ($c >= 0) { $c++; }
        ### store: "$_ count $c"
        $cache{$_} = $c;
      }
    }
  }
  ### return: $c
  return ($c >= 0 ? $c : undef);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::FibonacciFrequency -- number of applications of the PisanoPeriod until a fixed value

=head1 SYNOPSIS

 use Math::NumSeq::FibonacciFrequency;
 my $seq = Math::NumSeq::FibonacciFrequency->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the number of times the PisanoPeriod must be applied before reaching
an unchanging value.

    starting i=1
    0, 4, 3, 2, 3, 1, 2, 2, 1, 2, 3, 1, 3, 2, 3, 1, 2, 1, 2, ...

Per Fulton and Morris, repeatedly applying the PisanoPeriod eventually
reaches a value m which has PisanoPeriod(m)==m.  For example i=5 goes

    PisanoPeriod(5)=20
    PisanoPeriod(20)=60
    PisanoPeriod(60)=60
    PisanoPeriod(120)=120
    so value=3 applications until to reach unchanging 120

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::FibonacciFrequency-E<gt>new ()>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the Leonardo logarithm period of C<$i>.

=cut

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

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
