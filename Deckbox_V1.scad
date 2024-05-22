

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
        2mm / 75mm / 105mm
*/

// Gamma for making things render nicely
y = 0.02;
// Rho for accounting for material expansion
p = 0.2;

// Define inner space
inSpace = [70, 80, 50];

// Define sleeve dimensions
bigSleeve = [2, 75, 105];

// Define shell dimensions
oShell = [4, 4, 4];

// Define length of overlap for top/bottom halves
tbO = 5;


// Difference to refine shape
difference() {
    // Make the big shape
    union() {
        // Make a box that's the total of inner+shell
        cube(inSpace + (2*oShell));
            // Make cube for ribbon
            translate([(oShell[0]/2)+(p/2),(oShell[1]/2)+(p/2),(inSpace[2]+(2*oShell[2])-y)])
                cube([(inSpace[0]+oShell[0]-p), (inSpace[1]+oShell[1]-p), tbO]);
    }
    
    // Cut out the center box for the cards
    translate(oShell) {
        cube(inSpace + [0,0,tbO]);
    }
    

}







