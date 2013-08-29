
internal class ErrMsgs {
	
	static Str templatesFileNotFound(File file) {
		"File not found: ${file.normalize.osPath}"
	}
	
	static Str viewHelperMixinIsNotMixin(Type vht) {
		"View Helper type ${vht.qname} is NOT a mixin."
	}
	
	static Str viewHelperMixinIsNotConst(Type vht) {
		"View Helper mixin ${vht.qname} is NOT const."
	}

	static Str viewHelperMixinIsNotPublic(Type vht) {
		"View Helper mixin ${vht.qname} is NOT public."
	}
	
}
