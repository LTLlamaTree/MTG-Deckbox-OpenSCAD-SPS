

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

// Define inner space
inSpace = [70, 80, 50];

// Define Big Sleeve dimensions
bigSlev = [3, 76, 103];
// Define Big Sleeve edge width
slevEdge = 3;

// Define shell dimensions
oShell = [4, 4, 4];

// Define length of overlap for top/bottom halves
tbO = 5;


// Make dimensions for half of box to fit /DECK/
boxDeck = inSpace + (2*oShell);
// Add on enough space for the big sleeve
boxSlev = boxDeck + [bigSlev[0], 0, 0];


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
        translate([oShell[0]/2+y, slevEdge, slevEdge])
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
            (oShell[0]/2)+(p/2), 
            (oShell[1]/2)+(p/2), 
            (inSpace[2]+(2*oShell[2])-y)
            ])
                cube([
                (inSpace[0]+oShell[0]+bigSlev[0]-p), 
                (inSpace[1]+oShell[1]-p), 
                tbO
                ]);
        }
        
        // Cuts space for Deck, Big Sleeve, Viewport
        cutSpace();

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
        (oShell[0]/2)-(p/2), 
        (oShell[1]/2)-(p/2), 
        (inSpace[2]+(2*oShell[2])-tbO+y)
        ])
            cube([
            (inSpace[0]+oShell[0]+bigSlev[0]+p), 
            (inSpace[1]+oShell[1]+p), 
            tbO
            ]);
        
        
        // Cuts space for Deck, Big Sleeve, Viewport
        cutSpace();

    }

}



bottomHalf();

translate([0, 1.1*boxSlev[1], 0])
    topHalf();






