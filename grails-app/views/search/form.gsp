<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CommonGood Search Form</title>
    </head>
    <body>
        <h1>Advanced Search</h1>
        <p>${authorized}</p>
        <p>All fields are optional, but you must enter something to at least one field</p>
        <form action="advanced">
            Text <input type="text" name="q"> (we search for the exact word or phrase)<br/>
            <br/>
            Birth Year range (you can enter either or both From and To<br/>
            From <input type="text" name="fromBirthYear"> (search will include people born in this year)<br/>
            To <input type="text" name="toBirthYear"> (ditto)<br/>
            <br/>
            <input type="submit" value="Search">
        </form>
    </body>
</html>
