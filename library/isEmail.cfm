<cffunction name="isEmail" output="no" returntype="boolean" hint="I return a boolean indicating whether our not my string argument is a valid email address">
	<cfargument name="string" required="yes" type="string" />
	<cfreturn (reFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$" ,arguments.string) EQ 1) />
</cffunction>