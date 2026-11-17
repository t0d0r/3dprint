// Round stand that carries a Belkin BoostCharge Pro 3-in-1 stand
// (WIZ017) above the base of an IKEA NYMANE work lamp (A2001), so the
// Qi pad in the lamp base stays free for a second device.
//
// Shape: a truncated cone. Its wide end is a skirt pushed over the rim
// of the lamp base; its narrow end carries a round plate for the
// Belkin. The cone wall shows a kumiko pattern (asanoha, hemp leaf) in
// relief on a thin skin.
//
// Two openings, both open_w wide and as tall as the cone, opposite
// each other:
//   rear   for the bracket of the lamp arm, which stands on the base
//          near its rim and is taller than the stand;
//   front  the door, for the device that goes on the pad under the
//          plate.
// They leave two side walls, left and right.
//
// Three printed pieces, because a ring round a 220 mm base does not
// fit a 220 mm bed:
//   sides  the two side walls, in one STL. Printed as they stand,
//          skirt on the bed.
//   top    the plate. A lip under it drops inside the tops of the side
//          walls, and tabs in the tops of both openings keep the walls
//          from sliding round the lamp. Printed upside down, plate on
//          the bed.
//
// Pattern: on the unrolled cone the triangle grid is regular in
// (log of the distance from the apex, angle), so every triangle is
// equilateral in shape and the triangles get smaller towards the top.
//
// Model frame: origin on the lamp axis, Z up, top of the lamp base at
// Z = 0, lamp arm at +Y, door at -Y, side walls at -X and +X.
//
// Build:  make lamp-stand        (STLs and previews)
//         make lamp-stand-save   (copy the STLs to models/)
// See specs/lamp-charger-stand.md. The lamp and charger numbers are
// read from ruler photos.

/* [Lamp, from ruler photos] */
lamp_d    = 220;    // diameter of the base
lamp_clr  = 0.6;    // air between the base and the skirt, on the radius
lamp_h    = 28;     // preview only: height of the base
pad_d     = 80;     // preview only: Qi pad in the middle of the base
bracket_r = 60;     // lamp axis to the near face of the arm bracket
bracket_w = 50;     // width of the arm bracket
bracket_h = 45;     // preview only
bracket_gap = 2;    // air between Belkin or plate and the bracket

/* [Belkin stand] */
belkin_d = 135;     // diameter of the base
belkin_h = 14;      // preview only: thickness of the base

/* [Device on the pad] */
phone_w  = 82;      // widest device, in its case
phone_l  = 166;     // preview only
phone_t  = 13;      // preview only

/* [Cone] */
clear_h  = 34;      // lamp top to the underside of the plate
top_d    = 162;     // diameter of the plate and of the top of the cone
wall     = 2.4;     // wall and skirt, measured level
skirt_h  = 8;       // skirt down the side of the lamp base
open_w   = 92;      // width of the door and of the rear opening

/* [Plate] */
top_t    = 5;       // plate thickness
lip_h    = 3;       // lip under the plate, inside the top of the cone
lip_w    = 2.4;     // its width
lip_clr  = 0.3;     // air between lip and cone
tab_clr  = 0.3;     // air between a tab and the wall end beside it

/* [Kumiko] */
n_around = 45;      // triangles round the full circle
rows     = 3;       // rows of triangles up the wall
band_bot = 4;       // plain band at the bottom of the wall
band_top = 2.5;     // least plain band at the top
jamb_w   = 3;       // plain band beside the openings
skin     = 1.2;     // skin behind the pattern, measured level
grid_w   = 1.6;     // bars of the triangle grid
leaf_w   = 1.0;     // bars from the centre of a triangle to its corners

/* [Output] */
// "sides", "top" (print these), or a preview: "assembly", "side", "below"
part = "sides";
bed  = 220;         // bed side, for the size check
plate_gap = 20;     // between the two side walls in the "sides" STL

$fn = 180;
eps = 0.01;

r_o  = lamp_d / 2 + lamp_clr + wall;     // outside of the skirt
r_t  = top_d / 2;                        // outside of the cone at the top
run  = r_o - r_t;
slant = norm([run, clear_h]);
tilt = atan2(clear_h, run);              // wall above the level
lay  = wall - skin;                      // depth of the pattern, measured level
function r_at(z) = r_o - z * run / clear_h;
function z_at(r) = (r_o - r) * clear_h / run;

// Pattern rows: constant ratio between the radii of neighbouring rows.
step    = 360 / n_around;
row_ln  = sqrt(3) / 2 * (2 * PI / n_around) * (run / slant);
r1      = r_at(band_bot);
function row_r(k) = r1 * exp(-k * row_ln);
z2      = z_at(row_r(rows));

// The Belkin stands in front of the lamp axis to clear the bracket.
stand_off = max(0, belkin_d / 2 + bracket_gap - bracket_r);
notch_w   = bracket_w + 6;               // cut in the plate for the bracket
notch_y   = bracket_r - bracket_gap;
// Size of the "sides" STL on the bed.
half      = open_w / 2;
sides_x   = 2 * (r_o - half) + plate_gap;
sides_y   = 2 * sqrt(r_o * r_o - half * half);

assert(tilt >= 45, "wall leans more than 45 degrees; raise clear_h or top_d");
assert(max(sides_x, sides_y) <= bed, "side walls do not fit the bed; widen open_w");
assert(top_d <= bed, "plate does not fit the bed");
assert(z2 <= clear_h - band_top, "pattern runs into the top of the wall; fewer rows or more triangles");
assert(stand_off + belkin_d / 2 <= r_t - 1, "Belkin base reaches over the edge of the plate; raise top_d");
assert(open_w >= phone_w + 8, "door under 8 mm wider than the device");
assert(open_w >= bracket_w + 6, "rear opening under 6 mm wider than the bracket");
assert(lay >= 0.8, "pattern under 0.8 mm deep; lower skin");
assert(skin >= 0.8, "skin under 0.8 mm");

// ---- wall, full circle -------------------------------------------------

module wall_solid() {
    rotate_extrude() polygon([
        [r_o - wall, -skirt_h], [r_o, -skirt_h], [r_o, 0],
        [r_t, clear_h], [r_t - wall, clear_h], [r_o - wall, 0]]);
}

// Outer layer of the wall between the bands; d widens it outwards.
module zone(d = 0) {
    rotate_extrude() polygon([
        [r1 - lay, band_bot], [r1 + d, band_bot],
        [row_r(rows) + d, z2], [row_r(rows) - lay, z2]]);
}

function node_a(k, j) = (j + (k % 2) / 2) * step;
function node(k, j) = [row_r(k), node_a(k, j)];          // [radius, angle]
function mid3(a, b, c) = [exp((ln(a[0]) + ln(b[0]) + ln(c[0])) / 3), (a[1] + b[1] + c[1]) / 3];

module peg(p, w) {
    rotate(p[1]) translate([p[0], 0, z_at(p[0])]) rotate([0, tilt, 0])
        rotate(7) cylinder(d = w, h = 2 * lay + 4, center = true, $fn = 10);
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

module bars() {
    rotate(phase) for (k = [0 : rows - 1], j = [0 : n_around - 1]) {
        odd = k % 2;
        triangle(node(k, j), node(k, j + 1), node(k + 1, j + odd));
        triangle(node(k + 1, j), node(k + 1, j + 1), node(k, j + 1 - odd));
    }
}

big = lamp_d;

// The two openings. d grows them sideways.
module openings(d = 0) {
    translate([-half - d, -big, -big]) cube([open_w + 2 * d, 2 * big, 2 * big]);
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
    in = lay + skin / 2;
    rotate_extrude() polygon([
        [r_at(za) - in, za], [r_at(za) + proud, za], [r_at(zb) + proud, zb], [r_at(zb) - in, zb]]);
}

// Plain bands beside the openings.
module jambs() {
    difference() { openings(jamb_w); openings(); }
}

module shell() {
    difference() {
        wall_solid();
        difference() { zone(1); jambs(); }
    }
    intersection() { pattern_room(); bars(); }
}

// ---- pieces ------------------------------------------------------------

// Both side walls, in place.
module side_walls() {
    difference() { shell(); openings(); }
}

// Ring under the plate between ri and the cone surface moved in by c.
module under_ring(ri, c) {
    ro = r_t - c;
    rotate_extrude() polygon([
        [ri, clear_h - lip_h], [ro + lip_h * run / clear_h, clear_h - lip_h],
        [ro, clear_h + eps], [ri, clear_h + eps]]);
}

module top_piece() {
    lip_ro = r_t - wall - lip_clr;
    difference() {
        union() {
            translate([0, 0, clear_h]) cylinder(r = r_t, h = top_t);
            // lip inside the tops of the side walls
            under_ring(lip_ro - lip_w, wall + lip_clr);
            // tabs in the tops of the openings, as thick as the wall
            intersection() {
                under_ring(lip_ro - lip_w, 0);
                openings(-tab_clr);
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
    color("Orange") side_walls();
    color("Gold") top_piece();
}

module assembly() {
    lamp();
    // an earbud case on the pad
    color("SteelBlue") translate([-23, -30, 0.3]) cube([46, 60, 22]);
    stand();
    translate([0, -stand_off, clear_h + top_t]) belkin();
}

if (part == "sides") {
    // moved together to fit the bed
    for (s = [-1, 1]) translate([-s * (half - plate_gap / 2), 0, skirt_h])
        intersection() {
            side_walls();
            translate([s > 0 ? 0 : -big, -big, -big]) cube([big, 2 * big, 2 * big]);
        }
} else if (part == "top") {
    translate([0, 0, clear_h + top_t]) rotate([180, 0, 0]) top_piece();
} else if (part == "assembly" || part == "side") {
    assembly();
} else if (part == "below") {
    stand();
} else {
    assert(false, "unknown part");
}
