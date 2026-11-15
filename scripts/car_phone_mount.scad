// Phone holder for a car dashboard. A plug with the shape of the storage
// slot above the radio fills the slot completely; a neck comes out of
// the mouth and carries a cradle that the phone stands in, leaning back.
//
// The slot is a funnel: the mouth is wider and higher than the back
// panel, its upper edge drops towards both ends, and seen from above the
// mouth bows towards the cabin while the back panel is straight. The
// plug is a loft between the section at the back and the section at the
// mouth, cut off at the bowed mouth.
//
// Nothing is screwed or glued. The plug wedges into the funnel; felt or
// foam tape on its top and bottom takes up the play and protects the
// trim.
//
// Car frame: X across the car, Y out of the slot towards the cabin with
// the middle of the mouth at Y = 0, Z up with the floor of the slot at
// Z = 0.
// The STL is in the car frame and prints that way, the flat underside of
// the plug on the bed. No supports.
//
// Build:  make phone-mount        (STL and previews)
//         make phone-mount-fit    (three flat templates of the slot, fit test)
//         make phone-mount-save   (copy the STLs to models/)
// make phone-mount builds both variants, vertical and horizontal.
// See specs/car-phone-mount.md for the reasons behind the numbers.
// The slot numbers are read off photos with a ruler: print the fit test
// first.

/* [Slot: mouth] */
mouth_w   = 228;    // width of the mouth on the floor
mouth_top = 160;    // width of the level part of the upper edge
mouth_h   = 26;     // clear height in the middle
bow       = 10;     // seen from above, the middle of the mouth lies this far in front of its ends

/* [Slot: back panel] */
back_w    = 195;    // width of the back panel on the floor
back_top  = 165;    // width of the level part of its upper edge
back_ht   = 24;     // its height
slot_d    = 40;     // depth from the middle of the mouth to the back panel

/* [Plug] */
pad_t     = 1;      // felt or foam tape on the top and on the bottom of the plug
plug_clr  = 0.5;    // play in height left after the two pads
side_clr  = 1.5;    // play at each end
back_gap  = 5;      // the plug stops this far short of the back panel
r_bot     = 3;      // radius of the lower corners of the section
r_top     = 10;     // radius of the upper corners of the section

/* [Window for an indicator on the back panel] */
lamp_w    = 0;      // width of a tunnel through the plug; 0 = none
lamp_x    = 60;     // its centre along the slot
lamp_h    = 14;     // its height
lamp_z    = 4;      // floor of the tunnel above the underside of the plug

/* [Phone: Xiaomi 15T Pro, 162.7 x 77.9 x 8.0 mm, in a case] */
// "vertical" (portrait) or "horizontal" (landscape)
variant   = "vertical";
body_l    = 162.7;  // phone without case: length
body_w    = 77.9;   // width
body_t    = 8.0;    // thickness without the camera bump
case_side = 1.5;    // case wall at each edge
case_back = 2.5;    // case under the back, the height of the camera surround
play      = 1;      // play across the cradle
// depth of the channel; in landscape the camera end stands in a pocket
phone_t   = variant == "horizontal" ? 13.5 : 12;

/* [Cradle] */
cradle_x  = 0;      // centre of the cradle along the slot
tilt      = 20;     // the backrest leans back by this angle from vertical
neck_w    = 86;     // width of the neck; the cradle may be wider
lip_low   = 5;      // lip height between the corners, below the screen
corner_w  = 18;     // length of the full-height lip at each end
back_t    = 5;      // backrest thickness
ledge_t   = 4;      // ledge under the phone
lip_t     = 3;      // lip in front of the phone
lip_h     = 12;     // lip height
cheek_t   = 3;      // walls at the two sides of the phone
win_w     = 16;     // cable window in the ledge, across the phone
neck_l    = 22;     // from the mouth of the slot to the foot of the backrest
lip_clear = 10;     // the backrest must clear the edge of the dash up to this height above the slot
fil       = 1.5;    // fillet in the inner corners of the cradle

/* [Output] */
tpl_t     = 2;      // thickness of the fit-test templates
tpl_rim   = 5;      // width of their rim
// "print" (print this), "fit" (fit test), or a preview: "assembly", "side"
part = "print";

$fn = 64;
eps = 0.01;

horiz   = variant == "horizontal";
case_l  = body_l + 2 * case_side;                   // phone in its case
case_w  = body_w + 2 * case_side;
phone_w = ceil((horiz ? case_l : case_w) + play);   // width of the channel
phone_up = horiz ? case_w : case_l;                 // height of the phone above the ledge
back_h  = horiz ? 55 : 95;                          // length of the backrest above the ledge
plug_d  = slot_d - back_gap;                        // length of the plug in the middle
cut_h   = 2 * pad_t + plug_clr;                     // taken off the height of the slot
plug_h  = mouth_h - cut_h;                          // height of the plug at the mouth
cheek_h = lip_h - 1;                                // height of the pocket side walls
width   = phone_w + 2 * cheek_t;                    // cradle and neck along X
foot_z  = back_t * sin(tilt) + ledge_t * cos(tilt); // lifts the cradle so its lowest corner is at Z = 0
bow_r   = bow > 0 ? (mouth_w * mouth_w / 4 + bow * bow) / (2 * bow) : 1e6;
// Y of the rear face of the backrest at the height where it passes the dash edge
back_y  = neck_l - back_t / cos(tilt) - (mouth_h + lip_clear - foot_z) * tan(tilt);

// Slot section at depth y (0 at the middle of the mouth, -slot_d at the
// back panel). The floor width reaches mouth_w at y = -bow, where the
// ends of the mouth are; height and upper width reach the mouth values
// at y = 0.
function lerp(a, b, t) = a + (b - a) * t;
function sec_w(y)   = lerp(back_w, mouth_w, (y + slot_d) / (slot_d - bow));
function sec_top(y) = lerp(back_top, mouth_top, (y + slot_d) / slot_d);
function sec_h(y)   = lerp(back_ht, mouth_h, (y + slot_d) / slot_d);

assert(bow >= 0 && bow < slot_d - back_gap - 10, "bow leaves less than 10 mm of plug at the ends");
assert(mouth_top < mouth_w - 2 * r_top && back_top < back_w - 2 * r_top, "upper edge wider than the floor");
assert(plug_h > 10, "slot too low");
assert(plug_d > 20, "plug shorter than 20 mm: too little hold in the slot");
assert(back_y >= 2, "the backrest leans into the edge of the dash; raise neck_l or lower tilt");
assert(variant == "vertical" || variant == "horizontal", "unknown variant");
assert(neck_w <= width, "neck wider than the cradle");
assert(abs(cradle_x) + neck_w / 2 <= mouth_top / 2, "the neck leaves the level part of the mouth");
assert(lip_low < cheek_h && 2 * corner_w < phone_w - win_w, "lip corners too long or middle lip too high");
assert(win_w < phone_w - 20, "cable window wider than the ledge can spare");
assert(lip_h <= 15, "corner pockets over 15 mm cover the side buttons");
assert(lamp_w == 0 || abs(lamp_x - cradle_x) >= (lamp_w + neck_w) / 2 + 3, "the indicator window runs into the neck; move cradle_x");
assert(lamp_w == 0 || lamp_z + lamp_h <= sec_h(-plug_d) - cut_h - 3, "indicator window too high for the plug");

// Section of the plug in the X-Z plane, drawn as 2D x-y: floor width wb,
// level upper edge wt, height h.
module section(wb, wt, h) {
    hull() {
        for (s = [-1, 1]) {
            translate([s * (wb / 2 - r_bot), r_bot]) circle(r_bot);
            translate([s * (wt / 2 - r_top), h - r_top]) circle(r_top);
        }
    }
}

// Plug section at depth y, with the play taken off.
module plug_section(y) {
    section(sec_w(y) - 2 * side_clr, sec_top(y) - 2 * side_clr, sec_h(y) - cut_h);
}

// Footprint of the bowed mouth, seen from above.
module bow2d() {
    translate([0, -bow_r]) circle(r = bow_r, $fn = 360);
}

module plug() {
    difference() {
        intersection() {
            hull() for (y = [-plug_d, 0])
                translate([0, y, 0]) rotate([90, 0, 0]) linear_extrude(eps) plug_section(y);
            translate([0, 0, -1]) linear_extrude(mouth_h + 2) bow2d();
        }
        if (lamp_w > 0)
            translate([lamp_x - lamp_w / 2, -slot_d, lamp_z]) cube([lamp_w, slot_d + 1, lamp_h]);
    }
}

// Cradle section, local frame: the back of the phone on x = 0, its
// lower edge on y = 0.
module cradle2d() {
    translate([-back_t, -ledge_t]) square([back_t, back_h + ledge_t]);
    translate([-back_t, -ledge_t]) square([back_t + phone_t + lip_t, ledge_t]);
    translate([phone_t, 0]) square([lip_t, lip_h]);
}

// Local cradle frame -> side profile (Y-Z).
module placed() {
    translate([neck_l, foot_z]) rotate(tilt) children();
}

// Side profile of the cradle in the Y-Z plane, drawn as 2D x-y.
function foot_y0() = neck_l - back_t * cos(tilt) + ledge_t * sin(tilt);
module profile() {
    foot_y1 = neck_l + (phone_t + lip_t) * cos(tilt) + ledge_t * sin(tilt);
    // closing: rounds the inner corners only
    offset(r = -fil) offset(delta = fil) union() {
        placed() cradle2d();
        // foot: the ledge filled down to Z = 0, so nothing overhangs
        hull() {
            placed() translate([-back_t, -ledge_t]) square([back_t + phone_t + lip_t, ledge_t]);
            translate([foot_y0(), 0]) square([foot_y1 - foot_y0(), eps]);
        }
    }
}

// Side profile of the neck: from inside the plug into the backrest and
// the foot. It ends inside them, so it shares no face with the cradle
// except the underside.
module neck2d() {
    hull() {
        translate([-plug_d / 2, 0]) square([plug_d / 2, plug_h - 1]);
        placed() translate([-back_t, -ledge_t / 2]) square([back_t / 2, plug_h - 1 - ledge_t / 2]);
        translate([foot_y0() + 0.5, 0]) square([1, 0.3]);
    }
}

// Profile (Y-Z) -> car frame, extruded along X from x0 over w.
module along_x(x0, w) {
    translate([x0, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) linear_extrude(w) children();
}

module cradle() {
    x0 = cradle_x - width / 2;
    difference() {
        union() {
            along_x(x0, width) profile();
            along_x(cradle_x - neck_w / 2, neck_w) neck2d();
            // side walls of the corner pockets: the channel closed at both
            // ends. They end inside the backrest, the ledge and the lip and
            // 1 mm under the lip top, so no face of theirs lies in a face of
            // the profile.
            for (x = [x0, x0 + width - cheek_t])
                along_x(x, cheek_t) placed() translate([-back_t / 2, -ledge_t / 2])
                    square([back_t / 2 + phone_t + lip_t / 2, ledge_t / 2 + cheek_h]);
        }
        // cable window: straight down through ledge and foot, in front of
        // the backrest and behind the lip
        translate([cradle_x - win_w / 2, neck_l + 1, -1])
            cube([win_w, phone_t * cos(tilt) - 2, foot_z + phone_t * sin(tilt) + 3]);
        // lip lowered between the corners, so it stays below the screen
        along_x(x0 + cheek_t + corner_w, width - 2 * (cheek_t + corner_w))
            placed() translate([phone_t - 0.5, lip_low]) square([lip_t + 2, lip_h]);
    }
}

module mount() {
    plug();
    cradle();
}

// Fit test: flat rings with the outline of the plug seen from the
// front, at its rear end, and seen from above.
module ring() {
    difference() {
        children();
        offset(delta = -tpl_rim) children();
    }
}

module templates() {
    linear_extrude(tpl_t) {
        // front view: the widest floor (at the ends of the mouth) with the
        // height and upper edge of the middle
        ring() section(sec_w(-bow) - 2 * side_clr, sec_top(0) - 2 * side_clr, sec_h(0) - cut_h);
        translate([0, mouth_h + 4]) ring() plug_section(-plug_d);
        translate([0, -6]) ring() projection() plug();
    }
}

module phone() {
    along_x(cradle_x - phone_w / 2 + 0.5, phone_w - 1)
        placed() translate([0.5, 0]) square([phone_t - 3, phone_up]);
}

module dash() {
    // trim under the slot, with the shelf in front of the mouth
    color("Silver", 0.6) translate([0, 0, -12]) linear_extrude(12) intersection() {
        translate([0, 15]) bow2d();
        translate([-mouth_w / 2 - 20, -slot_d]) square([mouth_w + 40, slot_d + 15]);
    }
    // back panel
    color("DimGray", 0.6) translate([0, -slot_d, 0]) rotate([90, 0, 0])
        linear_extrude(3) section(back_w, back_top, back_ht);
    // dash top above the slot
    color("DimGray", 0.35) translate([0, 0, mouth_h]) linear_extrude(lip_clear) intersection() {
        bow2d();
        translate([-mouth_w / 2 - 20, -slot_d - 3]) square([mouth_w + 40, slot_d + 3]);
    }
}

if (part == "print") {
    mount();
} else if (part == "fit") {
    templates();
} else if (part == "assembly") {
    color("Orange") mount();
    color("SlateGray", 0.7) phone();
    dash();
} else if (part == "side") {
    color("Orange") mount();
    color("SlateGray", 0.5) phone();
    intersection() {
        dash();
        translate([-mouth_w, -200, -200]) cube([mouth_w, 400, 400]);
    }
} else {
    assert(false, "unknown part");
}
