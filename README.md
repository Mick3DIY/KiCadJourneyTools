<picture>
    <img alt="MadeForKiCad(forthebadge.com)" src="assets/made-for-kicad.svg">
</picture>

# Our journey with KiCad

A simple repository with scripts, codes and tips that I'm using every day, to wish you a pleasant journey with KiCad, for your studies or hobbies.

## Codes :

* For new project, Bash script : [new_project](new_project/) folder
* To manage project, Bash script : [manage_project](manage_project/) folder

## Text variables :

:bulb: In KiCad, you can define common global variables for the schematic/PCB drawing sheets. 

To not re-enter these text variables in each new project, you can add this JSON code in the `.kicad_pro` file, in the section `text_variables` (don't forget to close all KiCad windows before) :

```json
"text_variables": {
    "PROJECT_TITLE": "Your project name",
    "PROJECT_LINK": "Your project link : https://your-project-url",
    "PCB_VERSION": "V1.0.0",
    "SCHEMATIC_VERSION": "V1.0.0",
    "YOUR_VARIABLE_NAME": "Your text, component reference, link"
}
```
After that, just add any variable names in your schematic or PCB (texts, symbols, drawing sheet zones...) with a specific call  `${PROJECT_TITLE}` for the project name.

Otherwise if you have these text variables in one of your project, you can import it directly from KiCad :
* From the schematic or board setup window, select the button 'Import settings from another project' or 'Import settings from another board'
* Select 'Text variables' in the options list

More informations : https://docs.kicad.org/master/en/eeschema/eeschema.html#variant-text-variables

## Printed Circuit Board (PCB) :

If you want a quick and affordable manufacturer for your next electronic project, get a unique 10€ coupon code in <ins>your first order</ins> in [AISLER](https://aisler.net) with my referral code : `MakeInEurope-ECYPW` :heart:

Big thanks to [AISLER](https://aisler.net) PCB manufacturer :eu:

## TODO :

- [x] [code] Add script for creating new KiCad project folders, files
- [x] [code] Add script for managing KiCad project with a normal workflow : schematic, PCB...
- [ ] [code] Add script for creating custom design rules (.kicad_dru), step by step
- [ ] [code] Add script for creating common jobsets file (all projects)
- [ ] [code] Add a empty KiCad project files, version 9 or 10 ?
- [ ] [code] Add more scripts and codes, any ideas ? :laughing:

## Documentation :

KiCad :
* https://www.kicad.org
* https://docs.kicad.org
* Plugins repository : https://www.kicad.org/pcm/

KiCad Electrical Rule Check (ERC) ⟶ schematic workflow :
* https://docs.kicad.org/master/en/eeschema/eeschema.html#erc

KiCad Custom Design Rules (DRC) ⟶ PCB workflow :
* https://docs.kicad.org/master/en/pcbnew/pcbnew.html#custom-design-rules

KiCad Design Rule Check (DRC) ⟶ PCB workflow :
* https://docs.kicad.org/master/en/pcbnew/pcbnew.html#design-rule-checking

KiCad jobsets ⟶ project workflow :
* https://docs.kicad.org/master/en/kicad/kicad.html#jobsets

KiCad Command Line Interface (CLI) ⟶ project workflow :
* https://docs.kicad.org/master/en/cli/cli.html

KiCad useful plugins :
* Interactive HTML BOM : https://github.com/openscopeproject/InteractiveHtmlBom
* Board2Pdf : https://gitlab.com/dennevi/Board2Pdf
* KiKit PCB panelization : https://github.com/yaqwsx/KiKit :thumbsup:
* PcbDraw convert PCB into 2D drawing : https://github.com/yaqwsx/PcbDraw :thumbsup:
* Solarized Dark theme : https://github.com/pointhi/kicad-color-schemes

KiCad manufacturers support repositories :
* https://github.com/AislerHQ/aisler-support

Projects using KiCad :
* https://passionelectronique.fr with many tutorials from Jérôme Tomski [FR] :ok_hand:
* https://www.elektormagazine.fr/labs?sort=relevancy&q=kicad from Elektor Labs and contributors

KiCad books :
* Elektor Ebooks bundle "KiCad Like a Pro" : https://www.elektor.fr/products/kicad-like-a-pro-e-book-bundle from [Peter Dalmaris](https://github.com/futureshocked) :ok_hand:

Bash script :
* https://www.gnu.org/software/bash/manual/
* https://linuxcommand.org from William Shotts :penguin: :pray:
* https://github.com/bobbyiliev/introduction-to-bash-scripting :ok_hand:
* https://itsfoss.com/bash-scripting-tutorial/ [beginners]


> [!NOTE]
> Big thanks to the GNU/Linux, [KiCad](https://www.kicad.org) and plugins communities. :heart:

Happy commanding, schematicing, routing, soldering & have fun ! :partying_face:
