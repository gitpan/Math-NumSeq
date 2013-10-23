#!/usr/bin/perl -w

# Copyright 2013 Kevin Ryde

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

BEGIN { require 5.0004 }
use strict;
use Getopt::Long;
use IO::Select;
use List::Util 'min', 'max';
use X11::Protocol;
use X11::Protocol::WM;

use vars '%Keysyms';
use X11::Keysyms '%Keysyms', qw(MISCELLANY LATIN1);

# uncomment this to run the ### lines
use Smart::Comments;

my $scale = 50;
my $initial = 0;
my $screen_fraction = 0.4;
my $try_dbe = 1;

#------------------------------------------------------------------------------

sub round_down_pow {
  my ($n, $base) = @_;
  ### round_down_pow(): "$n base $base"

  # only for integer bases
  ### assert: $base == int($base)

  if ($n < $base) {
    return (1, 0);
  }

  # Math::BigInt and Math::BigRat overloaded log() return NaN, use integer
  # based blog()
  if (ref $n) {
    if ($n->isa('Math::BigRat')) {
      $n = int($n);
    }
    if ($n->isa('Math::BigInt')) {
      ### use blog() ...
      my $exp = $n->copy->blog($base);
      ### exp: "$exp"
      return (Math::BigInt->new(1)->blsft($exp,$base),
              $exp);
    }
  }

  my $exp = int(log($n)/log($base));
  my $pow = $base**$exp;
  ### n:   ref($n)."  $n"
  ### exp: ref($exp)."  $exp"
  ### pow: ref($pow)."  $pow"

  # check how $pow actually falls against $n, not sure should trust float
  # rounding in log()/log($base)
  # Crib: $n as first arg in case $n==BigFloat and $pow==BigInt
  if ($n < $pow) {
    ### hmm, int(log) too big, decrease...
    $exp -= 1;
    $pow = $base**$exp;
  } elsif ($n >= $base*$pow) {
    ### hmm, int(log) too small, increase...
    $exp += 1;
    $pow *= $base;
  }
  return ($pow, $exp);
}

# return true if file handle $fh has data ready to read
sub fh_readable {
  my ($fh) = @_;
  require IO::Select;
  my $s = IO::Select->new;
  $s->add($fh);
  my @ready = $s->can_read(0);
  return scalar(@ready);
}

sub time_modulo {
  my $t = time();
  return $t - ($t % 4);
}

# return ($quotient, $remainder)
sub divrem_ceil {
  my ($n, $d) = @_;
  my $rem = $n % $d;
  if ($rem) { $rem -= $d; }
  return (int(($n-$rem)/$d), # exact division stays in UV
          $rem);
}

#------------------------------------------------------------------------------

# return ($quotient, $digit)
sub divrem_negaternary {
  my ($n) = @_;
  my $digit = $n % 3;
  if ($digit == 2) { $digit = -1 }
  $n -= $digit;
  return (int(($n - $digit) / 3),
          $digit);
}

sub xy_to_haferman {
  my ($x,$y, $initial) = @_;
  my $ret = 0;
  while ($x || $y) {
    ($x, my $xdigit) = divrem_negaternary($x);
    ($y, my $ydigit) = divrem_negaternary($y);
    if (($xdigit + $ydigit) & 1) {
      return $ret;
    }
    $ret ^= 1;
  }
  return $initial;
}

#------------------------------------------------------------------------------

my ($window_width, $window_height);

sub getopt_geometry {
  my ($opt, $geometry_str) = @_;
  if ($geometry_str =~ /^(\d+)x(\d+)$/) {
    $window_width = $1;
    $window_height = $2;
  } else {
    print STDERR "Unrecognised --geometry \"$geometry_str\"\n";
    exit 1;
  }
}
sub getopt_fullscreen {
  $window_width = 'fullscreen';
  $window_height = 'fullscreen';
}
sub getopt_initial {
  my ($opt, $initial) = @_;
  if ($initial == 0 || $initial == 1) {
    $initial = $initial;
  } else {
    print STDERR "Unrecognised --initial pixel, should be 0 or 1\n";
    exit 1;
  }
}
Getopt::Long::Configure ('no_ignore_case', 'bundling');
if (! Getopt::Long::GetOptions (# 'help|?'    => $set_action,
                                # 'verbose:+' => \$verbose,
                                # 'V+'        => \$verbose,
                                # 'version'   => $set_action,
                                'scale=i'     => \$scale,
                                'geometry=s'  => \&getopt_geometry,
                                'fullscreen'  => \&getopt_fullscreen,
                                'initial=i'   => \&getopt_initial,
                               )) {
  exit 1;
}

my $X = X11::Protocol->new ($ENV{'DISPLAY'});

if (! defined $window_width) {
  $window_width = int($X->width_in_pixels * $screen_fraction);
} elsif ($window_width eq 'fullscreen') {
  $window_width = $X->width_in_pixels;
}
if (! defined $window_height) {
  $window_height = int($X->height_in_pixels * $screen_fraction);
} elsif ($window_height eq 'fullscreen') {
  $window_height = $X->height_in_pixels;
}
my $depth = $X->root_depth;

my $window = $X->new_rsrc;
$X->CreateWindow ($window,
                  $X->root,         # parent
                  'InputOutput',
                  $depth,           # depth
                  'CopyFromParent', # visual
                  0,0,              # x,y
                  $window_width,$window_height,
                  0,                # border
                  background_pixel => $X->black_pixel,
                  event_mask => $X->pack_event_mask('Exposure',
                                                    'KeyPress',
                                                    'ButtonPress',
                                                    'Button1Motion',
                                                    'ButtonRelease',
                                                    'StructureNotify'));

my $window_buffer;
my $have_dbe;
if ($try_dbe && $X->init_extension('DOUBLE-BUFFER')) {
  $have_dbe = 1;
  $window_buffer = $X->new_rsrc;
  $X->DbeAllocateBackBufferName ($window, $window_buffer, 'Undefined');
} else {
  $window_buffer = $window;
}
### $have_dbe

X11::Protocol::WM::set_wm_name ($X, $window, 'Haferman Carpet'); # title
X11::Protocol::WM::set_wm_icon_name ($X, $window, 'Haferman');
X11::Protocol::WM::set_wm_client_machine_from_syshostname ($X, $window);
X11::Protocol::WM::set_net_wm_pid ($X, $window);
X11::Protocol::WM::set_wm_protocols ($X, $window, 'WM_DELETE_WINDOW');
if ($window_width == $X->width_in_pixels && $window_height == $X->height_in_pixels) {
  $X->ChangeProperty($window,
                     $X->atom('_NET_WM_STATE'),   # property
                     X11::AtomConstants::ATOM(),  # type
                     32,                          # format
                     'Replace',
                     pack('L', $X->atom('_NET_WM_STATE_FULLSCREEN')));
}

my ($zero_bitmap, $one_bitmap);
my $bitmap_gc;
my $bitmap_pow;
my $bitmap_exp;
my $bitmap_size;

sub copy_bitmap {
  my ($from_bitmap, $to_bitmap, $x,$y) = @_;
  $x *= $bitmap_size;
  $y *= $bitmap_size;
  $X->CopyArea ($from_bitmap, $to_bitmap, $bitmap_gc,
                0,0,      # src x,y
                $bitmap_size,$bitmap_size,    # width,height
                $x,$y);   # dst x,y
}

sub make_bitmaps {
  ### make_bitmaps() ...
  ### $scale

  if ($zero_bitmap) { $X->FreePixmap($zero_bitmap); }
  if ($one_bitmap)  { $X->FreePixmap($one_bitmap); }

  ($bitmap_pow, $bitmap_exp)
    = round_down_pow(max($window_width,$window_height)/$scale,
                     3);
  $bitmap_size = $bitmap_pow*$scale;

  $zero_bitmap = $X->new_rsrc;
  $X->CreatePixmap ($zero_bitmap, $window, 1, $bitmap_size,$bitmap_size);
  $one_bitmap = $X->new_rsrc;
  $X->CreatePixmap ($one_bitmap, $window, 1, $bitmap_size,$bitmap_size);

  if (! $bitmap_gc) {
    $bitmap_gc = $X->new_rsrc;
    $X->CreateGC ($bitmap_gc, $one_bitmap, graphics_exposures => 0);
  }

  # initial single pixel
  $bitmap_size = $scale;
  $X->ChangeGC($bitmap_gc, foreground => 0);
  $X->PolyFillRectangle ($zero_bitmap, $bitmap_gc,
                         [ 0,0, $bitmap_size,$bitmap_size ]);
  $X->ChangeGC($bitmap_gc, foreground => 1);
  $X->PolyFillRectangle ($one_bitmap, $bitmap_gc,
                         [ 0,0, $bitmap_size,$bitmap_size ]);

  foreach (1 .. $bitmap_exp) {
    copy_bitmap ($one_bitmap, $one_bitmap, 0,1);
    copy_bitmap ($one_bitmap, $one_bitmap, 0,2);
    copy_bitmap ($one_bitmap, $one_bitmap, 1,0);
    copy_bitmap ($one_bitmap, $one_bitmap, 1,1);
    copy_bitmap ($one_bitmap, $one_bitmap, 1,2);
    copy_bitmap ($one_bitmap, $one_bitmap, 2,0);
    copy_bitmap ($one_bitmap, $one_bitmap, 2,1);
    copy_bitmap ($one_bitmap, $one_bitmap, 2,2);

    copy_bitmap ($one_bitmap,  $zero_bitmap, 0,1);
    copy_bitmap ($zero_bitmap, $zero_bitmap, 0,2);
    copy_bitmap ($one_bitmap,  $zero_bitmap, 1,0);
    copy_bitmap ($zero_bitmap, $zero_bitmap, 1,1);
    copy_bitmap ($one_bitmap,  $zero_bitmap, 1,2);
    copy_bitmap ($zero_bitmap, $zero_bitmap, 2,0);
    copy_bitmap ($one_bitmap,  $zero_bitmap, 2,1);
    copy_bitmap ($zero_bitmap, $zero_bitmap, 2,2);

    $bitmap_size *= 3;
    ($zero_bitmap,$one_bitmap) = ($one_bitmap,$zero_bitmap);
  }
  if ($bitmap_exp & 1) {
    ($zero_bitmap,$one_bitmap) = ($one_bitmap,$zero_bitmap);
  }
  ### final bitmap_size: $bitmap_size
}

my $scroll_x = 0;
my $scroll_y = 0;
my ($drag_x, $drag_y);

my @keysym_arefs =  $X->GetKeyboardMapping
  ($X->{'min_keycode'},
   $X->{'max_keycode'} - $X->{'min_keycode'} + 1);
### keycode table size: scalar(@keysym_arefs)
### keycode min: $X->{'min_keycode'}
### keycode max: $X->{'max_keycode'}
### keysym left: $Keysyms{'Left'}
### keysym right: $Keysyms{'Right'}

my $scroll_step = 50;
my $WM_DELETE_WINDOW = $X->atom('WM_DELETE_WINDOW');
my $WM_PROTOCOLS = $X->atom('WM_PROTOCOLS');

my $redraw;
my $redraw_bitmaps = 1;

my $window_gc = $X->new_rsrc;
$X->CreateGC ($window_gc, $window,
              foreground => $X->white_pixel,
              background => $X->black_pixel,
              graphics_exposures => 0);

sub event_handler {
  my (%h) = @_;
  ### event_handler: \%h

  if ($h{'name'} eq 'KeyPress') {
    my $keycode = $h{'detail'};
    ### keycode: sprintf('%d %#x', $keycode, $keycode)
    my $shift = ($h{'state'} & 1);
    my $keysym = $keysym_arefs[$keycode - $X->{'min_keycode'}]->[$shift];
    ### keysym_aref: $keysym_arefs[$keycode - $X->{'min_keycode'}]
    ### keysym: sprintf '%d %X', $keysym, $keysym

    if ($keysym == $Keysyms{'Left'}
        || $keysym == $Keysyms{'KP_Left'}) {
      $scroll_x -= $scroll_step;
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'Right'}
             || $keysym == $Keysyms{'KP_Right'}) {
      $scroll_x += $scroll_step;
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'Up'}
             || $keysym == $Keysyms{'KP_Up'}) {
      $scroll_y -= $scroll_step;
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'Down'}
             || $keysym == $Keysyms{'KP_Down'}) {
      $scroll_y += $scroll_step;
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'space'}) {
      $initial =  1 - $initial;  # flip 0<->1
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'plus'}
             || $keysym == $Keysyms{'KP_Add'}) {
      $scale++;
      $redraw = 1;
      $redraw_bitmaps = 1;
    } elsif ($keysym == $Keysyms{'minus'}
             || $keysym == $Keysyms{'KP_Subtract'}) {
      if ($scale > 1) {
        $scale--;
        $redraw = 1;
        $redraw_bitmaps = 1;
      }
    } elsif ($keysym == $Keysyms{'C'} || $keysym == $Keysyms{'c'}) {
      $scroll_x = 0;
      $scroll_y = 0;
      $redraw = 1;
    } elsif ($keysym == $Keysyms{'Q'} || $keysym == $Keysyms{'q'}) {
      exit 0;
    }

  } elsif ($h{'name'} eq 'ButtonPress') {
    if ($h{'detail'} == 1) {
      ### drag begin ...
      $drag_x = $h{'root_x'};
      $drag_y = $h{'root_y'};
    }
  } elsif ($h{'name'} eq 'MotionNotify' || $h{'name'} eq 'ButtonRelease') {
    if (defined $drag_x) {
      ### drag move: ($drag_x - $h{'root_x'}), ($drag_y - $h{'root_y'})
      $scroll_x += ($drag_x - $h{'root_x'});
      $scroll_y += ($drag_y - $h{'root_y'});
      $drag_x = $h{'root_x'};
      $drag_y = $h{'root_y'};
      $redraw = 1;
      if ($h{'name'} eq 'ButtonRelease') {
        ### drag end ...
        undef $drag_x;
      }
    }

  } elsif ($h{'name'} eq 'ConfigureNotify'
           && $h{'window'} == $window) {
    $window_width = $h{'width'};
    $window_height = $h{'height'};
    $redraw_bitmaps = 1;
    $redraw = 1;
  } elsif ($h{'name'} eq 'Expose') {
    $redraw = 1;
  } elsif ($h{'name'} eq 'ClientMessage') {
    if ($h{'format'} == 32
        && $h{'type'} == $WM_PROTOCOLS
        && unpack('L',$h{'data'}) == $WM_DELETE_WINDOW) {
      exit 0;
    }
  }
};

$X->{'event_handler'} = \&event_handler;
$X->MapWindow ($window);

my $fh = $X->{'connection'}->fh;
for (;;) {
  do {
    $X->handle_input;
  } while (fh_readable ($fh));

  if ($redraw) {
    $redraw = 0;
    if ($redraw_bitmaps) {
      make_bitmaps();
      $redraw_bitmaps = 0;
    }

    my $x_centre = int($bitmap_size/2 - $window_width/2) + $scroll_x;
    my $y_centre = int($bitmap_size/2 - $window_height/2) + $scroll_y;
    ### centre: "$x_centre,$y_centre   of $bitmap_size in $window_width,$window_height"

    my ($yhaf, $y) = divrem_ceil($y_centre, $bitmap_size);
    my ($xhaf_orig, $x_orig) = divrem_ceil($x_centre, $bitmap_size);

    for ( ; $y < $window_height; $y += $bitmap_size, $yhaf += 1) {
      my $xhaf = $xhaf_orig;
      my $x = $x_orig;
      for ( ; $x < $window_width; $x += $bitmap_size, $xhaf += 1) {
        my $haf = xy_to_haferman($xhaf,$yhaf);
        $haf ^= ($bitmap_exp & 1);
        ### draw: "xy=$x,$y haf=$xhaf,$yhaf value=$haf"
        $X->CopyPlane ($haf ? $one_bitmap : $zero_bitmap,
                       $window_buffer,
                       $window_gc,
                       0,0,                        # src x,y
                       $bitmap_size,$bitmap_size,  # width,height
                       $x,$y,                      # dst x,y
                       1);                         # bit plane
      }
    }
    if ($have_dbe) {
      $X->DbeSwapBuffers ($window, 'Undefined');
    }
  }
}
exit 0;






# sub copy_plane_clipped {
#   my ($X, $src, $dst, $gc, $src_x,$src_y, $width,$height, $dst_x,$dst_y) = @_;
#   if ($dst_x < 0) {
#     $src_x -= $dst_x;
#     $width += $dst_x;
#   }
#   if ($dst_y < 0) {
#     $src_y -= $dst_y;
#     $width += $dst_y;
#   }
#
#   $X->CopyPlane ($src, $dst, $gc, $src_x,$src_y, $width,$height, $dst_x,$dst_y);
# }

# $X->flush;
# my $select = IO::Select->new;
# my $t = time();
# $select->add($fh);
# $select->can_read(1);
#   # {
#   #   my $new_t = time_modulo();
#   #   if ($t != $new_t) {
#   #     ($one_bitmap,$zero_bitmap) = ($zero_bitmap,$one_bitmap);
#   #     $t = $new_t;
#   #     $redraw = 1;
#   #   }
#   # }
# while (fh_readable ($fh)) {
#   ### X handle_input ...
# }
