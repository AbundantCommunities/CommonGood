<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Results</title>
    </head>
    <body>
        <h1>Searched for "${q}"</h1>

        <h2>People</h2>
        <table>
        <g:each in="${people}" var="person">
            <tr>
                <td><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></td>
            </tr>
        </g:each>
        </table>

        <h2>Answers</h2>
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
