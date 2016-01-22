<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><g:layoutTitle default="Grails"/></title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">
            function doSearch() {
                document.getElementById('search-form').submit();
            }

            function checkEnter(e) {
                var characterCode;

                if(e && e.which) { //if which property of event object is supported (NN4)
                    e = e;
                    characterCode = e.which; //character code is contained in NN4's which property
                }
                else{
                    e = event;
                    characterCode = e.keyCode; //character code is contained in IE's keyCode property
                }

                if(characterCode == 13) { //if generated character code is equal to ascii 13 (if enter key)

                    doSearch(); //submit the form
                    return false;
                }
                else{
                    return true;
                }
            }
        </script>
        <g:layoutHead/>
    </head>
    <body>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                <img src="${resource(dir:'images',file:'aci-logo.png')}" width="80" height="78"/>
                <div id="welcome-line">Welcome ${session.user.firstNames} ${session.user.lastName} <span id="sign-out"><g:link controller="logout">log out</g:link></span></div>
                <div id="role-line">Neighbourhood Connector for ${session.neighbourhood.name}</div>
                <form id="search-form" action="<g:createLink controller='search' />" method="get">
                    <div id="search"><img id="search-image" src="${resource(dir:'images',file:'search.png')}" width="18" height="18"/><input id="search-criteria" type="text" placeholder="search" name="q" value="" style="display:inline;" onKeyPress="checkEnter(event);"/></div>
                </form>
            </div>
            <g:if test="${navContext.size() > 0}">
                <div id="nav-path">
                    <g:each in="${navContext}" var="oneLevel">
                        <span>${oneLevel.level}: <span style="font-weight:bold;"><a href="${resource(dir:'navigate/'+oneLevel.level.toLowerCase(),file:"${oneLevel.id}")}">${oneLevel.description}</a></span></span><span class="nav-path-space"></span>
                    </g:each>
                </div>
            </g:if>
            <g:layoutBody/>
            <div id="footer">
                &copy;2016 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
        </div>
    </body>
</html>