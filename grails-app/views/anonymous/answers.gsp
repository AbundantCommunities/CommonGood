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
    <h1>${question.neighbourhood.name}</h1>
    <h2>${question.text}</h2>

    <div id="CGAnswers"></div>
    <script src="https://app.abundantcommunityinitiative.org/js/cg/commongood-init-1.1.0.js" type="text/javascript" ></script>
    <script>
            CGURL = "https://app.abundantcommunityinitiative.org/";
            CGNeighbourhoodID = "${question.neighbourhood.id}";
            CGQuestionID = "${question.id}";
            CGRequestContext = "question: SOMETHING";
            CGAllowAnswerInquiry = false;
    </script>
    <script src="https://app.abundantcommunityinitiative.org/js/cg/commongood-answerinquiry-1.1.0.js" type="text/javascript" ></script>
    </div>

</body>
</html>
