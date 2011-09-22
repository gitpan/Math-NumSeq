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

package Math::NumSeq::OEIS::Catalogue::Plugin::FractionDigits;
use 5.004;
use strict;
use List::Util 'min', 'max'; # FIXME: 5.6 only, maybe

use vars '@ISA';
use Math::NumSeq::OEIS::Catalogue::Plugin;
@ISA = ('Math::NumSeq::OEIS::Catalogue::Plugin');

use vars '$VERSION';
$VERSION = 5;

# uncomment this to run the ### lines
#use Smart::Comments;

use constant num_first => 21022;   # A021022 1/18
use constant num_last  => 21999;   # A021999 1/995

my %exclude = (21029 => 1,  # 1/25
              );
sub anum_after {
  my ($class, $anum) = @_;
  (my $num = $anum) =~ s/^A0*//g;
  $num ||= 0;
  $num++;
  if (($class->num_to_denominator($num) % 10) == 0
      || $exclude{$num}) {
    $num++;
  }
  if ($num > $class->num_last) {
    return undef;
  }
  return sprintf 'A%06d', max ($num, $class->num_first);
}
sub anum_before {
  my ($class, $anum) = @_;
  (my $num = $anum) =~ s/^A0*//g;
  $num ||= 0;
  $num--;
  if (($class->num_to_denominator($num) % 10) == 0
      || $exclude{$num}) {
    $num--;
  }
  if ($num <= $class->num_first) {
    return undef;
  }
  return sprintf 'A%06d', min ($num, $class->num_last);
}

sub anum_to_info {
  my ($class, $anum) = @_;
  ### Catalogue-BuiltinCalc num_to_info(): @_

  # Math::NumSeq::FractionDigits
  # fraction=1/k radix=10 for k=11 to 995 is anum=21004+k,
  # being A021015 through A021999, though 1/11 is also A010680 and prefer
  # that one (in BuiltinTable.pm)

  my $num = $anum;
  if (($num =~ s/^A0*//g)
      && ($class->num_to_denominator($num) % 10) != 0
      && ! $exclude{$num}
      && $num >= $class->num_first
      && $num <= $class->num_last) {
    return $class->make_info($num);
  } else {
    return undef;
  }
}

my @info_array;
sub info_arrayref {
  my ($class) = @_;
  if (! @info_array) {
    @info_array = map {$class->make_info($_)}
      grep {($_ % 10) != 0}
        $class->num_first .. $class->num_last;
    ### made info_arrayref: @info_array
  }
  return \@info_array;
}

sub make_info {
  my ($class, $num) = @_;
  ### make_info(): $num
  return { anum  => sprintf('A%06d', $num),
           class => 'Math::NumSeq::FractionDigits',
           parameters =>
           [ fraction => '1/'.$class->num_to_denominator($num),
             radix => 10,
           ],
         };
}

sub num_to_denominator {
  my ($class, $num) = @_;
  return ($num-21004);
}

1;
__END__

