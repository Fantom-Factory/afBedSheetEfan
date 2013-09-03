using afIoc::Inject
using afIoc::ConcurrentCache
using afEfan::EfanCompiler
using afEfan::EfanRenderer
using afBedSheet::Config

** Renders Embedded Fantom (efan) templates against a given context.
const mixin EfanTemplates {

	** Renders the given template with the ctx.
	** 
	** WARN: Overuse of this method could cause a memory leak! A new Fantom Type is created on 
	** every call. 
	abstract Str renderFromStr(Str efan, Obj? ctx := null)
	
	** Renders an '.efan' template file with the given ctx. 
	** The compiled '.efan' template is cached for re-use.   
	abstract Str renderFromFile(File efanFile, Obj? ctx := null)

	** Returns (or compiles) a renderer for the given file.
	abstract EfanRenderer rendererForFile(File efanFile, Type? ctxType := null)
}

internal const class EfanTemplatesImpl : EfanTemplates {
	private const static Log 	log := Utils.getLog(EfanTemplates#)
	private const FileCache 	fileCache
	private const EfanCompiler 	compiler
	
	@Inject @Config { id="afEfan.templateTimeout" }
	private const Duration templateTimeout
	
	@Inject	@Config { id="afEfan.srcCodePadding" } 	
	private const Int srcCodePadding	
	
	@Inject	@Config { id="afEfan.ctxVarName" } 	
	private const Str ctxVarName

	@Inject	private const EfanViewHelpers 	viewHelpers

	internal new make(|This|in) {
		in(this) 
		fileCache 	= FileCache(templateTimeout)
		compiler	= EfanCompiler() { 
			it.ctxVarName 		= this.ctxVarName 
			it.srcCodePadding	= this.srcCodePadding 			
		}
	}

	override Str renderFromStr(Str efan, Obj? ctx := null) {
		renderer	:= compiler.compile(`rendered/from/str`, efan, ctx?.typeof, viewHelpers.mixins)
		return renderer.render(ctx)
	}

	override Str renderFromFile(File efanFile, Obj? ctx := null) {
		renderer := rendererForFile(efanFile, ctx?.typeof)
		
		return renderer->render(ctx)
	}
	
	override EfanRenderer rendererForFile(File efanFile, Type? ctxType := null) {
		if (!efanFile.exists)
			throw IOErr(ErrMsgs.templatesFileNotFound(efanFile))

		renderer := (EfanRenderer) fileCache.getOrAddOrUpdate(efanFile) |->Obj| {
			template 	:= efanFile.readAllStr
			renderer	:= compiler.compile(efanFile.normalize.uri, template, ctxType, viewHelpers.mixins)
			return renderer
		}
		
		if (ctxType != null) {
			if (renderer.ctxType == null || !ctxType.fits(renderer.ctxType)) {
				log.warn(LogMsgs.templatesCtxDoesNotFitRendererCts(ctxType, renderer.ctxType, efanFile))
				template 	:= efanFile.readAllStr
				renderer	= compiler.compile(efanFile.normalize.uri, template, ctxType, viewHelpers.mixins)
				fileCache[efanFile] = renderer
			}
		}
		
		return renderer
	}
}
