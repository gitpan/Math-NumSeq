#!/usr/bin/perl -w

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

use 5.004;
use strict;
use POSIX;

# uncomment this to run the ### lines
use Smart::Comments;

{
  require Math::NumSeq::OEIS::Catalogue;
  my $anum = 'A055508';
  my $info = Math::NumSeq::OEIS::Catalogue->anum_to_info($anum);
  ### $info

  require Math::NumSeq::OEIS;
  my $seq = Math::NumSeq::OEIS->new(anum=>$anum);
  ### $seq
  exit 0;
}
{
  unshift @INC,'t';
  require MyOEIS;
  my @ret = MyOEIS::read_values('008683');
  ### @ret
  exit 0;
}
{
  require Math::NumSeq::OEIS::Catalogue::Plugin::ZZ_Files;
  require Math::NumSeq::OEIS::Catalogue::Plugin::FractionDigits;
  foreach my $info (Math::NumSeq::OEIS::Catalogue::Plugin::FractionDigits->info_arrayref) {
    ### info: $info->[0]
    my $anum = $info->[0]->{'anum'};
    require Math::NumSeq::OEIS;
    my $seq = Math::NumSeq::OEIS->new(anum=>$anum);
  }
  exit 0;
}

{
  require Math::NumSeq::OEIS::Catalogue;
  my $info = Math::NumSeq::OEIS::Catalogue->anum_to_info('A000290');
  ### $info
  { my $anum = Math::NumSeq::OEIS::Catalogue->anum_first;
    ### $anum
  }
  { my $anum = Math::NumSeq::OEIS::Catalogue->anum_last;
    ### $anum
  }
  {
    my $anum = Math::NumSeq::OEIS::Catalogue->anum_after('A000032');
    ### $anum
  }
  {
    my $anum = Math::NumSeq::OEIS::Catalogue->anum_before('A000032');
    ### $anum
  }
  # my @list = Math::NumSeq::OEIS::Catalogue->anum_list;
  # ### @list

  {
    require Math::NumSeq::OEIS::Catalogue;
    foreach my $plugin (Math::NumSeq::OEIS::Catalogue->plugins) {
      ### $plugin
      ### first: $plugin->anum_first
      ### last: $plugin->anum_last
    }
  }

  exit 0;
}


{
  require Math::NumSeq::OEIS;
  my $seq = Math::NumSeq::OEIS->new(anum=>'A000032');
  ### $seq
  exit 0;
}
{
  {
    require File::Find;
    my $old = \&File::Find::find;
    no warnings 'redefine';
    *File::Find::find = sub {
      print "File::Find::find\n";
      print "  $_[1]\n";
      goto $old;
    };
  }
  require Math::NumSeq::OEIS::Catalogue;
  Math::NumSeq::OEIS::Catalogue->plugins;
  print "\n";
  Math::NumSeq::OEIS::Catalogue->plugins;
  print "\n";
  Math::NumSeq::OEIS::Catalogue->plugins;
}

{
  require Math::NumSeq::OEIS::Catalogue::Plugin::Files;
  my $info = Math::NumSeq::OEIS::Catalogue::Plugin::Files->anum_to_info(32);
  ### $info
exit 0;
}

