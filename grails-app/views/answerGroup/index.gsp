<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Answer Group Management</title>
    </head>
    <body>
        <h1>Manage Answer Groups</h1>
        <h2>You have ${ungroupedAnswerCount} ungrouped answer(s)</h2>
        <a href="<g:createLink action='getUngroupedAnswers'/>">See my ungrouped answers</a>
        <h2>Your Groups</h2>
        <g:each in="${groups}" var="group">
            <g:link action="getAnswers" id="${group.id}">${group.name}</g:link><br/>
        </g:each>
    </body>
</html>
