<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>CommonGood Question</title>

        <script type="text/javascript">

            function currentDate() {
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth()+1; //January is 0!
                var yyyy = today.getFullYear();

                if(dd<10) {
                    dd='0'+dd
                } 

                if(mm<10) {
                    mm='0'+mm
                } 

                today = yyyy+'-'+mm+'-'+dd;

                return today;

            }


            function dateOk(date) {
                var pattern = /^$|^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;
                return pattern.test(date);
            }

            function interviewDataOkay(initialInterviewDate) {
                if (!dateOk(initialInterviewDate)) {
                    alert('Please enter a value for initial interview date in the format YYYY-MM-DD.');
                    return false;
                }
                return true;
            }


            function saveInterviewData() {
                if (interviewDataOkay(document.getElementById('interview-date-input').value)) {
                    var selectedInterviewerIndex = document.getElementById('interviewer-select').selectedIndex;
                    var interviewerId = possibleInterviewers[selectedInterviewerIndex][0];
                    document.getElementById('interviewer-id-input').value = interviewerId;
                    document.getElementById('interview-data-form').submit();
                }
            }

                        // Initialize array to hold ids for possible interviewers.
            var possibleInterviewers = [ ];

            window.onload = function onWindowLoad() {

                document.getElementById('permission-checkbox-input').checked = ${permissionToContact};
                document.getElementById('participate-checkbox-input').checked = ${participateInInterview};

                var interviewDate;

                <g:if test="${interviewed}">
                    interviewDate = "${interviewDate.format('yyyy-MM-dd')}";
                </g:if>

                if (${interviewed}) {
                    for (i = 0; i < possibleInterviewers.length; i++) {
                        if (possibleInterviewers[i][1]) {
                            document.getElementById( "interviewer-select" ).selectedIndex = i;
                        }
                    }
                    document.getElementById('interview-date-input').value = interviewDate;
                } else {
                    document.getElementById('interview-date-input').value = currentDate();
                }


                var numQuestions = ${questions.size()};
                var contentHeight = 230 + numQuestions * 110;

                document.getElementById('content-main').setAttribute("style","height:"+contentHeight+"px;");


                var pagecontainerDiv = document.getElementById('pagecontainer');

                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                document.getElementById('transparent-overlay').style.visibility = 'visible';

            }


        </script>

        <style type="text/css">

            #content-main {
                width:925px;
                height: 885px;
                margin-left:14px;
                margin-bottom: 10px;
                padding-left:10px;
                padding-top:7px;
                position:relative;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }

            #save-button {
                position: absolute;
                top:10px;
                left:840px;
                height: 22px;
                width: 80px;
                font-weight: bold;
                color: #B48B6A;
                padding-top: 4px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                cursor: pointer;
            }


            #cancel-button {
                position: absolute;
                top:10px;
                left:750px;
                height: 22px;
                width: 80px;
                color: #B48B6A;
                padding-top: 4px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }

            .heading-row {
                font-size: 110%;
                font-weight: bold;
            }

            #interview-data-div {
                position: relative;
                height: 90px;
                width: 700px;
            }

            #permission-div {
                position: absolute;
                top:15px;
                left:10px;
            }

            #participate-div {
                position: absolute;
                top:42px;
                left:10px;
            }

            #interview-date-div {
                position: absolute;
                top:10px;
                left:320px;
            }
            #interviewer-div {
                position: absolute;
                top:42px;
                left:320px;
            }

            .interview-data-item {
                margin-top: 10px;
                margin-left: 10px;
                height: 20px;
            }

            #matrix-container {
                position: relative;
                margin-top: 10px;
            }


            #question-column {
                position: absolute;
                top:0px;
                left:10px;
                width: 260px;
            }
            .question-heading {
                height: 25px;
            }
            .question-cell {
                height:110px;
                vertical-align:top;
            }

            #answer-matrix {
                position: absolute;
                top:0px;
                left:280px;
                width:640px;
                white-space: nowrap;
                overflow: scroll;
            }

            .answer-heading-row {
                height: 25px;
                position: relative;
            }

            .answer-heading {
                height: 25px;
                width: 180px;
                display: inline-block;
                position: relative;
            }
            .answer-row {
                height: 110px;
                position: relative;
            }
            .answer-cell {
                border: thin;
                border-style: solid;
                border-color: #777777;
                width: 180px;
                height: 95%;
                margin-bottom: 0px;
                position: relative;
                display: inline-block;
            }
            .answer-textarea {
                border: none;
                position: absolute;
                top:0px;
                left:0px;
                width: 97%;
                height: 97%;
            }
        </style>




    </head>
    <body>
            <div id="transparent-overlay"></div>
            <div id="content-main">
                <div id="save-button" onclick="saveInterviewData();">Save</div>
                <g:link controller="navigate" action="family" id="${familyId}"><div id="cancel-button">Cancel</div></g:link>
                <form id="interview-data-form" action=${resource(file:'Answer/saveInterview')} method="POST">
                    <input id="family-id-input" type="hidden" name="familyId" value="${familyId}"/>
                    <input id="interviewer-id-input" type="hidden" name="interviewerId"/>
                    <div class="heading-row">Enter interview data for family: ${familyName}</div>
                    <div id="interview-data-div">
                        <div id="permission-div"><input id="permission-checkbox-input" name="permissionToContact" type="checkbox"/> Permission to contact</div>
                        <div id="participate-div"><input id="participate-checkbox-input" name="participateInInterview" type="checkbox"/> Agreed to participate in interview</div>
                        <div id="interview-date-div">Initial interview date: <input id="interview-date-input" type="date" name="interviewDate" placeholder="YYYY-MM-DD" value=""/></div>
                        <div id="interviewer-div">Initial interviewer: 
                            <select id="interviewer-select">
                                <g:each in="${possibleInterviewers}" var="possibleInterviewer">
                                    <option value="${possibleInterviewer.fullName}">${possibleInterviewer.fullName}</option>
                                    <script type="text/javascript">
                                        possibleInterviewers.push([${possibleInterviewer.id}, ${possibleInterviewer.default}]);
                                    </script>
                                </g:each>
                            </select>
                        </div>
                    </div>
                    <g:if test="${members.size() > 0}">
                        <div class="heading-row">Add new interview answers*</div>
                        <div class="footnote">* To add multiple answers for one question, press Return after each.</div>
                        <div class="footnote">* To set 'would assist', or to edit or delete answers you add here, browse to the family member afterwards and click the answer.</div>
                        <div id="matrix-container">
                            <div id="question-column">
                                <div class="question-heading">Question</div>
                                <g:each in="${questions}" var="question">
                                    <div class="question-cell">${question.text}</div>
                                </g:each>
                            </div>
                            <div id="answer-matrix">
                                <div class="answer-heading-row">
                                    <g:each in="${members}" var="member">
                                        <div class="answer-heading">${member.name}</div>
                                    </g:each>
                                </div>
                                <g:each in="${questions}" var="question" status="curQuestion">
                                    <div class="answer-row">
                                        <g:each in="${members}" var="member" status="curFamilyMember">
                                            <div class="answer-cell">
                                                <textarea id="answers-textarea-${curQuestion}${curFamilyMember}" class="answer-textarea" name="${'answer'+member.id+'_'+question.id}"></textarea>
                                            </div>
                                        </g:each>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                    </g:if>
                </form>
            </div>
    </body>
</html>




