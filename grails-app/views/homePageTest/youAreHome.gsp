<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CommonGood Test Home Page</title>
    </head>
    <body>
        <g:if test="${flash.message}">
            <div class="flash">
                ${flash.message}
            </div>
        </g:if>

        <g:if test="${session.user}">
            <p>Hi ${session.user.firstNames}.</p>
            <p>You have authorization to access ${session.neighbourhood.name}</p>
            <p><g:link controller="navigate" action="neighbourhood" id="${session.neighbourhood.id}">Let's go!</g:link></p>
            <p><g:link controller="logout">Logout</g:link></p>
        </g:if>
        <g:else>
            <p>Hi! This is the CommonGood application.</p>
            <p><g:link controller="login">Login</g:link></p>
        </g:else>
    </body>
</html>
