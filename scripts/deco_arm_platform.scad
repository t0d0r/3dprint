// Platform for a TP-Link Deco (110 mm cylinder) on top of the swivel
// knuckle of a monitor arm, next to the VESA head.
//
// Two printed pieces:
//   tray  a round floor that lies on the flat top of the knuckle. Two
//         split cheeks reach down beside the knuckle and stop the tray
//         from turning or sliding. One cable tie goes through two
//         slots in the floor, in the gap of the cheeks, and around the
//         knuckle; on the top face it lies in a groove under the Deco.
//   rim   a loose band dropped over the edge of the floor. A step in
//         its bore rests on the floor; above the floor it stands 6 mm
//         high around the Deco.
//
// Seen from above the arm is an L: the link from the VESA head meets
// the knuckle and the spring arm at 90 degrees (arm_angle).
//
// Model frame: +X away from the VESA plate, Y along the plate, Z up. The Deco stands on Z = 0 with its axis on the origin.
// The top of the knuckle is at Z = -floor_t.
//
// Both pieces print without supports: the tray upside down on its top
// face, the rim upside down on its upper edge.
//
// Build:  make deco-platform        (STLs and previews)
//         make deco-platform-fit    (small test piece of the saddle)
//         make deco-platform-save   (copy the STLs to models/)
// See specs/deco-arm-platform.md. The arm numbers are read from photos
// and must be checked with the fit piece.

/* [Deco] */
deco_d   = 110;     // diameter of the Deco
deco_h   = 114;     // preview only
deco_clr = 2;       // added to the diameter inside the rim

/* [Arm, estimated from photos] */
knuckle_w   = 28;   // width of the knuckle block across the arm
knuckle_clr = 1;    // added to the width between the cheeks
knuckle_len = 36;   // flat top from the pin axis to the end of the block, towards the spring arm
boss_d      = 24;   // cap of the swivel pin on top of the knuckle
boss_h      = 1.5;  // how far the cap stands above the flat top
boss_clr    = 2;    // added to the pocket diameter
pin_to_plate = 51;  // pin axis to the face of the VESA plate
// Angle in plan between the knuckle (towards the spring arm) and the
// direction away from the plate: 90 = spring arm to the right seen
// from behind the plate, -90 = to the left, 0 = straight.
arm_angle   = 90;
plate_gap   = 2;    // air between the rim and the plate

/* [Tray] */
floor_t  = 4;       // floor thickness
step     = 1.2;     // floor edge outside the Deco bore; the rim rests on it
cheek_t  = 5;       // cheek thickness
cheek_h  = 10;      // cheek height below the floor
cheek_x0 = 2;       // cheeks start this far from the pin axis, along the knuckle

/* [Cable tie] */
tie_x    = 22;      // tie position, from the pin axis along the knuckle
tie_w    = 7;       // slot length along the knuckle (tie up to 5 mm wide)
tie_t    = 3;       // slot width across the knuckle
groove_d = 1.8;     // groove for the tie in the top face

/* [Rim] */
rim_h     = 6;      // height above the floor
band_wall = 2;      // wall of the band around the floor edge
band_clr  = 0.3;    // added to the bore around the floor edge

/* [Output] */
// "tray", "rim", "fit" (print these), or a preview: "assembly", "side", "below"
part = "tray";

$fn = 128;
eps = 0.01;

tray_d  = deco_d + deco_clr;                  // bore of the rim above the floor
disc_d  = tray_d + 2 * step;                  // floor disc
band_od = disc_d + band_clr + 2 * band_wall;
w_in    = knuckle_w + knuckle_clr;            // clear width between the cheeks
// The tray is pushed away from the plate until the rim clears it.
tray_off = max(0, band_od / 2 + plate_gap - pin_to_plate);
pin_x   = -tray_off;                          // pin axis in the model frame
// Along the knuckle, measured from the pin axis.
seg1 = [cheek_x0, tie_x - tie_w / 2 - 0.5];
seg2 = [tie_x + tie_w / 2 + 0.5, knuckle_len];
// The cheek on the plate side has no front segment: under it the link
// to the VESA head leaves the knuckle.
inner = arm_angle > 0 ? 1 : arm_angle < 0 ? 0 : -1;

function sad(p) = [pin_x + p[0] * cos(arm_angle) - p[1] * sin(arm_angle),
                   p[0] * sin(arm_angle) + p[1] * cos(arm_angle)];

assert(seg1[1] - seg1[0] >= 6, "front cheek segment under 6 mm; move tie_x away from the pin");
assert(seg2[1] - seg2[0] >= 6, "rear cheek segment under 6 mm; move tie_x towards the pin");
assert(boss_h < floor_t - 1.6, "boss pocket leaves under 1.6 mm of floor");
assert(groove_d < floor_t - 1.6, "tie groove leaves under 1.6 mm of floor");
assert(tie_x - tie_w / 2 > (boss_d + boss_clr) / 2 + 1, "tie groove runs over the boss pocket");
assert(max([for (x = [seg1[0], seg2[1]], y = [-1, 1]) norm(sad([x, y * (w_in / 2 + cheek_t)]))])
       < disc_d / 2 - 1, "cheeks reach the edge of the floor");

// Saddle frame: pin axis on the origin, X along the knuckle.
module saddle_frame() {
    translate([pin_x, 0, 0]) rotate(arm_angle) children();
}

// Cheeks, pocket, slots and groove; shared by the tray and the fit piece.
module saddle_add() {
    saddle_frame()
        for (s = [0, 1], seg = (s == inner ? [seg2] : [seg1, seg2]))
            translate([seg[0], s ? w_in / 2 : -w_in / 2 - cheek_t, -floor_t - cheek_h])
                cube([seg[1] - seg[0], cheek_t, cheek_h + eps]);
}

module saddle_cut() {
    saddle_frame() {
        // pocket for the cap of the swivel pin
        translate([0, 0, -floor_t - eps]) cylinder(d = boss_d + boss_clr, h = boss_h + eps);
        // tie slots, right beside the knuckle
        for (s = [0, 1])
            translate([tie_x - tie_w / 2, s ? w_in / 2 : -w_in / 2 - tie_t, -floor_t - eps])
                cube([tie_w, tie_t, floor_t + 2 * eps]);
        // groove in the top face between the slots
        translate([tie_x - tie_w / 2, -w_in / 2 - tie_t, -groove_d])
            cube([tie_w, w_in + 2 * tie_t, groove_d + eps]);
    }
}

module tray() {
    difference() {
        union() {
            translate([0, 0, -floor_t]) cylinder(d = disc_d, h = floor_t);
            saddle_add();
        }
        saddle_cut();
    }
}

// Test piece: the saddle on a small plate instead of the full floor.
module fit() {
    m = 4;
    difference() {
        union() {
            saddle_frame()
                translate([-boss_d / 2 - m, -w_in / 2 - cheek_t - m, -floor_t])
                    cube([knuckle_len + boss_d / 2 + 2 * m, w_in + 2 * cheek_t + 2 * m, floor_t]);
            saddle_add();
        }
        saddle_cut();
    }
}

module rim() {
    difference() {
        translate([0, 0, -floor_t]) cylinder(d = band_od, h = floor_t + rim_h);
        translate([0, 0, -floor_t - eps]) cylinder(d = disc_d + band_clr, h = floor_t + eps);
        translate([0, 0, -eps]) cylinder(d = tray_d, h = rim_h + 2 * eps);
    }
}

module arm() {
    zt = -floor_t;                            // top of the knuckle
    color("DimGray") {
        saddle_frame() {
            translate([0, -knuckle_w / 2, zt - 45]) cube([knuckle_len, knuckle_w, 45]);
            translate([0, 0, zt - 45]) cylinder(d = knuckle_w, h = 45);
            translate([0, 0, zt]) cylinder(d = boss_d, h = boss_h);
            // spring arm
            translate([knuckle_len, 0, zt - 22]) rotate([0, 125, 0])
                translate([-12, -15, 0]) cube([24, 30, 120]);
        }
        // link to the VESA head
        translate([pin_x - pin_to_plate + 4, -11, zt - 34]) cube([pin_to_plate - 4, 22, 22]);
    }
    color("Red") translate([pin_x - pin_to_plate - 4, -65, zt - 110]) cube([4, 130, 170]);
}

module assembly() {
    color("Orange") tray();
    color("Gold") rim();
    color("White", 0.6) cylinder(d = deco_d, h = deco_h);
    arm();
}

if (part == "tray") {
    rotate([180, 0, 0]) tray();
} else if (part == "rim") {
    translate([0, 0, rim_h]) rotate([180, 0, 0]) rim();
} else if (part == "fit") {
    rotate([180, 0, 0]) fit();
} else if (part == "assembly" || part == "side") {
    assembly();
} else if (part == "below") {
    color("Orange") tray();
    color("Gold") rim();
} else {
    assert(false, "unknown part");
}
