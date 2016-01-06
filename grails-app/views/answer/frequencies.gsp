<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Frequencies</title>
    </head>
    <body>
        <h1>Answer Frequencies for Question id ${questionId}</h1>
        <table>
        <g:each in="${frequencies}" var="answer">
            <tr><td>${answer[1]}</td><td>${answer[0]}</td></tr>
        </g:each>
        </table>
    </body>
</html>
