#!/usr/bin/perl -w

# Copyright 2010, 2011, 2012 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
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
use Test;
plan tests => 7;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::OEIS::File;

# uncomment this to run the ### lines
#use Smart::Comments;

#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 31;
  ok ($Math::NumSeq::OEIS::File::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::OEIS::File->VERSION, $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::OEIS::File->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::OEIS::File->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
#

foreach my $anum ('A003849', # special case a003849.txt
                  'A027750', # special case a027750.txt
                  'A005228', # detect a005228.txt is source code
                 ) {
  my $err;
  my $seq;
  if (eval { $seq = Math::NumSeq::OEIS::File->new (anum => $anum); 1 }) {
    $seq->next;
    $seq->next;
    $seq->next;
  } else {
    $err = $@;
  }
  ok (! defined $err || $err =~ /not found for A-number/);
}


exit 0;


