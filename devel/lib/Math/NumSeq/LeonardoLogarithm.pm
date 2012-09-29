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


package Math::NumSeq::LeonardoLogarithm;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 52;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

use Math::NumSeq::PisanoPeriod;
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::NumAronson 8; # new in v.8
*_round_down_pow = \&Math::NumSeq::NumAronson::_round_down_pow;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
# use constant description => Math::NumSeq::__('...');
use constant i_start => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant characteristic_count => 1;

use constant values_min => 1;

#------------------------------------------------------------------------------

use constant oeis_anum => 'A001179';

#------------------------------------------------------------------------------

# sub ith {
#   my ($self, $i) = @_;
#   ### LeonardoLogarithm ith(): $i
# 
#   if (_is_infinite($i)) {
#     return $i;
#   }
# 
#   $i = $self->Math::NumSeq::PisanoPeriod::ith($i);
#   if (! defined $i) {
#     return undef;
#   }
# 
#   for (;;) {
#     my $p = $self->Math::NumSeq::PisanoPeriod::ith($i);
#     if (! defined $p) {
#       return undef;
#     }
#     if ($p == $i) {
#       $p /= 24;
#       my ($power, $exp) = _round_down_pow ($p, 5);
#       ### assert: $power == $p
#       return $exp+1;
#     }
#     $i = $p;
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
  ### LeonardoLogarithm ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  if ($i == 1) {
    return 1;
  }

  my $l = _cache()->{$i};
  if (! defined $l) {
    ### calculate ...

    my @pending = ($i);
    for (;;) {
      my $p = $self->Math::NumSeq::PisanoPeriod::ith($i);
      if (! defined $p) {
        $l = 0;
        last;
      }
      if ($p == $i) {
        $p /= 24;
        ($i, $l) = _round_down_pow ($p, 5);
        ### assert: $i == $p
        $l++;
        last;
      }
      if (defined ($l = $cache{$i})) {
        ### found cache: $l
        last;
      }
      $i = $p;
      push @pending, $p;
    }

    ### store: $l
    ### @pending
    foreach (@pending) {
      $cache{$_} = $l;
    }
  }
  return ($l ? $l : undef);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::LeonardoLogarithm -- final power on repeatedly applying PisanoPeriod

=head1 SYNOPSIS

 use Math::NumSeq::LeonardoLogarithm;
 my $seq = Math::NumSeq::LeonardoLogarithm->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is an exponent of 5 left after repeatedly applying the PisanoPeriod,

    starting i=1
    1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 2, 1, 1, 1, 2, 1, ...

Per Fulton and Morris, repeatedly applying the PisanoPeriod eventually gives
an

    m = 24 * 5^(l-1)

and that final l is the Leonardo logarithm.  l ranges from 1 upwards (the
power l-1 ranging 0 upwards).

For example i=11 goes

    PisanoPeriod(11)=10
    PisanoPeriod(10)=60
    PisanoPeriod(60)=120
    120 = 24 * 5^1
    so l-1=1
       l=2

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LeonardoLogarithm-E<gt>new ()>

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
