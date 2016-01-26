<!DOCTYPE html>
<html>
    <head>
        <title><g:if env="development">Grails Runtime Exception</g:if><g:else>CommonGood Apologizes</g:else></title>
        <meta name="layout" content="main">
        <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
    </head>
    <body>
        <g:if env="development">
            <g:renderException exception="${exception}" />
        </g:if>
        <g:else>
            <p>
                We apologize. A programming error has occurred.
                We've recorded the error for later analysis.
            </p>
            <p>
                To resume work your work, use your browser's back button or
                <g:link controller="navigate" action="${session.lastNavigationLevel}" id="${session.lastNavigationId}">click here</g:link>.
            </p>
        </g:else>
    </body>
</html>
