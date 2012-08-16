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

package Math::NumSeq::OEIS::Catalogue::Plugin::Alpha;
use 5.004;
use strict;
use Module::Util;

use vars '$VERSION', '@ISA';
$VERSION = 49;
use Math::NumSeq::OEIS::Catalogue::Plugin;
@ISA = ('Math::NumSeq::OEIS::Catalogue::Plugin');

use constant::defer info_arrayref => sub {
  require Lingua::Any::Numbers;
  my @available = Lingua::Any::Numbers::available();
  my %available;
  @available{@available} = ();
  return [
          {
           anum  => 'A005589',
           class => 'Math::NumSeq::AlphabeticalLength',
           parameters => [ i_start => 0 ],
          },
          {
           anum  => 'A006944',
           class => 'Math::NumSeq::AlphabeticalLength',
           parameters => [ i_start => 1, number_type => 'ordinal' ],
          },

          (exists $available{'ES'}
           ? {
              anum  => 'A011762',
              class => 'Math::NumSeq::AlphabeticalLength',
              parameters => [ language => 'es', i_start => 0 ],
             }
           : ()),

          # premiere ?
          # (exists $available{'FR'}
          #  ? {
          #     anum  => 'A006969',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'fr',
          #                     number_type => 'ordinal',
          #                     i_start => 1 ],
          #    }
          #  : ()),

          # egy ?
          # (exists $available{'HU'}
          #  ? {
          #     anum  => 'A007292',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'hu', i_start => 1 ],
          #    }
          #  : ()),

          # centottanta in A026858 vs centoottanta in Lingua
          # (exists $available{'IT'}
          #  ? {
          #     anum  => 'A026858',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'it', i_start => 0 ],
          #    }
          #  : ()),

          # (exists $available{'JA'}
          #  ? {
          #     anum  => 'A030166',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'ja', i_start => 0 ],
          #    }
          #  : ()),

          # (exists $available{'NL'}
          #  ? {
          #     anum  => 'A090589',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'nl', i_start => 1 ],
          #    }
          #  : ()),

          # (exists $available{'PL'}
          #  ? {
          #     anum  => 'A008962',
          #     class => 'Math::NumSeq::AlphabeticalLength',
          #     parameters => [ language => 'pl', i_start => 0 ],
          #    }
          #  : ()),

          (exists $available{'SV'}
           ? {
              anum  => 'A059124',
              class => 'Math::NumSeq::AlphabeticalLength',
              parameters => [ language => 'sv', i_start => 0 ],
             }
           : ()),

          (exists $available{'TR'}
           ? {
              anum  => 'A057435',
              class => 'Math::NumSeq::AlphabeticalLength',
              parameters => [ language => 'tr', i_start => 1 ],
             }
           : ()),
         ];
};

1;
__END__
