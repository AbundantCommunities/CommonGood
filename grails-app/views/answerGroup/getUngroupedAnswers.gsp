<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ungrouped Answers</title>
    </head>
    <body>
        <h1>Ungrouped Answers</h1>
        <h2><a href="<g:createLink action='index'/>">Manage Answer Groups</a></h2>
        <form action="<g:createLink action='getGroupsForAnswers' />" method="POST">
        <button type="submit" value="GROUP">Group</button>
        <table>
            <tr>
                <td></td><td>Answer</td><td>Question</td><td>Person</td>
            </tr>
            <g:each in="${result}" var="permutation">
                <tr>
                    <td><input type="checkbox" name="cga-${permutation.answerId}"/></td>
                    <td>${permutation.permutedText}</td>
                    <td>${permutation.shortQuestion}</td>
                    <td>${permutation.personName}</td>
                </tr>
            </g:each>
        </table>
        </form>
    </body>
</html>
