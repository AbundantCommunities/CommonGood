<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="layout" content="anonymous"/>
        <title>Display a neighbourhood's questions</title>
    </head>
    <body>
        <h1>${neighbourhood?.name?:'Invalid neighbourhood id'}</h1>
        <p>We asked neighbours these questions. Select one to see the answers!</p>
        <br/>
        <g:each in="${questions}" var="question">
            <g:link action="answers" id="${question.id}">${question.text}</g:link>
            </p>
        </g:each>

    </body>
</html>
