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
        <form action="<g:createLink action='putAnswersInGroup' />" method="POST">
            <button type="submit" value="PUT">Put Into Group</button>
            <input type="text" hidden name="answerIds" value="${result.answerIds}"><br/>
            <g:each in="${result.groups}" var="group">
                <input type="radio" name="groupId" value="${group.id}">${group.name}<br/>
            </g:each>
        </form>
    </body>
</html>
