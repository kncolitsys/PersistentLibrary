<cffunction name="toArray" output="no" returntype="array" hint="I return an array of my arguments">
	<cfset var result = arrayNew(1) />
	<cfset var idx = "" />
	<cfloop from="1" to="#arrayLen(arguments)#" index="idx">
		<cfset result[idx] = duplicate(arguments[idx]) />
	</cfloop>
	<cfreturn result />
</cffunction>