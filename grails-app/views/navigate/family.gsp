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

                    var pagecontainerDiv = document.getElementById("pagecontainer");
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                    
                    document.getElementById("transparent-overlay").style.visibility='visible';
                    document.getElementById("bulk-answers-container").style.visibility='visible';
                    document.getElementById("familyNameInput").focus();
                    document.getElementById("familyNameInput").select();
                } else {
                    alert('Please add a family member first.');
                }


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
                        document.getElementById('initial-interviewer-value').innerHTML = possibleInterviewerSelect.value;
                    }
                }
            }

        </script>
        <style type="text/css">
            #content-detail {
                height:250px;
            }
            #family-name-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #family-name-value {
                position: absolute;
                top:30px;
                left: 260px;
            }
            #initial-interview-date-heading {
                position: absolute;
                top:50px;
                left: 10px;
            }
            #initial-interview-date-value {
                position: absolute;
                top:50px;
                left: 260px;
            }
            #initial-interviewer-heading {
                position: absolute;
                top:70px;
                left: 10px;
            }
            #initial-interviewer-value {
                position: absolute;
                top:70px;
                left: 260px;
            }
            #permission-to-contact-heading {
                position: absolute;
                top:90px;
                left: 10px;
            }
            #permission-to-contact-value {
                position: absolute;
                top:90px;
                left: 260px;
            }
            #agreed-to-participate-heading {
                position: absolute;
                top:110px;
                left: 10px;
            }
            #agreed-to-participate-value {
                position: absolute;
                top:110px;
                left: 260px;
            }
            #order-within-address-heading {
                position: absolute;
                top:130px;
                left: 10px;
            }
            #order-within-address-value {
                position: absolute;
                top:130px;
                left: 260px;
            }
            #note-heading {
                position: absolute;
                top:150px;
                left: 10px;
            }
            #note-value {
                position: absolute;
                top:150px;
                left: 260px;
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
            #new-container {
                position:absolute;
                top:140px;
                left:260px;
                width:420px;
                height:385px;
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
            button#new-savebutton{
                position: absolute;
                left:230px;
                top:375px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
                font-weight: bold;
            }
            button#new-cancelbutton{
                position: absolute;
                left:130px;
                top:375px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
            }
            #bulk-answers-container {
                position:absolute;
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
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div id="family-name-heading">Name: </div>
                <div id="family-name-value">${navSelection.description}</div>
                <div id="initial-interview-date-heading">Initial interview date: </div>
                <div id="initial-interview-date-value"><g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/></div>
                <div id="initial-interviewer-heading">Initial interviewer: </div>
                <div id="initial-interviewer-value"></div>
                <div id="permission-to-contact-heading">Permission to contact: </div>
                <div id="permission-to-contact-value">
                    <g:if test="${navSelection.permissionToContact}">
                        Yes
                    </g:if>
                    <g:else>
                        No
                    </g:else>
                </div>
                <div id="agreed-to-participate-heading">Agreed to participate in interview: </div>
                <div id="agreed-to-participate-value">
                    <g:if test="${navSelection.participateInInterview}">
                        Yes
                    </g:if>
                    <g:else>
                        No
                    </g:else>
                </div>
                <div id="order-within-address-heading">Order within address: </div>
                <div id="order-within-address-value">${navSelection.orderWithinAddress}</div>
                <div id="note-heading">Note: </div>
                <div id="note-value"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>




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
                <div id="content-children-title">Family members for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal()">+ Add New Family Member</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
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
                <p style="font-weight:bold;font-size:14px;">New Family Member</p>
                <form id="new-form" action=${resource(file:'Person/save')} method="post">
                    <input type="hidden" name="familyId" value="${navSelection.id}" />
                    <p>First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></p>
                    <p>Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></p>
                    <p>Birth year: <input id="birthYearInput" type="text" pattern="[12][90][0-9][0-9]" name="birthYear" value="" placeholder="YYYY"/></p>
                    <p>Email address: <input id="emailAddressInput" type="email" name="emailAddress" value="" size="40"/></p>
                    <p>Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></p>
                    <p>Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value=""/></p>
                    <p>Note: </p>
                    <p><textarea id="familyMemberNoteInput" name="note" cols=56 rows=4></textarea></p>
                </form>
                <button id="new-savebutton" type="button" onclick="JavaScript:saveFamilyMember();">Save</button>
                <button id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</button>
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
    </body>
</html>