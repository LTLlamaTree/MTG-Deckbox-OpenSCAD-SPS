
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


