<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Permuted ACI Questionnaire Answers</title>
    </head>
    <body>
        <g:each in="${result}" var="permutation">
            ${permutation}<br/>
        </g:each>
    </body>
</html>
