
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

// Gamma for making things render nicely
g = 0.005;
// Rho for accounting for material expansion
p = 0.4;


// Disable/Enable testing
testActive = false;

// Define scale factor for testing
testScale = testActive ? 0.4 : 1.0;


// Define space for Deck
inSpace = [68*testScale, 78*testScale, (testActive ? 12 : 100)];

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
cutAngle = 45;





// Models space for the deck itself
module cardDeck() {
    zmove(oShell[2]/2)
    linear_extrude(inSpace[2])
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

// Models space for the entire Box, when closed
module totalBox() {
    linear_extrude(inSpace[2]+oShell[2])
        square([
        inSpace[0] + oShell[0],
        inSpace[1] + oShell[1]
        ], center = true
        );
}


// Models a big cuboid to cut the the box
// If botTop is 0, this is for the BOTTOM half of the box
// If botTop is 1, this is for the TOP half of the box
module makeCut(botTop) {
    // Makes sure everything stays within the confines of the relevant section of the box
    // Moves to halfway point up box
    zmove((inSpace[2] + oShell[2])/2)
    // Rotates by specified angle
    xrot(cutAngle)
    difference() {
        // Cuts the top of the box down
        linear_extrude((inSpace[2]+oShell[2])*(2/3))
            square([
            inSpace[0] + oShell[0]+g,
            2*(inSpace[1] + oShell[1])
            ], center = true
            );
        
        // Checks if making the cut on the bottom or the top
        // 0 means bottom, 1 means top
        if (!botTop) {
            // If on bottom, re-add the inner ring of the join
            difference() {
                linear_extrude(tbO)
                    square([
                    inSpace[0] + (oShell[0]/2),
                    (inSpace[1] + (oShell[1]/2)) / cos(cutAngle)
                    ], center = true
                    );
                
                linear_extrude(tbO)
                    square([
                    inSpace[0],
                    (inSpace[1]) / cos(cutAngle)
                    ], center = true
                    );
            }
        }
        else {
            // If on top, re-add outer ring of join
        }
    }
    
}



// Renders bottom of Box
module bottomBox() {
    
    difference() {
        totalBox();
        
        cardDeck();
        
        makeCut(0);
    }
    
}


bottomBox();



