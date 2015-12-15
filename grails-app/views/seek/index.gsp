<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Testing ACI Search</title>
    </head>
    <body>
        <h1>Testing ACI Search</h1>
        <table>
        <g:each in="${result}" var="hit">
            <tr><td>${hit.answer}</td><td>${hit.person}</td></tr>
        </g:each>
        </table>
    </body>
</html>
