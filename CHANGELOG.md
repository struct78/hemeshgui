# Changelog
All notable changes to this project will be documented in this file.

## [0.6.0] - 2018-07-16
### Added
- __New Shapes:__ Sea Shell, Sweep Tube, and Twin ISO shapes
- __New Modifiers:__ Spherify, Shrink Wrap and Voronoi Cells modifiers
- Ani library for smoother animations
- Save As! Save your workspace settings
- Examples:
  - Beethoven
  - Cone
  - Custom shapes
  - Geodesic
  - Grid
  - Torus
  - UV Parametric

### Changed
- Complete re-write of Quick Save/Quick Loadload
- Switched from WB_Render to WB_Render3D
- Rotation in Sunflow rendering improved
- Improved light rendering in Sunflow
- Modified SunflowAPIAPI.java to include aa.jitter parameter

### Removed
- Translate to mouse movement
- Voronoi cells shape

## [0.5.0] - 2018-06-20
### Added
- __New Shapes:__ Voronoi Cells and UV Parametric
- __New Modifiers:__ Noise, Spherical Inversion, DooSabin
- __New Shaders:__ Ambient Occlusion
- UI themes! Change the interface to suit you
- Multithreaded rendering
-
### Changed
- Moved UI to grid-based layout
- Code refactoring to make adding shapes/modifiers easier
- Removed unused parameter sliders for Modifiers
- Unused parameter sliders for Shapes are disabled when shape is changed

### Removed
- Unused parameter sliders for modifiers. Modifiers now only display the amount of sliders necessary.


## [0.4.1] - 2018-05-23
### Added
- README images

### Fixed
- Property labels not appearing when changing shapes
- UI visual defects


## [0.4.0] - 2018-05-20
### Added
- __New Shapes:__ Beethoven, Super Duper, Alpha, Archimedes
- __New Modifiers:__ Mirror and Kaleidoscope

### Changed
- UI tweaks
- Sketch now runs in fullscreen mode
- Code formatting
- Updated to run under the latest version of Processing (3.3.7)
- Updated HE_Mesh library to version 5.0.3
- Updated ControlP5 version to 2.2.6

### Removed
- Mouse controls

[Unreleased]: https://github.com/struct78/hemeshgui/compare/v0.5...develop
[0.5.0]: https://github.com/struct78/hemeshgui/compare/v0.4.1...v0.5
[0.4.1]: https://github.com/struct78/hemeshgui/compare/v0.4...v0.4.1
