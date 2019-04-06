<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Anonymous Answers</title>
</head>

<body>
    <h1>${question.neighbourhood.name}</h1>
    <p>
        <g:link action="questions" id="${question.neighbourhood.id}">
        Return to list of questions</g:link>
    </p>
    <br/>

    <h2>${question.text}</h2>
    <br/>
    <p>Sorted from most common answer to least common</p>
    <br/>

    <div id="CGAnswers"></div>
    <script src="https://app.abundantcommunityinitiative.org/js/cg/commongood-init-1.1.0.js" type="text/javascript" ></script>
    <script>
            CGURL = "https://app.abundantcommunityinitiative.org/";
            CGNeighbourhoodID = "${question.neighbourhood.id}";
            CGQuestionID = "${question.id}";
            CGRequestContext = "N/A";
            CGAllowAnswerInquiry = false;
    </script>
    <script src="https://app.abundantcommunityinitiative.org/js/cg/commongood-answerinquiry-1.1.0.js" type="text/javascript" ></script>
    </div>

</body>
</html>
