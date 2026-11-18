// Kumiko cover for the RM10 shelf hanger without holes
// (scripts/rm10_shelf_hanger_plain.scad). Two flat lattices that make an L:
// a front panel against the front face of the hanger, and a top panel on
// the upper jaw of the clip, on top of the shelf.
//
// Pattern: asanoha (hemp leaf), a grid of equilateral triangles, each with
// three thin bars from its centre to its corners. Both panels use the same
// triangle and the same width, so the pattern runs round the corner.
//
// Why two pieces: a lattice of this pattern always has bars 30 degrees
// from the bed when it is printed standing, in every orientation. Printed
// flat it has no overhang at all. So each leg of the L is printed flat and
// the two are joined like kumiko itself: two tenons on the top edge of the
// front panel go through two mortises in the top panel.
//
// Fixing: five tabs on the back of the front panel are pushed into the air
// channels of the sleeve, between its ribs. The top panel lies on the jaw
// and is held in place by the tenons.
//
// Model frame as the hanger: X along the shelf edge, Y to the back with
// the hanger front face at Y = 0, Z up with the shelf underside at Z = 0.
// The STL holds both panels laid out for printing, visible faces down.
//
// Build:  make kumiko-panel         (STL and previews)
//         make kumiko-panel-save    (copy the STL to models/)
// See specs/rm10-kumiko-panel.md for the reasons behind the numbers.

use <rm10_shelf_hanger_plain.scad>

/* [Panels] */
rows     = 4;       // rows of triangles over the height of the front panel
cols     = 8;       // triangle sides over the width
rows_top = 3;       // rows of triangles over the depth of the top panel
over     = 6;       // front panel beyond the hanger face at the bottom
frame_w  = 4;       // outer frame
panel_t  = 3;       // thickness of frame, rim and grid bars
corner_r = 10;      // radius of the free corners: bottom of the front panel, back of the top panel

/* [Lattice] */
grid_w   = 1.6;     // bars of the triangle grid
leaf_w   = 1.0;     // bars from the centre of a triangle to its corners
leaf_t   = 2;       // their thickness; flush at the visible face, shallower behind

/* [Opening] */
rim_w    = 3;       // solid rim round the opening

/* [Tabs] */
tab_d    = 8;       // how far the tabs reach into the sleeve
tab_out  = 0.1;     // slack between a tab and the sleeve wall
tab_in   = 0.2;     // slack between a tab and the device outline
tab_side = 0.4;     // slack between a tab and the ribs next to it

/* [Corner joint] */
tenon_w   = 10;     // width of each tenon
tenon_t   = 2;      // its thickness, from the front face of the front panel
tenon_x   = 40;     // tenon centres, left and right of the middle
tenon_clr = 0.15;   // slack of a mortise round its tenon, each side
nose      = 1.5;    // the top panel reaches this far in front of the front panel
front_frame = 5.5;  // frame of the top panel at its front edge; holds the mortises

/* [Output] */
// "plate" (print this: both panels), "front_panel", "top_panel",
// or a preview: "assembly", "view"
part = "plate";

$fn = 32;
eps = 0.01;

f = hanger_face();
z_floor = f[0]; face_bot = f[1]; face_top = f[2]; face_w = f[3];
gap = f[4]; in_w = f[5]; in_h = f[6];
r = hanger_ribs();
rib_w = r[0]; rib_x = r[1]; rib_z = r[2];

// Front panel, 2D frame: X, and H = height above the sleeve floor.
// Its top edge is level with the top of the upper jaw.
h_bot   = face_bot - over - z_floor;
h_top   = face_top - z_floor;
panel_h = h_top - h_bot;
tri_h   = (panel_h - 2 * frame_w) / rows;      // height of a triangle
tri_a   = tri_h * 2 / sqrt(3);                 // its side
panel_w = cols * tri_a + 2 * frame_w;
rib_c   = rib_w / 2 + tab_side;                // keep-out round a rib centre

// Top panel, 2D frame: X, Y.
top_y0  = -panel_t - nose;                     // front edge
top_d   = front_frame + rows_top * tri_h + frame_w;
top_y1  = top_y0 + top_d;

echo(panel_w = panel_w, panel_h = panel_h, top_depth = top_d, triangle_side = tri_a);
assert(panel_w >= face_w, "panel narrower than the hanger face; raise cols");
assert(cols % 2 == 0, "cols must be even for a pattern that is symmetric left to right");
assert(tab_out + tab_in < gap - 1.2, "tabs thinner than 1.2 mm");
assert(leaf_t <= panel_t && leaf_w <= grid_w, "leaf bars must not be larger than the grid bars");
assert(corner_r >= frame_w && corner_r < min(panel_h, top_d) / 2, "corner radius out of range");
assert(tenon_t <= panel_t, "tenon thicker than the panel");
assert(nose - tenon_clr >= 1.2, "less than 1.2 mm in front of the mortises");
assert(front_frame >= nose + tenon_t + tenon_clr + 1.2, "front frame of the top panel too narrow for the mortises");
assert(tenon_x + tenon_w / 2 + 2 < panel_w / 2 - frame_w, "tenons too far out");

module bar(a, b, w) {
    hull() { translate(a) circle(d = w); translate(b) circle(d = w); }
}

// One triangle of the pattern.
module tri_grid(p) { for (i = [0 : 2]) bar(p[i], p[(i + 1) % 3], grid_w); }
module tri_leaf(p) {
    c = (p[0] + p[1] + p[2]) / 3;
    for (i = [0 : 2]) bar(c, p[i], leaf_w);
}

// All triangles of a field n rows tall whose lowest row starts at y0: row j
// has its lower corners at i * tri_a from the left edge, shifted by half a
// side on odd rows; each lower corner starts one triangle pointing up and
// one pointing down.
function tri_list(y0, n) = [
    for (j = [0 : n - 1], i = [-1 : cols + 1], up = [0, 1])
        let (x = -cols / 2 * tri_a + (i + (j % 2) / 2) * tri_a,
             y = y0 + j * tri_h)
        up ? [[x, y], [x + tri_a, y], [x + tri_a / 2, y + tri_h]]
           : [[x, y], [x + tri_a / 2, y + tri_h], [x - tri_a / 2, y + tri_h]]
];

// Rectangle with two rounded corners: at the y0 side if side < 0, at the
// y1 side if side > 0. The other two corners stay square; they are the
// ones at the joint of the L.
module rrect(x0, x1, y0, y1, rad, side) {
    yr = side < 0 ? y0 + rad : y1 - rad;
    hull() {
        for (x = [x0 + rad, x1 - rad]) translate([x, yr]) circle(r = rad, $fn = 64);
        translate([x0, side < 0 ? yr : y0]) square([x1 - x0, side < 0 ? y1 - yr : yr - y0]);
    }
}

// field: the inside of a frame, from y0, n rows tall; the frame keeps its
// width round the corners
module field(y0, n, side) {
    rrect(-panel_w / 2 + frame_w, panel_w / 2 - frame_w, y0, y0 + n * tri_h,
          max(corner_r - frame_w, 0.01), side);
}
module grid2d(y0, n, side) {
    // runs on inside the frame like the leaf bars; grid and frame are one 2D shape
    intersection() { offset(r = frame_w - 1) field(y0, n, side); for (p = tri_list(y0, n)) tri_grid(p); }
}
module leaf2d(y0, n, side) {
    // The shallower bars run on inside the frame, to 1 mm from its outer
    // edge, so that they share no face with it and no end cap is cut.
    intersection() { offset(r = frame_w - 1) field(y0, n, side); for (p = tri_list(y0, n)) tri_leaf(p); }
}

// ---- front panel ----

fy0 = h_bot + frame_w;
module opening() { offset(r = gap) inner(); }  // as large as the sleeve cavity
module rim_area() { offset(r = gap + rim_w) inner(); }
module frame2d() {
    difference() {
        rrect(-panel_w / 2, panel_w / 2, h_bot, h_top, corner_r, -1);
        field(fy0, rows, -1);
    }
    rim_area();
}

// Where tabs may be: between the ribs of the sleeve, and not above the
// device, where its head rises just in front of the hanger face.
module tab_zones() {
    xb = rib_x[len(rib_x) / 2] - rib_c;        // first rib right of the middle
    xo = rib_x[len(rib_x) - 1] + rib_c;        // outermost rib
    translate([-xb, -10]) square([2 * xb, 12]);                    // under the device
    for (m = [0, 1]) mirror([m, 0]) {
        translate([xo, -10]) square([20, 10 + rib_z[0] - rib_c]);  // lower corner
        translate([xo, rib_z[0] + rib_c]) square([20, rib_z[1] - rib_z[0] - 2 * rib_c]); // side
    }
}
module tabs2d() {
    intersection() {
        difference() { offset(r = gap - tab_out) inner(); offset(delta = tab_in) inner(); }
        tab_zones();
    }
}
// the same zones through the panel thickness, joined to the rim
module tab_roots2d() {
    intersection() {
        difference() { offset(r = gap + 1) inner(); offset(delta = tab_in) inner(); }
        tab_zones();
    }
}
module tenons2d() {
    for (x = [-tenon_x, tenon_x])
        translate([x - tenon_w / 2, h_top - 1]) square([tenon_w, panel_t + 1]);
}

// extrude a 2D shape in (X, H) along Y from y0 to y1
module along(y0, y1) {
    translate([0, y1, z_floor]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
}

module front_panel() {
    along(-panel_t, 0) {
        difference() { union() { frame2d(); grid2d(fy0, rows, -1); } opening(); }
        tab_roots2d();
    }
    along(-panel_t, -panel_t + leaf_t)
        difference() { leaf2d(fy0, rows, -1); offset(r = gap + rim_w - 0.3) inner(); }
    along(-panel_t, -panel_t + tenon_t) tenons2d();
    along(-eps, tab_d) tabs2d();
}

// ---- top panel ----

ty0 = top_y0 + front_frame;
module top_panel() {
    translate([0, 0, face_top]) {
        linear_extrude(panel_t) difference() {
            union() {
                difference() {
                    rrect(-panel_w / 2, panel_w / 2, top_y0, top_y1, corner_r, 1);
                    field(ty0, rows_top, 1);
                }
                grid2d(ty0, rows_top, 1);
            }
            for (x = [-tenon_x, tenon_x])      // mortises
                translate([x - tenon_w / 2 - tenon_clr, -panel_t - tenon_clr])
                    square([tenon_w + 2 * tenon_clr, tenon_t + 2 * tenon_clr]);
        }
        translate([0, 0, panel_t - leaf_t]) linear_extrude(leaf_t) leaf2d(ty0, rows_top, 1);
    }
}

if (part == "plate" || part == "front_panel" || part == "top_panel") {
    // visible faces on the bed; the top panel lies behind the front panel
    if (part != "top_panel")
        translate([0, 0, panel_t]) rotate([90, 0, 0]) front_panel();
    if (part != "front_panel")
        translate([0, h_top - z_floor + 8 + top_y1, face_top + panel_t])
            rotate([180, 0, 0]) top_panel();
} else if (part == "assembly" || part == "view") {
    color("Ivory") { front_panel(); top_panel(); }
    color("Orange") part_hanger();
    if (part == "assembly") {
        translate([0, 0, z_floor]) rm10();
        color("BurlyWood", 0.5) translate([-panel_w / 2 - 30, 4, 0]) cube([panel_w + 60, 150, 8]);
    }
} else {
    assert(false, "unknown part");
}
