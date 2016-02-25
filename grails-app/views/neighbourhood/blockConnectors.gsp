<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Block Connectors</title>
    </head>
    <body>
        <h1>Block Connectors</h1>
        <g:each in="${connectors}" var="bc">
            <p>
                ${bc.id} ${bc.firstNames} ${bc.lastName}
                ${bc.phone} ${bc.emailAddress} ${bc.address}
                ${bc.blockId} ${bc.blockCode} ${bc.blockDescription}
            </p>
        </g:each>
    </body>
</html>
