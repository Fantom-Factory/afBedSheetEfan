using afIoc
using afBedSheet::Route
using afBedSheet::Routes

@SubModule { modules=[EfanModule#] }
internal const class T_AppModule {
	
	static Void defineServices(ServiceDefinitions defs) {
//		binder.bindImpl(Router#)
	}

	@Contribute { serviceType=Routes# }
	static Void contributeRoutes(Configuration conf) {
		conf.add(Route(`/efanOkay/*`, 	T_PageHandler#efanOkay))
		conf.add(Route(`/efanErr`, 		T_PageHandler#efanErr))
	}
}
