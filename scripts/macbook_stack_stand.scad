// Stacking stand for two closed MacBook Pro 14" (M4) laptops.
//
// One stand is a side rail with an E-shaped cross-section: a vertical wall
// with three shelves. The laptop edges slide into the two channels between
// the shelves. Two stands are needed, a left one and a right one; they are
// mirror images of each other.
//
// The shelves are full depth only at the two rail ends (the pads). Between
// the pads they are cut back to a 1 mm rib, so the air intake slot on the
// underside of each laptop stays open there.
//
// Behind the rail only the middle shelf continues, as a flat bar between
// the two laptops, and ends in a cross plate: seen from the side the bar and
// the plate form a T. The plate stops both laptops at their back edges.
// There is no wall beside the bar, so the ports stay free.
//
// Model frame: the E profile is in XY and the rail length is Z (front end
// at Z = 0, back stop at the far end). In use the profile Y axis points up.
// The STL is exported lying on the shelf tips, which is how it prints.
//
// Build:  make macbook-stand        (left and right STL, previews)
//         make macbook-stand-fit    (10 mm slice of the profile, fit test)
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
length    = 100;    // rail length along the laptop side
pad_len   = 12;     // full-depth shelf at each rail end; 0 keeps the shelves full length
stub      = 1;      // shelf rib left along the wall between the pads
foot_out  = 12;     // outward foot that keeps an empty stand upright
foot_h    = 12;     // height where the foot meets the wall
foot_tip  = 4;      // thickness of the foot at its outer end (holds the screw heads)

/* [Back stop] */
ext    = 80;        // rail rear end to the back stop face = to the laptop back edge; 0 for none
bar_t  = 5;         // thickness of the bar, measured up from the top of the lower laptop's channel
cap_t  = 5;         // thickness of the cross plate
gusset = 4;         // 45 degree brace between the bar and the plate, on the upper side

/* [Screws] */
screw_n      = 2;   // screw holes in the outward foot; 0 for none
screw_inset  = 15;  // hole centre to the rail end
screw_d      = 4.5; // clearance hole, for a 4 mm countersunk wood screw
screw_head_d = 8.5; // head pocket diameter
screw_seat   = 1.5; // material under the countersink

/* [Detail] */
r_tip = 1.2;        // rounding of outer corners (shelf tips)
r_in  = 1.0;        // fillet of inner corners (shelf roots)
flare = 0.8;        // each channel opens by this much at the front end (both ends if ext = 0)
lead  = 4;          // length of that lead-in

/* [Placement, previews only] */
free_from_back = 80;   // laptop back edge to the rail rear end when there is no back stop
vent_from_back = 24;   // laptop back edge to the start of the intake slot (measured)
vent_len       = 105;  // length of the intake slot (measured)
side_gap       = 0.5;  // laptop side to stand wall

/* [Output] */
// "stand" (print one per side), "fit" (test slice), or a preview:
// "assembly", "section" (cut through a pad), "plan" (seen from below)
part = "stand";
side = "right";     // "right" or "left" stand, seen from the front of the laptops
fit_len = 10;       // length of the fit-test slice

$fn = 64;

slot_h  = laptop_t + clearance;    // channel height
mid_t   = stack_gap - clearance;   // middle shelf; laptops rest 10 mm apart
y1      = desk_gap;                // floor of the lower channel
y2      = y1 + slot_h;             // ceiling of the lower channel
y3      = y2 + mid_t;              // floor of the upper channel
y4      = y3 + slot_h;             // ceiling of the upper channel
total_h = y4 + top_t;

ramp     = engage - stub;                  // 45 degree run from rib to full shelf
win_len  = length - 2 * (pad_len + ramp);  // window length at the wall
windowed = pad_len > 0 && win_len > 0;

has_ext  = ext > 0;
z_c      = length + ext;                   // front face of the cross plate
rail_from_back = has_ext ? ext : free_from_back;

assert(top_t > 2 * r_tip, "top lip thinner than two tip radii");
assert(foot_tip > 2 * r_tip, "foot tip thinner than two tip radii");
assert(lead * 2 < length, "lead-ins longer than the rail");
assert(pad_len == 0 || pad_len >= lead, "pads shorter than the lead-in");
assert(pad_len == 0 || win_len > 0, "rail too short for pads and ramps; set pad_len = 0");
assert(stub > 0 && stub < engage, "stub must be between 0 and engage");
assert(bar_t >= 3 && bar_t <= mid_t, "bar_t must be between 3 and the middle shelf thickness");
assert(bar_t + gusset <= mid_t, "gusset reaches into the upper laptop");
assert(!has_ext || ext > 2 * gusset, "extension too short");
assert(side == "right" || side == "left", "side must be right or left");
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

// Section of the bar behind the rail: the lower part of the middle shelf,
// wall thickness included. Cut from profile(), so it shares its surface
// with the rail and the union leaves no slivers.
module bar_profile() {
    intersection() {
        profile();
        translate([0, y2]) square([wall_t + engage + 1, bar_t]);
    }
}

// Outline of the cross plate: the full height and depth of the profile,
// without the outward foot.
module plate_profile() {
    hull() intersection() {
        profile();
        square([wall_t + engage + 1, total_h + 1]);
    }
}

// Bar, cross plate and brace. The brace is on the upper side only, where
// the upper laptop rides 4.5 mm above the bar; below the bar the lower
// laptop passes with 0.5 mm.
module back_stop() {
    translate([0, 0, length - 0.01]) linear_extrude(ext + 0.02) bar_profile();
    translate([0, 0, z_c]) linear_extrude(cap_t) plate_profile();
    // polygon is in (Z, Y); the rotation maps it there and extrudes along -X
    // it starts at the shelf tip plane, which is the bed when printing
    translate([wall_t + engage, 0, 0]) rotate([0, -90, 0])
        linear_extrude(wall_t + engage - 0.5)
        polygon([[z_c - gusset, y2 + bar_t - 0.01], [z_c + 0.01, y2 + bar_t - 0.01],
                 [z_c + 0.01, y2 + bar_t + gusset]]);
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

// Cuts the shelves and the top lip back to the rib between the two end
// pads. The cut meets each pad at 45 degrees, so the pad at the upper end
// of the print grows out of the rib without supports.
module window() {
    x0 = wall_t + stub;
    x1 = wall_t + engage + 1;
    translate([0, total_h + 1, 0]) rotate([90, 0, 0])
        linear_extrude(total_h + 2)
            polygon([[x1, pad_len - 1], [x0, pad_len + ramp],
                     [x0, length - pad_len - ramp], [x1, length - pad_len + 1]]);
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

// The right stand in the model frame. The left stand is its mirror image.
module stand_right() {
    difference() {
        linear_extrude(length) profile();
        for (y = [y1, y3]) {
            lead_in(y);
            // with a back stop the laptops never enter from the rear end
            if (!has_ext) translate([0, 0, length]) mirror([0, 0, 1]) lead_in(y);
        }
        if (windowed) window();
        if (screw_n > 0)
            for (i = [0 : screw_n - 1])
                translate([-foot_out / 2, 0, screw_z(i)]) screw_hole();
    }
    if (has_ext) back_stop();
}

// Print orientation: lying on the shelf tips, outer wall face and foot up,
// rail along X.
module stand_print() {
    translate([0, 0, wall_t + engage]) rotate([0, 90, 0]) stand_right();
}

module stand() {
    if (side == "left") mirror([0, 1, 0]) stand_print();
    else stand_print();
}

// Short slice of the bare profile: no lead-ins, no window, no screws.
module fit_test() {
    linear_extrude(fit_len) profile();
}

// --- previews ---------------------------------------------------------------
// Laptop centred on the origin, back edge at +Y, front edge at -Y.

y_front = laptop_d / 2 - rail_from_back - length;   // front end of the rail

module laptop() {
    r = 10;
    linear_extrude(laptop_t)
        offset(r = r) square([laptop_w - 2 * r, laptop_d - 2 * r], center = true);
}

// Right stand in its position in use: wall vertical, model Z pointing back.
module right_in_use() {
    translate([laptop_w / 2 + side_gap + wall_t, y_front, 0])
        rotate([0, 0, 180]) rotate([90, 0, 0]) stand_right();
}

module left_in_use() {
    mirror([1, 0, 0]) right_in_use();
}

// Keeps the half behind the middle of the front pads when cut is true, so
// the section preview shows the full profile with the laptops in it.
module clip(cut) {
    y_cut = y_front + (windowed ? pad_len / 2 : length / 2);
    if (cut) intersection() {
        children();
        translate([0, 500 + y_cut, 0]) cube(1000, center = true);
    }
    else children();
}

module assembly(cut = false) {
    color("orange") clip(cut) left_in_use();
    color("orange") clip(cut) right_in_use();
    color("silver") clip(cut) translate([0, 0, y1]) laptop();
    color("lightgrey") clip(cut) translate([0, 0, y3]) laptop();
    color("burlywood") clip(cut) translate([0, 0, -2])
        cube([laptop_w + 120, laptop_d + 80, 4], center = true);
}

// Lower laptop and the stands seen from below. The red strips mark the
// measured length of the intake slots; their distance from the side edge
// and their width are not measured and only indicative.
module plan() {
    color("orange") left_in_use();
    color("orange") right_in_use();
    color("silver") translate([0, 0, y1]) laptop();
    for (sx = [-1, 1])
        color("red")
            translate([sx * (laptop_w / 2 - 5) - 1.5,
                       laptop_d / 2 - vent_from_back - vent_len, y1 - 0.2])
                cube([3, vent_len, 0.2]);
}

if (part == "assembly") assembly();
else if (part == "section") assembly(cut = true);
else if (part == "plan") plan();
else if (part == "fit") fit_test();
else stand();
