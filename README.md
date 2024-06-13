# This repo is a fork of the original repository :
https://git.lhnlm.fr/Doremus/org-meriemi-coloredgauge

If you have issues please add it to the gitlab repo

## Introduction

This ksysguard extension allow you to display colored icons from svg files.


## Demo
![Multi widget image](screenshots/full.png?raw=true "Multi widget")
![Full widget image](screenshots/full_desktop.png?raw=true "Full widget")


## Settings
![Full widget image](screenshots/data_settings.png?raw=true "Data setting tab")
![Full widget image](screenshots/display_settings.png?raw=true "Display setting tab")
![Full widget image](screenshots/icon_settings.png?raw=true "Icon setting tab")
![Full widget image](screenshots/position_settings.png?raw=true "Position setting tab")



## Notice
This widget allow you to display sensor value along with scg icon.
Both are colored depending on the sensor current value.



This widget allow you to customize a lot of things, font the color of the gradient to the prcise position of the labels.

Only one sensor can be selected at a time in the sensor section of the widget

You can also create your own SVG icon animation by adding as many frames as you need to create a custom animation.

You can add SVG frames to selecting them on the disk and you can reorder them to create your custom animation with drag and drop. Drag and drop is pretty buggy if you have any idea to implement it on a better way i will be glad to iumprove it.

If you want to avoid reordering them you only need to name the frame from 0 to n-1 frames to create the animation properly after import it.

## Troubleshooting

After some modfification (especially after modfying paddings) it can be usefull to refresh plasma desktop display you can do it with this command : 

` kquitapp5 plasmashell > /dev/null 2>&1 ; kstart5 plasmashell > /dev/null 2>&1`

## Support me
If you want to support my work you can buy me a coffee :
https://www.buymeacoffee.com/meriemi


