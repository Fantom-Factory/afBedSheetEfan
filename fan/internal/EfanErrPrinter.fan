using afIoc::Inject
using afPlastic::PlasticCompilationErr
using afPlastic::SrcErrLocation
using afEfan::EfanParserErr
using afEfan::EfanCompilationErr
using afBedSheet::Config
using web::WebOutStream

internal const class EfanErrPrinter {
	
	@Inject	@Config { id="afEfan.srcCodePadding" } 	
	private const Int srcCodePadding
	
	new make(|This|in) { in(this) }
	
	// ---- HTML Printing --------------------------------------------------------------------------
	
	Void printHtml(WebOutStream out, Err? err) {
		while (err != null) {
			if (err is EfanParserErr) 
				printHtmlErr(out, "Efan Parser Err", ((EfanParserErr) err).srcErrLoc)
	
			if (err is EfanCompilationErr) 
				printHtmlErr(out, "Efan Compilation Err", ((EfanCompilationErr) err).srcErrLoc)

			if (err is PlasticCompilationErr) { 
				sel := ((PlasticCompilationErr) err).srcErrLoc
				srcErrLoc := SrcErrLocation(sel.srcLocation, sel.srcCode.join("\n"), sel.errLineNo, sel.errMsg)
				printHtmlErr(out, "Plastic Compilation Err", srcErrLoc)
			}
			
			err = err.cause
		}
	}

	private Void printHtmlErr(WebOutStream out, Str title, SrcErrLocation srcErrLoc) {
		out.h2.w(title).h2End
		
		out.p.w(srcErrLoc.srcLocation).w(" : Line ${srcErrLoc.errLineNo}").br
		out.w("&nbsp;&nbsp;-&nbsp;").writeXml(srcErrLoc.errMsg).pEnd
		
		out.div("class=\"srcLoc\"")
		out.table
		srcErrLoc.srcCodeSnippetMap(srcCodePadding).each |src, line| {
			if (line == srcErrLoc.errLineNo) { out.tr("class=\"errLine\"") } else { out.tr }
			out.td.w(line).tdEnd.td.w(src.toXml).tdEnd
			out.trEnd
		}
		out.tableEnd
		out.divEnd
	}

	
	
	// ---- Str Printing ---------------------------------------------------------------------------

	Void printStr(StrBuf buf, Err? err) {
		while (err != null) {
			if (err is EfanParserErr) 
				printStrErr(buf, "Efan Parser Err", ((EfanParserErr) err).srcErrLoc)
	
			if (err is EfanCompilationErr) 
				printStrErr(buf, "Efan Compilation Err", ((EfanCompilationErr) err).srcErrLoc)

			if (err is PlasticCompilationErr) { 
				sel := ((PlasticCompilationErr) err).srcErrLoc
				srcErrLoc := SrcErrLocation(sel.srcLocation, sel.srcCode.join("\n"), sel.errLineNo, sel.errMsg)
				printStrErr(buf, "Plastic Compilation Err", srcErrLoc)
			}

			err = err.cause
		}
	}	

	private Void printStrErr(StrBuf buf, Str title, SrcErrLocation srcErrLoc) {
		buf.add("\n${title}:\n")
		buf.add(srcErrLoc.srcCodeSnippet(srcCodePadding))		
	}

}
