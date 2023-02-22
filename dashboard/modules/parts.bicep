param servicePlans array

param rows int

//var positions = [for len in range(1, length(servicePlans)): {
//  position: {
//    x: ((length(servicePlans) % 2) == 0) ? 0 : 4
    //y:  c* 6
//    rowSpan: 6
//    colSpan: 4
//    }
//}]

var positions1 = [for len in range(1, rows): {
  position: {
    x: 0
    y: len * 6
    rowSpan: 6
    colSpan: 4
    }
}]

var positions2 = [for len in range(1, rows): {
  position: {
    x: 4
    y: len * 6
    rowSpan: 6
    colSpan: 4
    }
}]

var completePositions = concat(positions1, positions2)
