using afEfan::EfanCompiler

** Contribute to 'EfanViewHelpers' to add view helpers to your efan templates.
const mixin EfanViewHelpers { 
	abstract internal Type[] mixins()
}

internal const class EfanViewHelpersImpl : EfanViewHelpers {
	override internal const Type[]	mixins
	
	internal new make(Type[] viewHelpers, |This|in) { 
		in(this)		
		this.mixins = EfanCompiler.validateViewHelpers(viewHelpers).toImmutable
	}
}
