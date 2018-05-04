<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Answers of a Group</title>
    </head>
    <body>
        <h1>Answers Grouped under "${result.group.name}"</h1>
        <g:each in="${result.answers}" var="answer">
            ${answer.text}<br/>
        </g:each>
    </body>
</html>
