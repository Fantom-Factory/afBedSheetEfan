using afIoc
using afPlastic::PlasticCompiler
using afBedSheet
using afEfan
using afIocConfig::ApplicationDefaults

internal class TestEfanIntegration : Test {

	BedClient? client
	
	@Inject
	PlasticCompiler? plasticCompiler
	
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
		verify(res.asStr.contains("<h2>Plastic Compilation Err</h2>"))
	}
	
	Void testCompilerHasConfig() {
		verifyEq(plasticCompiler.srcCodePadding, 50)
	}
}

internal class T_EfanMod {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(MappedConfig config) {
		config[BedSheetConfigIds.srcCodeErrPadding]	= 50
	}	
}