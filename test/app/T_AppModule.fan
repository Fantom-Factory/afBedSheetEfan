using afIoc
using afBedSheet

@SubModule { modules=[EfanModule#] }
internal const class T_AppModule {
	
	static Void bind(ServiceBinder binder) {
//		binder.bindImpl(Router#)
	}

	@Contribute { serviceType=Routes# }
	static Void contributeRoutes(OrderedConfig conf) {
		conf.add(Route(`/efanOkay/*`, 	T_PageHandler#efanOkay))
		conf.add(Route(`/efanErr`, 		T_PageHandler#efanErr))
	}
}
