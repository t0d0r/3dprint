// Clip that holds a 20 mm tube under a shelf and is pushed onto the
// front edge of the shelf: no tape, no screws. Two clips carry one tube
// about 300 mm long, which runs along the shelf edge.
// The taped and screwed clip is scripts/tube_clip.scad.
//
// One profile, extruded along the tube: a web in front of the shelf
// edge, a plate under the shelf, a springy jaw on top of it, and under
// the plate the same C ring as the taped clip. The mouth of the ring
// faces the front, so pushing the tube in pushes the clip onto the
// shelf. A bump under the jaw tip pinches the shelf.
// The tube sits at the same height and distance from the edge as in
// the taped clips, so both kinds hold one tube in one line.
//
// Profile frame (2D): u from the shelf edge (0) into the shelf, v up
// with the shelf underside at v = 0.
// Model frame: X along the shelf edge and the tube, Y = u, Z = v.
// The STL holds two clips standing on an end face: the layers run
// around the ring and along the jaw, both bend along the layers.
// No supports.
//
// Build:  make tube-edge-clip         (STL and previews)
//         make tube-edge-clip-save    (copy the STL to models/)
// See specs/tube-clip.md for the reasons behind the numbers.

/* [Shelf] */
shelf_t  = 8;       // shelf thickness
clip_clr = 0.3;     // slack of the slot over the shelf thickness
pinch    = 0.8;     // the bump under the jaw tip closes the slot to shelf_t - pinch
grip_d   = 40;      // how far the jaw reaches over the shelf
jaw_t    = 3;       // jaw thickness; it is the spring
web_t    = 4;       // web in front of the shelf edge
plate_t  = 4;       // plate under the shelf
plate_d  = 48;      // plate depth; longer than the jaw, the shelf meets it first
bump_r   = 4;       // radius of the bump, also the lead-in at the jaw tip

/* [Tube] */
tube_d   = 20;      // outer diameter of the tube
tube_clr = 0.2;     // added to the bore diameter
tube_len = 300;     // preview only
mouth    = 17;      // clear gap between the lips; the tube snaps through it
tube_u   = 32;      // tube axis behind the shelf edge; keep it under the jaw

/* [In line with the taped clip, scripts/tube_clip.scad] */
// The taped clip holds the tube tape_t + ref_gap under the shelf and
// its pad reaches ref_pad_w / 2 each side of the tube axis. This clip
// puts the tube at the same height, and tube_u keeps the axis far
// enough behind the edge for that pad.
tape_t    = 1.0;    // thickness of the tape under the taped clip; 0 if it is only screwed
ref_gap   = 5;      // taped clip: pad_t 3 + drop 2
ref_pad_w = 60;     // taped clip: pad_w

/* [Clip] */
wall     = 2.4;     // ring wall, six 0.4 mm perimeters
clip_len = 30;      // length along the tube = print height
neck_w   = 14;      // width of the neck between plate and ring
fil      = 3;       // fillet radius in the corners between ring and plate

/* [Output] */
count    = 2;       // clips in the STL
plate_gap = 6;      // gap between the clips on the bed
clip_span = 200;    // preview only: distance between the clip centres
// "plate" (print this), or a preview: "assembly", "side"
part = "plate";

$fn = 96;
eps = 0.01;

drop  = ref_gap + tape_t - plate_t;           // plastic between the plate and the top of the bore
r_in  = (tube_d + tube_clr) / 2;
r_out = r_in + wall;
r_mid = (r_in + r_out) / 2;
vc    = -(plate_t + drop + r_in);             // tube axis below the shelf
half_a = asin((mouth + wall) / (2 * r_mid));  // half angle of the mouth, to the lip centres
slot  = shelf_t + clip_clr;                   // underside of the jaw
v_top = slot + jaw_t;                         // top of the clip
v_bot = vc - r_out;                           // bottom of the clip

assert(mouth < tube_d, "mouth is wider than the tube: nothing holds it");
assert(mouth >= 0.8 * tube_d, "mouth under 80 % of the tube: the ring is strained too far on entry");
assert((mouth + wall) < 2 * r_mid, "mouth does not fit the ring");
assert(half_a < 75, "the upper lip runs into the plate; narrow the mouth");
assert(neck_w / 2 < r_in * cos(half_a) + wall, "neck reaches into the mouth");
assert(tube_u - r_out >= 0 && tube_u + r_out <= plate_d, "ring is not under the plate");
assert(drop >= 0, "plate thicker than the gap of the taped clip: the tubes cannot line up");
assert(tube_u >= ref_pad_w / 2, "tube axis too close to the edge: the pad of the taped clip would stick out");
assert(tube_u <= grip_d, "tube axis is behind the jaw: the load levers the clip off");
assert(grip_d >= 3 * shelf_t, "jaw too short to hold");
assert(plate_d >= grip_d, "plate shorter than the jaw: the bump meets the shelf first");
assert(pinch >= 0 && pinch < 1.5, "pinch out of range");
assert(shelf_t - pinch > 0 && bump_r > slot - (shelf_t - pinch), "bump does not fit");

// Ring, neck and plate. The mouth faces -u (the front).
module ring_part() {
    difference() {
        // closing: rounds the inner corners only (ring to plate, mouth to plate)
        offset(r = -fil) offset(delta = fil) difference() {
            union() {
                translate([-web_t, -plate_t]) square([web_t + plate_d, plate_t]);
                translate([tube_u, vc]) circle(r_out);
                translate([tube_u - neck_w / 2, vc]) square([neck_w, -vc - plate_t + eps]);
            }
            // mouth, cut up to the plate: above it the ring is one solid
            // nose with the neck, only the lower arm bends
            intersection() {
                translate([tube_u, vc]) polygon([[0, 0],
                    4 * r_out * [-cos(half_a), sin(half_a)],
                    4 * r_out * [-cos(half_a), -sin(half_a)]]);
                translate([tube_u - 8 * r_out, -plate_t - 8 * r_out]) square([8 * r_out, 8 * r_out]);
            }
        }
        translate([tube_u, vc]) circle(r_in);
    }
    // rounded lips, the lead-in for the tube
    for (s = [-1, 1])
        translate([tube_u, vc]) rotate(180 + s * half_a) translate([r_mid, 0]) circle(d = wall);
}

// Web and jaw. They are added after the fillets, so the slot keeps
// square corners for the square edge of the shelf.
module jaw_part() {
    translate([-web_t, -plate_t]) square([web_t, plate_t + v_top]);
    translate([-web_t, slot]) square([web_t + grip_d - bump_r, jaw_t]);
    // bump: pinches the shelf and rounds the tip upwards as a lead-in
    v_b = shelf_t - pinch;
    intersection() {
        translate([grip_d - bump_r, v_b + bump_r]) circle(bump_r);
        translate([grip_d - 2 * bump_r, v_b]) square([2 * bump_r, v_top - v_b]);
    }
}

module profile() {
    ring_part();
    jaw_part();
}

module clip() {
    linear_extrude(clip_len) profile();
}

// Clip in the model frame, centred on X = 0.
module clip_placed() {
    translate([-clip_len / 2, 0, 0]) rotate([90, 0, 90]) clip();
}

module shelf(x0, x1) {
    color("BurlyWood", 0.5) translate([x0, 0, 0]) cube([x1 - x0, 150, shelf_t]);
}

module assembly() {
    for (x = [-clip_span / 2, clip_span / 2])
        color("Orange") translate([x, 0, 0]) clip_placed();
    color("Silver") translate([-tube_len / 2, tube_u, vc]) rotate([0, 90, 0])
        difference() {
            cylinder(d = tube_d, h = tube_len);
            translate([0, 0, -1]) cylinder(d = tube_d - 3, h = tube_len + 2);
        }
    shelf(-tube_len / 2 - 30, tube_len / 2 + 30);
}

if (part == "plate") {
    // standing on an end face
    step = v_top - v_bot + plate_gap;
    for (i = [0 : count - 1])
        translate([0, i * step, 0]) clip();
} else if (part == "assembly") {
    assembly();
} else if (part == "side") {
    color("Orange") clip_placed();
    color("Silver") translate([-clip_len / 2 - 1, tube_u, vc]) rotate([0, 90, 0])
        cylinder(d = tube_d, h = clip_len + 2);
    color("BurlyWood", 0.5) translate([-clip_len / 2, 0, 0]) cube([clip_len, 80, shelf_t]);
} else {
    assert(false, "unknown part");
}
