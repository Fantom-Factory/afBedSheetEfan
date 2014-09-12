using build

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the BedSheet web framework"
		version = Version("1.0.18")

		meta = [	
			"proj.name"		: "BedSheet efan",
			"afIoc.module"	: "afBedSheetEfan::EfanModule",
			"tags"			: "templating, web",
			"repo.private"	: "false"
		]

		index = [	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0",

			// ---- Core ------------------------
			"afConcurrent 1.0.6+",
			"afIoc 2.0.0+",
			"afIocConfig 1.0.16+", 
			"afPlastic 1.0.16+",
			"afBedSheet 1.3.16+", 
			"afEfan 1.4.2+",
			
			// ---- Test ------------------------
			"afBounce 1.0.14+",
			"afButter 1.0.2+",
			"afSizzle 1.0.0+"
		]

		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`]
		resDirs = [,]
	}
	
	@Target
	override Void compile() {
		// remove test pods from final build
		testPods := "afBounce afButter afSizzle".split
		depends = depends.exclude { testPods.contains(it.split.first) }
		super.compile
	}
}
