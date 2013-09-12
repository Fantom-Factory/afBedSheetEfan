using afIoc
using afEfan::EfanCompiler
using afBedSheet::ConfigIds
using afBedSheet::ConfigSource
using afBedSheet::FactoryDefaults
using web::WebOutStream

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
const class EfanModule {

	@NoDoc
	static Void bind(ServiceBinder binder) {
		binder.bindImpl(EfanTemplates#).withoutProxy	// has default method args
		binder.bindImpl(EfanViewHelpers#).withoutProxy
	}

	@NoDoc
	@Build { serviceId="EfanCompiler" }
	static EfanCompiler buildEfanCompiler(ConfigSource config) {
		EfanCompiler() {
			it.ctxVarName		= config.getCoerced(EfanConfigIds.ctxVarName, Str#)
			it.srcCodePadding	= config.getCoerced(ConfigIds.srcCodeErrPadding, Int#)
		}
	}

	@NoDoc
	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
	}
}
