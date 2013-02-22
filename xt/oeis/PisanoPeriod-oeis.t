#!/usr/bin/perl -w

# Copyright 2012, 2013 Kevin Ryde

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
use List::Util 'max';

use Test;
plan tests => 2;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::PisanoPeriod;

# uncomment this to run the ### lines
#use Smart::Comments '###';


#------------------------------------------------------------------------------
# A071774 n for which period(n)==2n+1
# or rather period==2n+2 in reckoning of PisanoPeriod
# primes final digit 3 or 7

MyOEIS::compare_values
  (anum => 'A071774',
   func => sub {
     my ($count) = @_;
     my $seq = Math::NumSeq::PisanoPeriod->new;
     my @got;
     while (@got < $count) {
       my ($i, $value) = $seq->next or last;
       if ($value == 2*$i+2) {
         push @got, $i;
       }
     }
     return \@got;
   });

#------------------------------------------------------------------------------
# A060305 - period mod prime(n)

MyOEIS::compare_values
  (anum => 'A060305',
   func => sub {
     my ($count) = @_;
     require Math::NumSeq::Primes;
     my $primes = Math::NumSeq::Primes->new;
     my $pisano = Math::NumSeq::PisanoPeriod->new;
     my @got;
     while (@got < $count) {
       my ($i, $prime) = $primes->next or last;
       push @got, $pisano->ith($prime);
     }
     return \@got;
   });

#------------------------------------------------------------------------------
exit 0;
