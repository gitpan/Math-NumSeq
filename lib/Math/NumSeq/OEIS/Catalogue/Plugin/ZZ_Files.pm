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

package Math::NumSeq::OEIS::Catalogue::Plugin::ZZ_Files;
use 5.004;
use strict;
use File::Spec;
use Math::NumSeq::OEIS::File;

use vars '@ISA';
use Math::NumSeq::OEIS::Catalogue::Plugin;
@ISA = ('Math::NumSeq::OEIS::Catalogue::Plugin');

use vars '$VERSION';
$VERSION = 49;

# uncomment this to run the ### lines
#use Smart::Comments;


sub _make_info {
  my ($anum) = @_;
  ### _make_info(): $anum
  return { anum => $anum,
           class => 'Math::NumSeq::OEIS::File',
           parameters => [ anum => $anum ] };
}

sub anum_to_info {
  my ($class, $anum) = @_;
  ### Catalogue-ZZ_Files num_to_info(): @_

  my $dir = Math::NumSeq::OEIS::File::oeis_dir();
  foreach my $basename
    ("$anum.internal",
     "$anum.internal.html",
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

# on getting up to perhaps 2000 files of 500 anums it becomes a bit slow
# re-reading the directory on every anum_next(), cache a bit for speed

my $cached_arrayref = [];
my $cached_mtime = -1;
my $cached_time = -1;

sub info_arrayref {
  my ($class) = @_;

  # stat() at most once per second
  my $time = time();
  if ($cached_time != $time) {
    $cached_time = $time;

    # if $dir mtime changed then re-read
    my $dir = Math::NumSeq::OEIS::File::oeis_dir();
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks) = stat($dir);
    if (! defined $mtime) { $mtime = -1; } # if $dir doesn't exist
    if ($cached_mtime != $mtime) {
      $cached_mtime = $mtime;
      $cached_arrayref = _info_arrayref($dir);
    }
  }
  return $cached_arrayref;
}

sub _info_arrayref {
  my ($dir) = @_;
  ### _info_arrayref(): $dir

  my @ret;
  my %seen;
  if (! opendir DIR, $dir) {
    ### cannot opendir: $!
    return [];
  }
  while (defined (my $basename = readdir DIR)) {
    ### $basename

    unless (-e File::Spec->catfile($dir,$basename)) {
      ### skip dangling symlink ...
      next;
    }

    # Case insensitive for MS-DOS.  But dunno what .internal or
    # .internal.html will be or should be on an 8.3 DOS filesystem.  Maybe
    # "A000000.int", maybe "A000000i.htm" until 7-digit A-numbers.
    next unless $basename =~ m{^(
                                 A(\d*)(\.internal)?(\.html?)?  # $2 num
                               |[ab](\d*)\.txt                  # $5 num
                               )$}ix;

    my $anum = 'A'.($2||$5);
    next if $seen{$anum}++;  # uniquify

    push @ret, _make_info($anum);
  }
  closedir DIR or die "Error closing $dir: $!";
  return \@ret;
}

1;
__END__


# sub anum_after {
#   my ($class, $anum) = @_;
#   ### anum_after(): $anum
# 
#   my $dir = Math::NumSeq::OEIS::File::oeis_dir();
# 
#   if (! opendir DIR, $dir) {
#     ### cannot opendir: $!
#     return undef;
#   }
# 
#   $anum =~ /([0-9]+)/;
#   my $anum_num = $1 || 0;
# 
#   my $after_num;
#   while (defined (my $basename = readdir DIR)) {
#     # ### $basename
#     if ($basename =~ /^A(\d*)\.(html?|internal)
#                     |[ab](\d*)\.txt/xi) {
#       my $num = ($1||$3);
#       if ($num > $anum_num
#           && (! defined $after_num
#               || $after_num > $num)) {
#         $after_num = $num;
#       }
#     }
#   }
#   closedir DIR or die "Error closing $dir: $!";
# 
#   if (defined $after_num) {
#     $after_num = "A$after_num";
#   }
# 
#   ### $after_num
#   return $after_num;
# }

