use <MCAD/involute_gears.scad>
use <MCAD/regular_shapes.scad>

module ra_montaz(){
$fn=100;
	gear1_teeth = 24;
	gear2_teeth = 24;
	axis_angle = 90;
	outside_circular_pitch=300;

	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) +
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

	rotate([0,180,90])
	translate ([0,0,-3])
	{
		translate([0,0,-pitch_apex1])
		bevel_gear (
			number_of_teeth=gear1_teeth,
			cone_distance=cone_distance,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch,
      bore_diameter=0,
      clearance = 0.5,
      face_width=15
    );

	}
difference(){
translate([0,0,-25]) cylinder(d=20, h=45);
translate([0,0,-26]) cylinder(d=6.2, h=16);
translate([0,0,-19]) rotate([0,90,0]) cylinder(d=4, h=20);
  hull(){
translate([3,0,-38]) rotate([0,90,0]) cylinder(d=8, h=3.1, $fn=6);
translate([3,0,-19]) rotate([0,90,0]) cylinder(d=8, h=3.1, $fn=6);}
translate([6,0,-19]) rotate([0,90,0]) cylinder(h=6, d1=3.5, d2=12);

}

}

module ra_silnik(){
$fn=100;
	gear1_teeth = 24;
	gear2_teeth = 24;
	axis_angle = 90;
	outside_circular_pitch=300;

	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) +
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);


difference(){
  union(){
	rotate([0,0,90])
	translate ([0,0,32])
	{
		translate([0,0,-pitch_apex1])
		bevel_gear (
			number_of_teeth=gear1_teeth,
			cone_distance=cone_distance,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch,
      bore_diameter=0,
      clearance = 0.5,
      face_width=15
    );

	}
difference(){
translate([0,0,-0]) cylinder(d=20, h=20);
translate([0,0,6]) rotate([0,90,0]) cylinder(d=4, h=20);
  hull(){
translate([3,0,-13]) rotate([0,90,0]) cylinder(d=8, h=3.1, $fn=6);
translate([3,0,6]) rotate([0,90,0]) cylinder(d=8, h=3.1, $fn=6);}
translate([6,0,6]) rotate([0,90,0]) cylinder(h=6, d1=3.5, d2=12);
}
}

translate([0,0,-50]) cylinder(d=5.2, h=1000);

}

}

translate([40,0,25]) ra_montaz();
translate([0,0,0]) ra_silnik();
