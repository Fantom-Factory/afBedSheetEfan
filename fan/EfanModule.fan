using concurrent
using afIoc
using afEfan
using afIocConfig
using afPlastic::PlasticCompiler

** The [afIoc]`http://repo.status302.com/doc/afIoc/#overview` module class.
** 
** This class is public so it may be referenced explicitly in test code.
@NoDoc
const class EfanModule {

	static Void defineServices(ServiceDefinitions defs) {
		defs.add(EfanTemplates#)
		defs.add(EfanViewHelpers#)
	}

	@Build { serviceId="EfanCompiler" }
	static EfanCompiler buildEfanCompiler(ConfigSource configSrc, PlasticCompiler plasticCompiler) {
		// rely on afBedSheet to set srcCodePadding in PlasticCompiler (to be picked up by EfanCompiler) 
		EfanCompiler(EfanEngine(plasticCompiler)) {
			it.ctxVarName 			= configSrc.get(EfanConfigIds.ctxVarName, Str#)
			it.templateClassName	= configSrc.get(EfanConfigIds.templateClassName, Str#)
		}
	}

	@Contribute { serviceType=ActorPools# }
	static Void contributeActorPools(Configuration config) {
		config["afBedSheetEfan.fileCache"] = ActorPool() { it.name = "afBedSheetEfan.fileCache" }
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(Configuration config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.ctxVarName]		= "ctx"
		config[EfanConfigIds.templateClassName]	= "EfanTemplateImpl"
	}
}
