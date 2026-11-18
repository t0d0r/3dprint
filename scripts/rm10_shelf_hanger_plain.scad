// Shelf hanger for one GL.iNet Comet Pro (GL-RM10) with no holes in it.
//
// Same job and same clip as scripts/rm10_shelf_hanger.scad, but the sleeve
// is drawn here instead of imported from the rack mount: closed walls, no
// vent slots, no lip at the end. Printed on its front face every surface
// is vertical or grows at 45 degrees; nothing is bridged and nothing needs
// support.
//
// Air instead of slots: the sleeve is `gap` larger than the device all
// round and the device rests on ribs that run front to back. The channels
// between the ribs are open at the front and at the back.
//
// Only the inner outline of the rack mount sleeve is reused, as a list of
// points measured from that mesh; the mesh itself is not needed to build.
//
// Model frame: X along the shelf edge, Y from the front face (0) to the
// back, Z up with the shelf underside at Z = 0.
//
// Build:  make rm10-hanger-plain         (STL and previews)
//         make rm10-hanger-plain-save    (copy the STL to models/)
// See specs/rm10-shelf-hanger.md for the reasons behind the numbers.

/* [Shelf] */
shelf_t  = 8;       // shelf thickness
clip_clr = 0.3;     // slack of the slot over the shelf thickness
grip_d   = 40;      // how far the upper jaw reaches over the shelf
jaw_t    = 4;       // upper jaw thickness
web_t    = 4;       // front panel, and the web in front of the shelf edge
plate_t  = 4;       // plate under the shelf
tip_c    = 2;       // lead-in chamfer at the tip of the upper jaw
clip_w   = 120;     // width of panel, plate and jaw

/* [Fit to the device] */
rm_h     = 47;      // device height at the head, feet included
head_clr = 1;       // slack between the head and the shelf underside
seat_d   = 55;      // panel front face to the back face of the device, as in the rack mount
clr_back = 0.5;     // slack between the device back and the stops

/* [Sleeve] */
wall_t   = 2.4;     // sleeve wall
gap      = 2;       // air channel between the device outline and the wall
rib_w    = 3;       // ribs that carry the device
rib_x    = [-36, -10, 10, 36]; // ribs above and below the device; the foot rails run 18 to 30 mm from the middle
rib_z    = [12, 26];           // ribs at each side, height above the sleeve floor
stop     = 4;       // how far each stop reaches in over the back face of the device
stop_z   = [10, 28];           // height range of the stops; the side outline is close to vertical there
flare    = 0.4;     // the opening is this much larger over the first millimetre (elephant foot)

/* [Preview only] */
rm_w = 84; rm_d = 93; rm_body_h = 37.5; rm_out = 37;

/* [Output] */
// "hanger" (print this), or a preview: "assembly", "side"
part = "hanger";

$fn = 48;
eps = 0.01;

// Right half of the inner outline of the rack mount sleeve, X from the
// middle, Z above the sleeve floor (under the feet). It is the device
// outline plus the slack the rack mount gives it.
half = [[0, 38.32], [16.9, 38.3], [26.43, 38.2], [30.75, 37.91], [34.45, 37.06],
        [37.5, 35.33], [38.28, 34.63], [40.11, 32.15], [41.2, 29.8], [41.69, 28.6],
        [41.85, 27.85], [42.28, 23.94], [42.49, 19.8], [42.34, 17.3], [42.01, 13.93],
        [40.36, 8.42], [39.81, 7.48], [39.32, 6.83], [36.58, 4.08], [35.96, 3.81],
        [31.22, 2.23], [30.44, 2.11], [29.81, 1.89], [29.08, 1.39], [28.42, 0.54],
        [27.53, 0], [19.58, 0], [18.75, 0.44], [18.09, 1.11], [17.59, 1.44],
        [17.09, 1.63], [16.26, 1.74], [0, 1.74]];
in_w = 42.49;       // half width of that outline
in_h = 38.32;       // its height

z_floor = -(rm_h + head_clr);            // sleeve floor, under the device feet
z_slot  = shelf_t + clip_clr;            // underside of the upper jaw
out_top = in_h + gap + wall_t;           // sleeve outside, above the sleeve floor
out_bot = -(gap + wall_t);
y_stop  = seat_d + clr_back - gap;       // where the stops start to grow from the wall
len     = y_stop + gap + stop;           // sleeve length

assert(z_floor + out_top <= -plate_t + eps, "sleeve reaches into the plate; raise head_clr or lower gap");
assert(clip_w / 2 >= in_w + gap + wall_t, "clip narrower than the sleeve");
assert(grip_d >= 3 * shelf_t, "upper jaw too short to hold");
assert(stop < 9, "stops cover the ports: only the outer 9 mm of the back face are free");

// For scripts that `use` this file (scripts/rm10_kumiko_panel.scad):
// [sleeve floor Z, face bottom Z, face top Z, face width, gap, half width and height of the outline]
function hanger_face() = [z_floor, z_floor + out_bot, z_slot + jaw_t, clip_w, gap, in_w, in_h];
function hanger_ribs() = [rib_w, rib_x, rib_z];

module box(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]);
}

// 2D, in (X, height above the sleeve floor)
module inner() { polygon(half); mirror([1, 0]) polygon(half); }
module cavity() { offset(r = gap) inner(); }
module shell() { offset(r = gap + wall_t) inner(); }
module ribs2d() {
    intersection() {
        difference() { offset(r = gap + 0.2) inner(); inner(); }
        union() {
            for (x = rib_x) translate([x - rib_w / 2, -50]) square([rib_w, 150]);
            for (z = rib_z) translate([-100, z - rib_w / 2]) square([200, rib_w]);
        }
    }
}

// extrude a 2D outline along Y from y0 to y1, with the sleeve floor at z_floor
module along(y0, y1) {
    translate([0, y1, z_floor]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}

// Stop: wedge on the side wall, growing towards the back at 45 degrees.
module stops() {
    s = gap + stop;
    for (m = [0, 1]) mirror([m, 0, 0])
        translate([in_w + gap, y_stop, z_floor + stop_z[0]])
            linear_extrude(stop_z[1] - stop_z[0])
                polygon([[0, 0], [wall_t / 2, 0], [wall_t / 2, s], [-s, s]]);
}

module hanger() {
    difference() {
        union() {
            // front panel and web, one flat face on the bed
            box(-clip_w / 2, clip_w / 2, 0, web_t, z_floor + out_bot, z_slot + jaw_t / 2);
            // plate under the shelf
            box(-clip_w / 2, clip_w / 2, 0, len, -plate_t, 0);
            // upper jaw with a lead-in at its tip
            hull() {
                box(-clip_w / 2, clip_w / 2, 0, web_t + grip_d - tip_c, z_slot, z_slot + jaw_t);
                box(-clip_w / 2, clip_w / 2, web_t + grip_d - eps, web_t + grip_d, z_slot + tip_c, z_slot + jaw_t);
            }
            // sleeve, and the block that joins it to the plate
            along(0, len) shell();
            box(-in_w, in_w, 0, len, z_floor + in_h, -plate_t + eps);
        }
        along(-1, len + 1) cavity();
    }
    along(0, len) ribs2d();
    stops();
}

module opening_relief() {
    along(-1, 1) offset(delta = flare) inner();
}

module part_hanger() {
    difference() { hanger(); opening_relief(); }
}

// Stand-in for the device: rear body in the sleeve, head in front of the panel.
module rm10() {
    color([0.25, 0.27, 0.3]) translate([rm_w / 2, 0, 0]) rotate([90, 0, -90])
        linear_extrude(rm_w) offset(r = 3) offset(delta = -3)
            polygon([[-seat_d, 2.5], [-seat_d, rm_body_h], [0, rm_body_h],
                     [17, rm_h], [19.5, rm_h], [rm_d - seat_d, 9], [rm_d - seat_d - 8, 2.5]]);
}

module assembly() {
    color("Orange") part_hanger();
    translate([0, 0, z_floor]) rm10();
    color("BurlyWood", 0.5) box(-clip_w / 2 - 40, clip_w / 2 + 40, web_t, web_t + 150, 0, shelf_t);
}

if (part == "hanger") {
    rotate([90, 0, 0]) part_hanger();    // on the front face: Y becomes the print Z
} else if (part == "assembly") {
    assembly();
} else if (part == "side") {
    intersection() {
        assembly();
        box(-0.5, clip_w / 2 + 50, -100, 300, -100, 100);
    }
} else {
    assert(false, "unknown part");
}
