<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Display a neighbourhood's questions</title>
    </head>
    <body>
        <h1>${neighbourhood}</h1>
        <h2>Select one of these questions:</h2>

        <g:each in="${questions}" var="question">
            <p><a>${}</a>
            <g:link action="answers" id="${question.id}">${question.text}</g:link>
            </p>
        </g:each>

    </body>
</html>
