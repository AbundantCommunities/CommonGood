<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="basic"/>
    <title>Edit Address</title>
</head>

<body>
    <h3>Edit Address</h3>

    <form action="<g:createLink controller='address' action='save' />" method="POST">
        <input type="hidden" name="id" value="${address.id}" />
        <input type="hidden" name="version" value="${address.version}" />
        <label for="text">Address:</label>
        <input type="text" id="text" name="text" value="${address.text}"/><br/>
        <label for="note">Note:</label>
        <textarea id="note" name="note" rows="4" cols="44">${address.note}</textarea><br/>
        <input type="submit" value="Submit"/>
    </form>

</body>
</html>