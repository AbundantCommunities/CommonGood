<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><g:layoutTitle default="Grails"/></title>
        <meta name="description" content="Abundant Community Initiative CommonGood" />
        <asset:link rel="icon" href="favicon.ico" type="image/x-icon"/>
        <asset:stylesheet src="common.css"/>
        <asset:javascript src="decoder.js"/>
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

            function doReorder(thisId,afterId) {

                document.getElementById('reorder-this-id').value = thisId;
                document.getElementById('reorder-after-id').value = afterId;
                document.getElementById('reorder-form').submit();

            }


        </script>
        <style type="text/css">

            .sortable-ghost {
                opacity: .2;
            }


            .drag-handle {
                font: bold 10px Sans-Serif;
                color: #B48B6A;
                display: inline-block;
                cursor: move;
                cursor: -webkit-grabbing;  /* overrides 'move' */
            }

        </style>
        <g:layoutHead/>
    </head>
    <body>
        <g:if test="${flash.message}">

            <g:if test="${flash.nature=='SUCCESS'}">
                <g:set var="natureClass" value="flashsuccess" scope="request" />
            </g:if>
            <g:elseif test="${flash.nature=='WARNING'}">
                <g:set var="natureClass" value="flashwarning" scope="request" />
            </g:elseif>
            <g:elseif test="${flash.nature=='FAILURE'}">
                <g:set var="natureClass" value="flashfailure" scope="request" />
            </g:elseif>

            <div class="flashcontainer ${natureClass}">
                <div class="flashcontent">
                    <div>${flash.message}</div>
                </div>
            </div>
        </g:if>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                <asset:image src="aci-logo.png" width="80" height="78"/>
                <div id="welcome-line">Welcome ${session.user.firstNames} ${session.user.lastName} <span id="sign-out"><g:link controller="logout">log out</g:link></span></div>
                <div id="advanced-search"><g:link controller="search" action="form">advanced search</g:link></div>
                <form id="search-form" action="<g:createLink controller='search' />" method="get">
                    <div id="search">
                        <asset:image id="search-image" src="search.png" width="18" height="18"/>
                        <input id="search-criteria" type="text" placeholder="search" name="q" value="" onKeyPress="checkEnter(event);"/>
                        <input type="hidden" name="contactInfo" value="yes"/>
                    </div>
                </form>
            </div>
            <g:if test="${navContext.size() > 0}">
                <div class="content-section">
                    <g:each in="${navContext}" var="oneLevel">
                        <span>${oneLevel.level}: <span class="bold"><g:link controller="navigate" action="${oneLevel.level.toLowerCase()}" id="${oneLevel.id}">${oneLevel.description}</g:link></span></span><span class="nav-path-space"></span>
                    </g:each>
                </div>
            </g:if>
            <g:layoutBody/>
            <div id="footer">
                &copy;<script type="text/javascript">document.write(new Date().getFullYear());</script> The Abundant Community Initiative Canada.
                CommonGood Version <g:meta name="app.version"/>
            </div>
        </div>
        <asset:javascript src="Sortable.js"/>
        <asset:javascript src="app.js"/>
    </body>
</html>