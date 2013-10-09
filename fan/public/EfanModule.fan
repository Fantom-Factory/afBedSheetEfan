using afIoc
using afEfan::EfanCompiler
using afIocConfig::IocConfigSource
using afIocConfig::FactoryDefaults
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
	static EfanCompiler buildEfanCompiler(IocConfigSource configSrc, PlasticCompiler plasticCompiler) {
		// rely on afBedSheet to set srcCodePadding in PlasticCompiler (to be picked up by EfanCompiler) 
		EfanCompiler(plasticCompiler) {
			it.ctxVarName 			= configSrc.getCoerced(EfanConfigIds.ctxVarName, Str#)
			it.rendererClassName	= configSrc.getCoerced(EfanConfigIds.rendererClassName, Str#)
		}
	}

	@NoDoc
	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
		config[EfanConfigIds.rendererClassName]	= "EfanRendererImpl"
	}
}
