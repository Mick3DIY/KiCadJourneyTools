<picture>
    <img alt="MadeForKiCad(forthebadge.com)" src="assets/made-for-kicad.svg">
</picture>

# Our journey with KiCad

A simple repository with scripts, codes, tips than I'm using everyday and to wish you a pleasant journey with KiCad.

## Code :

* For new KiCad project, Bash scripts : [new_project](new_project/) folder

## Text variables :

:bulb: In KiCad, you can define common global variables for the schematic/PCB drawing sheets. 

To not re-enter these variables in each new project, you can add this JSON code in the `.kicad_pro` file, in the section `text_variables` :

```json
"text_variables": {
    "PROJECT_TITLE": "YOUR_PROJECT_NAME",
    "PROJECT_LINK": "Your project : https://your-project-url",
    "PCB_VERSION": "V1.0",
    "SCHEMATIC_VERSION": "V1.0",
    "YOUR_VARIABLE_NAME": "Your text, component reference, link"
}
```
After that, just add any variable names in your schematic or PCB (texts, symbols, drawing sheet zones...) with a specific call  `${PROJECT_TITLE}` for the project name.

More informations : https://docs.kicad.org/9.0/en/eeschema/eeschema.html#text-variables

## TODO :

- [ ] [code] Add a empty KiCad project files, version 9 or 10 ?
- [ ] [code] Add more scripts and codes, any ideas ? :laughing:

## Documentation :

KiCad :
* https://www.kicad.org
* https://docs.kicad.org
* Plugins repository : https://www.kicad.org/pcm/

KiCad manufacturers support repositories :
* https://github.com/AislerHQ/aisler-support

Bash script:
* https://www.gnu.org/software/bash/
* https://www.gnu.org/software/bash/manual/
* https://linuxcommand.org from William Shotts :penguin: :pray:
* https://itsfoss.com/bash-scripting-tutorial/ [beginners]


> [!NOTE]
> Big thanks to the GNU/Linux, [KiCad](https://www.kicad.org) and plugins communities. :heart:

Happy commanding, schematicing, routing, soldering & have fun ! :partying_face: