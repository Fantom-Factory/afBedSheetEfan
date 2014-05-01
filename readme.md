# BedSheet Efan

`BedSheet Efan` is a [Fantom](http://fantom.org) library that integrates [efan](http://www.fantomfactory.org/pods/afEfan) templates with the
[BedSheet](http://www.fantomfactory.org/pods/afBedSheet) web framework.

`BedSheet Efan` provides a cache of your compiled [efan](http://www.fantomfactory.org/pods/afEfan) renderers, integrates into [BedSheet](http://www.fantomfactory.org/pods/afBedSheet)'s Err 500 page and lets you contribute efan view helpers on an application level.



## Install

Install `BedSheet Efan` with the Fantom Respository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afBedSheetEfan

To use in a project, add a dependency in your `build.fan`:

    depends = ["sys 1.0", ..., "afBedSheetEfan 1.0+"]



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afBedSheetEfan/#overview).



## Quick Start

xmas.efan:

    <% ctx.times |i| { %>
      Ho! 
    <% } %>
    Merry Christmas!


Fantom code:

    @Inject EfanTemplates efanTemplates

    ...

    // --> Ho! Ho! Ho! Merry Christmas!
    efanTemplates.renderFromFile(`xmas.fan`.toFile, 3)
