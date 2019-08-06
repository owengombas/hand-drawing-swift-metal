# Draw on an iOS device using Metal

## TODO:
- README 😬
- Force (pointsize) changed -> correct link between triangles
- Move "triangle interpolated vertices calculation" to shaders
- Config n interpolated triangles
- Add a dot at the start/end of a line (round the line)
- Colors, pointSize, eraser, ... tools
- Handle touchesEstimatedPropertiesUpdated
- Drawing vertices buffer for a fluid draw (norm selector)

# How ?
![](https://github.com/eldade/ios_metal_bezier_renderer/blob/master/Wireframe_Screenshot.png)
*Image from [ios_metal_bezier_renderer](https://github.com/eldade/ios_metal_bezier_renderer)*  

A line is composed of a multitude of interconnected triangles, they are generated from "key point" which are the points having as coordinates the places where you have slipped your finger/pen. Several linked triangles can form a trapeze which allows to manage the force communicated with the apple pen in order to vary the width of the line on the same line.

## See also
- [ios_metal_bezier_renderer](https://github.com/eldade/ios_metal_bezier_renderer)
