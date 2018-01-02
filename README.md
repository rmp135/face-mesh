A demo app for showing off the iPhone X TrueDepth camera.

Current settings allow for the following:

- Show the face mesh in wireframe mode.
- Disable the camera view to only show the face mesh.
- Disable real world based lighting. Note: this will effectively show the face mesh with no lighting at all and only works well in wireframe mode.

There's also an option to export the current face pose in Stl file format. This exported file has been tested with Windows and Mac build in model viewer and Blender 2.78. Note: the facet normals are not calculated. This doesn't appear to have an impact with viewers I've tested with but may not be compatible with all viewers.

No dependencies. Just load into XCode and select your provisioning profile.

![Demo Image 1](https://i.imgur.com/6domDsH.png)
![Demo Image 2](https://i.imgur.com/XSI0LPr.png)

![Face Meshes](https://i.imgur.com/GwkXcy1.png)