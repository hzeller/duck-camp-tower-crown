$fn=96;
epsilon=0.1;

crown_slide_from_top=40;  // how far the crown platform slides from the top
crown_thick=15;           // thickness of the crown platform.
crown_dia=120;            // Diameter of the crown platform

pole_dia=25.4 + 2.5;      // Diameter of the poles. + wiggle-room

platform_dia=870;         // diameter on the last ring in the tower
pole_len=900;             // length of the poles originating from that ring.

// The poles meet somewhere, but not in one point, because they are real
// objects with a real thickness ("pole_dia") :)
// So they are a bit apart on the top. This affects the triangle_height and
// angle below, as the poles are a bit less steep than if they would meet in
// one point.
// (To adjust, just look at platform() alone and visually inspect)
top_platform_dia=3.5 * pole_dia;

//---- internal

pole_extra_space=5;       // We make the hole a little bit deeper
effective_r = (platform_dia - top_platform_dia)/2;
triangle_height=sqrt((pole_len * pole_len) - (effective_r * effective_r));
triangle_angle=acos(effective_r / pole_len);
slant=effective_r / triangle_height;

// The poles that meet at the top. There are 10 of them, based on a circle
// with "platform_dia" diameter with poles of length "pole_len"
module platform() {
    for (x=[0,1,2,3,4,5,6,7,8,9]) {
	rotate([0, 0, x * 36])
	   translate([-platform_dia/2, 0, 0]) rotate([0, 90 - triangle_angle, 0]) cylinder(r=pole_dia/2,h=pole_len + pole_extra_space);
    }
}

module raw_crown() {
    // Little platform to base the print on. The diameter is relatively small,
    // so that it is possible to see the duck from the ground.
    cylinder(r=crown_dia/2, r2=crown_dia/2 - slant * crown_thick,h=crown_thick);

    scale(1.8) duck();
}

module crown() {
    difference() {
	raw_crown();
	#translate([0, 0, -triangle_height + crown_slide_from_top]) platform();
    }
}

module duck() {
    // http://www.thingiverse.com/thing:139894
    translate([0,0,23.5]) import("Rubber_Duck.stl", convexity=5);
}

//platform();  // just to visualize the platform.

crown();  // The actual crown to print.
