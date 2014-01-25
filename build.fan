using build

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the afBedSheet web framework"
		version = Version([1,0,9])

		meta	= [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "AF-BedSheetEfan",
			"proj.uri"		: "http://repo.status302.com/doc/afBedSheetEfan/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afbedsheetefan",
			"license.name"	: "BSD 2-Clause License",
			"repo.private"	: "true",
	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"			
		]

		index	= [	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"
		]

		depends = [
			"sys 1.0", 
			"web 1.0", 

			"afIoc 1.5.2+",
			"afIocConfig 1.0.2+", 
			"afPlastic 1.0.10+",
			
			"afBedSheet 1.3.0+", 
			"afEfan 1.3.6.2+",
			
			// for testing
			"afBounce 0+"
		]

		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true
	}

	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("res/test/") }
		
		super.compile
		
		// copy src to %FAN_HOME% for F4 debugging
		log.indent
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)		
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}
}
