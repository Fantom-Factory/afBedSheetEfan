using afIoc
using afBedSheet

internal class TestEfanIntegration : Test {

	BedClient? client
	
	override Void setup() {
		client = BedServer(T_AppModule#).startup.makeClient
	}
	
	override Void teardown() {
		client.shutdown
	}	

	Void testWebOkay() {
		res := client.get(`/efanOkay/Beards!`)
		Env.cur.err.printLine(res.asStr)
		verify(res.asStr.contains("<title>Beards!</title>"))
	}

	Void testErrPageIntegration() {
		res := client.get(`/efanErr`)
		verifyEq(res.statusCode, 500)
		verify(res.asStr.contains("<h2>Efan Compilation Err</h2>"))
	}
}
