// ============================================================
// Project: Parametric Smartphone Case
// Model: Moto G54 5G
// Author: Nicolas Lourenço Ribeiro
// Description: 3D printable protective case
// ============================================================

$fn = 64; // Curve resolution

/* ============================================================
   PHONE DIMENSIONS
   ============================================================ */

phone_length = 161.6;
phone_width  = 73.8;
phone_depth  = 8.0;
tolerance    = 0.5;

/* ============================================================
   CASE STRUCTURE
   ============================================================ */

wall         = 0.2;
bottom_thick = 1.8;
corner_r     = 9;
edge_r       = 1.2;
scoop_depth  = 0.8;

/* ============================================================
   BUTTONS - RIGHT SIDE
   ============================================================ */

// (Values intentionally kept as defined in original model)

r2_y   = 95;
r2_len = 50;
r2_h   = 4.5;

/* ============================================================
   BUTTONS - LEFT SIDE
   ============================================================ */

l1_active = false;
l2_active = false;

/* ============================================================
   TOP PORTS (HEADPHONE JACK + USB)
   ============================================================ */

aux_radius = 4.0;
aux_x      = 18;
aux_z      = 0;

/* ============================================================
   CAMERA MODULE
   ============================================================ */

cam_x = 38.5;
cam_y = 6.5;
cam_w = 32;
cam_h = 40;
cam_r = 8;

/* ============================================================
   FRONT LIP
   ============================================================ */

lip_inward = 1.5;
lip_height = 1.2;

/* ============================================================
   DERIVED CALCULATIONS (DO NOT MODIFY)
   ============================================================ */

inner_x = phone_width  + tolerance;
inner_y = phone_length + tolerance;
inner_z = phone_depth  + tolerance;

outer_x = inner_x + 2 * wall;
outer_y = inner_y + 2 * wall;

total_z = inner_z + bottom_thick + lip_height;
mid_z   = bottom_thick + inner_z / 2;

/* ============================================================
   HELPER MODULES
   ============================================================ */

module rounded_rect(width, height, radius) {
    hull() {
        for (x = [radius, width - radius])
            for (y = [radius, height - radius])
                translate([x, y])
                    circle(radius);
    }
}

module smooth_cut(width, length, height, radius) {
    hull() {
        for (ix = [radius, width - radius])
            for (iy = [radius, length - radius])
                for (iz = [radius, height - radius])
                    translate([ix, iy, iz])
                        sphere(radius);
    }
}

/* ============================================================
   MAIN MODEL
   ============================================================ */

difference() {

    // --------------------------------------------------------
    // External Body
    // --------------------------------------------------------
    minkowski() {
        translate([edge_r, edge_r, edge_r])
            linear_extrude(height = total_z - 2 * edge_r)
                rounded_rect(
                    outer_x - 2 * edge_r,
                    outer_y - 2 * edge_r,
                    corner_r - edge_r
                );
        sphere(edge_r);
    }

    // --------------------------------------------------------
    // Internal Cavity
    // --------------------------------------------------------
    translate([wall, wall, bottom_thick])
        linear_extrude(height = inner_z + 0.1)
            rounded_rect(inner_x, inner_y, corner_r - wall);

    // --------------------------------------------------------
    // Front Protection Lip
    // --------------------------------------------------------
    translate([
        wall + lip_inward,
        wall + lip_inward,
        total_z - lip_height
    ])
        linear_extrude(height = lip_height + 0.2)
            rounded_rect(
                inner_x - 2 * lip_inward,
                inner_y - 2 * lip_inward,
                corner_r - wall - lip_inward
            );

    // --------------------------------------------------------
    // Right Side Buttons
    // --------------------------------------------------------
    translate([
        outer_x - wall - 1,
        wall + r1_y,
        mid_z - r1_h / 2
    ])
        smooth_cut(wall + 2, r1_len, r1_h, scoop_depth);

    translate([
        outer_x - wall - 1,
        wall + r2_y,
        mid_z - r2_h / 2
    ])
        smooth_cut(wall + 2, r2_len, r2_h, scoop_depth);

    // --------------------------------------------------------
    // AUX Port (Headphone Jack)
    // --------------------------------------------------------
    translate([wall + aux_x, -1, mid_z])
        rotate([-90, 0, 0])
            cylinder(h = wall + 3, r = aux_radius);

    // --------------------------------------------------------
    // USB Port
    // --------------------------------------------------------
    translate([wall + aux_x + 14, -1, mid_z - 2.5])
        smooth_cut(14, wall + 3, 5, scoop_depth);

    // --------------------------------------------------------
    // Speaker Opening
    // --------------------------------------------------------
    translate([wall + aux_x + 32, -1, mid_z - 2.25])
        smooth_cut(20, wall + 3, 4.5, scoop_depth);

    // --------------------------------------------------------
    // Camera Cutout
    // --------------------------------------------------------
    translate([
        wall + cam_x,
        outer_y - wall - cam_y - cam_h,
        -0.5
    ])
        linear_extrude(height = bottom_thick + 1)
            rounded_rect(cam_w, cam_h, cam_r);
}
