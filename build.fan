using build

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the BedSheet web framework"
		version = Version("1.0.15")

		meta = [	
			"proj.name"		: "BedSheet efan",
			"afIoc.module"	: "afBedSheetEfan::EfanModule",
			"tags"			: "templating, web",
			"repo.private"	: "true"
		]

		index = [	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0",

			// ---- Core ------------------------
			"afConcurrent 1.0.6+",
			"afIoc 1.7.2+",
			"afIocConfig 1.0.10+", 
			"afPlastic 1.0.16+",
			"afBedSheet 1.3.12+", 
			"afEfan 1.4.0.1+",
			
			// ---- Test ------------------------
			"afBounce 1.0.8+",
			"afButter 1.0.0+",
			"afSizzle 1.0.0+"
		]

		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [,]
	}
	
	override Void compile() {
		// remove test pods from final build
		testPods := "afBounce afButter afSizzle".split
		depends = depends.exclude { testPods.contains(it.split.first) }
		super.compile
	}
}
