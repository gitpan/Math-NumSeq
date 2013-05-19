#!/usr/bin/perl -w

# Copyright 2010, 2011, 2012, 2013 Kevin Ryde

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
use ExtUtils::MakeMaker;

WriteMakefile
  (NAME         => 'Math::NumSeq',
   ABSTRACT     => 'Number sequences.',
   VERSION_FROM => 'lib/Math/NumSeq.pm',
   PREREQ_PM    => {
                    'constant' => 1.02, # for leading underscore
                    'constant::defer' => 1,
                    'File::HomeDir' => 0,
                    'File::Spec' => 0,
                    'File::Temp' => 0,
                    'List::Util' => 0,
                    'Math::Libm' => 0,
                    'Math::Prime::XS' => '0.23', # version 0.23 for fix 1928099

                    # version 0.40 for factors() on Math::BigInt
                    'Math::Factor::XS' => '0.40',

                    'Module::Util' => 0,
                    'Module::Load' => 0,

                    # 4.7 no core removal warns, which was a ridiculous way
                    # to communicate to developers
                    'Module::Pluggable' => 4.7,

                    # only for testing
                    'Test' => 0,
                   },
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   MIN_PERL_VERSION => '5.004',

   META_MERGE =>
   { resources =>
     { homepage => 'http://user42.tuxfamily.org/math-numseq/index.html',
       license  => 'http://www.gnu.org/licenses/gpl.html',
     },
     no_index => { directory=>['devel','xt'] },

     recommends =>
     { 'Math::Prime::XS'  => '0.26', # v.26 for faster is_prime()
     },
     optional_features =>
     { maximum_interoperation =>
       { description => 'Have maximum inter-operation with other modules (optional other stuff).',
         requires => { 'Math::Symbolic' => 0,
                       'Math::Expression::Evaluator' => 0,
                       'Language::Expr' => 0,
                       'Language::Expr::Compiler::Perl' => 0,
                     },
       },
       maximum_tests =>
       { description => 'Have "make test" do as much as possible.',
         requires => { 'Data::Float'  => 0,
                     },
       },
     },
   },
  );

#------------------------------------------------------------------------------
# updating BuiltinTable.pm

package MY;
sub postamble {
  my ($makemaker) = @_;
  return <<'HERE';

oeis lib/Math/NumSeq/OEIS/Catalogue/Plugin/BuiltinTable.pm: tools/make-oeis-catalogue.pl lib/Math/NumSeq/*.pm
	$(PERL) tools/make-oeis-catalogue.pl || (rm -f $@; false)
HERE
}
