

/*
    Dimensions for objects
    Inner box space
        70mm / 80mm / 100mm
        -> Need half of this vertically
        70 / 80 / 50
        -> Need overlap of 5mm
        70 / 80 / 55
    Shell - total
        4mm / 4mm / 4mm
    Big Sleeve
        2mm / 75mm / 105mm
*/

// Define inner space
inSpace = [70, 80, 55];


// Define sleeve dimensions
bigSleeve = [2, 75, 105];

// Define shell dimensions
oShell = [4, 4, 4];

// Difference to refine shape
difference() {
    // Make a box that's the total of inner+shell
    cube(inSpace + oShell);



}




// Make cube that's the big sleeve
//cube(bigSleeve);


