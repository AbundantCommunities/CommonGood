<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Result (Interview)</title>
    </head>
    <body>
        <h1>Results from Searching Interviews for "${q}"</h1>
        <g:if test="${questionText}">
            <h2>Searched only answers to: ${questionText}</h2>
        </g:if>
        <g:else>
            <h2>Searched all answers</h2>
        </g:else>
        <table>
        <g:each in="${answers}" var="answer">
            <tr>
                <td>${answer[0]}</td>
                <td><g:link controller="navigate" action="familymember" id="${answer[1]}">${answer[2]}</g:link></td>
            </tr>
        </g:each>
        </table>
    </body>
</html>
