<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Put Answers into Group</title>
    </head>
    <body>
        <h1>Put Answers into Group</h1>

        <h2>Selected Answers</h2>
        <g:each in="${result.answers}" var="answer">
            ${answer.text}<br/>
        </g:each>

        <h2>Groups</h2>
        <g:each in="${result.groups}" var="group">
            ${group.name}<br/>
        </g:each>
    </body>
</html>
