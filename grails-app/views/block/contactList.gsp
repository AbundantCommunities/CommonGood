<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sample title</title>
    </head>
    <body>
<h1>Contact List for Block ${block.code}, ${block.description}</h1>

<g:each in="${connectors}" var="bc">
    <p>BC: ${bc.fullName}, ${bc.phoneNumber}</p>
</g:each>

<g:each in="${families}" var="familyPack">
    <h2>${familyPack.thisFamily.name} Family, ${familyPack.thisFamily.address.text}</h2>
    <table border="1">
        <g:each in="${familyPack.members}" var="person">
            <tr><td>${person.fullName}</td><td>${person.phoneNumber}</td><td>${person.emailAddress}</td><td>${person.birthYear}</td></tr>
        </g:each>
    </table>
</g:each>

    </body>
</html>
