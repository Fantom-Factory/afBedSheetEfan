using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the afBedSheet web framework"
		version = Version([1,0,1])

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/AlienFactory/afbedsheetefan",
					"proj.name"		: "AF-BedSheetEfan",
					"license.name"	: "BSD 2-Clause License",
					"repo.private"	: "true",
			
					"afIoc.module"	: "afBedSheetEfan::EfanModule"			
				]

		index	= [	"afIoc.module"	: "afBedSheetEfan::EfanModule"
				]

		depends = ["sys 1.0", "compiler 1.0", "web 1.0", 
					"afIoc 1.4.4+", "afBedSheet 1.0+", "afEfan 1.0+"]
		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true
		
		// exclude test code when building the pod - this means we can have public test classes!
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
	}
}
