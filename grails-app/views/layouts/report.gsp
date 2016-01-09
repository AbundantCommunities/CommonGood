<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><g:layoutTitle default="Grails"/></title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <g:layoutHead/>
    </head>
    <body>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                <img src="${resource(dir:'images',file:'aci-logo.png')}" width="80" height="78"/>
                <div id="welcome-line">Welcome Marie-Danielle <span id="sign-out"><a href="#">sign out</a> | <a href="#">account</a></span></div>
                <div id="role-line">Neighbourhood Connector for Bonnie Doon</div>
                <g:link controller="navigate" action="neighbourhood" id="1"><div id="browse-deselected">Browse</div></g:link>
                <a href="#" onclick="alert('Currently not implemented.');"><div id="find-people-deselected">Find People</div></a>
                <a href="#" onclick="alert('Currently not implemented.');"><div id="find-answers-deselected">Find Answers</div></a>
            </div>
            <g:layoutBody/>
            <div id="footer">
                &copy;2015 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
        </div>
    </body>
</html>