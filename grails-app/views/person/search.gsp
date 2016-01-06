<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Result (People)</title>
    </head>
    <body>
        <h1>Results from Searching People for "${q}"</h1>
        <table>
        <g:each in="${results}" var="person">
            <tr>
                <td><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></td>
            </tr>
        </g:each>
        </table>
    </body>
</html>
