
$fn=100;

module rotate_around(a, v, pt) {
    translate(pt)
        rotate(a,v)
            translate(-pt)
                children();   
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


module obudowa_cz1(){
difference(){
  union(){
    cube([85,75,4]);   
    translate([11,18,0]) cylinder(d=15, h=52);
    translate([36,76,0]) cylinder(d=15, h=52);
  };
  
  
  translate([27,15,-1]) cylinder(d=5.5,h=1000);
  translate([-11,58,-1]) cylinder(d=12.5,h=1000);
  translate([0,75,-10]) cube([100,10,100]);
  hull(){
      translate([-1,22,-1]) cylinder(d=1, h=100);
      translate([5,25,-1]) cylinder(d=1, h=100);
      translate([0,75,-1]) cylinder(d=1, h=100);
      translate([25,75,-1]) cylinder(d=1, h=100);
    }
  
};

translate([8,0,5.8]) rotate_around([0,0,-22.5], pt=[-11,58,20]) translate([20,58,20]) rotate([270,0,90]) scale([1,1,100])  difference(){
  translate([-25,-26.2,0]) cube([50,52,0.05]);
  nema17_helper();
  translate([-10,-27,-10]) cube([20,20,20]);

}

translate([28,71,0]) cube([57,4,52]);
cube([4,20,52]);
translate([81,0,0]) cube([4,74,52]);
cube([85,4,52]);


translate([0,0,0]) difference(){
  cube([15,15,15+37]);
  translate([6.5,6.5,0]) cylinder(d=3, h=100);
}
translate([70,0,0]) difference(){
  cube([15,15,15+37]);
  translate([6.5,6.5,0]) cylinder(d=3, h=100);
}
  
translate([70,60,0]) difference(){
  cube([15,15,15+37]);
  translate([6.5,6.5,0]) cylinder(d=3, h=100);
}
}

module obudowa(){
difference(){
  union(){
    obudowa_cz1();
    hull(){
    translate([15,0,32]) cube([26,14,20]);
    translate([15,0,5]) cube([26,1,10]);
    }
      };
  translate([15,3.5,33]) cube([21.5,7.6,30]);
  translate([33.5,71,33]) cylinder(d=3, h=25);
  
  //translate([6.5,0,45]) translate([-2.5, -2.5, 0]) cube([5.1,16,1.6]);
  
  //translate([76.5,0,45]) translate([-2.5, -2.5, 0]) cube([5.1,20,1.6]);
  
  //translate([76.5,56.5,45]) translate([-2.5, -2.5, 0]) cube([5.1,25,1.6]);
  
  //translate([33.5,69,45]) translate([-2.5, -2.5, 0]) cube([5.1,20,1.6]);
  translate([25,10,10]) cube([3,5,100]);

}
}

module dekiel(){
  
  difference(){
union(){
translate([15,0,32]) cube([26,14,20]);
translate([10,0,49]) cube([60,25,3]);
translate([33,0,49]) cube([40,73,3]);
translate([70,10,49]) cube([15,55,3]);
rotate([0,0,-28]) translate([-1,30,49]) cube([20,43,3]);
obudowa_cz1();
translate([8,0,5.8]) rotate_around([0,0,-22.5], pt=[-11,58,20]) translate([20,58,20]) rotate([270,0,90]) scale([1,1,100])  difference(){
  translate([-25,-26.2,0]) cube([50,52,0.05]);
}
}
translate([-1,-1,-1]) cube([100,100,42]);
translate([33.5,71,33]) cylinder(d=3, h=25);



translate([14,3.5,33]) cube([23.5,8.5,30]);

translate([14-0.75,3.5,33]) cube([25,8.5,9]);
translate([33.5,71,33]) cylinder(d=4, h=25);
translate([0,0,0]) translate([6.5,6.5,0]) cylinder(d=4, h=100);
translate([70,0,0]) translate([6.5,6.5,0]) cylinder(d=4, h=100);
translate([70,60,0]) translate([6.5,6.5,0]) cylinder(d=4, h=100);

translate([33.5,71,49]) cylinder(d=6, h=25);
translate([0,0,0]) translate([6.5,6.5,49]) cylinder(d=6.5, h=10);
translate([70,0,0]) translate([6.5,6.5,49]) cylinder(d=6.5, h=10);
translate([70,60,0]) translate([6.5,6.5,49]) cylinder(d=6.5, h=10);

}
  
  }

obudowa();
translate([100,0,0]) dekiel();