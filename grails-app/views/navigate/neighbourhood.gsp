<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">

            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("blockCodeInput").value = "";
                document.getElementById("blockDescriptionInput").value = "";
                document.getElementById("orderWithinNeighbourhoodInput").value = "";


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

            function blockIsValid(code,description,order) {
                if (code == "") {
                    alert("Please enter a code for the new block.");
                    return false;
                } else {
                    if (description == "") {
                        alert("Please enter a block description.");
                        return false;
                    } else {
                        if (!orderOk(order)) {
                            alert("Please enter a valid order. Must be a number.");
                            return false;
                        }
                    }
                }
                return true;
            }

            function saveBlock() {
                var blockCode = document.getElementById('blockCodeInput').value.trim();
                var blockDescription = document.getElementById('blockDescriptionInput').value.trim();
                var order = document.getElementById('orderWithinNeighbourhoodInput').value.trim();
                if (blockIsValid(blockCode,blockDescription,order)) {
                    dismissNewModal();

                    document.getElementById("blockCodeInput").value = blockCode;
                    document.getElementById("blockDescriptionInput").value = blockDescription;
                    document.getElementById("orderWithinNeighbourhoodInput").value = order;

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
                var questionId = selectedQuestion + 11;
                var idInputTag = document.getElementById('inputId');
                idInputTag.value = questionId;
                var selectQuestionForm = document.getElementById('select-question-form');
                selectQuestionForm.submit();
            }

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
                <div id="hood-name-heading">Name: </div>
                <div id="hood-name-value">${navSelection.description}</div>

                <div id="content-actions-left-side">
                    <div class="content-left-action"><g:link controller="blockSummary" action="index">Block Summary</g:link></div>
                    <div class="content-left-action"><g:link controller="blockConnectorSummary" action="index">Block Connector Sumary</g:link></div>
                    <div class="content-left-action"><a href="#" onclick="presentSelectQuestionModal();">Answer Ranking</a></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal();">+ Add New Block</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row" style="color:#CCCCCC;">no blocks</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>


            <div id="new-container">
                <div class="modal-title">New Block</div>
                <form id="new-form" action=${resource(file:'Neighbourhood/addBlock')} method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                    <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                    <div class="modal-row">Order within neighbourhood: <input id="orderWithinNeighbourhoodInput" type="text" name="orderWithinNeighbourhood" value="" /></div>
                </form>
                <div class="button-row">
                    <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div id="new-savebutton" type="button" onclick="JavaScript:saveBlock();">Save</div>
                </div>
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