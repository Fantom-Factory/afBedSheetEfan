## Overview 

`BedSheet Efan` is a Fantom library that integrates [efan](http://www.fantomfactory.org/pods/afEfan) templates with the [BedSheet](http://www.fantomfactory.org/pods/afBedSheet) web framework.

`BedSheet Efan` uses [IoC](http://www.fantomfactory.org/pods/afIoc), therefore to use the [EfanTemplates](http://repo.status302.com/doc/afBedSheetEfan/EfanTemplates.html) service you must `@Inject` it into your own service / class.

`BedSheet Efan` provides a cache of your compiled [efan](http://www.fantomfactory.org/pods/afEfan) templates, integrates into [BedSheet](http://www.fantomfactory.org/pods/afBedSheet)'s Err 500 page and lets you contribute efan view helpers on an application level.

See [efan](http://www.fantomfactory.org/pods/afEfan) for Embedded Fantom documentation.

> **ALIEN-AID:** Replace `BedSheetEfan` with [efanXtra](http://www.fantomfactory.org/pods/afEfanXtra) to create managed libraries of reusable Embedded Fantom (efan) components!

## Install 

Install `BedSheet efan` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afBedSheetEfan

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afBedSheetEfan 1.0+"]

## Documentation 

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afBedSheetEfan/#overview).

## Quick Start 

xmas.efan:

```
<% ctx.times |i| { %>
  Ho!
<% } %>
Merry Christmas!
```

IndexPage.fan:

```
using afIoc::Inject
using afBedSheet::Text
using afBedSheetEfan::EfanTemplates

class IndexPage {

  @Inject private EfanTemplates? efan

  Text render() {
    template := efan.renderFromFile(`res/index.efan`.toFile, 3)

    // --> Ho! Ho! Ho! Merry Christmas!
    return Text.fromPlain(template)
  }
}
```

## Usage 

To use `BedSheetEfan` just add it as dependency in your project's `build.fan`. Example:

```
depends = ["sys 1.0", ... "afBedSheetEfan 1.0+" ]
```

...and that's it!

Because `BedSheetEfan` defines [pod meta-data](http://repo.status302.com/doc/afIoc/RegistryBuilder.html) for [IoC](http://www.fantomfactory.org/pods/afIoc), no more configuration or setup is required.

## View Helpers 

Efan lets you provide view helpers for common tasks. View helpers are `mixins` that your efan template can extend, giving your templates access to commonly used methods. Example, for escaping XML:

Contribute View Helpers in your `AppModule`:

```
@Contribute { serviceType=EfanViewHelpers# }
static Void contrib(OrderedConfig conf) {
  conf.add(XmlViewHelper#)
}
```

All templates then have access to methods on `XmlViewHelper`:

```
<p>
  Hello <%= x(ctx.name) %>!
</p>
```

## Err Reporting 

afEfan automatically hooks into afBedSheet to give detailed reports on efan compilation and runtime errors. The reports are added to the default afBedSheet Err500 page.

```
Efan Compilation Err:
  file:/C:/Projects/Fantom/Efan/test/app/compilationErr.efan : Line 17
    - Unknown variable 'dude'

    12: Five space-worthy orbiters were built; two were destroyed in mission accidents. The Space...
    13: </textarea><br/>
    14:         <input id="submitButton" type="button" value="Submit">
    15:     </form>
    16:
==> 17: <% dude %>
    18: <script type="text/javascript">
    19:     <%# the host domain where the scanner is located %>
    20:
    21:     var plagueHost = "http://fan.home.com:8069";
    22:     console.debug(plagueHost);
```

## Fair Usage Policy! 

Efan works by dynamically generating Fantom source code and compiling it into a Fantom type. Because types can not be *unloaded*, if you were compile 1000s of efan templates, it could be considered a memory leak.

For this reason, templates compiled from files are cached and reused, therefore posing no risk in your typical web application(*). But templates compiled [from Strs](http://repo.status302.com/doc/afBedSheetEfan/EfanTemplates#renderFromStr.html) are not cached and so calls to this method should be made judiciously.

(*) If a template file seen to be modified, the efan template is re-compiled on the fly. This is fine in dev, but be weary of modifying template files in live.

