<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CommonGood Reset Password</title>
</head>

<body>
    <h1>Request a password reset email</h1>

    <g:if test="${flash.message}">
        <p>[${flash.nature}] ${flash.message}</p>
    </g:if>

    <form action="<g:createLink action='sendEmail'/>" method="POST">
        <div>Email address <input type="text" name="emailAddress" /></div>
    </form>

</body>
</html>
