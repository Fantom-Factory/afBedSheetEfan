using build

class Build : BuildPod {

	new make() {
		podName = "afBedSheetEfan"
		summary = "A library for integrating Embedded Fantom (efan) templates with the BedSheet web framework"
		version = Version("1.0.11")

		meta = [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "BedSheet efan",
			"proj.uri"		: "http://repo.status302.com/doc/afBedSheetEfan/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afbedsheetefan",
			"license.name"	: "The MIT Licence",
			"repo.private"	: "true",
	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"			
		]

		index = [	
			"afIoc.module"	: "afBedSheetEfan::EfanModule"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0",

			"afConcurrent 1.0.0+",
			"afIoc 1.6.0+",
			"afIocConfig 1.0.4+", 
			"afPlastic 1.0.10+",
			"afBedSheet 1.3.6+", 
			"afEfan 1.3.8+",
			
			// for testing
			"afBounce 0.0.6+",
			"afButter 0.0.4+",
			"afSizzle 1.0.0+"
		]

		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`licence.txt`, `doc/`]

		docApi = true
		docSrc = true
	}

	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// see "stripTest" in `/etc/build/config.props` to exclude test src & res dirs
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
