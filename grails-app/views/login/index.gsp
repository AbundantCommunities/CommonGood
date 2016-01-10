<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="session"/>
        <title>Abundant Communities - Edmonton</title>
    </head>
    <body>
            <div id="content-detail">
                <p>Login to CommonGood:</p>
                <form action="<g:createLink action='authenticate'/>" method="post">
                    <p>Email address <input type="text" name="emailAddress" value="" /></p>
                    <p>Password <input type="text" name="password" value="" /></p>
                    <p><input type="submit" value="Login" /></p>
                </form>
                <br/>
                <g:if test="${flash.message}">
                    <div class="flash">
                        ${flash.message}
                    </div>
                </g:if>
            </div>
    </body>
</html>