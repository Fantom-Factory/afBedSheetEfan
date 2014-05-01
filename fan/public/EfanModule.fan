using concurrent
using afIoc
using afEfan::EfanCompiler
using afIocConfig::IocConfigSource
using afIocConfig::FactoryDefaults
using afPlastic::PlasticCompiler

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class EfanModule {

	static Void bind(ServiceBinder binder) {
		binder.bind(EfanTemplates#).withoutProxy	// has default method args
		binder.bind(EfanViewHelpers#).withoutProxy
	}

	@Build { serviceId="EfanCompiler" }
	static EfanCompiler buildEfanCompiler(IocConfigSource configSrc, PlasticCompiler plasticCompiler) {
		// rely on afBedSheet to set srcCodePadding in PlasticCompiler (to be picked up by EfanCompiler) 
		EfanCompiler(plasticCompiler) {
			it.ctxVarName 			= configSrc.get(EfanConfigIds.ctxVarName, Str#)
			it.rendererClassName	= configSrc.get(EfanConfigIds.rendererClassName, Str#)
		}
	}

	@Contribute { serviceType=ActorPools# }
	static Void contributeActorPools(MappedConfig config) {
		config["afBedSheetEfan.fileCache"] = ActorPool()
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
		config[EfanConfigIds.rendererClassName]	= "EfanRendererImpl"
	}
}
