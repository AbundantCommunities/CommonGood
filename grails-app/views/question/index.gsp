<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Enter Interview Answers</title>
    </head>
    <body>
<p>familyId = ${familyId}</p>
<p>familyName = ${familyName}</p>

<p>interviewed = ${interviewed}</p>
<p>interviewDate = ${interviewDate}</p>
<p>possibleInterviewers = ${possibleInterviewers}</p>
<p>participateInInterview = ${participateInInterview}</p>
<p>permissionToContact = ${permissionToContact}</p>

<g:each in="${members}" var="member">
    <p>member.id = ${member.id}</p>
    <p>member.text = ${member.name}</p>
</g:each>

<g:each in="${questions}" var="question">
    <p>question.id = ${question.id}</p>
    <p>question.text = ${question.text}</p>
</g:each>
    </body>
</html>
