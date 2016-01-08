class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

//      "/"( view: "/index" )
        "/"( controller:"HomePageTest" )
        "500"(view:'/error')
	}
}
