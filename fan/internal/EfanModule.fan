using afIoc
using afEfan::EfanCompiler
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
			it.srcCodePadding	= config.getCoerced(EfanConfigIds.srcCodePadding, Int#)
		}
	}
	
	@Contribute { serviceId="ErrPrinterHtml" }
	static Void contributeErrPrinterHtml(OrderedConfig config) {
		printer := (EfanErrPrinter) config.autobuild(EfanErrPrinter#)		
		config.addOrdered("Efan", |WebOutStream out, Err? err| { printer.printHtml(out, err) }, ["Before: StackTrace", "After: IocOperationTrace"])
	}

	@Contribute { serviceId="ErrPrinterStr" }
	static Void contributeErrPrinterStr(OrderedConfig config) {
		printer := (EfanErrPrinter) config.autobuild(EfanErrPrinter#)
		config.addOrdered("Efan", |StrBuf out, Err? err| { printer.printStr(out, err) }, ["Before: StackTrace", "After: IocOperationTrace"])
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeFactoryDefaults(MappedConfig config) {
		config[EfanConfigIds.templateTimeout]	= 10sec
		config[EfanConfigIds.srcCodePadding]	= 5
		config[EfanConfigIds.ctxVarName]		= "ctx"
	}
}
