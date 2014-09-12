using afConcurrent
using afIoc
using afIocConfig
using afEfan

** Renders Embedded Fantom (efan) templates against a given context.
const mixin EfanTemplates {

	** Renders the given template with the ctx.
	** 
	** **Warning:** Overuse of this method could cause a memory leak! A new Fantom Type is created 
	** on every call. 
	abstract Str renderFromStr(Str efan, Obj? ctx := null)
	
	** Renders an '.efan' template file with the given ctx. 
	** The compiled '.efan' template is cached for re-use.   
	abstract Str renderFromFile(File efanFile, Obj? ctx := null)

	** Returns (or compiles) a template for the given file.
	abstract EfanTemplate templateFromFile(File efanFile, Type? ctxType := null)
	
	@NoDoc @Deprecated { msg = "Use tempalteFromFile() instead" }
	EfanTemplate rendererForFile(File efanFile, Type? ctxType := null) {
		templateFromFile(efanFile, ctxType)
	}
}

internal const class EfanTemplatesImpl : EfanTemplates {
	@Inject private const Log 					log
			private const SynchronizedFileMap 	fileCache
	
	@Config { id="afEfan.templateTimeout" }
	private const Duration templateTimeout
	
	@Config { id="afEfan.ctxVarName" } 	
	private const Str ctxVarName

	@Inject	private const EfanViewHelpers 	viewHelpers
	@Inject private const EfanCompiler 		compiler

	new make(ActorPools actorPools, |This|in) { 
		in(this)
		fileCache = SynchronizedFileMap(actorPools["afBedSheetEfan.fileCache"], templateTimeout)
	}

	override Str renderFromStr(Str efan, Obj? ctx := null) {
		template := compiler.compile(`rendered/from/str`, efan, ctx?.typeof, viewHelpers.mixins)
		return template.render(ctx)
	}

	override Str renderFromFile(File efanFile, Obj? ctx := null) {
		template := templateFromFile(efanFile, ctx?.typeof)
		return template.render(ctx)
	}
	
	override EfanTemplate templateFromFile(File efanFile, Type? ctxType := null) {
		if (!efanFile.exists)
			throw IOErr(templatesFileNotFound(efanFile))
		
		template := (EfanTemplate) fileCache.getOrAddOrUpdate(efanFile) |->Obj| {
			templateStr	:= efanFile.readAllStr
			template	:= compiler.compile(efanFile.normalize.uri, templateStr, ctxType, viewHelpers.mixins)
			return template
		}
		
		if (ctxType != null) {
			templateCtxType := template.templateMeta.ctxType
			if (templateCtxType == null || !ctxType.fits(templateCtxType)) {
				log.warn(templatesCtxDoesNotFitTemplateCtx(ctxType, templateCtxType, efanFile))
				templateStr := efanFile.readAllStr
				template	= compiler.compile(efanFile.normalize.uri, templateStr, ctxType, viewHelpers.mixins)
				fileCache[efanFile] = template
			}
		}
	
		return template
	}
	
	static Str templatesFileNotFound(File file) {
		"File not found: ${file.normalize}"
	}

	static Str templatesCtxDoesNotFitTemplateCtx(Type ctx, Type templateCtx, File file) {
		"Ctx type ${ctx.qname} does not fit existing template ctx ${templateCtx.qname} - Recompiling ${file.normalize}"
	}
}
