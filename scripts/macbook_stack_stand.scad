// Stacking stand for two closed MacBook Pro 14" (M4) laptops.
//
// One stand is a side rail with an E-shaped cross-section: a vertical wall
// with three shelves. The laptop edges slide into the two channels between
// the shelves. Two identical stands are needed, one at the middle of the
// left side and one at the middle of the right side of the laptops.
//
// The part is modelled in print orientation: the E profile lies on the bed
// (XY) and the rail length is Z. In use the profile Y axis points up.
//
// Build:  make macbook-stand
// See specs/macbook-stack-stand.md for the reasons behind the numbers.

/* [Laptop] */
laptop_t = 15.5;    // closed thickness without the rubber feet
laptop_w = 312.6;   // width, used by the assembly preview only
laptop_d = 221.2;   // depth, used by the assembly preview only

/* [Stand] */
desk_gap  = 5;      // desk to underside of the lower laptop
stack_gap = 10;     // top of the lower laptop to underside of the upper one
clearance = 0.5;    // vertical slack of a laptop in its channel
engage    = 15;     // channel depth: how far the shelves reach in from the wall
wall_t    = 4;      // vertical wall
top_t     = 3;      // lip above the upper laptop
length    = 68;     // rail length along the laptop side (60 mm of full channel + 2 lead-ins)
foot_out  = 12;     // outward foot that keeps an empty stand upright
foot_h    = 12;     // height where the foot meets the wall
foot_tip  = 4;      // thickness of the foot at its outer end (holds the screw heads)

/* [Screws] */
screw_n      = 2;   // screw holes in the outward foot; 0 for none
screw_inset  = 20;  // hole centre to the rail end
screw_d      = 4.5; // clearance hole, for a 4 mm countersunk wood screw
screw_head_d = 8.5; // head pocket diameter
screw_seat   = 1.5; // material under the countersink

/* [Detail] */
r_tip = 1.2;        // rounding of outer corners (shelf tips)
r_in  = 1.0;        // fillet of inner corners (shelf roots)
flare = 0.8;        // each channel opens by this much at both rail ends
lead  = 4;          // length of that lead-in

/* [Output] */
part = "stand";     // "stand" (print this, twice), "assembly" or "section" (previews)
side_gap = 0.5;     // assembly preview: laptop side to stand wall

$fn = 64;

slot_h  = laptop_t + clearance;    // channel height
mid_t   = stack_gap - clearance;   // middle shelf; laptops rest 10 mm apart
y1      = desk_gap;                // floor of the lower channel
y2      = y1 + slot_h;             // ceiling of the lower channel
y3      = y2 + mid_t;              // floor of the upper channel
y4      = y3 + slot_h;             // ceiling of the upper channel
total_h = y4 + top_t;

assert(top_t > 2 * r_tip, "top lip thinner than two tip radii");
assert(foot_tip > 2 * r_tip, "foot tip thinner than two tip radii");
assert(lead * 2 < length, "lead-ins longer than the rail");
assert(screw_n == 0 || foot_out >= screw_head_d + 3, "foot too narrow for the screw head");
assert(screw_n < 2 || screw_inset * 2 + screw_head_d < length, "screw holes overlap");

// X = 0 is the outer face of the wall, shelves point to +X, foot to -X.
module profile_raw() {
    difference() {
        union() {
            square([wall_t + engage, total_h]);
            polygon([[0, 0], [-foot_out, 0], [-foot_out, foot_tip], [0, foot_h]]);
        }
        for (y = [y1, y3])
            translate([wall_t, y]) square([engage + 1, slot_h]);
    }
}

// Opening rounds the outer corners, closing fillets the inner ones.
module profile() {
    offset(r = -r_in) offset(r = r_in)
        offset(r = r_tip) offset(r = -r_tip)
            profile_raw();
}

// Tapered cutter that widens one channel at one rail end. The small end
// sits 0.05 mm inside the channel so no face is coplanar with the part.
module lead_in(y) {
    hull() {
        translate([wall_t - flare, y - flare, -0.01])
            cube([engage + flare + 2, slot_h + 2 * flare, 0.01]);
        translate([wall_t + 0.05, y + 0.05, lead])
            cube([engage + 2, slot_h - 0.1, 0.01]);
    }
}

// Vertical screw hole (in use) at the origin, axis along +Y: clearance
// hole, 90 degree countersink, then a head pocket open through the
// sloped top of the foot.
module screw_hole() {
    cone_h = (screw_head_d - screw_d) / 2;
    rotate([-90, 0, 0]) {
        translate([0, 0, -1]) cylinder(d = screw_d, h = foot_h + 2);
        translate([0, 0, screw_seat])
            cylinder(d1 = screw_d, d2 = screw_head_d, h = cone_h + 0.01);
        translate([0, 0, screw_seat + cone_h]) cylinder(d = screw_head_d, h = foot_h + 1);
    }
}

// Hole centres along the rail: screw_inset from each end, evenly spaced.
function screw_z(i) = screw_n == 1 ? length / 2
    : screw_inset + i * (length - 2 * screw_inset) / (screw_n - 1);

module stand() {
    difference() {
        linear_extrude(length) profile();
        for (y = [y1, y3]) {
            lead_in(y);
            translate([0, 0, length]) mirror([0, 0, 1]) lead_in(y);
        }
        if (screw_n > 0)
            for (i = [0 : screw_n - 1])
                translate([-foot_out / 2, 0, screw_z(i)]) screw_hole();
    }
}

// --- assembly preview -----------------------------------------------------

module laptop() {
    r = 10;
    linear_extrude(laptop_t)
        offset(r = r) square([laptop_w - 2 * r, laptop_d - 2 * r], center = true);
}

// Stand turned to its position in use: wall vertical, rail along Y.
module stand_in_use() {
    translate([-(laptop_w / 2 + side_gap + wall_t), length / 2, 0])
        rotate([90, 0, 0]) stand();
}

// Keeps the half behind the middle of the rails when cut is true, so the
// section preview shows the profile with the laptops in it.
module clip(cut) {
    if (cut) intersection() {
        children();
        translate([0, 500, 0]) cube(1000, center = true);
    }
    else children();
}

module assembly(cut = false) {
    color("orange") clip(cut) stand_in_use();
    color("orange") clip(cut) mirror([1, 0, 0]) stand_in_use();
    color("silver") clip(cut) translate([0, 0, y1]) laptop();
    color("lightgrey") clip(cut) translate([0, 0, y3]) laptop();
    color("burlywood") clip(cut) translate([0, 0, -2])
        cube([laptop_w + 120, laptop_d + 80, 4], center = true);
}

if (part == "assembly") assembly();
else if (part == "section") assembly(cut = true);
else stand();
