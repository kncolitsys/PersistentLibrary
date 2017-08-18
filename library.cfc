<cfcomponent output="no">
<!---
	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
	Software, and to permit persons to whom the Software is furnished to do so,
	subject to the following conditions:
	 
	The above copyright notice and this permission notice shall be included in all 
	copies or substantial portions of the Software. 
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
--->

	<!--- PRIVATE VARIABLES ------------------------------------------------- --->

	<cfset variables.absPath = getDirectoryFromPath(getCurrentTemplatePath()) />
	<cfset variables.files = "" />
	<cfset variables.path = "" />
	<cfset variables.name = "" />
	<cfset variables.ext = "" />
	<cfset variables.buildTime = now() />

	<!--- PUBLIC METHODS ---------------------------------------------------- --->

	<cffunction name="libraryBuildTime" access="public" output="no" returntype="date" hint="I return the date/time of the last rebuild of the library">
		<cfreturn variables.buildTime />
	</cffunction>
	
	<!--- LINKER ------------------------------------------------------------ --->

	<cfdirectory name="variables.files" action="list" directory="#variables.absPath#library" recurse="yes" filter="*.cf?" />
	<cfloop query="variables.files">
		<!--- Use this template's absolute path to convert the directory path of the item to a relative path for use by cfinclude, and normalize slashes. --->
		<cfset variables.path = replace(right(variables.files.directory, len(variables.files.directory) - len(variables.absPath)), "\", "/", "all") />
		<cfset variables.name = listFirst(files.name, ".") />
		<cfset variables.ext = listLast(files.name, ".") />
		<cfswitch expression="#variables.ext#">
			<cfcase value="cfm">
				<cfinclude template="#variables.path#/#variables.name#.#variables.ext#" />
			</cfcase>
			<cfcase value="cfc">
				<!--- Create component using its filename as the variable name. Convert relative path to CFC path for use with createObject. --->
				<cfset this[variables.name] = createObject("component", replaceNoCase(variables.path, "/", ".") & "." & variables.name) />
				<cftry>
					<!--- Try to include the CFCs init file. If it is missing then ignore the exception. --->
					<cfinclude template="#variables.path#/#variables.name#.init" />
					<cfcatch type="MissingInclude"></cfcatch>
				</cftry>
			</cfcase>
		</cfswitch>
	</cfloop>

</cfcomponent>