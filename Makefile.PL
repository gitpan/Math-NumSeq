#!/usr/bin/perl

# Copyright 2010, 2011 Kevin Ryde

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
use lib 'inc';
use MyMakeMakerExtras;

MyMakeMakerExtras::WriteMakefile
  (NAME         => 'Math::NumSeq',
   ABSTRACT     => 'Number sequences.',
   VERSION_FROM => 'lib/Math/NumSeq.pm',
   PREREQ_PM    => {
                    'base' => 0,
                    'constant' => 1.02, # for leading underscore
                    'constant::defer' => 1,
                    'File::HomeDir' => 0,
                    'File::Spec' => 0,
                    'List::Util' => 0,
                    'Math::Libm' => 0,
                    'Math::Prime::XS' => '0.23', # version 0.23 for fix 1928099
                    'Module::Util' => 0,
                    'Module::Load' => 0,
                    'Module::Pluggable' => 0,

                    # only for testing
                    'Test' => 0,
                    'Test::More' => 0,
                   },
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   MIN_PERL_VERSION => '5.004',

   META_MERGE =>
   { resources =>
     { homepage => 'http://user42.tuxfamily.org/math-numseq/index.html',
     },
     recommends =>
     { 'Math::Prime::XS' => '0.25', # v.25 faster is_prime()
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
       maximum_devel =>
       { description => 'Stuff used variously for development.',
         requires => { 'B::Concise'       => 0,
                       'Math::BigRat'     => 0,
                       'Math::Fibonacci'  => 0,
                       'Math::Polynomial' => 1,
                       'Math::Prime::TiedArray'  => 1,
                       'Math::TriangularNumbers' => 1,
                       'Devel::TimeThis'  => 1,
                       'Bit::Vector'      => 0,
                       'String::Parity'   => 0,
                       'String::BitCount' => 0,
                       'Path::Class'      => 0,
                     },
       },
     },
   },
  );


#------------------------------------------------------------------------------
package MY;
sub postamble {
  my ($makemaker) = @_;
  return MyMakeMakerExtras::postamble ($makemaker) . <<'HERE';

#------------------------------------------------------------------------------

oeis lib/Math/NumSeq/OEIS/Catalogue/Plugin/BuiltinTable.pm: tools/make-oeis-catalogue.pl lib/Math/NumSeq/*.pm
	$(PERL) tools/make-oeis-catalogue.pl || (rm -f $@; false)
HERE
}
