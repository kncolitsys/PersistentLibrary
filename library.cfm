<cfsilent>
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

	<!--- Only execute on tag start --->
	<cfif thistag.executionmode EQ "start">

		<!--- The name used to reference the library in the chosen scope. --->
		<cfparam name="attributes.name" type="string" default="lib" />
		<!--- The name of the persistant scope to create the library in. (server, application, or session)  --->
		<cfparam name="attributes.scope" type="string" default="server" />
		<!--- The name of the caller variable used to reference the library. No caller reference is created when blank. --->
		<cfparam name="attributes.variable" type="string" default="" />
		<!--- The path to the library.cfc file (dot delimited). The path can either be relative to this files location, or an absolute path using a CF mapping. --->
		<cfparam name="attributes.cfcpath" type="string" default="cfcs.cflibrary.library" />
		<!--- Flag to force a rebuild of the library. --->
		<cfparam name="attributes.rebuild" type="boolean" default="false" />

		<!--- Initialize the library is it isn't already inited or if a rebuild was requested. Use DCL to synchronize (double-check lock) --->
		<cfif NOT(isDefined(attributes.scope & "." & attributes.name)) OR attributes.rebuild>
			<cflock scope="#attributes.scope#" type="exclusive" timeout="30">
				<cfif NOT(isDefined(attributes.scope & "." & attributes.name)) OR attributes.rebuild>
					<cfset "#attributes.scope#.#attributes.name#" = CreateObject("component", attributes.cfcpath) />
				</cfif>
			</cflock>
		</cfif>

		<!--- If the library is inited and a caller variable reference was requested then create a reference to the library in the callers scope. --->
		<cfif len(attributes.variable) AND isDefined(attributes.scope & "." & attributes.name)>
			<cfset caller[attributes.variable] = evaluate(attributes.scope & "." & attributes.name) />
		</cfif>

	</cfif>

</cfsilent>