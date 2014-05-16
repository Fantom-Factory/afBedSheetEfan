using afIoc::Inject
using afBedSheet::Text

internal const class T_PageHandler {

	@Inject	private const EfanTemplates efanTemplates

	new make(|This|in) { in(this) }

	Obj efanOkay(Str title) {
		layout		:= efanTemplates.templateFromFile(`test/app/layout.efan`.toFile, Map#)
		meat		:= efanTemplates.templateFromFile(`test/app/meat.efan`.toFile,   Map#)
		
		layoutCtx	:= ["pageTitle": title]
		meatCtx		:= ["layout": layout, "layoutCtx": layoutCtx]

		text		:= meat.render(meatCtx)
		return Text.fromHtml(text)
	}
	
	Obj efanErr() {
		text := efanTemplates.renderFromFile(`test/app/compilationErr.efan`.toFile, [:])
		return Text.fromHtml(text)
	}
	
}
