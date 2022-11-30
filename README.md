# Atoms Flutter plugin

Flutter fancy animated widget that can be used as a background.

![Screenshot](https://github.com/alnitak/atoms/blob/master/images/atoms.gif?raw=true "Atoms Demo")

## Atoms Widget Properties

##### Atoms widget
* [**backgroundColor**] The background color.
* [**minVelocity**] Minimum offset for each tick.
* [**maxVelocity**] Maximum offset for each tick.
* [**nAtoms**] the number of atoms.
* [**atomParameters**] Parameters to draw atoms.

##### Atom properties
* [**atomsDiameter**] The atoms diameter.
* [**atomsColor**] The atoms color.
* [**webColor**] Color of the line that connects dots.
* [**maxDistance**] Max distance to draw the web.


## How to use

```dart
  SizedBox.expand(
    child: Atoms(
      backgroundColor: Color(0xff00001a),
      minVelocity: 0.2,
      maxVelocity: 1,
      nAtoms: 100,
      atomParameters: Atom(
        atomsColor: Colors.white,
        webColor:  Colors.white,
        atomsDiameter: 2,
        maxDistance: 140,
      ),
    ),
  ),
```


