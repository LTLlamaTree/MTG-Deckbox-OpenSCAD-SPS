
/*
    Default deckbox shape
    Box joins at center with a bit of overlap
    Has a spot for a Toploader sleeve to show commander
*/

/*
    Dimensions of objects
    Toploader:
        1.6/76/100.4
    
    Inside current box:
        71/76.2/...
    
    Deck itself:
        67/76.2/93
*/

/*
    Dimensions for writing
    Inner box space
        70mm / 80mm / 100mm
        -> Need half of this vertically
        70 / 80 / 50
        -> Need overlap of 5mmm
        -> Use union to get that
    Shell - total
        4mm / 4mm / 4mm
    Toploader
        3mm / 77mm / 103mm
*/

// Includes from BOSL
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
use <sps/parallelepiped.scad>

// Gamma for making things render nicely
g = 0.05;
// Rho for accounting for material expansion
p = 0.4;


// Disable/Enable testing
testActive = false;

// Define scale factor for testing
testScale = testActive ? 0.5 : 1.0;


// Define space for Deck
inSpace = [68*testScale, 78*testScale, 100*testScale];

// Define Big Sleeve dimensions
bigSlev = [2, 76*testScale, 103];
// Define Big Sleeve edge width
slevEdge = 3;

// Define shell dimensions
    // This is the total shell; each wall is half this
oShell = [3.2, 3.2, 3.2];


// Define length of overlap for top/bottom halves
tbO = 10;

// Define radius for grip posts
postRad = 3;

// Define inverse-depth for grid posts
postDep = 0.7;

// Define angle of box join, in degrees above horizontal
cutAngle = 40;




/* 
    Models space for the entire Box, when closed
    */
module totalBox() {
    linear_extrude(inSpace[2]+oShell[2])
        square([
        inSpace[0] + oShell[0],
        inSpace[1] + oShell[1]
        ], center = true
        );
}

/* 
    Models space for the deck itself
*/
module cardDeck() {
    zmove(oShell[2]/2)
    linear_extrude(inSpace[2] + oShell[2])
        square([
        inSpace[0], 
        inSpace[1]], 
        center = true
        );
}

// Models space for the Toploader
//module topLoader() {
//    zmove(oShell[2]/2)
//    linear_extrude(inSpace[2])
//        square([
//        inSpace[0], 
//        inSpace[1]], 
//        center = true
//        );
//    
//}



/* 
    Models the big box for cutting
*/
module bigCutBox() {
    *translate([
        -(inSpace[0] + oShell[0]+g)/2,
        -(inSpace[1] + oShell[1]+g)/2,
        0
        ])
    parallelepiped(
        inSpace[0] + oShell[0] + (2*g),
        inSpace[1] + oShell[1] + (2*g),
        inSpace[2],
        inSpace[2]-(4*tbO)
    );
    
    difference() {
        linear_extrude((inSpace[2]+oShell[2]))
            square([
            inSpace[0] + oShell[0]+g,
            2*(inSpace[1] + oShell[1])
            ], center = true
            );
    }
}


/* 
    Cuts the overlap for top and bottom halves
*/
module botTopOver(isBot) {
    skew_xy(0, cutAngle){
        // Checks if cutting bottom or top half
        if (!isBot) {
            // Cutting bottom half: need to leave inner portion of shell
            // Pass back an inner extrude
            linear_extrude(tbO+g)
                square([
                inSpace[0] + (oShell[0]/2),
                (inSpace[1] + (oShell[1]/2)) / cos(cutAngle)
                ], center = true
                );
            
        }
        else {
            // Cutting top half: need to leave outer portion of shell
            // Subtract a smaller, inner extrude from an outer extrude
            difference() {
                linear_extrude(tbO)
                    square([
                    inSpace[0] + oShell[0] + g,
                    (inSpace[1] + oShell[1]) / cos(cutAngle)
                    ], center = true
                    );
                
                linear_extrude(tbO+g)
                    square([
                    inSpace[0] + (oShell[0]/2) + p,
                    (inSpace[1] + (oShell[1]/2) + p) / cos(cutAngle)
                    ], center = true
                    );
            }
        }
    }
}


/* 
    Cuts the box along the overlap, leaving the part for joining
    If botTop is 0, this is for the BOTTOM half of the box
    If botTop is 1, this is for the TOP half of the box
*/
module makeCut(botTop) {
    
    // Moves to halfway point up box, then down half the overlap
    // Half the overlap because it moves down on both sides
    zmove((inSpace[2]/2) + oShell[2] - (tbO/2))
        // Rotates by specified angle
        xrot(cutAngle) 
            difference() {
                // Cuts the top of the box down
                bigCutBox();
                
                // Cuts overlap for both halves
                // Checks topBot: 0 means bottom, 1 means top
                // Cuts the inner or outer shell accordingly
                // Bottom keep inner half; Top keeps outer half
                botTopOver(botTop);
            }
    
        
    
    
}


/* 
    Models catch holes
*/
module catchHoles() {
    
    // Moves to halfway point up box, then down half the overlap
    // Half the overlap because it moves down on both sides
    zmove((inSpace[2]/2) + oShell[2] - (tbO/2))
        intersection() {
            // Move back up some of the overlap for holes
            zmove(tbO/2)
            // Then rotate
            xrot(cutAngle) 
            // Copy hole 4x
            xflip_copy()
            yflip_copy()
                // Move hole to correct location
                zmove(tbO/8)
                xmove((inSpace[0]/2)-p)
                ymove((inSpace[1])/3)
                scale([0.6,1.5,1.3])
                yrot(90)
                cylinder(h=postRad, r = postRad, $fn=16);
            
            // Rotate the bouding box
            xrot(cutAngle) 
            botTopOver(0);
        }
        
    
}

/* 
    Models catch posts
*/
module catchPosts() {
    intersection() {
        // Moves to halfway point up box, then down half the overlap
        // Half the overlap because it moves down on both sides
        zmove((inSpace[2]/2 + oShell[2]))
        // Rotate by angle
        xrot(cutAngle) {
            
            // Make posts
            xflip_copy()
            yflip_copy()
                zmove(tbO/8)
                xmove((inSpace[0] + oShell[0])/2)
                ymove((inSpace[1])/3)
                scale([0.7,1.5,1.5])
                sphere(r = postRad, $fn=16);
            
            
                
        }
        // Intersect with the box edge to ensure nothing outside
        totalBox();
    }
}



/* 
    Renders half of Box
    Bottom half if boxHalf = 0
    Top half if boxHalf = 1
*/
module makeHalf(boxHalf) {
    
    union() {
        difference() {
            totalBox();
            
            cardDeck();
            
            makeCut(boxHalf);
            
            // If bottom half, cut catch holes
            if (!boxHalf) catchHoles();
        }
        
        // If top half, add catch posts
        if (boxHalf) catchPosts();
    }
    
    
}

// Makes bottom of box
makeHalf(0);

// Moves to the side, makes top half of box
xmove(1.2*(inSpace[0] + oShell[0]))
    makeHalf(1);

*catchHoles();
*catchPosts();
    



