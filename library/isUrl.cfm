<cffunction name="isUrl" output="no" returntype="boolean" hint="I return a boolean indicating whether our not my string argument is a URL">
	<cfargument name="string" required="yes" type="string" />
	<cfreturn (reFindNoCase("^(((https?:|ftp:|gopher:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$", arguments.string) EQ 1) />
</cffunction>