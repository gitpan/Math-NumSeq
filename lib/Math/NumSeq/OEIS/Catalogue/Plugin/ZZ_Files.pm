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

package Math::NumSeq::OEIS::Catalogue::Plugin::ZZ_Files;
use 5.004;
use strict;
use File::Spec;
use Math::NumSeq::OEIS::File;

use vars '@ISA';
use Math::NumSeq::OEIS::Catalogue::Plugin;
@ISA = ('Math::NumSeq::OEIS::Catalogue::Plugin');

use vars '$VERSION';
$VERSION = 10;

# uncomment this to run the ### lines
#use Devel::Comments;

sub _make_info {
  my ($anum) = @_;
  ### _make_info(): $anum
  return { anum => $anum,
           class => 'Math::NumSeq::OEIS::File',
           parameters => [ anum => $anum ] };
}

sub anum_to_info {
  my ($class, $anum) = @_;
  ### Catalogue-ZFiles num_to_info(): @_

  my $dir = Math::NumSeq::OEIS::File::oeis_dir();
  foreach my $basename
    ("$anum.internal",
     "$anum.html",
     "$anum.htm",
     Math::NumSeq::OEIS::File::anum_to_bfile($anum),
     Math::NumSeq::OEIS::File::anum_to_bfile($anum,'a')) {
    my $filename = File::Spec->catfile ($dir, $basename);
    ### $filename
    if (-e $filename) {
      return _make_info($anum);
    }
  }
  return undef;
}

sub info_arrayref {
  my ($class) = @_;
  my $dir = Math::NumSeq::OEIS::File::oeis_dir();
  ### $dir
  my @ret;
  my %seen;
  if (! opendir DIR, $dir) {
    ### cannot opendir: $!
    return [];
  }
  while (defined (my $basename = readdir DIR)) {
    ### $basename
    # FIXME: case insensitive ?
    if ($basename =~ /^A(\d*)\.(html?|internal)
                    |[ab](\d*)\.txt/x) {
      my $anum = 'A'.($1||$3);
      unless ($seen{$anum}++) {
        push @ret, _make_info($anum);
      }
    }
  }
  closedir DIR or die "Error closing $dir: $!";
  return \@ret;
}


1;
__END__

