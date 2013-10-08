using afIoc
using afEfan::EfanCompiler
using afBedSheet::ConfigIds
using afBedSheet::ConfigSource
using afBedSheet::FactoryDefaults
using web::WebOutStream
using afPlastic::PlasticCompiler

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
const class EfanModule {

	@NoDoc
	static Void bind(ServiceBinder binder) {
		binder.bindImpl(EfanTemplates#).withoutProxy	// has default method args
		binder.bindImpl(EfanViewHelpers#).withoutProxy
	}

	@NoDoc
	@Build { serviceId="EfanCompiler" }
	static EfanCompiler buildEfanCompiler(ConfigSource configSrc, PlasticCompiler plasticCompiler) {
		EfanCompiler() {
			it.ctxVarName		= configSrc.getCoerced(EfanConfigIds.ctxVarName, Str#)
			it.srcCodePadding	= configSrc.getCoerced(ConfigIds.srcCodeErrPadding, Int#)
//			it.plasticCompiler	= plasticCompiler
		}
	}

	@NoDoc
	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
	}
}
