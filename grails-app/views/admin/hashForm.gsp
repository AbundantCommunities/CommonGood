<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create a password hash</title>
    </head>
    <body>
        <h1>Password Hasher</h1>
        <g:form action="hashPassword">
            Email Address
            <input type="text" name="emailAddress"/><br/>
            Password
            <input type="text" name="password"/><br/>
            <g:submitButton name="hash" value="Submit"/>
        </g:form>
    </body>
</html>
