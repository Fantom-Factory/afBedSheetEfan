using afIoc
using afBedSheet
using afEfan

internal class TestEfanIntegration : Test {

	BedClient? client
	
	@Inject
	EfanCompiler? compiler
	
	override Void setup() {
		server := BedServer(T_AppModule#).addModule(T_EfanMod#).startup
		server.injectIntoFields(this)
		client = server.makeClient
	}

	override Void teardown() {
		client.shutdown
	}	

	Void testWebOkay() {
		res := client.get(`/efanOkay/Beards!`)
		verify(res.asStr.contains("<title>Beards!</title>"))
	}

	Void testErrPageIntegration() {
		res := client.get(`/efanErr`)
		verifyEq(res.statusCode, 500)
		verify(res.asStr.contains("<h2>Efan Compilation Err</h2>"))
//		Env.cur.err.printLine(res.asStr)
		verify(res.asStr.contains("<h2>Plastic Compilation Err</h2>"))
	}
	
	Void testCompilerHasConfig() {
		verifyEq(compiler.srcCodePadding, 50)		
	}
}

internal class T_EfanMod {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(MappedConfig config) {
		config[ConfigIds.srcCodeErrPadding]	= 50
	}	
}