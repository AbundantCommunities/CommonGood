<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CommonGood Enter new password</title>
</head>

<body>
    <g:if test="${!reset}">
        <h1>Bad token</h1>
    </g:if>
    <g:if test="${reset}">
        <h1>Enter new password</h1>
    </g:if>
</body>
</html>
