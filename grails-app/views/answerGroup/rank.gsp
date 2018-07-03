<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    
<head>
    <meta name="layout" content="basic">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Answer Group Ranking</title>
</head>

<body>
    <br/>
    <g:link action="index">Back</g:link><br/>
    <br/>
    Found ${groups.size()} groups (including any ungrouped answers)<br/>
    <br/>
    <table>
        <g:each in="${groups}" var="group">
            <tr>
                <td>${group.name}</td><td>${group.count}</td>
            </tr>
        </g:each>
    </table>
</body>

</html>
