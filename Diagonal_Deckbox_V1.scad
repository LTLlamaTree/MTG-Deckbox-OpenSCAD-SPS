
/*
    This version for a diagonal split
    This way the deck can stay in the box during gameplay
*/


/*
    Dimensions for objects
    Inner box space
        70mm / 80mm / 100mm
        -> Need half of this vertically
        70 / 80 / 50
        -> Need overlap of 5mmm
        -> Use union to get that
    Shell - total
        4mm / 4mm / 4mm
    Big Sleeve
        3mm / 77mm / 103mm
*/

// Gamma for making things render nicely
y = 0.005;
// Rho for accounting for material expansion
p = 0.2;

// Define height of space before diagonal split
minHeight = 10;

// Define inner space
    // Subtract minHeight for easier cube creation
inSpace = [70, 80, 50-minHeight];

// Define Big Sleeve dimensions
bigSlev = [3, 76, 103];
// Define Big Sleeve edge width
slevEdge = 3;

// Define shell dimensions
oShell = [3.4, 3.4, 2];

// Define length of overlap for top/bottom halves
tbO = 5;






/*
    Module to create the bottom half of the box
*/
module bottomDiag() {
    // Union to combine the bottom shell with the deck-holding part
    union() {
        // Makes bottom layer for shell
        cube((2*oShell) + [inSpace[0], inSpace[1], 0]);
        
        // Makes the area before the diagonal
        translate([0, 0, oShell[2]])
            difference() { // including cutout
                cube([
                inSpace[0]+(2*oShell[0]), 
                inSpace[1]+(2*oShell[1]), 
                minHeight
                ]); 
                
                translate([oShell[0], oShell[1], y])
                    cube([
                    inSpace[0],
                    inSpace[1],
                    minHeight
                    ]);
            }
        
    }
    
}



bottomDiag();




