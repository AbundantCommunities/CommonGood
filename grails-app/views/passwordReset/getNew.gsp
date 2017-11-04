<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CommonGood Enter new password</title>
</head>

<body>
    <g:if test="${quality.equals('okay')}">
        <g:if test="${flash.message}">
            <p>[${flash.nature}] ${flash.message}</p>
        </g:if>

        <h1>Enter new password</h1>

        <form action="<g:createLink action='reset'/>" method="POST">
            <div>New Password <input type="text" name="password1" /></div>
            <div>Same Again <input type="text" name="password2" /></div>
            <div><input name="submit" type="submit" value="Change" /></div>
        </form>
    </g:if>

    <g:if test="${!quality.equals('okay')}">
        <h1>Oops ${quality}</h1>
    </g:if>
</body>
</html>
