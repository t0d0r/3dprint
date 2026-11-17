// Round stand that carries a Belkin BoostCharge Pro 3-in-1 stand
// (WIZ017) above the base of an IKEA NYMANE work lamp (A2001), so the
// Qi pad in the lamp base stays free for a second device.
//
// Shape: a slanted truncated cone. Its wide end is a skirt pushed over
// the rim of the lamp base; its narrow end carries a round plate for
// the Belkin. The plate is moved forward until its front edge is
// straight above the front of the skirt, so the wall is upright at the
// front and leans most at the rear. That keeps the plate away from the
// lamp arm, which swings forward and back. The wall shows a kumiko
// pattern (asanoha, hemp leaf) in relief on a thin skin.
//
// Two openings, both open_w wide, opposite each other:
//   rear   as tall as the cone, for the bracket of the lamp arm, which
//          stands on the base near its rim;
//   front  the door, upright sides with an arch on top, for the device
//          that goes on the pad under the plate.
//
// A ledge inside the foot of the wall stands on the flat top of the
// lamp base and carries the weight; the skirt only keeps the stand in
// place.
//
// Two printed pieces:
//   cone   the wall with skirt and ledge, a C open at the rear.
//          Printed as it stands, skirt on the bed, with supports under
//          the ledge and under the crown of the arch.
//   top    the plate. A lip under it drops inside the top of the cone,
//          and a tab in the top of the rear opening keeps it from
//          turning. Printed upside down, plate on the bed.
//
// Pattern: 42 columns round the circle; the rows get lower towards the
// top in step with the radius, so the triangles keep their shape on
// the sides of the cone and shrink towards the top. Towards the rear,
// where the wall leans more, they are stretched along the wall.
//
// Model frame: origin on the lamp axis, Z up, top of the lamp base at
// Z = 0, lamp arm at +Y, door at -Y.
//
// Build:  make lamp-stand        (STLs and previews)
//         make lamp-stand-save   (copy the STLs to models/)
// See specs/lamp-charger-stand.md. The lamp and charger numbers are
// read from ruler photos.

/* [Lamp, from ruler photos] */
lamp_d    = 210;    // diameter of the base
lamp_clr  = 0.6;    // air between the base and the skirt, on the radius
lamp_h    = 28;     // preview only: height of the base
pad_d     = 80;     // preview only: Qi pad in the middle of the base
bracket_r = 60;     // lamp axis to the near face of the arm bracket
bracket_w = 50;     // width of the arm bracket
bracket_h = 45;     // preview only
bracket_gap = 2;    // air between the plate and the bracket

/* [Belkin stand] */
belkin_d = 137;     // diameter of the base
belkin_h = 14;      // preview only: thickness of the base

/* [Device on the pad] */
phone_w  = 82;      // widest device, in its case

/* [Cone] */
clear_h  = 65;      // lamp top to the underside of the plate
top_d    = 150;     // diameter of the plate and of the top of the cone
wall     = 2.4;     // wall and skirt, measured level
skirt_h  = 8;       // skirt down the side of the lamp base
open_w   = 92;      // width of the door and of the rear opening
door_h   = 56;      // crown of the door arch above the lamp top
arch_rise = 16;     // height of the arch; below it the door has upright sides
ledge_w  = 10;      // ledge on the lamp top, inwards from the wall
ledge_t  = 3;       // its thickness

/* [Plate] */
top_t    = 5;       // plate thickness
lip_h    = 5;       // lip under the plate, inside the top of the cone
lip_w    = 2.4;     // its width
lip_clr  = 0.3;     // air between lip and cone
tab_clr  = 0.3;     // air between a tab and the wall end beside it

/* [Kumiko] */
n_around = 42;      // triangles round the full circle
rows     = 6;       // rows of triangles up the wall
band_bot = 4;       // plain band at the bottom of the wall
band_top = 2.5;     // least plain band at the top
jamb_w   = 3;       // plain band beside the openings
skin     = 1.2;     // skin behind the pattern, measured level
grid_w   = 1.6;     // bars of the triangle grid
leaf_w   = 1.0;     // bars from the centre of a triangle to its corners

/* [Output] */
// "cone", "top" (print these), or a preview: "assembly", "side", "below"
part = "cone";
bed  = 220;         // bed side, for the size check

$fn = 180;
eps = 0.01;

r_o  = lamp_d / 2 + lamp_clr + wall;     // outside of the skirt
r_t  = top_d / 2;                        // outside of the cone at the top
run  = r_o - r_t;
top_fwd = run;                           // plate axis in front of the lamp axis
lay  = wall - skin;                      // depth of the pattern, measured level
half = open_w / 2;

// The wall at height z is a circle of radius r_at(z) round [0, c_at(z)].
function r_at(z) = r_o - z * run / clear_h;
function c_at(z) = -top_fwd * z / clear_h;
function z_at(r) = (r_o - r) * clear_h / run;
// Lean of the wall above the level, at angle a round the axis.
function tilt(a) = atan2(clear_h, run + top_fwd * sin(a));

// Pattern rows: constant ratio between the radii of neighbouring rows,
// set for the sides of the cone (a = 0).
step    = 360 / n_around;
slant   = norm([run, top_fwd, clear_h]);
row_ln  = sqrt(3) / 2 * (2 * PI / n_around) * (run / slant);
r1      = r_at(band_bot);
function row_r(k) = r1 * exp(-k * row_ln);
z2      = z_at(row_r(rows));

notch_w   = bracket_w + 6;               // cut in the plate for the bracket, if it reaches it
notch_y   = bracket_r - bracket_gap;
// Least lean, at the ends of the walls beside the rear opening.
tilt_min  = tilt(acos(half / r_o));

assert(tilt_min >= 45, "wall leans more than 45 degrees beside the rear opening; raise clear_h or top_d");
assert(2 * r_o <= bed, "cone does not fit the bed");
assert(arch_rise > 0 && arch_rise <= half, "arch_rise must be between 0 and half the door width");
assert(door_h > arch_rise + 15, "door sides under 15 mm tall");
assert(door_h <= clear_h - 6, "under 6 mm of wall above the door");
assert(ledge_t < band_bot + 1, "ledge taller than the plain band at the foot");
assert(top_d <= bed, "plate does not fit the bed");
assert(z2 <= clear_h - band_top, "pattern runs into the top of the wall; fewer rows or more triangles");
assert(belkin_d <= top_d - 2, "Belkin base reaches over the edge of the plate; raise top_d");
assert(open_w >= phone_w + 8, "door under 8 mm wider than the device");
assert(open_w >= bracket_w + 6, "rear opening under 6 mm wider than the bracket");
assert(lay >= 0.8, "pattern under 0.8 mm deep; lower skin");
assert(skin >= 0.8, "skin under 0.8 mm");
assert(lip_h < clear_h / 4, "lip too deep");

// ---- wall, full circle -------------------------------------------------

// The cone between za and zb, its surface moved out by d (in by -d).
// It is drawn 1 mm longer at both ends and cut to length, so that the
// ends are plain faces; thin end discs left bad edges in the STL.
module frust(d, za, zb) {
    intersection() {
        hull() for (z = [za - 1, zb + 1])
            translate([0, c_at(z), z - 0.1]) linear_extrude(0.1) circle(r = r_at(z) + d);
        translate([-big, -2 * big, za]) cube([2 * big, 3 * big, zb - za]);
    }
}

// Skirt and cone as one convex body.
module body() {
    hull() {
        translate([0, 0, -skirt_h]) cylinder(r = r_o, h = skirt_h);
        translate([0, c_at(clear_h), clear_h - 0.1]) cylinder(r = r_t, h = 0.1);
    }
}

// The body less its hollow. The hollow is the body moved in by the
// wall and drawn longer at both ends, less the ledge on the lamp top.
// The ledge is left standing in the hollow instead of being added to
// the wall: added, its faces lay in the faces of the wall and left
// bad edges in the STL.
module wall_solid() {
    zt = clear_h + 1;
    difference() {
        body();
        difference() {
            hull() {
                translate([0, 0, -skirt_h - 1]) cylinder(r = r_o - wall, h = skirt_h + 1);
                translate([0, c_at(zt), zt - 0.1]) cylinder(r = r_at(zt) - wall, h = 0.1);
            }
            linear_extrude(ledge_t) difference() {
                circle(r = 2 * r_o);
                circle(r = r_o - wall - ledge_w);
            }
        }
    }
}

// Outer layer of the wall between the bands, open to the outside.
module zone() {
    difference() {
        frust(1, band_bot, z2);
        frust(-lay, band_bot - eps, z2 + eps);
    }
}

function node_a(k, j) = (j + (k % 2) / 2) * step;
function node(k, j) = [row_r(k), node_a(k, j)];          // [radius, angle]
function mid3(a, b, c) = [exp((ln(a[0]) + ln(b[0]) + ln(c[0])) / 3), (a[1] + b[1] + c[1]) / 3];

// A short rod through the wall, square to it.
module peg(p, w) {
    z = z_at(p[0]);
    translate([0, c_at(z), z]) rotate(p[1]) translate([p[0], 0, 0])
        rotate([0, tilt(p[1]), 0]) rotate(7)
            cylinder(d = w, h = 2 * lay + 4, center = true, $fn = 10);
}

module bar(p, q, w) { hull() { peg(p, w); peg(q, w); } }

module triangle(a, b, c) {
    bar(a, b, grid_w); bar(b, c, grid_w); bar(c, a, grid_w);
    m = mid3(a, b, c);
    bar(m, a, leaf_w); bar(m, b, leaf_w); bar(m, c, leaf_w);
}

// The pattern is turned a fraction of a degree so that no bar lies
// along a facet edge of the wall; such bars left edges shared by four
// faces in the STL.
phase = 0.7;
function ph(p) = [p[0], p[1] + phase];

module bars() {
    for (k = [0 : rows - 1], j = [0 : n_around - 1]) {
        odd = k % 2;
        triangle(ph(node(k, j)), ph(node(k, j + 1)), ph(node(k + 1, j + odd)));
        triangle(ph(node(k + 1, j)), ph(node(k + 1, j + 1)), ph(node(k, j + 1 - odd)));
    }
}

big = lamp_d;

// Outline of the door, seen from the front: X, and Z upwards. Upright
// sides, and on top a segment of a circle arch_rise high.
module door_2d() {
    zs = door_h - arch_rise;                              // where the arch starts
    ra = (half * half + arch_rise * arch_rise) / (2 * arch_rise);
    translate([-half, 0]) square([open_w, zs]);
    intersection() {
        translate([0, door_h - ra]) circle(r = ra, $fn = 360);
        translate([-half, zs - 0.01]) square([open_w, arch_rise + 1]);
    }
}

// The two openings. d grows them.
module openings(d = 0) {
    translate([-half - d, 0, -big]) cube([open_w + 2 * d, big, 2 * big]);
    rotate([90, 0, 0]) linear_extrude(big) offset(r = d) door_2d();
}

// The rear opening alone. d grows it sideways.
module rear_opening(d = 0) {
    translate([-half - d, 0, -big]) cube([open_w + 2 * d, big, 2 * big]);
}

// Room for the bars: from just outside the wall to the middle of the
// skin, ending inside the bands. The bars run on into the skin and the
// bands and stand proud of the wall by `proud`, so that no face of a
// bar lies in a face of the wall; faces in one surface left edges
// shared by four or six faces in the STL.
proud = 0.02;

module pattern_room() {
    za = band_bot / 2;
    zb = (z2 + clear_h) / 2;
    difference() {
        frust(proud, za, zb);
        frust(-lay - skin / 2, za - eps, zb + eps);
    }
}

// Plain bands round the openings: the openings grown by the band. The
// openings themselves are cut out of the wall afterwards.
module jambs() {
    openings(jamb_w);
}

module shell() {
    difference() {
        wall_solid();
        difference() { zone(); jambs(); }
    }
    intersection() { pattern_room(); bars(); }
}

// ---- pieces ------------------------------------------------------------

module cone_piece() {
    difference() { shell(); openings(); }
}

// Ring under the plate, lip_h deep, between the cone surface moved in
// by c and that moved in by ci.
module under_ring(c, ci) {
    difference() {
        frust(-c, clear_h - lip_h, clear_h + eps);
        frust(-ci, clear_h - lip_h - eps, clear_h + 2 * eps);
    }
}

module top_piece() {
    lip_in = wall + lip_clr + lip_w;
    difference() {
        union() {
            translate([0, -top_fwd, clear_h]) cylinder(r = r_t, h = top_t);
            // lip inside the top of the cone
            under_ring(wall + lip_clr, lip_in);
            // tab in the top of the rear opening, as thick as the wall
            intersection() {
                under_ring(0, lip_in);
                rear_opening(-tab_clr);
            }
        }
        // room for the arm bracket
        translate([-notch_w / 2, notch_y, clear_h - lip_h - 1]) cube([notch_w, big, top_t + lip_h + 2]);
    }
}

// ---- previews ----------------------------------------------------------

module lamp() {
    color("WhiteSmoke") {
        translate([0, 0, -lamp_h]) cylinder(d = lamp_d, h = lamp_h - eps);
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

module stand() {
    color("Orange") cone_piece();
    color("Gold") top_piece();
}

module assembly() {
    lamp();
    // an earbud case on the pad
    color("SteelBlue") translate([-23, -30, 0.3]) cube([46, 60, 22]);
    stand();
    translate([0, -top_fwd, clear_h + top_t]) belkin();
}

if (part == "cone") {
    translate([0, 0, skirt_h]) cone_piece();
} else if (part == "top") {
    translate([0, top_fwd, clear_h + top_t]) rotate([180, 0, 0]) top_piece();
} else if (part == "assembly" || part == "side") {
    assembly();
} else if (part == "below") {
    stand();
} else {
    assert(false, "unknown part");
}
