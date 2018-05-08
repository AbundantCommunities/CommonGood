<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Answers of a Group</title>
    </head>
    <body>
        <h1>Answers Grouped under "${result.group.name}"</h1>
        <g:each in="${result.answers}" var="answer">
            <a href ="<g:createLink action='removeAnswer' id='${answer.id}'/>">${answer.text}</a><br/>
        </g:each>
    </body>
</html>
