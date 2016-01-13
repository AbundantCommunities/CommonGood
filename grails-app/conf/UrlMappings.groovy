class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

//      "/"( view: "/index" )
        "/"( controller:"login" )
        "500"(view:'/error')
	}
}
