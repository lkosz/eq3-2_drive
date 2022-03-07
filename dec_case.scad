$fn=200;

 module regular_polygon(n=3, d=1, h=1){
 	angles=[ for (i = [0:n-1]) i*(360/n) ];
 	coords=[ for (th=angles) [0.5*d*cos(th), 0.5*d*sin(th)] ];
  
  linear_extrude(height=h, center=true ) {polygon(coords);
  }
}


module nema17_helper(slide=8){
  
  union(){
 hull(){
 translate([0,slide/2,0]) cylinder(d=22, h=20, center=true);
  translate([0,-1*slide/2,0]) cylinder(d=22, h=20, center=true);

   }

hull(){
translate([0,slide/2,0]) translate([15.5,15.5]) cylinder(d=3.5, h=20, center=true);
translate([0,-1*slide/2,0])translate([15.5,15.5]) cylinder(d=3.5, h=20, center=true);
}
hull(){
translate([0,slide/2,0]) translate([-15.5,15.5]) cylinder(d=3.5, h=20, center=true);
translate([0,-1*slide/2,0])translate([-15.5,15.5]) cylinder(d=3.5, h=20, center=true);
}
hull(){
translate([0,slide/2,0]) translate([15.5,-15.5]) cylinder(d=3.5, h=20, center=true);
translate([0,-1*slide/2,0])translate([15.5,-15.5]) cylinder(d=3.5, h=20, center=true);
}
hull(){
translate([0,slide/2,0]) translate([-15.5,-15.5]) cylinder(d=3.5, h=20, center=true);
translate([0,-1*slide/2,0])translate([-15.5,-15.5]) cylinder(d=3.5, h=20, center=true);
}   
   }
  
}

module obudowa(){
difference(){
union(){
  
difference(){
hull(){
cube([55,49,52]);
translate([3,-15,0]) cube([48,15.5,40]);
}
translate([-3,3,3]) cube([55,44,46]);

translate([3,-14.5,0]) translate([3,3,-3]) cube([42,9,34]);

translate([55,25,25]) 
rotate([90,0,90]) nema17_helper(slide=8);
}


translate([0,4,0]) rotate([0,90,0]) cylinder(d=6, h=15);
translate([0,46,0]) rotate([0,90,0]) cylinder(d=6, h=15);
translate([0,4,52]) rotate([0,90,0]) cylinder(d=6, h=15);
translate([0,46,52]) rotate([0,90,0]) cylinder(d=6, h=15);

}

translate([-1,4,0]) rotate([0,90,0]) cylinder(d=2.6, h=15);
translate([-1,4,52]) rotate([0,90,0]) cylinder(d=2.6, h=15);
translate([-1,46,0]) rotate([0,90,0]) cylinder(d=2.6, h=15);
translate([-1,46,52]) rotate([0,90,0]) cylinder(d=2.6, h=15);

translate([27,15,10]) rotate([90,0,0]) cylinder(d=6, h=50);
translate([27,5.3-4,10]) rotate([90,0,0]) regular_polygon(n=6, d=11.6, h=4.5);
}


}
module wieko(){
difference(){
union(){
difference(){
 cube([10,49,52]);
translate([2,3,3]) cube([10,44,46]);
}

translate([0,0,2.9]) cube([10,48,5]);
translate([0,0,45]) cube([10,48,5]);
cube([10,15,48]);


translate([0,4,0]) rotate([0,90,0]) cylinder(d=6, h=10);
translate([0,46,0]) rotate([0,90,0]) cylinder(d=6, h=10);
translate([0,4,52]) rotate([0,90,0]) cylinder(d=6, h=10);
translate([0,46,52]) rotate([0,90,0]) cylinder(d=6, h=10);
}

translate([-1,4,0]) rotate([0,90,0]) cylinder(d=4, h=30);
translate([-1,4,52]) rotate([0,90,0]) cylinder(d=4, h=30);
translate([-1,46,0]) rotate([0,90,0]) cylinder(d=4, h=30);
translate([-1,46,52]) rotate([0,90,0]) cylinder(d=4, h=30);

translate([-1,4,0]) rotate([0,90,0]) cylinder(d=6.2, h=5);
translate([-1,4,52]) rotate([0,90,0]) cylinder(d=6.2, h=5);
translate([-1,46,0]) rotate([0,90,0]) cylinder(d=6.2, h=5);
translate([-1,46,52]) rotate([0,90,0]) cylinder(d=6.2, h=5);

translate([2,8,25+13.5]) rotate([0,180,270]) union(){
translate([-1,1,1]) cube([20,20,21.5]);
translate([-19,0,0]) cube([20,20,23.5]);
translate([0,0,-0.75]) cube([1.5,20,25]);
}

}





}

obudowa();
translate([-50,0,0]) wieko();

//color("red") translate([50,25,26]) rotate([0,90,0]) cylinder(d=22, h=10);

//translate([0,3,3]) color("red") cube([49,43,43]);
