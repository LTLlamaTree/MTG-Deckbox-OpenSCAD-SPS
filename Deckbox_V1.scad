
/*
    Default deckbox shape
    Box joins at center with a bit of overlap
    Has a spot for a Toploader sleeve to show commander
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
g = 0.005;
// Rho for accounting for material expansion
p = 0.4;

// Define inner space
inSpace = [68, 80, 12];

// Define Big Sleeve dimensions
bigSlev = [2.6, 76, 103];
// Define Big Sleeve edge width
slevEdge = 3;

// Define shell dimensions
oShell = [3.2, 3.2, 1.6];

// Define length of overlap for top/bottom halves
tbO = 10;


// Make dimensions for half of box to fit /DECK/
boxDeck = inSpace + (2*oShell);
// Add on enough space for the big sleeve
boxSlev = boxDeck + [bigSlev[0], 0, 0];


/*
    Reduces bottom density for testing.
*/
module cutBottom() {
    translate((2*oShell) + [1, 1, -(2*oShell[2])-g])
        cube([
        inSpace[0]-(2.5*oShell[0]), 
        inSpace[1]-(2.5*oShell[1]), 
        (2*oShell[2])+(2*g)
        ]);
}


/*
    Models the space for the Deck, Big Sleeve, Viewport
*/
module cutSpace() {
    // Cut out the center box for the cards
    translate(oShell + [0,0,oShell[2]]) 
        cube(inSpace + [0,0,tbO]);
    
    
    // Cut out the space for the Big Sleeve
    translate(oShell + [inSpace[0]+(oShell[0]/2), (oShell[1]/2), 0]) {
        cube(bigSlev);
    
    // Cut out the viewport for the Big Sleeve
        translate([oShell[0]/2+g, slevEdge, slevEdge])
            cube(bigSlev - 2*[0, slevEdge, slevEdge]);
    }
}


/*
    Make BOTTOM Half of deckbox
*/
module bottomHalf() {
    // Difference to refine shape
    difference() {
        // Make the big shape
        union() {
            // Make a box that's the total of inner+shell
            cube(boxSlev);
            // Make cube for ribbon
            translate([
            (oShell[0]/2), 
            (oShell[1]/2), 
            (inSpace[2]+(2*oShell[2])-g)
            ])
                cube([
                (inSpace[0]+oShell[0]+bigSlev[0]-g), 
                (inSpace[1]+oShell[1]), 
                tbO
                ]);
        }
        
        // Cuts space for Deck, Big Sleeve, Viewport
        cutSpace();
        
        // Cuts bottom, uncomment for testing
        cutBottom();

    }

}


/*
    Make TOP Half of deckbox
*/
module topHalf() {
    difference() {
        // Make a box that's the total of inner+shell
        cube(boxSlev);
        
        // Cut out inner ribbon for the join
        translate([
        (oShell[0]/2)-p, 
        (oShell[1]/2)-p, 
        (inSpace[2]+(2*oShell[2])-tbO+g)
        ])
            cube([
            (inSpace[0]+oShell[0]+bigSlev[0]+(2*p)), 
            (inSpace[1]+oShell[1]+(2*p)), 
            tbO
            ]);
        
        
        // Cuts space for Deck, Big Sleeve, Viewport
        cutSpace();
        
        // Cuts bottom, uncomment for testing
        cutBottom();

    }

}



bottomHalf();

translate([0, 1.1*boxSlev[1], 0])
    topHalf();






