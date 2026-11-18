// Under-shelf mount for one GL.iNet Comet Pro (GL-RM10) and two JetKVM
// Mini W, side by side in one row: mini, RM10, mini.
//
// A top plate is screwed to the underside of the shelf through two ears,
// one at each end of the row. Three open-front bays hang from the plate.
// Each device slides in from the front until it meets two wedge stops at
// the back of its bay. The RM10 bay holds only the rear body: the head with
// the screen stays rm_out in front of the mount, so its curve is visible. Front and back of every bay are open for the screen
// and the cables.
//
// The mini bays are only as deep as a mini and are flush with the front,
// so the minis are not buried in a tunnel; their cables leave under the
// plate behind them. The space under the mini bays is open.
//
// Model frame: X along the row, Y from the front (0) to the back, Z up
// with the shelf underside at Z = 0; the mount hangs into -Z.
// The STL is exported standing on its front face, which is how it prints:
// no supports, the stops grow at 45 degrees, all slots bridge 8 mm or less.
//
// Build:  make kvm-mount         (STL and previews)
//         make kvm-mount-save    (copy the STL to models/)
// See specs/kvm-shelf-mount.md for the reasons behind the numbers.

/* [GL-RM10, dimension drawing: 84 wide, 93 deep, 47 tall] */
// The RM10 is not a box. Seen from the side the rear body is about 37.5 mm
// tall; near the front the top sweeps up to a 47 mm head that carries the
// screen, and the screen face leans back. The bay is the 84 x 47 mm tunnel
// the head needs; the rear body leaves about 10 mm of air under the plate.
rm_w = 84;          // width, the face with the screen
rm_d = 93;          // depth, lower edge of the screen to the port face
rm_h = 47;          // height at the head, feet included
rm_body_h   = 37.5; // height of the rear body, feet included (preview only)
rm_head_d   = 17.5; // front edge to where the head reaches full height (preview only)
rm_rise_d   = 37;   // front edge to where the top starts to rise (preview only)
rm_chin_h   = 9;    // lower edge of the screen above the feet (preview only)
rm_foot_h   = 2.5;  // foot rails under the body (preview only)
rm_foot_in  = 16.5; // foot rail centre to the side of the device
rm_out      = 37;   // how far the RM10 sticks out in front of the mount; 0 hides it in the bay
rm_hold_n   = 2;    // hold-down ribs above the rear body, against tipping forward; 0 for none
rm_hold_clr = 1.5;  // slack between those ribs and the top of the rear body

/* [JetKVM Mini W, published: 42 x 42 x 23 mm] */
mini_w = 42;        // width
mini_d = 42;        // depth
mini_h = 23;        // height, lying flat

/* [Fit] */
clr_side = 0.5;     // slack at each side of a device
clr_h    = 0.6;     // slack above a device
clr_back = 0.5;     // slack between the device back and the stops

/* [Body] */
top_t   = 3;        // plate against the shelf
wall_t  = 3;        // bay walls
floor_t = 3;        // bay floors
rm_stop   = 4;      // how far each RM10 stop reaches in from its wall
mini_stop = 2;      // same for a mini
flare   = 0.8;      // each bay opens by this much at the front
lead    = 3;        // length of that lead-in

/* [Ears and screws] */
ear_w        = 13;  // plate beyond the outer walls; total width must fit the bed
ear_t        = 4;   // ear thickness (holds the countersink)
screw_inset  = 14;  // hole centre to the front and to the back edge
screw_d      = 4.5; // clearance hole, for a 4 mm countersunk wood screw
screw_head_d = 8.5; // head diameter at the underside of the ear

/* [Openings] */
slot_w     = 8;     // width of every vent slot (bridged when printing)
slot_gap   = 6;     // least material between two floor slots
slot_edge  = 24;    // floor left solid at each side; the foot rails run 14 to 20 mm in
slot_front = 12;    // floor and wall left solid at the front
slot_back  = 16;    // same at the back
side_slots = 2;     // vent slots in each wall of the RM10 bay, below the mini floor; 0 for none
mini_win   = 30;    // window in a mini floor (screen visible if the mini lies screen down); 0 for none
mini_win_c = 9;     // 45 degree corners of that window at its back edge

/* [Preview only] */
shelf_t = 18;

/* [Output] */
// "mount" (print this), or a preview: "assembly", "plan" (seen from below)
part = "mount";

$fn = 48;
eps = 0.01;

mb_w = mini_w + 2 * clr_side;            // mini bay, inside
mb_h = mini_h + clr_h;
mb_d = mini_d + clr_back + mini_stop;    // depth of the mini bays
rb_w = rm_w + 2 * clr_side;              // RM10 bay, inside
rb_h = rm_h + clr_h;
rb_d = rm_d - rm_out + clr_back + rm_stop;  // depth of the RM10 bay
depth = max(rb_d, mb_d);                 // depth of the plate

x_w1 = ear_w;                            // left outer wall
x_m1 = x_w1 + wall_t;                    // left mini bay
x_w2 = x_m1 + mb_w;                      // wall between left mini and RM10
x_rm = x_w2 + wall_t;                    // RM10 bay
x_w3 = x_rm + rb_w;                      // wall between RM10 and right mini
x_m2 = x_w3 + wall_t;                    // right mini bay
x_w4 = x_m2 + mb_w;                      // right outer wall
width = x_w4 + wall_t + ear_w;

z_mc = -top_t;                           // ceiling of every bay
z_mf = z_mc - mb_h;                      // mini floor, top face
z_rf = z_mc - rb_h;                      // RM10 floor, top face
height = -z_rf + floor_t;

slot_len = depth - slot_front - slot_back;
floor_n  = floor((rb_w - 2 * slot_edge + slot_gap) / (slot_w + slot_gap));
floor_pitch = floor_n > 1 ? (rb_w - 2 * slot_edge - slot_w) / (floor_n - 1) : 0;
side_zone = (z_mf - floor_t) - z_rf;     // wall height below the mini floor

assert(ear_w >= screw_head_d + 2, "ear too narrow for the screw head");
assert(ear_t > (screw_head_d - screw_d) / 2 + 1, "ear too thin for the countersink");
assert(screw_inset * 2 + screw_head_d < depth, "screw holes overlap");
assert(slot_len > 20, "plate too short for the vent slots");
assert(floor_n >= 1, "RM10 bay too narrow for a floor slot");
assert(side_slots == 0 || side_zone >= slot_w + 4, "no room for side slots under the mini floor");
assert(mini_win == 0 || mini_win + 8 <= mb_w, "mini window leaves less than 4 mm ledges");
assert(mini_win == 0 || mini_win_c * 2 < mini_win, "mini window corners too large");
assert(slot_edge >= rm_foot_in + 5, "a floor slot runs under a foot rail");
assert(rm_out >= 0 && rm_out <= rm_rise_d, "rm_out beyond the start of the rise: the rear body would lose support");
assert(rb_d >= mb_d, "RM10 bay shorter than the mini bays; lower rm_out");
assert(rm_stop * 2 < rb_w / 3 && mini_stop * 2 < mb_w / 3, "stops close the back of a bay");

module box(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]);
}

// Stop: triangular prism on a wall face at x, growing towards the back to
// s at y_end. dir = +1 points to +X, -1 to -X.
module stop(x, dir, s, y_end, z0, z1) {
    translate([x, 0, z0]) linear_extrude(z1 - z0)
        polygon([[-dir * eps, y_end - s], [-dir * eps, y_end], [dir * s, y_end]]);
}

// Lead-in of a bay: widens the opening by flare at the front face.
module lead_in(x0, x1, z0, z1) {
    hull() {
        box(x0, x1, lead, lead + eps, z0, z1);
        box(x0 - flare, x1 + flare, -eps, 0, z0 - flare, z1);
    }
}

module body() {
    box(0, width, 0, depth, -top_t, 0);                       // plate
    for (x = [0, width - ear_w]) box(x, x + ear_w, 0, depth, -ear_t, 0);
    for (x = [x_w1, x_w4]) box(x, x + wall_t, 0, mb_d, z_mf - floor_t, 0);
    for (x = [x_w2, x_w3]) box(x, x + wall_t, 0, depth, z_rf - floor_t, 0);
    box(x_w1, x_w2 + wall_t, 0, mb_d, z_mf - floor_t, z_mf);  // mini floors
    box(x_w3, x_w4 + wall_t, 0, mb_d, z_mf - floor_t, z_mf);
    box(x_w2, x_w3 + wall_t, 0, depth, z_rf - floor_t, z_rf); // RM10 floor

    for (b = [[x_m1, 1], [x_w2, -1], [x_m2, 1], [x_w4, -1]])
        stop(b[0], b[1], mini_stop, mb_d, z_mf, z_mc);
    for (b = [[x_rm, 1], [x_w3, -1]])
        stop(b[0], b[1], rm_stop, depth, z_rf, z_mc);

    // hold-down ribs: the head stays in front of the mount, so only the
    // lower rear body is in the bay and nothing else keeps it from tipping
    if (rm_hold_n > 0 && rm_out > 0) {
        z_h = z_rf + rm_body_h + rm_hold_clr;
        c = 3;                                   // lead-in chamfer at the front
        for (i = [1 : rm_hold_n]) {
            x = x_rm + i * rb_w / (rm_hold_n + 1) - wall_t / 2;
            translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(wall_t)
                polygon([[0, z_mc + eps], [depth, z_mc + eps], [depth, z_h],
                         [c, z_h], [0, z_h + c]]);
        }
    }
}

module screw_holes() {
    cs = (screw_head_d - screw_d) / 2;
    for (x = [ear_w / 2, width - ear_w / 2], y = [screw_inset, depth - screw_inset])
        translate([x, y, 0]) {
            translate([0, 0, -ear_t - 1]) cylinder(d = screw_d, h = ear_t + 2);
            translate([0, 0, -ear_t - eps]) cylinder(d1 = screw_head_d, d2 = screw_d, h = cs);
            translate([0, 0, -ear_t - 1]) cylinder(d = screw_head_d, h = 1);
        }
}

module openings() {
    // RM10 floor: slots along the depth
    for (i = [0 : floor_n - 1]) {
        x = x_rm + slot_edge + i * floor_pitch;
        box(x, x + slot_w, slot_front, depth - slot_back, z_rf - floor_t - 1, z_rf + eps);
    }
    // RM10 bay walls, the part below the mini floors
    if (side_slots > 0) {
        post = 8;
        len = (slot_len - (side_slots - 1) * post) / side_slots;
        z0 = z_rf + 2;
        for (x = [x_w2, x_w3], i = [0 : side_slots - 1]) {
            y = slot_front + i * (len + post);
            box(x - 1, x + wall_t + 1, y, y + len, z0, z0 + slot_w);
        }
    }
    // mini floors: screen window, pointed towards the back so it prints
    if (mini_win > 0) {
        y0 = (mini_d - mini_win) / 2;
        for (x = [x_m1, x_m2])
            translate([x + (mb_w - mini_win) / 2, y0, z_mf - floor_t - 1])
                linear_extrude(floor_t + 2)
                    polygon([[0, 0], [mini_win, 0], [mini_win, mini_win - mini_win_c],
                             [mini_win - mini_win_c, mini_win], [mini_win_c, mini_win],
                             [0, mini_win - mini_win_c]]);
    }
}

module mount() {
    difference() {
        body();
        screw_holes();
        openings();
        for (x = [x_m1, x_m2]) lead_in(x, x + mb_w, z_mf, z_mc);
        lead_in(x_rm, x_rm + rb_w, z_rf, z_mc);
    }
}

// Rounded stand-in for a device, front face at y = 0.
module device(w, d, h, r, col, screen) {
    color(col) translate([r, r, r]) minkowski() {
        cube([w - 2 * r, d - 2 * r, h - 2 * r]);
        sphere(r, $fn = 24);
    }
    color("DeepSkyBlue") translate(screen) children();
}

// Side profile of the RM10 in (Y, Z): front at Y = 0, feet on Z = 0.
module rm10_profile() {
    offset(r = 3) offset(delta = -3)
        polygon([[rm_d, rm_foot_h], [rm_d, rm_body_h], [rm_rise_d, rm_body_h],
                 [rm_head_d + 2.5, rm_h], [rm_head_d, rm_h], [0, rm_chin_h],
                 [8, rm_foot_h]]);
}

module rm10() {
    color([0.25, 0.27, 0.3]) {
        translate([rm_w, 0, 0]) rotate([90, 0, -90]) mirror([1, 0, 0])
            linear_extrude(rm_w) rm10_profile();
        for (x = [rm_foot_in, rm_w - rm_foot_in])
            translate([x - 3, 25, 0]) cube([6, 55, rm_foot_h + 1]);
    }
    // screen, on the leaning front face
    a = atan2(rm_head_d, rm_h - rm_chin_h);
    color("DeepSkyBlue") translate([12, 0, rm_chin_h]) rotate([-a, 0, 0])
        translate([0, -0.4, 6]) cube([rm_w - 24, 1, 28]);
}

module devices() {
    translate([x_rm + clr_side, -rm_out, z_rf]) rm10();
    for (x = [x_m1, x_m2])
        translate([x + clr_side, 0, z_mf])
            device(mini_w, mini_d, mini_h, 2, [0.7, 0.7, 0.72], [7, 7, -0.3])
                cube([mini_w - 14, mini_d - 14, 1]);
}

if (part == "mount") {
    // stand it on its front face: Y becomes the print Z
    translate([0, 0, 0]) rotate([90, 0, 0]) translate([0, 0, 0]) mount();
} else if (part == "assembly") {
    color("Orange") mount();
    devices();
    color("BurlyWood", 0.5) box(-30, width + 30, -20, depth + 60, 0, shelf_t);
} else if (part == "plan") {
    color("Orange") mount();
    devices();
} else {
    assert(false, "unknown part");
}
