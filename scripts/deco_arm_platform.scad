// Platform for a TP-Link Deco (110 mm cylinder) on top of the swivel
// link of a monitor arm, behind the VESA head.
//
// Seen from above the arm is an L: the head block runs from the VESA
// plate straight back to a vertical swivel pin; from the pin a link
// runs along the plate to the elbow of the spring arm (arm_angle).
// The link is a fork around the pin, with a flat top; the elbow
// housing at its far end stands a few mm higher.
//
// Two printed pieces:
//   tray  a round floor on a raised pad. The pad lies on the flat top
//         of the link and lifts the floor over the elbow housing. One
//         cheek beside the link, on the side away from the plate, and
//         one cable tie around the link hold the tray. The tie goes
//         through two slots in the floor and lies in a groove of the
//         top face, under the Deco. There is no cheek on the plate
//         side: the head block swivels there. A ring of windows in
//         the floor lets air reach the vent slots in the Deco base.
//   rim   a loose band dropped over the edge of the floor. A step in
//         its bore rests on the floor; above the floor it stands 6 mm
//         high around the Deco.
//
// Model frame: +X away from the VESA plate, Y along the plate, Z up.
// The Deco stands on Z = 0 with its axis on the origin. The top of
// the link is at Z = -(floor_t + pad_h).
// Saddle frame: pin axis on the origin, X along the link towards the
// elbow.
//
// Both pieces print without supports: the tray upside down on its top
// face, the rim upside down on its upper edge.
//
// Build:  make deco-platform        (STLs and previews)
//         make deco-platform-fit    (small test piece of the saddle)
//         make deco-platform-save   (copy the STLs to models/)
// See specs/deco-arm-platform.md. The arm numbers are read from ruler
// photos; check them with the fit piece.

/* [Deco] */
deco_d   = 110;     // diameter of the Deco
deco_h   = 114;     // preview only
deco_clr = 2;       // added to the diameter inside the rim

/* [Arm, from ruler photos] */
link_w    = 26;     // width of the link
link_len  = 31;     // flat top from the pin axis to the elbow housing
link_back = 13;     // round end of the link behind the pin axis
elbow_h   = 5;      // elbow housing above the flat top
cap_d     = 20;     // cap of the swivel pin in the top of the link
cap_h     = 1.5;    // depth of the pocket over the cap
cap_clr   = 2;      // added to the pocket diameter
pin_to_plate = 57;  // pin axis to the face of the VESA plate
plate_gap = 2;      // air between the rim and the plate
// Angle in plan between the link (towards the elbow) and the
// direction away from the plate: 90 = elbow to the right seen from
// behind the plate, -90 = to the left, 0 = straight back.
arm_angle = 90;
head_w    = 48;     // preview only: head block across
head_len  = 44;     // preview only: head block from the plate

/* [Tray] */
floor_t  = 4;       // floor thickness
step     = 1.2;     // floor edge outside the Deco bore; the rim rests on it
pad_h    = 7;       // pad between link and floor; must exceed elbow_h
pad_in   = 1;       // pad stays this far inside the link outline
tray_along = 9;     // Deco axis moved from the pin along the link, to the middle of the flat top
link_clr = 0.5;     // air between link and cheek
cheek_t  = 5;       // cheek thickness
cheek_h  = 8;       // cheek height below the pad; the fork cap is about 10 mm thick

/* [Vents] */
// Windows in the floor under the ring of vent slots in the Deco base.
// The five rubber feet stand inside that ring, on the solid floor.
vents    = true;
vent_r1  = 42;      // inner radius of the windows
vent_r2  = 53;      // outer radius of the windows
vent_n   = 8;       // number of windows
spoke_w  = 8;       // floor left between two windows

/* [Cable tie] */
tie_x    = 20.5;    // tie position, from the pin axis along the link
tie_w    = 7;       // slot length along the link (tie up to 5 mm wide)
tie_t    = 2.5;     // slot width across the link
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
z_link  = -floor_t - pad_h;                   // top of the link

// The tray is pushed away from the plate until the rim clears it,
// then along the link by tray_along.
tray_off = max(0, band_od / 2 + plate_gap - pin_to_plate);
pin_pos  = [-tray_off - tray_along * cos(arm_angle), -tray_along * sin(arm_angle)];
plate_x  = pin_pos[0] - pin_to_plate;         // face of the plate

// Cheek side in the saddle frame: the side away from the plate.
// -1 or 1; with a straight arm both sides get a cheek.
cheek_sides = arm_angle > 0 ? [-1] : arm_angle < 0 ? [1] : [-1, 1];
y_side = link_w / 2 + link_clr;               // inner face of a cheek

seg1 = [0, tie_x - tie_w / 2 - 0.5];
seg2 = [tie_x + tie_w / 2 + 0.5, link_len];

function sad(p) = [pin_pos[0] + p[0] * cos(arm_angle) - p[1] * sin(arm_angle),
                   pin_pos[1] + p[0] * sin(arm_angle) + p[1] * cos(arm_angle)];

assert(pad_h > elbow_h + 1, "floor does not clear the elbow housing; raise pad_h");
assert(seg1[1] - seg1[0] >= 6, "front cheek segment under 6 mm; move tie_x away from the pin");
assert(seg2[1] - seg2[0] >= 6, "rear cheek segment under 6 mm; move tie_x towards the pin");
assert(cap_h < pad_h, "cap pocket deeper than the pad");
assert(groove_d < floor_t - 1.6, "tie groove leaves under 1.6 mm of floor");
assert(tie_x - tie_w / 2 > link_back, "tie runs over the swivel ring of the head block");
assert(max([for (x = [-link_back, link_len], y = [-1, 1]) norm(sad([x, y * (y_side + cheek_t)]))])
       < disc_d / 2 - 1, "saddle reaches the edge of the floor");
sad_r = max([for (x = [-link_back, link_len], y = [-1, 1]) norm(sad([x, y * (y_side + cheek_t)]))]);
assert(!vents || vent_r1 >= sad_r + 2, "vent windows cut into the saddle");
assert(!vents || vent_r2 <= disc_d / 2 - 3, "under 3 mm of floor outside the vent windows");
assert(!vents || 2 * PI * vent_r1 / vent_n - spoke_w >= 6, "vent windows under 6 mm wide; fewer windows or narrower spokes");
assert(plate_x + band_od / 2 < -plate_gap + eps, "rim touches the plate");

module saddle_frame() {
    translate([pin_pos[0], pin_pos[1], 0]) rotate(arm_angle) children();
}

// Pad and cheek; shared by the tray and the fit piece.
module saddle_add() {
    saddle_frame() {
        // pad on the flat top, widened under the cheek
        for (s = [-1, 1]) {
            w = link_w / 2 - pad_in + (len(search(s, cheek_sides)) ? pad_in + link_clr + cheek_t : 0);
            translate([-link_back + pad_in, s > 0 ? 0 : -w, z_link])
                cube([link_back + link_len - pad_in, w, pad_h + eps]);
        }
        for (s = cheek_sides, seg = [seg1, seg2])
            translate([seg[0], s > 0 ? y_side : -y_side - cheek_t, z_link - cheek_h])
                cube([seg[1] - seg[0], cheek_t, cheek_h + eps]);
    }
}

module saddle_cut() {
    saddle_frame() {
        // pocket for the cap of the swivel pin
        translate([0, 0, z_link - eps]) cylinder(d = cap_d + cap_clr, h = cap_h + eps);
        // tie slots, right beside the link, through pad and floor
        for (s = [-1, 1])
            translate([tie_x - tie_w / 2, s > 0 ? y_side - link_clr : -y_side + link_clr - tie_t, z_link - eps])
                cube([tie_w, tie_t, pad_h + floor_t + 2 * eps]);
        // groove in the top face between the slots
        translate([tie_x - tie_w / 2, -link_w / 2 - tie_t, -groove_d])
            cube([tie_w, link_w + 2 * tie_t, groove_d + eps]);
    }
}

// Ring of windows through the floor, spokes between them.
module vent_cut() {
    translate([0, 0, -floor_t - eps]) linear_extrude(floor_t + 2 * eps)
        difference() {
            circle(r = vent_r2);
            circle(r = vent_r1);
            for (i = [0 : vent_n - 1])
                rotate(i * 360 / vent_n + 180 / vent_n)
                    translate([0, -spoke_w / 2]) square([vent_r2 + 1, spoke_w]);
        }
}

module tray() {
    difference() {
        union() {
            translate([0, 0, -floor_t]) cylinder(d = disc_d, h = floor_t);
            saddle_add();
        }
        saddle_cut();
        if (vents) vent_cut();
    }
}

// Test piece: the saddle on a small plate instead of the full floor.
module fit() {
    m = 4;
    difference() {
        union() {
            saddle_frame()
                translate([-link_back - m, -y_side - cheek_t - m, -floor_t])
                    cube([link_back + link_len + 2 * m, 2 * (y_side + cheek_t + m), floor_t]);
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
    link_h = 37;
    color("DimGray") {
        saddle_frame() {
            translate([0, -link_w / 2, z_link - link_h]) cube([link_len, link_w, link_h]);
            translate([0, 0, z_link - link_h]) cylinder(d = link_w, h = link_h);
            // elbow housing and spring arm
            translate([link_len, -link_w / 2 - 3, z_link - link_h - 4])
                cube([24, link_w + 6, link_h + 4 + elbow_h]);
            translate([link_len + 14, 0, z_link - 20]) rotate([0, 160, 0])
                translate([-12, -15, 0]) cube([24, 30, 110]);
        }
        // head block between the plate and the swivel pin
        translate([plate_x, pin_pos[1] - head_w / 2, z_link - link_h])
            cube([head_len, head_w, link_h]);
    }
    color("Silver") saddle_frame() translate([0, 0, z_link]) cylinder(d = cap_d - 4, h = 0.5);
    color("Red") translate([plate_x - 4, pin_pos[1] - 65, z_link - 110]) cube([4, 130, 170]);
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
