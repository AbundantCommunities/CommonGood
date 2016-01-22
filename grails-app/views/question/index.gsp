<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>

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

            function addAnswers() {
                document.getElementById('bulk-answers-form').submit();
            }

                        // Initialize array to hold ids for possible interviewers.
            var possibleInterviewerIds = [ ];

            window.onload = function onWindowLoad() {
                for (i = 0; i < possibleInterviewerIds.length; i++) {
                    if (possibleInterviewerIds[i][1]) {
                        var interviewerSelect = document.getElementById( "interviewer-select" );
                        interviewerSelect.selectedIndex = i;
                        document.getElementById('initial-interviewer-value').innerHTML = interviewerSelect.value;
                    }
                }

                document.getElementById('interview-date-input').value = currentDate();

                if (${!interviewed}) {
                    document.getElementById('question-column').style.top = "125px";
                    document.getElementById('answer-matrix').style.top = "125px";
                }

                var pagecontainerDiv = document.getElementById('pagecontainer');

                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                document.getElementById('transparent-overlay').style.visibility = 'visible';
            }


        </script>

        <style type="text/css">

            #content-main {
                width:925px;
                height: 820px;
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

            #add-answers-button {
                position: absolute;
                top:10px;
                left:800px;
                height: 22px;
                width: 120px;
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


            #cancel-add-answers-button {
                position: absolute;
                top:10px;
                left:710px;
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




            #top-line {
                position: absolute;
                top:10px;
                left:10px;
            }
            #first-time-notice {
                position: absolute;
                top:35px;
                left:10px;
            }
            #interview-date {
                position: absolute;
                top:60px;
                left:20px;
            }
            #interviewer {
                position: absolute;
                top:90px;
                left:20px;
            }
            #question-column {
                position: absolute;
                top:60px;
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
                top:60px;
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
                <div id="add-answers-button" onclick="addAnswers();">Add Answers</div>
                <g:link controller="navigate" action="family" id="${familyId}"><div id="cancel-add-answers-button">Cancel</div></g:link>
                <div>Enter new answers for family: ${familyName}</div>
                <div <g:if test="${interviewed}">style="display:none;"</g:if>>
                    <div id="first-time-notice">You are entering answers for this family for the first time. Please enter:</div>
                    <div id="interview-date">Initial interview date: <input id="interview-date-input" type="date" name="interviewDate" placeholder="yyyy-MM-dd" value=""/></div>
                    <div id="interviewer">Initial interviewer: 
                        <select id="interviewer-select">
                            <g:each in="${possibleInterviewers}" var="possibleInterviewer">
                                <option value="${possibleInterviewer.fullName}">${possibleInterviewer.fullName}</option>
                                <script type="text/javascript">
                                    possibleInterviewerIds.push(${possibleInterviewer.id});
                                </script>
                            </g:each>
                        </select>
                    </div>
                </div>
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
                    <form id="bulk-answers-form" action=${resource(file:'Answer/saveTable')} method="POST">
                        <g:each in="${questions}" var="question" status="curQuestion">
                            <div class="answer-row">
                                <g:each in="${members}" var="member" status="curFamilyMember">
                                    <div class="answer-cell">
                                        <textarea id="answers-textarea-${curQuestion}${curFamilyMember}" class="answer-textarea" name="${'answer'+member.id+'_'+question.id}"></textarea>
                                    </div>
                                </g:each>
                            </div>
                        </g:each>

                    </form>
                </div>
            </div>
    </body>
</html>




