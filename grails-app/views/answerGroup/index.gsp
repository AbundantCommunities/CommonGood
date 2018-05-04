<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Answer Groups</title>
    </head>
    <body>
        <h1>Answer Groups</h1>
        <g:each in="${result}" var="group">
            <g:link action="getAnswers" id="${group.id}">${group.name}</g:link><br/>
        </g:each>
    </body>
</html>
