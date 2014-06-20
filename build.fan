using build

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the BedSheet web framework"
		version = Version("1.0.13")

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

			"afConcurrent 1.0.6+",
			"afIoc 1.6.2+",
			"afIocConfig 1.0.4+", 
			"afPlastic 1.0.12+",
			"afBedSheet 1.3.8+", 
			"afEfan 1.4.0.1+",
			
			// for testing
			"afBounce 1.0.2+",
			"afButter 0.0.6+",
			"afSizzle 1.0.0+"
		]

		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [,]
	}
}
