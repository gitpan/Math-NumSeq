#!/usr/bin/perl -w

# Copyright 2011 Kevin Ryde

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
use Test::More tests => 7;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::Expression;

# uncomment this to run the ### lines
#use Smart::Comments;

#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 6;
  is ($Math::NumSeq::Expression::VERSION, $want_version, 'VERSION variable');
  is (Math::NumSeq::Expression->VERSION,  $want_version, 'VERSION class method');

  ok (eval { Math::NumSeq::Expression->VERSION($want_version); 1 },
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Expression->VERSION($check_version); 1 },
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------

{
  my $seq = Math::NumSeq::Expression->new (expression => '2*i');
  is (join(',',map {$seq->next} 1,2,3), '0,0,1,2,2,4');
}
{
  my $seq = Math::NumSeq::Expression->new (expression => 'i*2');
  is (join(',',map {$seq->next} 1,2,3), '0,0,1,2,2,4');
}
{
  my $seq = Math::NumSeq::Expression->new (expression => '2*$i');
  is (join(',',map {$seq->next} 1,2,3), '0,0,1,2,2,4');
}


#------------------------------------------------------------------------------

exit 0;


