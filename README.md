# Draw on an iOS device using Metal ✏️

## TODOs and WIP tasks ✅
Look at the the project board [here](https://github.com/OwenCalvin/hand-drawing-swift-metal/projects/1)

## How does it works 📟 ?
### Line system
A line is composed of a multitude of interconnected triangles, they are generated from **"key point"** which are **the points having as coordinates the places where you have slipped your finger/pen and handled by your device**. Several linked triangles can form a trapeze which allows to manage the force communicated with the apple pen in order to vary the width of the line on the same line.

![](https://github.com/eldade/ios_metal_bezier_renderer/blob/master/Wireframe_Screenshot.png)
*Image from [ios_metal_bezier_renderer](https://github.com/eldade/ios_metal_bezier_renderer)*  
![](https://i.imgur.com/8t2qGRj.png)
*From XCode debugger*

### Interpolation
I use the Catmull Rom interpolation, it generates points between each **key points**   
*With interpolation:*  
![](https://i.imgur.com/dw193ag.jpg)

*Without interpolation (only the **key points**):*  
![](https://i.imgur.com/UTst8CB.jpg)  

## See also
- [ios_metal_bezier_renderer](https://github.com/eldade/ios_metal_bezier_renderer)
- [Catmull–Rom spline interpolation](https://en.wikipedia.org/wiki/Centripetal_Catmull–Rom_spline)
