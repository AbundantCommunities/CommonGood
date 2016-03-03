<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create a password hash</title>
    </head>
    <body>
        <h1>Password Hasher</h1>
        <g:form action="hashPassword">
            <input type="text" name="password">
            <g:submitButton name="hash" value="Hash"/>
        </g:form>
    </body>
</html>
