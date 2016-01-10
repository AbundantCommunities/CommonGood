<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">

            function presentSelectQuestionModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // show overlay and new-container divs and focus to family name
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("select-question-container").style.visibility='visible';
            }

            function dismissSelectQuestionModal() {
                document.getElementById("select-question-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function generateAnswerRankingReport() {
                dismissSelectQuestionModal();

                var selectQuestionSelect = document.getElementById('questionsSelect');
                var selectedQuestion = selectQuestionSelect.selectedIndex;
                var questionId = selectedQuestion + 11;
                var idInputTag = document.getElementById('inputId');
                idInputTag.value = questionId;
                var selectQuestionForm = document.getElementById('select-question-form');
                selectQuestionForm.submit();
            }

        </script>
        <style type="text/css">
            #select-question-container {
                position:absolute;
                top:100px;
                left:300px;
                width:330px;
                height:100px;
                padding:20px;
                padding-top: 10px;
                box-shadow: 0px 0px 20px #000000;
                background-color: #FFFFFF;
                border-radius:10px;
                border-width: 2px;
                border-color: #B48B6A;
                border-style: solid;
                visibility:hidden;
            }
            button#select-question-generatebutton{
                position: absolute;
                left:130px;
                top:90px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
                font-weight: bold;
            }
            button#select-question-cancelbutton{
                position: absolute;
                left:60px;
                top:90px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div>Name: ${navSelection.description}</div>

                <div id="content-actions-left-side">
                    <div class="content-left-action"><g:link controller="blockSummary" action="index" target="_blank">Block Summary</g:link></div>
                    <div class="content-left-action"><g:link controller="blockConnectorSummary" action="index" target="_blank">Block Connector Sumary</g:link></div>
                    <div class="content-left-action"><a href="#" onclick="presentSelectQuestionModal();">Answer Ranking</a></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="select-question-container">
                <p style="font-weight:bold;font-size:14px;">Select Question for Answer Ranking</p>
                <form id="select-question-form" action="<g:createLink controller='answer' action='frequencies'/>" method="get">
                    <input id="inputId" type="hidden" name="id" value="14" />
                    <p>Question: 
                        <select id="questionsSelect">
                            <option value="11">1: Value in neighbourhood</option>
                            <option value="12">2: Make neighbourhood better</option>
                            <option value="13">3: Activities</option>
                            <option value="14">4: Interests</option>
                            <option value="15">5: Skills, gifts, abilities</option>
                            <option value="16">6: Life experiences</option>
                        </select>
                    </p>
                </form>
                <button id="select-question-generatebutton" type="button" onclick="JavaScript:generateAnswerRankingReport();">Generate Report</button>
                <button id="select-question-cancelbutton" type="button" onclick="JavaScript:dismissSelectQuestionModal();">Cancel</button>
            </div>
    </body>
</html>