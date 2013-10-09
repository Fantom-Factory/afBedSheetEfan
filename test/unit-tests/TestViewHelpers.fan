using afIoc
using afIocConfig

internal class TestViewHelpers : EfanTest {
	
	@Inject private EfanTemplates? efan
	
	override Void setup() {
		modules = [IocConfigModule#, EfanModule#, T_Mod01#]
		super.setup
	}
	
	Void testMultipleViewHelpers() {
		template := "<%= a() %> <%= b %>"
		output	 := efan.renderFromStr(template, null)
		verifyEq("Judge Dredd", output)
	}
}

@NoDoc
const mixin T_Vh3 {
	Str a() { "Judge" }
}

@NoDoc
const mixin T_Vh4 {
	Str b() { "Dredd" }
}

internal class T_Mod01 {
	@Contribute { serviceType=EfanViewHelpers# }
	static Void contrib(OrderedConfig config) {
		config.add(T_Vh3#)
		config.add(T_Vh4#)
	}
}