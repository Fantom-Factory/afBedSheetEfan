using afEfan::EfanErr
using afIoc::Registry
using afIoc::RegistryBuilder
using afIocConfig::IocConfigModule

abstract internal class EfanTest : Test {
	
	Registry? 	reg
	Type[]		modules	:= [IocConfigModule#, EfanModule#]
	
	override Void setup() {
		reg = (Registry) RegistryBuilder().addModules(modules).build.startup
		reg.injectIntoFields(this)
	}
	
	override Void teardown() {
		reg?.shutdown
	}
	
	Void verifyEfanErrMsg(Str errMsg, |Obj| func) {
		verifyErrTypeMsg(EfanErr#, errMsg, func)
	}

	protected Void verifyErrTypeMsg(Type errType, Str errMsg, |Obj| func) {
		try {
			func(69)
		} catch (Err e) {
			if (!e.typeof.fits(errType)) 
				throw Err("Expected $errType got $e.typeof", e)
			msg := e.msg
			if (msg != errMsg)
				verifyEq(errMsg, msg)	// this gives the Str comparator in eclipse
//				throw Err("Expected: \n - $errMsg \nGot: \n - $msg")
			return
		}
		throw Err("$errType not thrown")
	}
	
}
