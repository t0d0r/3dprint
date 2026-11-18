// Shelf hanger for one GL.iNet Comet Pro (GL-RM10), made from the 10 inch
// rack mount models/Comet-Pro-RM10-10inch-3d-printable-rack-mount-1-lot.stl.
//
// The rack mount is a 255 x 43.5 x 4 mm front panel with a slotted sleeve
// behind it; the device slides in through the panel until it meets the lip
// at the end of the sleeve. Here the rack ears are cut off and a clip is
// added above the sleeve: a plate under the shelf, a web in front of the
// shelf edge and a jaw on top of the shelf. The clip is pushed onto the
// front edge of the shelf; no screws.
//
// Model frame: X along the shelf edge, Y from the front face of the panel
// (0) to the back, Z up with the shelf underside at Z = 0.
// The STL is exported standing on the front face, as the rack mount is
// printed: every added wall is vertical, no supports.
//
// Build:  make rm10-hanger         (STL and previews)
//         make rm10-hanger-save    (copy the STL to models/)
// See specs/rm10-shelf-hanger.md for the reasons behind the numbers.

/* [Shelf] */
shelf_t  = 8;       // shelf thickness
clip_clr = 0.3;     // slack of the slot over the shelf thickness
grip_d   = 40;      // how far the upper jaw reaches over the shelf
jaw_t    = 4;       // upper jaw thickness
web_t    = 4;       // web in front of the shelf edge; same as the rack panel
plate_t  = 4;       // plate under the shelf
tip_c    = 2;       // lead-in chamfer at the tip of the upper jaw

/* [Fit to the device] */
rm_h     = 47;      // device height at the head, feet included
head_clr = 1;       // slack between the head and the shelf underside

/* [Body] */
half_w   = 72;      // the panel is cut to +-half_w; the sleeve gussets end at 71.2
rib_w    = 3;       // ribs between the sleeve and the plate
rib_x    = [-24, 0, 24]; // rib centres; the top vent slots run 2 to 17 mm each side of 0
rib_sink = 0.8;     // how far the ribs reach into the top wall of the sleeve

/* [Source mesh, measured with scripts/mesh_info.py and sections] */
src = "../models/Comet-Pro-RM10-10inch-3d-printable-rack-mount-1-lot.stl";
src_rot    = 45;      // the mesh lies diagonally on the bed
src_floor  = 192.33;  // y of the sleeve floor (under the feet) after the rotation
src_len    = 57.76;   // panel front face to the end of the sleeve
src_top    = 40.52;   // top of the sleeve above its floor
src_ptop   = 41.55;   // top edge of the panel above the sleeve floor
src_pbot   = -1.95;   // bottom edge of the panel
src_panel  = 4;       // panel thickness

/* [Preview only] */
rm_w = 84; rm_d = 93; rm_body_h = 37.5; rm_out = 37;

/* [Output] */
// "hanger" (print this), or a preview: "assembly", "side"
part = "hanger";

$fn = 48;
eps = 0.01;

z_floor = -(rm_h + head_clr);            // sleeve floor, under the device feet
z_top   = z_floor + src_top;             // top of the sleeve
z_ptop  = z_floor + src_ptop;            // top edge of the rack panel
z_slot  = shelf_t + clip_clr;            // underside of the upper jaw

assert(web_t == src_panel, "web and panel differ in thickness: the print face is no longer flat");
assert(z_top < -plate_t, "sleeve reaches into the plate; raise head_clr");
assert(grip_d >= 3 * shelf_t, "upper jaw too short to hold");
assert(half_w > 50, "cut goes through the sleeve");

module box(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]);
}

// Rack mount in the model frame: panel front face at Y = 0, sleeve to +Y,
// sleeve floor at z_floor. Proper rotations only, the part is not mirrored.
module rack() {
    translate([0, 0, z_floor]) rotate([0, 0, 180]) rotate([90, 0, 0])
        translate([0, -src_floor, 0]) rotate([0, 0, src_rot]) import(src, convexity = 10);
}

module clip() {
    // web: continues the panel upwards, in front of the shelf edge
    box(-half_w, half_w, 0, web_t, z_ptop - 1, z_slot + jaw_t / 2);
    // plate under the shelf, as long as the sleeve
    box(-half_w, half_w, 0, src_len, -plate_t, 0);
    // upper jaw with a lead-in at its tip
    y1 = web_t + grip_d;
    hull() {
        box(-half_w, half_w, 0, y1 - tip_c, z_slot, z_slot + jaw_t);
        box(-half_w, half_w, y1 - eps, y1, z_slot + tip_c, z_slot + jaw_t);
    }
    // ribs: carry the sleeve, leave the top vent slots open
    for (x = rib_x)
        box(x - rib_w / 2, x + rib_w / 2, web_t - eps, src_len, z_top - rib_sink, -plate_t + eps);
}

module hanger() {
    intersection() {
        rack();
        box(-half_w, half_w, -1, src_len + 1, z_floor + src_pbot - 1, z_ptop + 1);
    }
    clip();
}

// Stand-in for the device: rear body in the sleeve, head in front of the panel.
module rm10() {
    color([0.25, 0.27, 0.3]) translate([rm_w / 2, 0, 0]) rotate([90, 0, -90])
        linear_extrude(rm_w) offset(r = 3) offset(delta = -3)
            polygon([[-(rm_d - rm_out), 2.5], [-(rm_d - rm_out), rm_body_h], [0, rm_body_h],
                     [17, rm_h], [19.5, rm_h], [rm_out, 9], [rm_out - 8, 2.5]]);
}

module assembly() {
    color("Orange") hanger();
    translate([0, 0, z_floor]) rm10();
    color("BurlyWood", 0.5) box(-half_w - 40, half_w + 40, web_t, web_t + 150, 0, shelf_t);
}

if (part == "hanger") {
    rotate([90, 0, 0]) hanger();         // on the front face: Y becomes the print Z
} else if (part == "assembly") {
    assembly();
} else if (part == "side") {
    intersection() {
        assembly();
        box(-0.5, half_w + 50, -100, 300, -100, 100);
    }
} else {
    assert(false, "unknown part");
}
