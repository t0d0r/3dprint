// Bridge that carries a Belkin BoostCharge Pro 3-in-1 stand (WIZ017)
// above the base of an IKEA NYMANE work lamp (A2001), so the Qi pad
// in the lamp base stays free for a second device.
//
// One printed piece: a flat plate on two walls. The walls stand on
// the flat top of the lamp base, one each side of the Qi pad. Between
// them is a tunnel, open at both ends, over the pad. A phone lies on
// the pad across the lamp, under the plate; the Belkin stands on the
// plate.
//
// The part is symmetric and is not fixed to the lamp. It is placed so
// that the plate clears the bracket of the lamp arm (stand_off in the
// previews).
//
// Model frame: X along the tunnel, Y across it, Z up. The top of the
// lamp base is Z = 0, the part is centred on the origin. In the
// previews the lamp arm is on the +Y side.
//
// Prints without supports, upside down on the top face of the plate.
//
// Build:  make lamp-stand        (STL and previews)
//         make lamp-stand-save   (copy the STL to models/)
// See specs/lamp-charger-stand.md. The lamp and charger numbers are
// read from ruler photos.

/* [Belkin stand] */
belkin_d = 135;     // diameter of the base
belkin_h = 14;      // preview only: thickness of the base
margin   = 2;       // plate beyond the base, each side

/* [Tunnel] */
clear_h  = 32;      // free height between lamp top and plate
phone_w  = 82;      // widest device on the pad, in its case
phone_l  = 166;     // preview only
phone_t  = 13;      // preview only

/* [Part] */
top_t    = 5;       // plate thickness
wall_t   = 6;       // wall thickness
gusset   = 6;       // 45 degree gusset between wall and plate
corner_r = 20;      // corner radius of the plate

/* [Lamp, from ruler photos] */
lamp_d    = 220;    // diameter of the base
lamp_h    = 28;     // preview only: height of the base
lamp_edge = 8;      // rounded edge of the base; the walls stay inside it
pad_d     = 80;     // preview only: Qi pad in the middle of the base
bracket_r = 60;     // lamp centre to the near face of the arm bracket
bracket_w = 50;     // preview only
bracket_h = 45;     // preview only
bracket_gap = 2;    // air between plate and bracket

/* [Output] */
// "part" (print this), or a preview: "assembly", "side", "below"
part = "part";

$fn = 96;
eps = 0.01;

side    = belkin_d + 2 * margin;        // plate is side x side
total_h = clear_h + top_t;
bay_w   = side - 2 * wall_t;            // between the walls
// How far the part sits in front of the lamp centre to clear the bracket.
stand_off = max(0, side / 2 + bracket_gap - bracket_r);
// Furthest point of a wall foot from the lamp centre.
foot_reach = norm([side / 2 - corner_r, stand_off + side / 2 - corner_r]) + corner_r;

assert(side <= 220, "plate does not fit a 220 mm bed");
assert(corner_r > wall_t, "corner radius must exceed the wall thickness");
assert(gusset < clear_h - phone_t - 4, "gusset reaches down to the device");
assert(bay_w / 2 - stand_off >= phone_w / 2 + 3,
       "under 3 mm between the device on the pad and the wall by the bracket");
assert(foot_reach <= lamp_d / 2 - lamp_edge, "a wall foot stands on the rounded edge of the lamp base");

module outline() {
    hull() for (x = [-1, 1], y = [-1, 1])
        translate([x * (side / 2 - corner_r), y * (side / 2 - corner_r)]) circle(r = corner_r);
}

// Section of the +Y wall with its gusset, in (Y, Z).
module wall_section() {
    polygon([[side / 2 + 1, 0],
             [side / 2 + 1, clear_h + eps],
             [side / 2 - wall_t - gusset, clear_h + eps],
             [side / 2 - wall_t, clear_h - gusset],
             [side / 2 - wall_t, 0]]);
}

module stand() {
    translate([0, 0, clear_h]) linear_extrude(top_t) outline();
    intersection() {
        linear_extrude(clear_h + eps) outline();
        for (m = [0, 1]) mirror([0, m, 0])
            translate([-side / 2 - 1, 0, 0]) rotate([90, 0, 90])
                linear_extrude(side + 2) wall_section();
    }
}

module lamp() {
    color("WhiteSmoke") {
        translate([0, 0, -lamp_h]) cylinder(d = lamp_d, h = lamp_h);
        translate([-bracket_w / 2, bracket_r, 0]) cube([bracket_w, lamp_d / 2 - bracket_r - 4, bracket_h]);
        translate([0, bracket_r + 22, bracket_h - 10]) rotate([-8, 0, 0]) cylinder(d = 22, h = 150);
    }
    color("Gainsboro") cylinder(d = pad_d, h = 0.3);
}

module belkin() {
    color("DimGray") {
        cylinder(d = belkin_d, h = belkin_h);
        translate([0, 18, 0]) cylinder(d = 14, h = 105);
    }
    color("Silver") translate([-75, 18, 105]) rotate([0, 90, 0]) cylinder(d = 9, h = 150);
    color("White") {
        translate([-52, 10, 108]) rotate([75, 0, 0]) cylinder(d = 60, h = 6);
        translate([62, 10, 108]) rotate([75, 0, 0]) cylinder(d = 30, h = 6);
    }
}

module assembly() {
    lamp();
    color("SteelBlue") translate([-phone_l / 2, -phone_w / 2, 0.3]) cube([phone_l, phone_w, phone_t]);
    translate([0, -stand_off, 0]) {
        color("Orange") stand();
        translate([0, 0, total_h]) belkin();
    }
}

if (part == "part") {
    translate([0, 0, total_h]) rotate([180, 0, 0]) stand();
} else if (part == "assembly" || part == "side") {
    assembly();
} else if (part == "below") {
    color("Orange") stand();
} else {
    assert(false, "unknown part");
}
