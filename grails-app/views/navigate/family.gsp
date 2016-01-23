<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">
            function populateEditModal() {

                document.getElementById('familyNameInput').value = "${navSelection.description}";
                document.getElementById('initialInterviewDateInput').value = "<g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/>";

                for (i = 0; i < possibleInterviewerIds.length; i++) {
                    if (possibleInterviewerIds[i][1]) {
                        var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                        possibleInterviewerSelect.selectedIndex = i;
                    }
                }

                document.getElementById('permissionToContactInput').checked = ${navSelection.permissionToContact};
                document.getElementById('participateInInterviewInput').checked = ${navSelection.participateInInterview};
                document.getElementById('orderWithinAddressInput').value = "${navSelection.orderWithinAddress}";

                var encodedNote = "${navSelection.note.split('\r\n').join('|')}";
                var decodedNote = encodedNote.split('|').join('\n');

                document.getElementById('familyNoteInput').value = decodedNote;
            }
            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("familyNameInput").focus();
                document.getElementById("familyNameInput").select();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function familyIsValid(note) {
                if (note.indexOf('|') > -1) {
                    alert("Notes cannot contain the '|' character. Please use a different character");
                    return false;
                }
                return true;
            }
            function saveFamily() {
                if (familyIsValid(document.getElementById('familyNoteInput').value)) {
                    dismissEditModal();
                    var editForm = document.getElementById('edit-form');
                    var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                    var interviewerId = possibleInterviewerIds[possibleInterviewerSelect.selectedIndex][0];
                    document.getElementById('interviewerId').value = interviewerId;
                    editForm.submit();
                }
            }

            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("firstNamesInput").value = "";
                document.getElementById("lastNameInput").value = "";
                document.getElementById("birthYearInput").value = "";
                document.getElementById("emailAddressInput").value = "";
                document.getElementById("phoneNumberInput").value = "";
                document.getElementById("orderWithinFamilyInput").value = "";
                document.getElementById("familyMemberNoteInput").value = "";


                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // show overlay and new-container divs and focus to family name
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("new-container").style.visibility='visible';
                document.getElementById("firstNamesInput").focus();
            }

            function dismissNewModal() {
                document.getElementById("new-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function newFamilyMemberIsValid (firstNames, lastName, note) {
                if (firstNames == "") {
                    alert("Please enter a first name for the new family member.");
                    return false;
                }

                if (lastName == "") {
                    alert("Please enter a last name for the new family member.");
                    return false;
                }

                if (note.indexOf('|') > -1) {
                    alert("Notes cannot contain the '|' character. Please use a different character");
                    return false;
                }

                // If initial interview date is non-blank, validate date.

                return true;
            }

            function saveFamilyMember() {
                // Validate new family
                var firstNames = document.getElementById("firstNamesInput").value;
                var lastName = document.getElementById("lastNameInput").value;
                var note = document.getElementById("familyMemberNoteInput").value;
                if (newFamilyMemberIsValid(firstNames, lastName, note)) {
                    dismissNewModal();
                    document.getElementById("new-form").submit();
                }
            }

            function presentBulkAnswersModal() {

                if (${navChildren.children.size()} > 0) {
                    document.getElementById('familyId-input').value = "${navSelection.id}";
                    document.getElementById('present-questions-form').submit();

                } else {
                    alert('Please add a family member first.');
                }


            }

            // Initialize array to hold ids for possible interviewers.
            var possibleInterviewerIds = [ ];

            window.onload = function onWindowLoad() {
                for (i = 0; i < possibleInterviewerIds.length; i++) {
                    if (possibleInterviewerIds[i][1]) {
                        var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                        possibleInterviewerSelect.selectedIndex = i;
                        document.getElementById('initial-interviewer-value').innerHTML = possibleInterviewerSelect.value;
                    }
                }
            }

        </script>
        <style type="text/css">
            #content-detail {
                height:250px;
            }
            #detail-headings {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #detail-values {
                position: absolute;
                top:30px;
                left: 260px;
            }
            .detail-item {
                height: 20px;
            }
            #edit-container {
                position:absolute;
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
            .modal-title {
                margin-top: 10px;
                font-weight:bold;
                font-size:14px;
            }

            #new-container {
                position:absolute;
                top:90px;
                left:260px;
                width:420px;
                padding:20px;
                padding-top: 10px;
                background-color: #FFFFFF;
                border-radius:10px;
                visibility:hidden;
            }
            #new-fm-cancelbutton{
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
            #new-fm-savebutton{
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

            .button-row {
                margin-top: 20px;
                margin-left: 0px;
                width: 100%;
            }
            
            .modal-row {
                margin-top: 10px;
            }

            .email-style {
                width:70%;
            }

            .note-style {
                width:95%;
            }

            .heading-row {
                height:25px;
            }
            .answer-row {
                height:110px;
            }
            .question-column {
                display: inline-block;
                width: 260px;
                vertical-align:top;
            }
            .answer-column-heading {
                display: inline-block;
                width: 180px;
            }
            .answer-column {
                border: thin;
                border-style: solid;
                border-color: #000000;
                display: inline-block;
                width: 180px;
                height: 91%;
                margin-bottom: -20px;
                position: relative;
            }
            .lo {
                font-size: x-small;
                position: absolute;
                bottom:0px;
            }
            .lo-edit {
                display: none;
            }
            .answer-textarea {
                border: none;
                position: absolute;
                top:0;
                left:0;
                width: 97%;
                height: 77%;
            }
            .answer-div {
                position: absolute;
                top: 0;
                left: 0;
                width: 97%;
                height: 80%;
                overflow:scroll;
            }
            .lead {
                display: inline;
                font-style: italic;
            }
            .organize {
                display: inline;
                font-weight: 700;
            }
        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div id="detail-headings">
                    <div class="detail-item">Family name: </div>
                    <g:if test="${navSelection.interviewed}">
                        <div class="detail-item">Initial interview date: </div>
                        <div class="detail-item">Initial interviewer: </div>
                    </g:if>
                    <div class="detail-item">Permission to contact: </div>
                    <div class="detail-item">Agreed to participate in interview: </div>
                    <div class="detail-item">Order within address: </div>
                    <div class="detail-item">Note: </div>
                </div>
                <div id="detail-values">
                    <div class="detail-item">${navSelection.description}</div>
                    <g:if test="${navSelection.interviewed}">
                        <div class="detail-item"><g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/></div>
                        <div id="initial-interviewer-value" class="detail-item"></div>
                    </g:if>
                    <div class="detail-item">
                        <g:if test="${navSelection.permissionToContact}">
                            Yes
                        </g:if>
                        <g:else>
                            No
                        </g:else>
                    </div>
                    <div class="detail-item">
                        <g:if test="${navSelection.participateInInterview}">
                            Yes
                        </g:if>
                        <g:else>
                            No
                        </g:else>
                    </div>
                    <div class="detail-item">${navSelection.orderWithinAddress}</div>
                    <div class="detail-item"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                </div>

                <g:if test="${!navSelection.interviewed}">
                    <div style="position:absolute;bottom:10px;font-size:x-small;">This family has not yet been interviewed.</div>
                </g:if>

                <div id="content-actions-left-side">
                    <div class="content-left-action"><a href="#" onclick="presentBulkAnswersModal();">Add Interview Answers</a></div>
                    <form id="present-questions-form" action="<g:createLink controller='question' method='POST'/>">
                        <input type="hidden" id="familyId-input" name="familyId"/>
                    </form>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Family members for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal()">+ Add New Family Member</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container">
                <p style="font-weight:bold;font-size:14px;">Edit Family</p>
                <form id="edit-form" action=${resource(file:'Family/save')} method="post">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <p>Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></p>
                    <p>Initial interview date: <input id="initialInterviewDateInput" type="date" name="initialInterviewDate" placeholder="yyyy-MM-dd" value=""/></p>
                    <p>Initial interviewer: 
                        <select id="possibleInterviewerSelect">
                            <g:each in="${navSelection.possibleInterviewers}" var="possibleInterviewer">
                                <option value="${possibleInterviewer.fullName}">${possibleInterviewer.fullName}</option>
                                <script type="text/javascript">
                                    possibleInterviewerIds.push([${possibleInterviewer.id}, ${possibleInterviewer.default}]);
                                </script>
                            </g:each>
                        </select>
                    </p>
                    <input id="interviewerId" type="hidden" name="interviewerId" value="" />
                    <p><input id="permissionToContactInput" type="checkbox" name="permissionToContact" value="false" /> Permission to contact</p>
                    <p><input id="participateInInterviewInput" type="checkbox" name="participateInInterview" value="false" /> Agreed to participate in interview</p>
                    <p>Order within address: <input id="orderWithinAddressInput" type="text" name="orderWithinAddress" value="" /></p>
                    <p>Note:</p>
                    <p><textarea id="familyNoteInput" name="note" cols=44 rows=4></textarea></p>
                </form>
                <button id="edit-savebutton" type="button" onclick="JavaScript:saveFamily();">Save</button>
                <button id="edit-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</button>
            </div>

            <div id="new-container">
                <div class="modal-title">New Family Member</div>
                <form id="new-form" action=${resource(file:'Person/save')} method="POST">
                    <input type="hidden" name="familyId" value="${navSelection.id}" />
                    <div class="modal-row">First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></div>
                    <div class="modal-row">Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></div>
                    <div class="modal-row">Birth year: <input id="birthYearInput" type="text" pattern="[12][90][0-9][0-9]" name="birthYear" value="" placeholder="YYYY"/></div>
                    <div class="modal-row">Email address: <input id="emailAddressInput" class="email-style" type="email" name="emailAddress" value="" size="40"/></div>
                    <div class="modal-row">Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></div>
                    <div class="modal-row">Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyMemberNoteInput" class="note-style" name="note" cols=56 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="new-fm-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div id="new-fm-savebutton" type="button" onclick="JavaScript:saveFamilyMember();">Save</div>
                </div>
            </div>

    </body>
</html>