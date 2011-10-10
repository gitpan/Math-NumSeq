# Copyright 2011 Kevin Ryde

# Generated by tools/make-oeis-catalogue.pl -- DO NOT EDIT

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

package Math::NumSeq::OEIS::Catalogue::Plugin::BuiltinTable;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 10;
use Math::NumSeq::OEIS::Catalogue::Plugin;
@ISA = ('Math::NumSeq::OEIS::Catalogue::Plugin');

## no critic (CodeLayout::RequireTrailingCommaAtNewline)

# total 269 A-numbers in 48 modules

use constant info_arrayref =>
[
  {
    'anum' => 'A001477',
    'class' => 'Math::NumSeq::All'
  },
  {
    'anum' => 'A086747',
    'class' => 'Math::NumSeq::BaumSweet'
  },
  {
    'anum' => 'A051003',
    'class' => 'Math::NumSeq::Beastly',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A006667',
    'class' => 'Math::NumSeq::CollatzSteps',
    'parameters' => [
      'step_type',
      'up'
    ]
  },
  {
    'anum' => 'A006666',
    'class' => 'Math::NumSeq::CollatzSteps',
    'parameters' => [
      'step_type',
      'down'
    ]
  },
  {
    'anum' => 'A006577',
    'class' => 'Math::NumSeq::CollatzSteps',
    'parameters' => [
      'step_type',
      'both'
    ]
  },
  {
    'anum' => 'A000578',
    'class' => 'Math::NumSeq::Cubes'
  },
  {
    'anum' => 'A002064',
    'class' => 'Math::NumSeq::CullenNumbers'
  },
  {
    'anum' => 'A080791',
    'class' => 'Math::NumSeq::DigitCount',
    'parameters' => [
      'radix',
      2,
      'digit',
      0
    ]
  },
  {
    'anum' => 'A000120',
    'class' => 'Math::NumSeq::DigitCount',
    'parameters' => [
      'radix',
      2,
      'digit',
      1
    ]
  },
  {
    'anum' => 'A062756',
    'class' => 'Math::NumSeq::DigitCount',
    'parameters' => [
      'radix',
      3,
      'digit',
      1
    ]
  },
  {
    'anum' => 'A081603',
    'class' => 'Math::NumSeq::DigitCount',
    'parameters' => [
      'radix',
      3,
      'digit',
      2
    ]
  },
  {
    'anum' => 'A102683',
    'class' => 'Math::NumSeq::DigitCount',
    'parameters' => [
      'radix',
      10,
      'digit',
      9
    ]
  },
  {
    'anum' => 'A070939',
    'class' => 'Math::NumSeq::DigitLength',
    'parameters' => [
      'radix',
      2
    ]
  },
  {
    'anum' => 'A081604',
    'class' => 'Math::NumSeq::DigitLength',
    'parameters' => [
      'radix',
      3
    ]
  },
  {
    'anum' => 'A110591',
    'class' => 'Math::NumSeq::DigitLength',
    'parameters' => [
      'radix',
      4
    ]
  },
  {
    'anum' => 'A110592',
    'class' => 'Math::NumSeq::DigitLength',
    'parameters' => [
      'radix',
      5
    ]
  },
  {
    'anum' => 'A083652',
    'class' => 'Math::NumSeq::DigitLengthCumulative',
    'parameters' => [
      'radix',
      2
    ]
  },
  {
    'anum' => 'A007954',
    'class' => 'Math::NumSeq::DigitProduct',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A053735',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      3
    ]
  },
  {
    'anum' => 'A053737',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      4
    ]
  },
  {
    'anum' => 'A053824',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      5
    ]
  },
  {
    'anum' => 'A053827',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      6
    ]
  },
  {
    'anum' => 'A053828',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      7
    ]
  },
  {
    'anum' => 'A053829',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      8
    ]
  },
  {
    'anum' => 'A053830',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      9
    ]
  },
  {
    'anum' => 'A007953',
    'class' => 'Math::NumSeq::DigitSum'
  },
  {
    'anum' => 'A053831',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      11
    ]
  },
  {
    'anum' => 'A053832',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      12
    ]
  },
  {
    'anum' => 'A053833',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      13
    ]
  },
  {
    'anum' => 'A053834',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      14
    ]
  },
  {
    'anum' => 'A053835',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      15
    ]
  },
  {
    'anum' => 'A053836',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'radix',
      16
    ]
  },
  {
    'anum' => 'A003132',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'power',
      2
    ]
  },
  {
    'anum' => 'A055012',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'power',
      3
    ]
  },
  {
    'anum' => 'A055013',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'power',
      4
    ]
  },
  {
    'anum' => 'A055014',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'power',
      5
    ]
  },
  {
    'anum' => 'A055015',
    'class' => 'Math::NumSeq::DigitSum',
    'parameters' => [
      'power',
      6
    ]
  },
  {
    'anum' => 'A010060',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      2
    ]
  },
  {
    'anum' => 'A053838',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      3
    ]
  },
  {
    'anum' => 'A053839',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      4
    ]
  },
  {
    'anum' => 'A053840',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      5
    ]
  },
  {
    'anum' => 'A053841',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      6
    ]
  },
  {
    'anum' => 'A053842',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      7
    ]
  },
  {
    'anum' => 'A053843',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      8
    ]
  },
  {
    'anum' => 'A053844',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      9
    ]
  },
  {
    'anum' => 'A053837',
    'class' => 'Math::NumSeq::DigitSumModulo',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A006567',
    'class' => 'Math::NumSeq::Emirps',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A005843',
    'class' => 'Math::NumSeq::Even'
  },
  {
    'anum' => 'A002522',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      'i*i+1'
    ]
  },
  {
    'anum' => 'A059100',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      'i*i+2'
    ]
  },
  {
    'anum' => 'A005563',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      'i*(i+2)'
    ]
  },
  {
    'anum' => 'A000447',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      'i*(4*i*i-1)/3'
    ]
  },
  {
    'anum' => 'A033991',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      'i*(4*i-1)'
    ]
  },
  {
    'anum' => 'A016743',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      '(2*i)**3'
    ]
  },
  {
    'anum' => 'A086746',
    'class' => 'Math::NumSeq::Expression',
    'parameters' => [
      'expression',
      '3018*i'
    ]
  },
  {
    'anum' => 'A000142',
    'class' => 'Math::NumSeq::Factorials'
  },
  {
    'anum' => 'A003714',
    'class' => 'Math::NumSeq::Fibbinary'
  },
  {
    'anum' => 'A000045',
    'class' => 'Math::NumSeq::Fibonacci'
  },
  {
    'anum' => 'A020806',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/7'
    ]
  },
  {
    'anum' => 'A068028',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '22/7'
    ]
  },
  {
    'anum' => 'A000012',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/9'
    ]
  },
  {
    'anum' => 'A010680',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/11'
    ]
  },
  {
    'anum' => 'A021015',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/11'
    ]
  },
  {
    'anum' => 'A021016',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/12'
    ]
  },
  {
    'anum' => 'A021017',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/13'
    ]
  },
  {
    'anum' => 'A021018',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/14'
    ]
  },
  {
    'anum' => 'A021019',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/15'
    ]
  },
  {
    'anum' => 'A021020',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/16'
    ]
  },
  {
    'anum' => 'A007450',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/17'
    ]
  },
  {
    'anum' => 'A022001',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/997'
    ]
  },
  {
    'anum' => 'A022002',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/998'
    ]
  },
  {
    'anum' => 'A022003',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '1/999'
    ]
  },
  {
    'anum' => 'A010888',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '13717421/1111111110'
    ]
  },
  {
    'anum' => 'A010701',
    'class' => 'Math::NumSeq::FractionDigits',
    'parameters' => [
      'fraction',
      '10/3'
    ]
  },
  {
    'anum' => 'A007770',
    'class' => 'Math::NumSeq::HappyNumbers',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A049445',
    'class' => 'Math::NumSeq::HarshadNumbers',
    'parameters' => [
      'radix',
      2
    ]
  },
  {
    'anum' => 'A005349',
    'class' => 'Math::NumSeq::HarshadNumbers'
  },
  {
    'anum' => 'A000204',
    'class' => 'Math::NumSeq::LucasNumbers'
  },
  {
    'anum' => 'A008683',
    'class' => 'Math::NumSeq::MobiusFunction'
  },
  {
    'anum' => 'A079000',
    'class' => 'Math::NumSeq::NumAronson'
  },
  {
    'anum' => 'A005408',
    'class' => 'Math::NumSeq::Odd'
  },
  {
    'anum' => 'A006995',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      2
    ]
  },
  {
    'anum' => 'A014190',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      3
    ]
  },
  {
    'anum' => 'A014192',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      4
    ]
  },
  {
    'anum' => 'A029952',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      5
    ]
  },
  {
    'anum' => 'A029953',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      6
    ]
  },
  {
    'anum' => 'A029954',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      7
    ]
  },
  {
    'anum' => 'A029803',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      8
    ]
  },
  {
    'anum' => 'A029955',
    'class' => 'Math::NumSeq::Palindromes',
    'parameters' => [
      'radix',
      9
    ]
  },
  {
    'anum' => 'A002113',
    'class' => 'Math::NumSeq::Palindromes'
  },
  {
    'anum' => 'A000129',
    'class' => 'Math::NumSeq::Pell'
  },
  {
    'anum' => 'A000326',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      5,
      'pairs',
      'first'
    ]
  },
  {
    'anum' => 'A005449',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      5,
      'pairs',
      'second'
    ]
  },
  {
    'anum' => 'A001318',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      5,
      'pairs',
      'both'
    ]
  },
  {
    'anum' => 'A000384',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      6,
      'pairs',
      'first'
    ]
  },
  {
    'anum' => 'A014105',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      6,
      'pairs',
      'second'
    ]
  },
  {
    'anum' => 'A000566',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      7
    ]
  },
  {
    'anum' => 'A000567',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      8
    ]
  },
  {
    'anum' => 'A001106',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      9
    ]
  },
  {
    'anum' => 'A001107',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      10
    ]
  },
  {
    'anum' => 'A051682',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      11
    ]
  },
  {
    'anum' => 'A051624',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      12
    ]
  },
  {
    'anum' => 'A051865',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      13
    ]
  },
  {
    'anum' => 'A051866',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      14
    ]
  },
  {
    'anum' => 'A051867',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      15
    ]
  },
  {
    'anum' => 'A051868',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      16
    ]
  },
  {
    'anum' => 'A051869',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      17
    ]
  },
  {
    'anum' => 'A051870',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      18
    ]
  },
  {
    'anum' => 'A051871',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      19
    ]
  },
  {
    'anum' => 'A051872',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      20
    ]
  },
  {
    'anum' => 'A051873',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      21
    ]
  },
  {
    'anum' => 'A051874',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      22
    ]
  },
  {
    'anum' => 'A051875',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      23
    ]
  },
  {
    'anum' => 'A051876',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      24
    ]
  },
  {
    'anum' => 'A001105',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      6,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033428',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      8,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A016742',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      10,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033429',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      12,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033581',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      14,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033582',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      16,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A139098',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      18,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A016766',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      20,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033583',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      22,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A033584',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      24,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A135453',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      26,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A152742',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      28,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A144555',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      30,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A064761',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      32,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A016802',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      34,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A017522',
    'class' => 'Math::NumSeq::Polygonal',
    'parameters' => [
      'polygonal',
      290,
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A001221',
    'class' => 'Math::NumSeq::PrimeFactorCount',
    'parameters' => [
      'multiplicity',
      'distinct'
    ]
  },
  {
    'anum' => 'A001222',
    'class' => 'Math::NumSeq::PrimeFactorCount',
    'parameters' => [
      'multiplicity',
      'repeated'
    ]
  },
  {
    'anum' => 'A000040',
    'class' => 'Math::NumSeq::Primes'
  },
  {
    'anum' => 'A002110',
    'class' => 'Math::NumSeq::Primorials'
  },
  {
    'anum' => 'A002378',
    'class' => 'Math::NumSeq::Pronic'
  },
  {
    'anum' => 'A080075',
    'class' => 'Math::NumSeq::ProthNumbers'
  },
  {
    'anum' => 'A032924',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      3,
      'digit',
      0
    ]
  },
  {
    'anum' => 'A005823',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      3,
      'digit',
      1
    ]
  },
  {
    'anum' => 'A005836',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      3,
      'digit',
      2
    ]
  },
  {
    'anum' => 'A023705',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      4,
      'digit',
      0
    ]
  },
  {
    'anum' => 'A023709',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      4,
      'digit',
      1
    ]
  },
  {
    'anum' => 'A023713',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      4,
      'digit',
      2
    ]
  },
  {
    'anum' => 'A023717',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      4,
      'digit',
      3
    ]
  },
  {
    'anum' => 'A023721',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      5,
      'digit',
      0
    ]
  },
  {
    'anum' => 'A023725',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      5,
      'digit',
      1
    ]
  },
  {
    'anum' => 'A023729',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      5,
      'digit',
      2
    ]
  },
  {
    'anum' => 'A023733',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      5,
      'digit',
      3
    ]
  },
  {
    'anum' => 'A023737',
    'class' => 'Math::NumSeq::RadixWithoutDigit',
    'parameters' => [
      'radix',
      5,
      'digit',
      4
    ]
  },
  {
    'anum' => 'A010785',
    'class' => 'Math::NumSeq::Repdigits',
    'parameters' => [
      'radix',
      10
    ]
  },
  {
    'anum' => 'A035522',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      1
    ]
  },
  {
    'anum' => 'A061561',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      22
    ]
  },
  {
    'anum' => 'A075253',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      77
    ]
  },
  {
    'anum' => 'A075268',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      442
    ]
  },
  {
    'anum' => 'A077076',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      537
    ]
  },
  {
    'anum' => 'A077077',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      2,
      'start',
      775
    ]
  },
  {
    'anum' => 'A075299',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      290
    ]
  },
  {
    'anum' => 'A075153',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      318
    ]
  },
  {
    'anum' => 'A075466',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      266718
    ]
  },
  {
    'anum' => 'A075467',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      270798
    ]
  },
  {
    'anum' => 'A076247',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      1059774
    ]
  },
  {
    'anum' => 'A076248',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'radix',
      4,
      'start',
      1059831
    ]
  },
  {
    'anum' => 'A001127',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'start',
      1
    ]
  },
  {
    'anum' => 'A033648',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'start',
      3
    ]
  },
  {
    'anum' => 'A033670',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'start',
      89
    ]
  },
  {
    'anum' => 'A006960',
    'class' => 'Math::NumSeq::ReverseAdd',
    'parameters' => [
      'start',
      196
    ]
  },
  {
    'anum' => 'A005384',
    'class' => 'Math::NumSeq::SophieGermainPrimes'
  },
  {
    'anum' => 'A004539',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      2,
      'radix',
      2
    ]
  },
  {
    'anum' => 'A004540',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      2,
      'radix',
      3
    ]
  },
  {
    'anum' => 'A004541',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      2,
      'radix',
      4
    ]
  },
  {
    'anum' => 'A004542',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      2,
      'radix',
      5
    ]
  },
  {
    'anum' => 'A002193',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      2
    ]
  },
  {
    'anum' => 'A002194',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      3
    ]
  },
  {
    'anum' => 'A002163',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      5
    ]
  },
  {
    'anum' => 'A010467',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      10
    ]
  },
  {
    'anum' => 'A010468',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      11
    ]
  },
  {
    'anum' => 'A010469',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      12
    ]
  },
  {
    'anum' => 'A010470',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      13
    ]
  },
  {
    'anum' => 'A010471',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      14
    ]
  },
  {
    'anum' => 'A010472',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      15
    ]
  },
  {
    'anum' => 'A010473',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      17
    ]
  },
  {
    'anum' => 'A010474',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      18
    ]
  },
  {
    'anum' => 'A010475',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      19
    ]
  },
  {
    'anum' => 'A010476',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      20
    ]
  },
  {
    'anum' => 'A010477',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      21
    ]
  },
  {
    'anum' => 'A010478',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      22
    ]
  },
  {
    'anum' => 'A010479',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      23
    ]
  },
  {
    'anum' => 'A010480',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      24
    ]
  },
  {
    'anum' => 'A010481',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      26
    ]
  },
  {
    'anum' => 'A010482',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      27
    ]
  },
  {
    'anum' => 'A010483',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      28
    ]
  },
  {
    'anum' => 'A010484',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      29
    ]
  },
  {
    'anum' => 'A010485',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      30
    ]
  },
  {
    'anum' => 'A010486',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      31
    ]
  },
  {
    'anum' => 'A010487',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      32
    ]
  },
  {
    'anum' => 'A010488',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      33
    ]
  },
  {
    'anum' => 'A010489',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      34
    ]
  },
  {
    'anum' => 'A010490',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      35
    ]
  },
  {
    'anum' => 'A010491',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      37
    ]
  },
  {
    'anum' => 'A010492',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      38
    ]
  },
  {
    'anum' => 'A010493',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      39
    ]
  },
  {
    'anum' => 'A010494',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      40
    ]
  },
  {
    'anum' => 'A010495',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      41
    ]
  },
  {
    'anum' => 'A010496',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      42
    ]
  },
  {
    'anum' => 'A010497',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      43
    ]
  },
  {
    'anum' => 'A010498',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      44
    ]
  },
  {
    'anum' => 'A010499',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      45
    ]
  },
  {
    'anum' => 'A010500',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      46
    ]
  },
  {
    'anum' => 'A010501',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      47
    ]
  },
  {
    'anum' => 'A010502',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      48
    ]
  },
  {
    'anum' => 'A010503',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      50
    ]
  },
  {
    'anum' => 'A010504',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      51
    ]
  },
  {
    'anum' => 'A010505',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      52
    ]
  },
  {
    'anum' => 'A010506',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      53
    ]
  },
  {
    'anum' => 'A010507',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      54
    ]
  },
  {
    'anum' => 'A010508',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      55
    ]
  },
  {
    'anum' => 'A010509',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      56
    ]
  },
  {
    'anum' => 'A010510',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      57
    ]
  },
  {
    'anum' => 'A010511',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      58
    ]
  },
  {
    'anum' => 'A010512',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      59
    ]
  },
  {
    'anum' => 'A010513',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      60
    ]
  },
  {
    'anum' => 'A010514',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      61
    ]
  },
  {
    'anum' => 'A010515',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      62
    ]
  },
  {
    'anum' => 'A010516',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      63
    ]
  },
  {
    'anum' => 'A010517',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      65
    ]
  },
  {
    'anum' => 'A010518',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      66
    ]
  },
  {
    'anum' => 'A010519',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      67
    ]
  },
  {
    'anum' => 'A010520',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      68
    ]
  },
  {
    'anum' => 'A010521',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      69
    ]
  },
  {
    'anum' => 'A010522',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      70
    ]
  },
  {
    'anum' => 'A010523',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      71
    ]
  },
  {
    'anum' => 'A010524',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      72
    ]
  },
  {
    'anum' => 'A010525',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      73
    ]
  },
  {
    'anum' => 'A010526',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      74
    ]
  },
  {
    'anum' => 'A010527',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      75
    ]
  },
  {
    'anum' => 'A010528',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      76
    ]
  },
  {
    'anum' => 'A010529',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      77
    ]
  },
  {
    'anum' => 'A010530',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      78
    ]
  },
  {
    'anum' => 'A010531',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      79
    ]
  },
  {
    'anum' => 'A010532',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      80
    ]
  },
  {
    'anum' => 'A010533',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      82
    ]
  },
  {
    'anum' => 'A010534',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      83
    ]
  },
  {
    'anum' => 'A010535',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      84
    ]
  },
  {
    'anum' => 'A010536',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      85
    ]
  },
  {
    'anum' => 'A010537',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      86
    ]
  },
  {
    'anum' => 'A010538',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      87
    ]
  },
  {
    'anum' => 'A010539',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      88
    ]
  },
  {
    'anum' => 'A010540',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      89
    ]
  },
  {
    'anum' => 'A010541',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      90
    ]
  },
  {
    'anum' => 'A010542',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      91
    ]
  },
  {
    'anum' => 'A010543',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      92
    ]
  },
  {
    'anum' => 'A010544',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      93
    ]
  },
  {
    'anum' => 'A010545',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      94
    ]
  },
  {
    'anum' => 'A010546',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      95
    ]
  },
  {
    'anum' => 'A010547',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      96
    ]
  },
  {
    'anum' => 'A010548',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      97
    ]
  },
  {
    'anum' => 'A010549',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      98
    ]
  },
  {
    'anum' => 'A010550',
    'class' => 'Math::NumSeq::SqrtDigits',
    'parameters' => [
      'sqrt',
      99
    ]
  },
  {
    'anum' => 'A000290',
    'class' => 'Math::NumSeq::Squares'
  },
  {
    'anum' => 'A003154',
    'class' => 'Math::NumSeq::StarNumbers'
  },
  {
    'anum' => 'A002487',
    'class' => 'Math::NumSeq::SternDiatomic'
  },
  {
    'anum' => 'A000292',
    'class' => 'Math::NumSeq::Tetrahedral'
  },
  {
    'anum' => 'A000217',
    'class' => 'Math::NumSeq::Triangular'
  },
  {
    'anum' => 'A000073',
    'class' => 'Math::NumSeq::Tribonacci'
  },
  {
    'anum' => 'A001359',
    'class' => 'Math::NumSeq::TwinPrimes',
    'parameters' => [
      'pairs',
      'first'
    ]
  },
  {
    'anum' => 'A006512',
    'class' => 'Math::NumSeq::TwinPrimes',
    'parameters' => [
      'pairs',
      'second'
    ]
  },
  {
    'anum' => 'A001097',
    'class' => 'Math::NumSeq::TwinPrimes',
    'parameters' => [
      'pairs',
      'both'
    ]
  },
  {
    'anum' => 'A014574',
    'class' => 'Math::NumSeq::TwinPrimes',
    'parameters' => [
      'pairs',
      'average'
    ]
  },
  {
    'anum' => 'A003261',
    'class' => 'Math::NumSeq::WoodallNumbers'
  }
]
;
1;
__END__
