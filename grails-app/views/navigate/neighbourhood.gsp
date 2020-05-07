<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood Neighbourhood</title>

        <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
        <asset:stylesheet src="leaflet/leaflet.css"/>
        <asset:javascript src="leaflet/leaflet.js"/>
        <style type="text/css">
            #mapid { height: 400px; }
        </style>
        </g:if>


        <script type="text/javascript">

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                <g:if test="${authorized.canWrite()==Boolean.TRUE}">

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

                
                function blockIsValid(code,description) {
                    if (code == "") {
                        alert("Please enter a code for the new block.");
                        return false;
                    }
                    if (code.length > 255) {
                        alert("The block code cannot exceed 255 characters in length.");
                        return false;
                    }
                    if (description.length > 255) {
                        alert("The block description cannot exceed 255 characters in length.");
                        return false;
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
                </g:if>

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

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}">

                #new-container {
                    top:90px;
                    left:280px;
                    width:370px;
                }

            </g:if>

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                #select-question-container {
                    top:100px;
                    left:300px;
                    width:330px;
                }

            </g:if>

        </style>

    </head>
    <body>
            <div class="content-section" style="height:115px;">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>
                <div class="content-row">
                    <div class="content-row-item" style="width:55px;">Name: </div><div class="content-row-item">${navSelection.description}</div>
                </div>

                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                    <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                    <div id="content-actions-left-side">
                        <div class="content-left-action"><g:link controller="anonymousRequest" action="inbox">Connect Me Inbox (${anonymousRequests})</g:link></div>
                        <div class="content-left-action"><g:link controller="blockSummary" action="index">Block Summary</g:link></div>
                        <div class="content-left-action"><g:link controller="neighbourhood" action="blockConnectors">Block Connector Contact List</g:link></div>
                        <div class="content-left-action"><a href="#" onclick="presentSelectQuestionModal();">Answer Ranking</a></div>
                        <g:if test="${session.neighbourhood.featureFlags.contains('groups')==Boolean.TRUE}">
                            <div class="content-left-action"><g:link controller="answerGroup">Manage Answer Groups</g:link></div>
                        </g:if>
                    </div>

                    <div id="content-actions">
                        <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Edit</a></div>
                    </div>
                    </g:if>
                    <g:else>
                    <div id="content-actions" style="left:710px;">
                        <div class="content-left-action"><g:link controller="anonymousRequest" action="inbox">Public Inbox (${anonymousRequests})</g:link></div>
                        <div class="content-left-action"><g:link controller="blockSummary" action="index">Block Summary</g:link></div>
                        <div class="content-left-action"><g:link controller="neighbourhood" action="blockConnectors">Block Connector Contact List</g:link></div>
                        <div class="content-left-action"><a href="#" onclick="presentSelectQuestionModal();">Answer Ranking</a></div>
                    </div>
                    </g:else>
                </g:if>
            </div>
            <div class="content-section">
                
                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                    <div class="content-heading">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}  <g:if test="${authorized.canWrite()==Boolean.TRUE}">&nbsp;&nbsp;<a href="#" onclick="presentNewModal();" style="font-weight:normal;">+ Add New Block</a></g:if></div>
                </g:if>
                <g:elseif test="${authorized.forBlock()==Boolean.TRUE}">
                    <div class="content-heading">Your ${navChildren.childType}<g:if test="${navChildren.children.size() > 1}">s</g:if> in ${navSelection.levelInHierarchy} ${navSelection.description}</div>
                </g:elseif>

                <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
                <div id="listWithHandle" style="width:500px;display:inline-block;vertical-align:top;">
                </g:if>
                <g:else>
                <div id="listWithHandle" style="width:900px;display:inline-block;vertical-align:top;">
                </g:else>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}">id="${child.id}"</g:if> class="content-children-row">
                            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}"><span class="drag-handle"><asset:image src="reorder-row.png" width="18" height="18" style="vertical-align:middle;"/></span></g:if>
                            <g:link controller="Navigate" action="${navChildren.childType.toLowerCase()}" id="${child.id}">${child.code}<g:if test="${child.description.size()>0}"> - ${child.description}</g:if></g:link>:
                            <g:if test="${child.connectors.size()>0}">
                                <g:each in="${child.connectors}" var="bc" status="i">
                                    <g:if test="${i>0}">, </g:if>
                                     <g:link controller="Navigate" action="familymember" id="${bc.id}">${bc.firstNames} ${bc.lastName}</g:link>
                                </g:each>
                            </g:if>
                            <g:else>
                                 <span class="light-text">no block connector</span>
                            </g:else>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no blocks</div>
                </g:else>
                </div>

                <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
                <div style="display:inline-block;width:400px;"><div style="border:solid gray;"><div id="mapid"></div></div><div id="mapcaption" style="margin:10px;font-size:small;"></div></div>
                <script type="text/javascript">

                    var boundaryType = '${navSelection.boundary.type}';
                    var boundary = [
                        <g:each in="${navSelection.boundary.coordinates}" var="coord" status="i">
                            [${coord.getY()},${coord.getX()}],
                        </g:each>
                    ];
                    if (boundaryType != 'nada') {
                        var map = L.map('mapid');

                        var boundaryPoly;
                        var invertedPoly;

                        boundaryPoly = L.polygon(boundary);

                        // add inverted polygon to map
                        invertedPoly = L.polygon(
                            [[[90, -180],
                             [90, 180],
                             [-90, 180],
                             [-90, -180]], //outer ring, the world
                             boundaryPoly.getLatLngs()],
                             {opacity:0.4} // cutout
                            );

                        map.addLayer(invertedPoly);

                        map.fitBounds(boundaryPoly.getBounds());

                        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                            maxZoom: 19,
                            id: 'mapbox/streets-v11',
                            accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                        }).addTo(map);


                    } else {
                        document.getElementById('mapid').style = "position:relative;background-color:darkgrey;";
                        document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                    }

                </script>
                </g:if>  <%-- End of test for featureFlag gismaps --%>





                <div class="content-children-row"></div>
                <form id="reorder-form" action="<g:createLink controller='Neighbourhood' action='reorder' />" method="POST">
                    <input id="reorder-this-id" type="hidden" name="blockId" value=""/>
                    <input id="reorder-after-id" type="hidden" name="afterId" value=""/>
                </form>
            </div>
            <div id="transparent-overlay">
            </div>

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}">
            <div id="new-container" class="modal">
                <div class="modal-title">New Block</div>
                <form id="new-form" action="<g:createLink controller='Neighbourhood' action='addBlock' />" method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                    <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveBlock();">Save</div>
                </div>
            </div>
            </g:if>

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
            <div id="select-question-container" class="modal">
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
                    <div class="button" onclick="JavaScript:dismissSelectQuestionModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:generateAnswerRankingReport();">Generate Report</div>
                </div>
            </div>
            </g:if>
    </body>
</html>