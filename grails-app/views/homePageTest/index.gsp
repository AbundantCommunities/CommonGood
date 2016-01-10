<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>Abundant Communities - Edmonton</title>
    </head>
    <body>

            <div id="content-detail">
                <g:if test="${flash.message}">
                    <div class="flash">
                        ${flash.message}
                    </div>
                </g:if>

                <g:if test="${session.user}">
                    <p>Hi ${session.user.firstNames}.</p>
                    <p>You are authorized to access
                        <g:link controller="navigate" action="neighbourhood" id="${session.neighbourhood.id}">
                            ${session.neighbourhood.name}
                        </g:link></p>

                    <p><g:link controller="logout">Logout</g:link></p>
                </g:if>
                <g:else>
                    <p>Hi! This is the CommonGood web application.</p>
                    <p><g:link controller="login">Login</g:link></p>
                </g:else>
            </div>
            
    </body>
</html>
