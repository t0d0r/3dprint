// Clip that holds a 20 mm tube under a shelf and is pushed onto the
// front edge of the shelf: no tape, no screws. The tube runs at 90
// degrees to the shelf edge, from the front to the back, and comes out
// under the edge. The taped and screwed clip is scripts/tube_clip.scad;
// both kinds hold one tube in one line.
//
// A web in front of the shelf edge, a plate under the shelf and a jaw
// on top of it form the clip. A bump under the jaw tip pinches the
// shelf. Under the plate hangs the same C ring as on the taped clip,
// with its axis at 90 degrees to the shelf edge and its mouth to the
// side (+X).
//
// Model frame: X along the shelf edge, Y from the shelf edge (0) into
// the shelf, Z up with the shelf underside at Z = 0. The tube runs
// along Y.
// The STL holds two clips standing on the front face: plate, jaw and
// ring rise from the bed as vertical walls, the layers run around the
// ring. No supports.
//
// Build:  make tube-edge-clip         (STL and previews)
//         make tube-edge-clip-save    (copy the STL to models/)
// See specs/tube-clip.md for the reasons behind the numbers.

/* [Shelf] */
shelf_t  = 8;       // shelf thickness
clip_clr = 0.3;     // slack of the slot over the shelf thickness
pinch    = 0.5;     // the bump under the jaw tip closes the slot to shelf_t - pinch
grip_d   = 40;      // how far the jaw reaches over the shelf
jaw_t    = 3;       // jaw thickness; it is the spring
web_t    = 4;       // web in front of the shelf edge
plate_t  = 4;       // plate under the shelf
plate_d  = 48;      // plate depth; longer than the jaw, the shelf meets it first
bump_r   = 4;       // radius of the bump, also the lead-in at the jaw tip
clip_w   = 40;      // width along the shelf edge

/* [Tube] */
tube_d   = 20;      // outer diameter of the tube
tube_clr = 0.2;     // added to the bore diameter
tube_len = 300;     // preview only
mouth    = 17;      // clear gap between the lips; the tube snaps through it

/* [Ring] */
wall     = 2.4;     // ring wall, six 0.4 mm perimeters
ring_len = 30;      // ring length along the tube, from the front face of the web
neck_w   = 14;      // width of the neck between plate and ring
fil      = 3;       // fillet radius in the corners between ring and plate

/* [In line with the taped clip, scripts/tube_clip.scad] */
// The taped clip holds the tube tape_t + ref_gap under the shelf.
// This clip puts the tube at the same height.
tape_t    = 1.0;    // thickness of the tape under the taped clip; 0 if it is only screwed
ref_gap   = 5;      // taped clip: pad_t 3 + drop 2

/* [Output] */
count    = 2;       // clips in the STL
plate_gap = 6;      // gap between the clips on the bed
// preview only: Y of the taped clips behind the shelf edge
taped_y  = [140, 260];
tube_out = 20;      // preview only: how far the tube stands out in front of the clip
// "plate" (print this), or a preview: "assembly", "side", "front"
part = "plate";

$fn = 96;
eps = 0.01;

drop  = ref_gap + tape_t - plate_t;           // plastic between the plate and the top of the bore
r_in  = (tube_d + tube_clr) / 2;
r_out = r_in + wall;
r_mid = (r_in + r_out) / 2;
zc    = -(plate_t + drop + r_in);             // tube axis below the shelf
half_a = asin((mouth + wall) / (2 * r_mid));  // half angle of the mouth, to the lip centres
slot  = shelf_t + clip_clr;                   // underside of the jaw
z_top = slot + jaw_t;                         // top of the clip

assert(mouth < tube_d, "mouth is wider than the tube: nothing holds it");
assert(mouth >= 0.8 * tube_d, "mouth under 80 % of the tube: the ring is strained too far on entry");
assert((mouth + wall) < 2 * r_mid, "mouth does not fit the ring");
assert(half_a < 75, "the upper lip runs into the plate; narrow the mouth");
assert(neck_w / 2 < r_in * cos(half_a) + wall, "neck reaches into the mouth");
assert(drop >= 0, "plate thicker than the gap of the taped clip: the tubes cannot line up");
assert(clip_w >= 2 * r_out, "clip narrower than the ring");
assert(ring_len > web_t && ring_len - web_t <= plate_d, "ring is not under the plate");
assert(grip_d >= 3 * shelf_t, "jaw too short to hold");
assert(plate_d >= grip_d, "plate shorter than the jaw: the bump meets the shelf first");
assert(pinch >= 0 && pinch < 1.5, "pinch out of range");
assert(bump_r > slot - (shelf_t - pinch), "bump does not fit");
// the bump grows out of the jaw while printing; keep it under 45 degrees
assert(acos((bump_r - (slot - (shelf_t - pinch))) / bump_r) <= 45, "bump overhangs more than 45 degrees; raise bump_r");

// Ring, neck and a strip of plate, seen from the front (2D x = X, y = Z).
// The mouth faces +X.
module ring_profile() {
    difference() {
        // closing: rounds the inner corners only (ring to plate, mouth to plate)
        offset(r = -fil) offset(delta = fil) difference() {
            union() {
                translate([-clip_w / 2, -plate_t]) square([clip_w, plate_t]);
                translate([0, zc]) circle(r_out);
                translate([-neck_w / 2, zc]) square([neck_w, -zc - plate_t + eps]);
            }
            // mouth, cut up to the plate: above it the ring is one solid
            // nose with the neck, only the lower arm bends
            intersection() {
                translate([0, zc]) polygon([[0, 0],
                    4 * r_out * [cos(half_a), sin(half_a)],
                    4 * r_out * [cos(half_a), -sin(half_a)]]);
                translate([0, -plate_t - 8 * r_out]) square([8 * r_out, 8 * r_out]);
            }
        }
        translate([0, zc]) circle(r_in);
    }
    // rounded lips, the lead-in for the tube
    for (s = [-1, 1])
        translate([0, zc]) rotate(s * half_a) translate([r_mid, 0]) circle(d = wall);
}

// Web, plate and jaw, seen from the side (2D x = Y, y = Z). The slot
// keeps square corners for the square edge of the shelf.
module jaw_profile() {
    translate([-web_t, -plate_t]) square([web_t, plate_t + z_top]);
    translate([-web_t, -plate_t]) square([web_t + plate_d, plate_t]);
    translate([-web_t, slot]) square([web_t + grip_d - bump_r, jaw_t]);
    // bump: pinches the shelf and rounds the tip upwards as a lead-in
    z_b = shelf_t - pinch;
    intersection() {
        translate([grip_d - bump_r, z_b + bump_r]) circle(bump_r);
        translate([grip_d - 2 * bump_r, z_b]) square([2 * bump_r, z_top - z_b]);
    }
}

module clip() {
    // side profile, extruded along X
    translate([-clip_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(clip_w) jaw_profile();
    // front profile, extruded along Y from the front face of the web
    translate([0, ring_len - web_t, 0]) rotate([90, 0, 0]) linear_extrude(ring_len) ring_profile();
}

// Stand-in for the taped clip of scripts/tube_clip.scad, on its tape.
module taped_clip() {
    color("Gold") translate([0, 20, -tape_t]) rotate([90, 0, 0]) linear_extrude(40)
        difference() {
            union() {
                translate([-30, -3]) square([60, 3]);
                translate([0, zc + tape_t]) circle(r_out);
                translate([-neck_w / 2, zc + tape_t]) square([neck_w, -zc - tape_t - 3]);
            }
            translate([0, zc + tape_t]) circle(r_in);
            translate([0, zc + tape_t - mouth / 2]) square([2 * r_out, mouth]);
        }
}

module tube() {
    y0 = -web_t - tube_out;
    color("Silver") translate([0, y0 + tube_len, zc]) rotate([90, 0, 0])
        difference() {
            cylinder(d = tube_d, h = tube_len);
            translate([0, 0, -1]) cylinder(d = tube_d - 3, h = tube_len + 2);
        }
}

module assembly() {
    color("Orange") clip();
    for (y = taped_y) translate([0, y, 0]) taped_clip();
    tube();
    color("BurlyWood", 0.5) translate([-100, 0, 0]) cube([200, 320, shelf_t]);
}

if (part == "plate") {
    // standing on the front face: Y becomes the print Z
    for (i = [0 : count - 1])
        translate([i * (clip_w + plate_gap), 0, web_t]) rotate([90, 0, 0]) clip();
} else if (part == "assembly") {
    assembly();
} else if (part == "side") {
    // cut along the tube axis, seen from +X
    intersection() {
        assembly();
        translate([-200, -100, -100]) cube([200, 500, 200]);
    }
} else if (part == "front") {
    color("Orange") clip();
    tube();
    color("BurlyWood", 0.5) translate([-60, 0, 0]) cube([120, 60, shelf_t]);
} else {
    assert(false, "unknown part");
}
