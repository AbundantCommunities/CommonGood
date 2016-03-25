<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood Neighbourhood</title>
        <script type="text/javascript">

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function presentNewModal() {
                    var pagecontainerDiv = document.getElementById("pagecontainer");

                    // clear UI before presenting
                    document.getElementById("blockCodeInput").value = "";
                    document.getElementById("blockDescriptionInput").value = "";


                    // set height of overlay to match height of pagecontainer height
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                    
                    // show overlay and new-container divs and focus to family name
                    document.getElementById("transparent-overlay").style.visibility='visible';
                    document.getElementById("new-container").style.visibility='visible';
                    document.getElementById("blockCodeInput").focus();
                }

                function dismissNewModal() {
                    document.getElementById("new-container").style.visibility='hidden';
                    document.getElementById("transparent-overlay").style.visibility='hidden';
                }

                

                function orderOk(order) {
                    if (order.length == 0) {
                        return false;
                    } else {
                        for (i=0; i<order.length; i++) {
                            if ('0123456789'.indexOf(order.substr(i,1)) < 0) {
                                return false;
                            }
                        }
                    }
                    return true;
                }

                function blockIsValid(code,description) {
                    if (code == "") {
                        alert("Please enter a code for the new block.");
                        return false;
                    } else {
                        if (description == "") {
                            alert("Please enter a block description.");
                            return false;
                        }
                    }
                    return true;
                }

                function saveBlock() {
                    var blockCode = document.getElementById('blockCodeInput').value.trim();
                    var blockDescription = document.getElementById('blockDescriptionInput').value.trim();
                    if (blockIsValid(blockCode,blockDescription)) {
                        dismissNewModal();

                        document.getElementById("blockCodeInput").value = blockCode;
                        document.getElementById("blockDescriptionInput").value = blockDescription;

                        document.getElementById('new-form').submit();
                    }
                }




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
                    var questionId = selectQuestionSelect.options[selectedQuestion].value;
                    var idInputTag = document.getElementById('inputId');
                    idInputTag.value = questionId;
                    var selectQuestionForm = document.getElementById('select-question-form');
                    selectQuestionForm.submit();
                }

            </g:if>

        </script>
        <style type="text/css">
            #hood-name-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #hood-name-value {
                position: absolute;
                top:30px;
                left: 60px;
            }

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                #new-container {
                    position:absolute;
                    top:90px;
                    left:280px;
                    width:370px;
                    padding:20px;
                    padding-top: 10px;
                    background-color: #FFFFFF;
                    border-radius:10px;
                    visibility:hidden;

                }
                #new-cancelbutton{
                    display: inline-block;
                    height: 22px;
                    width: 80px;
                    cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                    color:#B48B6A;
                    padding-top: 4px;
                    text-align: center;
                    border-radius: 5px;
                    border-width:thin;
                    border-style:solid;
                    border-color: #B48B6A;
                    background-color:#FFFFFF;
                }
                #new-savebutton{
                    display: inline-block;
                    height: 22px;
                    width: 80px;
                    margin-left: 10px;
                    cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                    color:#B48B6A;
                    padding-top: 4px;
                    text-align: center;
                    border-radius: 5px;
                    border-width:thin;
                    border-style:solid;
                    border-color: #B48B6A;
                    background-color:#FFFFFF;
                    font-weight: bold;
                }
                .modal-title {
                    margin-top: 10px;
                    font-weight:bold;
                    font-size:14px;
                }
                .button-row {
                    margin-top: 20px;
                    margin-left: 0px;
                    width: 100%;
                }
                
                .modal-row {
                    margin-top: 10px;
                }


                #select-question-container {
                    position:absolute;
                    top:100px;
                    left:300px;
                    width:330px;
                    height:100px;
                    padding:20px;
                    padding-top: 10px;
                    background-color: #FFFFFF;
                    border-radius:10px;
                    visibility:hidden;
                }
                #select-question-cancelbutton {
                    display: inline-block;
                    height: 22px;
                    width: 80px;
                    cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                    color:#B48B6A;
                    padding-top: 4px;
                    text-align: center;
                    border-radius: 5px;
                    border-width:thin;
                    border-style:solid;
                    border-color: #B48B6A;
                    background-color:#FFFFFF;
                }
                #select-question-generatebutton {
                    display: inline-block;
                    height: 22px;
                    width: 160px;
                    margin-left: 10px;
                    cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                    color:#B48B6A;
                    padding-top: 4px;
                    text-align: center;
                    border-radius: 5px;
                    border-width:thin;
                    border-style:solid;
                    border-color: #B48B6A;
                    background-color:#FFFFFF;
                    font-weight: bold;
                }

            </g:if>

        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div id="hood-name-heading">Name: </div>
                <div id="hood-name-value">${navSelection.description}</div>

                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                    <div id="content-actions-left-side">
                        <div class="content-left-action"><g:link controller="blockSummary" action="index">Block Summary</g:link></div>
                        <div class="content-left-action"><g:link controller="neighbourhood" action="blockConnectors">Block Connector Contact List</g:link></div>
                        <div class="content-left-action"><a href="#" onclick="presentSelectQuestionModal();">Answer Ranking</a></div>
                    </div>

                    <div id="content-actions">
                        <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Edit</a></div>
                        <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Delete</a></div>
                        <div class="content-action">&nbsp;</div>
                    </div>
                </g:if>
            </div>
            <div id="content-children">
                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                    <div class="content-heading">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal();" style="font-weight:normal;">+ Add New Block</a></div>
                </g:if>
                <g:elseif test="${authorized.forBlock()==Boolean.TRUE}">
                    <div class="content-heading">Your ${navChildren.childType}<g:if test="${navChildren.children.size() > 1}">s</g:if></div>
                </g:elseif>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row">
                            <g:link controller="Navigate" action="${navChildren.childType.toLowerCase()}" id="${child.id}">(${child.code}) ${child.description}</g:link>:
                            <g:if test="${child.connectors.size()>0}">
                                <g:each in="${child.connectors}" var="bc" status="i">
                                    <g:if test="${i>0}">, </g:if>
                                     <g:link controller="Navigate" action="familymember" id="${bc.id}">${bc.firstNames} ${bc.lastName}</g:link>
                                </g:each>
                            </g:if>
                            <g:else>
                                 <span style="color:#CCCCCC;">no block connector</span>
                            </g:else>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row" style="color:#CCCCCC;">no blocks</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>


            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                <div id="new-container">
                    <div class="modal-title">New Block</div>
                    <form id="new-form" action="<g:createLink controller='Neighbourhood' action='addBlock' />" method="POST">
                        <input type="hidden" name="id" value="${navSelection.id}" />
                        <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                        <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                    </form>
                    <div class="button-row">
                        <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                        <div id="new-savebutton" type="button" onclick="JavaScript:saveBlock();">Save</div>
                    </div>
                </div>


                <div id="select-question-container">
                    <div class="modal-title">Select Question for Answer Ranking</div>
                    <form id="select-question-form" action="<g:createLink controller='answer' action='frequencies'/>" method="get">
                        <input id="inputId" type="hidden" name="id" value="${navSelection.questions?navSelection.questions[0].id:''}" />
                        <div class="modal-row">Question: 
                            <select id="questionsSelect">
                                <g:each in="${navSelection.questions}" var="question">
                                    <option value="${question.id}">${question.code}: ${question.shortText}</option>
                                </g:each>
                            </select>
                        </div>
                    </form>
                    <div class="button-row">
                        <div id="select-question-cancelbutton" onclick="JavaScript:dismissSelectQuestionModal();">Cancel</div>
                        <div id="select-question-generatebutton" onclick="JavaScript:generateAnswerRankingReport();">Generate Report</div>
                    </div>
                </div>
            </g:if>
    </body>
</html>