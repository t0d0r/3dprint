// Snap clip that holds a 20 mm tube under a shelf. The clip is stuck to
// the underside of the shelf with double-sided tape; two clips carry one
// tube about 300 mm long.
//
// A flat pad takes the tape. Under it hangs a C-shaped ring that is open
// to one side: the tube is pushed in sideways and snaps past the two
// lips. The weight of the tube rests on the closed lower half of the
// ring, not on the snap. Two countersunk holes in the pad take screws
// if the tape is not trusted.
//
// Model frame: X across the tube (the mouth faces +X), Y along the tube,
// Z up with the shelf underside at Z = 0.
// The STL holds two clips standing on an end face: the profile is
// extruded upwards, so the layers run around the ring and the snap arm
// bends along the layers. No supports.
//
// Build:  make tube-clip         (STL and previews)
//         make tube-clip-save    (copy the STL to models/)
// See specs/tube-clip.md for the reasons behind the numbers.

/* [Tube] */
tube_d   = 20;      // outer diameter of the tube
tube_clr = 0.2;     // added to the bore diameter
tube_len = 300;     // preview only
mouth    = 17;      // clear gap between the lips; the tube snaps through it

/* [Clip] */
wall     = 2.4;     // ring wall, six 0.4 mm perimeters
clip_len = 40;      // length along the tube = print height
pad_w    = 60;      // pad width across the tube
pad_t    = 3;       // pad thickness
drop     = 2;       // plastic between the pad and the top of the bore, on top of pad_t
neck_w   = 14;      // width of the neck between pad and ring
fil      = 3;       // fillet radius in the corners between ring and pad

/* [Screws, optional: the clip also holds on tape alone] */
screws   = true;    // one countersunk hole in the pad at each side of the ring
screw_d  = 3.8;     // clearance hole for a 3.5 mm wood screw
head_d   = 7.5;     // countersink diameter at the underside of the pad
screw_x  = 22.5;    // hole centres, each side of the tube axis

/* [Output] */
count    = 2;       // clips in the STL
plate_gap = 8;      // gap between the clips on the bed
clip_span = 200;    // preview only: distance between the clip centres
// "plate" (print this), or a preview: "assembly", "side"
part = "plate";

$fn = 96;
eps = 0.01;

r_in  = (tube_d + tube_clr) / 2;
r_out = r_in + wall;
r_mid = (r_in + r_out) / 2;
zc    = -(pad_t + drop + r_in);               // tube axis below the shelf
half_a = asin((mouth + wall) / (2 * r_mid));  // half angle of the mouth, to the lip centres

assert(mouth < tube_d, "mouth is wider than the tube: nothing holds it");
assert(mouth >= 0.8 * tube_d, "mouth under 80 % of the tube: the ring is strained too far on entry");
assert((mouth + wall) < 2 * r_mid, "mouth does not fit the ring");
assert(half_a < 75, "the upper lip runs into the pad; narrow the mouth");
assert(pad_w >= 2 * r_out, "pad narrower than the ring");
assert(neck_w / 2 < r_in * cos(half_a) + wall, "neck reaches into the mouth");

cs_h = (head_d - screw_d) / 2;                // 90 degree countersink
assert(!screws || cs_h < pad_t - 0.8, "countersink leaves under 0.8 mm of pad; thicken pad_t");
assert(!screws || screw_x - head_d / 2 >= r_out + fil, "screw head runs into the ring fillet");
assert(!screws || screw_x + head_d / 2 <= pad_w / 2 - 2, "under 2 mm of pad outside the screw head");

// Cross-section in the X-Z plane, drawn as 2D x-y.
module profile() {
    difference() {
        // closing: rounds the inner corners only (ring to pad, mouth to pad)
        offset(r = -fil) offset(delta = fil) difference() {
            union() {
                translate([-pad_w / 2, -pad_t]) square([pad_w, pad_t]);
                translate([0, zc]) circle(r_out);
                translate([-neck_w / 2, zc]) square([neck_w, -zc - pad_t + eps]);
            }
            // mouth, towards +X, cut up to the pad: above it the ring is
            // one solid nose with the neck, only the lower arm bends
            intersection() {
                translate([0, zc]) polygon([[0, 0],
                    4 * r_out * [cos(half_a), sin(half_a)],
                    4 * r_out * [cos(half_a), -sin(half_a)]]);
                translate([0, -pad_t - 8 * r_out]) square([8 * r_out, 8 * r_out]);
            }
        }
        translate([0, zc]) circle(r_in);
    }
    // rounded lips, the lead-in for the tube
    for (s = [-1, 1])
        translate([0, zc]) rotate(s * half_a) translate([r_mid, 0]) circle(d = wall);
}

// Hole through the pad, countersunk from below, axis along model Z.
module screw_hole() {
    rotate([90, 0, 0]) {
        translate([0, 0, -eps]) cylinder(d = screw_d, h = pad_t + 2 * eps, $fn = 32);
        translate([0, 0, pad_t - cs_h]) cylinder(d1 = screw_d, d2 = head_d, h = cs_h + eps, $fn = 32);
    }
}

module clip() {
    difference() {
        linear_extrude(clip_len) profile();
        if (screws)
            for (x = [-screw_x, screw_x])
                translate([x, 0, clip_len / 2]) screw_hole();
    }
}

// Clip in the model frame, centred on Y = 0.
module clip_placed() {
    translate([0, clip_len / 2, 0]) rotate([90, 0, 0]) clip();
}

module assembly() {
    for (y = [-clip_span / 2, clip_span / 2])
        color("Orange") translate([0, y, 0]) clip_placed();
    color("Silver") translate([0, tube_len / 2, zc]) rotate([90, 0, 0])
        difference() {
            cylinder(d = tube_d, h = tube_len);
            translate([0, 0, -1]) cylinder(d = tube_d - 3, h = tube_len + 2);
        }
    color("BurlyWood", 0.5) translate([-80, -tube_len / 2 - 30, 0])
        cube([160, tube_len + 60, 16]);
}

if (part == "plate") {
    // standing on an end face, pads back to back
    step = pad_t + drop + 2 * r_in + wall + plate_gap;
    for (i = [0 : count - 1])
        translate([0, i * step, 0]) clip();
} else if (part == "assembly") {
    assembly();
} else if (part == "side") {
    color("Orange") clip_placed();
    color("Silver") translate([0, clip_len / 2 + 1, zc]) rotate([90, 0, 0])
        cylinder(d = tube_d, h = clip_len + 2);
    color("BurlyWood", 0.5) translate([-50, -clip_len / 2, 0]) cube([100, clip_len, 16]);
} else {
    assert(false, "unknown part");
}
