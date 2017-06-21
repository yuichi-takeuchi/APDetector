# APDetector
Matlab GUI for automatic action potential detection of membrane potential recordings. Action potentials going above a defined threshold are automatically detected and their timestamps, peak voltage, amplitude, half width etc. are stored into a structure named APStruct in the workspace. The results can be converted into a table and exported as a comma-separated value file for further analyses.

## Getting Started

### Prerequisites
* Matlab (https://www.mathworks.com/products/matlab.html)

The code has been tested with Matlab ver 8.6 (R2015b).

### Installing
* Install Matlab.
* Give your Matlab pass to the m and fig files.

### How to use
1. Launch Matlab.
2. Launch APDetector as
```
guide APDetector.fig
```
and Run Figure (Ctrl+T).
3. or Run APDetector.fig directly.
```
APDetector
```
4. The number of "group", any number of integer and sampling rate of recordings must be stored in a structure named as "StructInfo". For example:
```
StructInfo.expnum = 1;
StructInfo.sr = 20000;
```
5. Data must be stored in a structure named as "StructDataX", where X is a group name integer. StructDataX must has "Voltage" cell field each of which several voltage sweeps as column vectors. Each series of sweeps must be treated as a record of the StructDataX structure. For example, the 3rd sweep of the 2nd series of the 1st group must be accessed as "StructData1(2).Voltage{3,1}". An script for automatic organization of the StructData structure can be found in the demo script (DemoScript.m).
6. Define the numbers of group, series, and sweep of the source wave on the popupmenus on the APDetector GUI. After that define a threshold voltage in the edit box 1 on the GUI.
7. Press "Plot and Detect" button on the GUI. The source wave will be shown on the graph1 and action potentials will be detected and their peaks will be labeled with red open circles.
8. Press "Add and Calc" button. Time stamp, peak voltage, and other parameters of each action potential will be stored into a structure named as "APStruct".
9. Repeat 6 to 8.

## Demostration
* DemoData.mat has a variable (StructData1), which includes in vivo patch-clamp data from a pyraminal neuron in the V1 cortex.
* Load the data and launch cells in the DemoScript.m one-by-one to see how it works.

## DOI
[![DOI](https://zenodo.org/badge/95033472.svg)](https://zenodo.org/badge/latestdoi/95033472)

## Versioning
We use [SemVer](http://semver.org/) for versioning.

## Releases
* Ver 1.0.0, 2017/06/21

## Authors
* **Yuichi Takeuchi PhD** - *Initial work* - [GitHub](https://github.com/yuichi-takeuchi)
* Affiliation: Department of Physiology, University of Szeged, Hungary
* E-mail: yuichi-takeuchi@umin.net

## License
This project is licensed under the MIT License.

## Acknowledgments
* The Uehara Memorial Foundation
* Department of Physiology, University of Szeged, Hungary

