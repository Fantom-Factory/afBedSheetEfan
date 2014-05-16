
internal class LogMsgs {
	
	static Str templatesCtxDoesNotFitTemplateCtx(Type ctx, Type templateCtx, File file) {
		"Ctx type ${ctx.qname} does not fit existing template ctx ${templateCtx.qname} - Recompiling ${file.normalize}"
	}

}
