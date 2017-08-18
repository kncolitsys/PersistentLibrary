<cfcomponent displayname="example" output="no" hint="I dont do anything. I am just an example of a thread-safe persistent cfc">
	
	<cfset variables.instanceData = structNew() />
	<cfset init() />

<!--- -------------------------------------------------------------------------
	CONSTRUCTOR 
-------------------------------------------------------------------------- --->

	<cffunction name="init" access="public" output="no" returntype="example">
		<cfreturn this />
	</cffunction>

<!--- -------------------------------------------------------------------------
	PUBLIC METHODS 
-------------------------------------------------------------------------- --->

	<cffunction name="addItem" access="public" output="no" returntype="void" hint="Add an item to this cfc's instance data">
 		<cfargument name="key" type="string" required="yes" />
 		<cfargument name="value" type="string" required="yes" />
		<!---
			Use an exclusive named lock. The lock name is a combination of the cfc name, the instance structure's name, and the key name. This
			makes the lock very granular (i.e. multiple threads can create items at the same time as long as the key name is different).
		--->
		<cflock name="example_instanceData_#arguments.key#" type="exclusive" timeout="5">
			<cfset structInsert(variables.instanceData, arguments.key, arguments.value, true) />
		</cflock>
	</cffunction>

	<cffunction name="getItem" access="public" output="no" returntype="string" hint="Retrieve an item from this cfc's instance data">
 		<cfargument name="key" type="string" required="yes" />
		<cfset var result = "" />
		<!---
			Use an exclusive named double checked lock (DCL), This is a very common performance optimization for locking code.
			First we do a check to see if the item exists	in the structure (checking for existence is in itself thread-safe). If the item doesnt exist
			we cant get it, so we avoid the expense of creating a lock unless we actually need one. If the item DOES exists then we create a readonly
			lock, but within it we again check for existence. This is needed because another thread could have deleted this item if our thread was
			waiting to aquire a lock. The purpose of the lock is not to avoid corruption - corruption is no longer possible in modern CF servers. The
			lock is there to avoid race conditions.
		--->
		<cfif structKeyExists(variables.instanceData, arguments.key)>
			<cflock name="example_instanceData_#arguments.key#" type="readonly" timeout="5">
				<cfif structKeyExists(variables.instanceData, arguments.key)>
					<cfset result = variables.instanceData[arguments.key]  />
				</cfif>	
			</cflock>
		</cfif>
		<cfreturn result />
	</cffunction>

	<cffunction name="deleteItem" access="public" output="no" returntype="void" hint="Dete an item from this cfc's instance data">
 		<cfargument name="key" type="string" required="yes" />
		<!---
			Again we use a DCL, for the same reasons as the getItem function.
		--->
		<cfif structKeyExists(variables.instanceData, arguments.key)>
			<cflock name="example_instanceData_#arguments.key#" type="exclusive" timeout="5">
				<cfif structKeyExists(variables.instanceData, arguments.key)>
					<cfset structDelete(variables.instanceData, arguments.key, false) />
				</cfif>	
			</cflock>
		</cfif>	
	</cffunction>

</cfcomponent>