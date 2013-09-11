using afIoc
using afEfan::EfanCompiler
using afBedSheet::ConfigIds
using afBedSheet::ConfigSource
using afBedSheet::FactoryDefaults
using web::WebOutStream

// FIXME: fandoc, public 'cos so it may be ref'ed from tetss in other projs
const class EfanModule {

	static Void bind(ServiceBinder binder) {
		binder.bindImpl(EfanTemplates#).withoutProxy	// has default method args
		binder.bindImpl(EfanViewHelpers#).withoutProxy
	}

	@Build { serviceId="EfanCompiler" }
	static EfanCompiler buildEfanCompiler(ConfigSource config) {
		EfanCompiler() {
			it.ctxVarName		= config.getCoerced(EfanConfigIds.ctxVarName, Str#)
			it.srcCodePadding	= config.getCoerced(ConfigIds.srcCodeErrPadding, Int#)
		}
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
	}
}
