<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">
            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("familyNameInput").focus();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }
            function saveFamily() {
                dismissEditModal();
                var editForm = document.getElementById('edit-form');
                var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                var interviewerId = possibleInterviewerIds[possibleInterviewerSelect.selectedIndex][0];
                document.getElementById('interviewerId').value = interviewerId;
                editForm.submit();
            }
            function presentBulkAnswersModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("bulk-answers-container").style.visibility='visible';
                //document.getElementById("familyNameInput").focus();
            }
            function dismissBulkAnswersModal() {
                document.getElementById("bulk-answers-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }
            function addBulkAnswers() {
                dismissBulkAnswersModal();
                document.getElementById('bulk-answers-form').submit();
            }

            // Initialize array to hold ids for possible interviewers.
            var possibleInterviewerIds = [ ];

            window.onload = function onWindowLoad() {
                for (i = 0; i < possibleInterviewerIds.length; i++) {
                    if (possibleInterviewerIds[i][1]) {
                        var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                        possibleInterviewerSelect.selectedIndex = i;
                        document.getElementById('initialInterviewerDiv').innerHTML = "Initial interviewer: "+possibleInterviewerSelect.value;
                    }
                }
            }

        </script>
        <style type="text/css">
            #edit-container {
                position:absolute;;
                top:100px;
                left:300px;
                width:330px;
                height:360px;
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
            button#edit-savebutton{
                position: absolute;
                left:180px;
                top:350px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
                font-weight: bold;
            }
            button#edit-cancelbutton{
                position: absolute;
                left:80px;
                top:350px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
            }
            #bulk-answers-container {
                position:absolute;;
                top:50px;
                left:${(929/2) - ((290+navChildren.children.size()*180) / 2)}px;
                width:${290+navChildren.children.size()*180}px;
                height:${50+(navSelection.questions.size()*80)}px;
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
            button#bulk-answers-savebutton {
                position: absolute;
                left:${((290+navChildren.children.size()*180)/2) + 20}px;
                top:${36+(navSelection.questions.size()*80)}px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
                font-weight: bold;
            }
            button#bulk-answers-cancelbutton {
                position: absolute;
                left:${((290+navChildren.children.size()*180)/2) - 80}px;
                top:${36+(navSelection.questions.size()*80)}px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
            }
            .heading-row {
                height:25px;
            }
            .answer-row {
                height:80px;
            }
            .question-column {
                display: inline-block;
                width: 260px;
                vertical-align:top;
            }
            .answer-column {
                display: inline-block;
                width: 180px;
            }
        </style>




    </head>
    <body>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                <img src="${resource(dir:'images',file:'aci-logo.png')}" />
                <div id="welcome-line">Welcome Marie-Danielle <span id="sign-out"><a href="#">sign out</a> | <a href="#">account</a></span></div>
                <div id="role-line">Neighbourhood Connector for Bonnie Doon</div>
            </div>
            <g:if test="${navContext.size() > 0}">
                <div id="nav-path">
                    <g:each in="${navContext}" var="oneLevel">
                        <span>${oneLevel.level}: <span style="font-weight:bold;"><a href="${resource(dir:'navigate/'+oneLevel.level.toLowerCase(),file:"${oneLevel.id}")}">${oneLevel.description}</a></span></span><span class="nav-path-space"></span>
                    </g:each>
                </div>
            </g:if>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div class="content-detail-value">Name: ${navSelection.description}</div>
                <div class="content-detail-value">Initial interview date: <g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/></div>
                <div id="initialInterviewerDiv" class="content-detail-value">Initial interviewer: </div>
                <div class="content-detail-value">
                    <g:if test="${navSelection.permissionToContact}">
                        Permission to contact: Yes
                    </g:if>
                    <g:else>
                        Permission to contact: No
                    </g:else>
                </div>
                <div class="content-detail-value">
                    <g:if test="${navSelection.participateInInterview}">
                        Agreed to participate in interview: Yes
                    </g:if>
                    <g:else>
                        Agreed to participate in interview: No
                    </g:else>
                </div>
                <div class="content-detail-value">Order within address: ${navSelection.orderWithinAddress}</div>
                <div class="content-detail-value">Note: ${navSelection.note}</div>
                <br/>




                <div id="content-actions-left-side">
                    <div class="content-left-action"><a href="#" onclick="presentBulkAnswersModal();">Add Interview Answers</a></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
            <div id="footer">
                &copy;2015 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container">
                <p style="font-weight:bold;font-size:14px;">Edit Family</p>
                <form id="edit-form" action=${resource(file:'Family/save')} method="post">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <p>Family name: <input id="familyNameInput" type="text" name="familyName" value="${navSelection.description}"/></p>
                    <p>Initial interview date: <input type="date" name="initialInterviewDate" placeholder="yyyy-MM-dd" value="<g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/>"/></p>
                    <p>Initial interviewer: 
                        <select id="possibleInterviewerSelect">
                            <g:each in="${navSelection.possibleInterviewers}" var="possibleInterviewer">
                                <option value="${possibleInterviewer.fullName}">${possibleInterviewer.fullName}</option>
                                <script type="text/javascript">
                                    <g:if test="${possibleInterviewer.default == 'true'}">
                                        possibleInterviewerIds.push([${possibleInterviewer.id}, true]);
                                    </g:if>
                                    <g:else>
                                        possibleInterviewerIds.push([${possibleInterviewer.id}, false]);
                                    </g:else>
                                </script>
                            </g:each>
                        </select>
                    </p>
                    <input id="interviewerId" type="hidden" name="interviewerId" value="" />
                    <g:if test="${navSelection.permissionToContact}">
                        <p><input type="checkbox" name="permissionToContact" value="true" checked /> Permission to contact</p>
                    </g:if>
                    <g:else>
                        <p><input type="checkbox" name="permissionToContact" value="false" /> Permission to contact</p>
                    </g:else>
                    <g:if test="${navSelection.participateInInterview}">
                        <p><input type="checkbox" name="participateInInterview" value="true" checked /> Agreed to participate in interview</p>
                    </g:if>
                    <g:else>
                        <p><input type="checkbox" name="participateInInterview" value="false" /> Agreed to participate in interview</p>
                    </g:else>
                    <p>Order within address: <input type="text" name="orderWithinAddress" value="${navSelection.orderWithinAddress}" /></p>
                    <p>Note:</p>
                    <p><textarea name="note" cols=44 rows=4>${navSelection.note}</textarea></p>
                </form>
                <button id="edit-savebutton" type="button" onclick="JavaScript:saveFamily();">Save</button>
                <button id="edit-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</button>
            </div>
            <div id="bulk-answers-container">
                <div class="heading-row">
                    <div class="question-column">Question</div>
                    <g:each in="${navChildren.children}" var="child">
                        <div class="answer-column">${child.name}</div>
                    </g:each>
                </div>
                <form id="bulk-answers-form" action=${resource(file:'Answer/saveTable')} method="post">
                    <g:each in="${navSelection.questions}" var="question">
                        <div class="answer-row">
                            <div class="question-column">${question.text}</div>
                            <g:each in="${navChildren.children}" var="child">
                                <div class="answer-column"><textarea name="${'answer'+child.id+'_'+question.id}" cols=22 rows=4></textarea></div>
                            </g:each>
                        </div>
                    </g:each>
                </form>
                <button id="bulk-answers-cancelbutton" type="button" onclick="JavaScript:dismissBulkAnswersModal();">Cancel</button>
                <button id="bulk-answers-savebutton" type="button" onclick="JavaScript:addBulkAnswers();">Add Answers</button>
            </div>
        </div>
    </body>
</html>