<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CommonGood Login</title>
    </head>
    <body>
        <g:if test="${flash.message}">
            <div class="flash">
                ${flash.message}
            </div>
        </g:if>

        <p>Login to CommonGood:</p>
        <form action="<g:createLink action='authenticate'/>" method="post">
            <p>Email address <input type="text" name="emailAddress" value="" /></p>
            <p>Password <input type="text" name="password" value="" /></p>
            <p><input type="submit" value="Login" /></p>
        </form>
    </body>
</html>
