<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Family</title>
        <script type="text/javascript">

            function populateEditModal() {
                document.getElementById('familyNameInput').value = decodeEntities("${navSelection.description}");

                var encodedNote = "${navSelection.note.split('\r\n').join('|')}";
                var decodedNote = encodedNote.split('|').join('\n');

                document.getElementById('familyNoteInput').value = decodeEntities(decodedNote);
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

            function familyIsValid(familyName,note) {
                if (familyName == "") {
                    alert("Please enter a family name for the new family.");
                    return false;
                } else {
                    if (note.indexOf('|') > -1) {
                        alert("Notes cannot contain the '|' character. Please use a different character");
                        return false;
                    }
                }
                return true;
            }

            function saveFamily() {
                var familyName = document.getElementById('familyNameInput').value.trim();
                var note = document.getElementById('familyNoteInput').value.trim();
                if (familyIsValid(familyName,note)) {
                    dismissEditModal();

                    document.getElementById("familyNameInput").value = document.getElementById("familyNameInput").value.trim();
                    document.getElementById("familyNoteInput").value = document.getElementById("familyNoteInput").value.trim();

                    document.getElementById('edit-form').submit();
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

            function emailOk(email) {
                if (email.length > 0) {
                    var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    return re.test(email);
                }
                return true;
            }

            function yearOk(year) {
                var pattern = /^$|^(19|20)\d{2}$/;
                return pattern.test(year);
            }

            function familyMemberIsValid (firstNames, lastName, birthYear, email, note) {
                if (firstNames == "") {
                    alert("Please enter a first name for the new family member.");
                    return false;
                } else {
                    if (lastName == "") {
                        alert("Please enter a last name for the new family member.");
                        return false;
                    } else {
                        if (!yearOk(birthYear)) {
                            alert("Please enter a valid birth year (YYYY) or leave it blank.");
                            return false;
                        } else {
                            if (!emailOk(email)) {
                                alert("Please enter a valid email address or leave it blank.");
                                return false;
                            } else {
                                if (note.indexOf('|') > -1) {
                                    alert("Notes cannot contain the '|' character. Please use a different character.");
                                    return false;
                                }
                            }
                        }
                    }
                }
                return true;
            }

            function saveFamilyMember() {
                // Validate new family
                var firstNames = document.getElementById("firstNamesInput").value.trim();
                var lastName = document.getElementById("lastNameInput").value.trim();
                var birthYear = document.getElementById("birthYearInput").value.trim();
                var email = document.getElementById("emailAddressInput").value.trim();
                var note = document.getElementById("familyMemberNoteInput").value.trim();
                if (familyMemberIsValid(firstNames, lastName, birthYear, email, note)) {
                    dismissNewModal();
                    // trim all values
                    document.getElementById("firstNamesInput").value = firstNames;
                    document.getElementById("lastNameInput").value = lastName;
                    document.getElementById('birthYearInput').value = birthYear;
                    document.getElementById("emailAddressInput").value = email;
                    document.getElementById("familyMemberNoteInput").value = note;
                    // check if birth year blank. if yes, set it to '0'.
                    if (document.getElementById('birthYearInput').value.length == 0) {
                        document.getElementById('birthYearInput').value = '0';
                    }
                    document.getElementById("new-form").submit();
                }
            }


            function presentInterviewForm   () {

                document.getElementById('familyId-input').value = "${navSelection.id}";
                document.getElementById('present-interview-form').submit();

            }

            window.onload = function onWindowLoad() {
                <g:each in="${navSelection.possibleInterviewers}" var="possibleInterviewer">
                    <g:if test="${possibleInterviewer.default=='true'}">
                        document.getElementById('initial-interviewer-value').innerHTML = "${possibleInterviewer.fullName}";
                    </g:if>
                </g:each>
            }

        </script>
        <style type="text/css">

            #edit-container {
                top:90px;
                left:300px;
                width:330px;
            }
            #familyNoteInput {
                width: 95%;
            }
            #new-container {
                top:90px;
                left:260px;
                width:420px;
            }

        </style>
    </head>
    <body>
            <div class="content-section" >
                <div class="content-heading">${navSelection.levelInHierarchy}</div>
                <div class="content-row">
                    <div class="content-row-item" style="width:160px;">Family name: </div><div class="content-row-item">${navSelection.description}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:160px;">Note: </div><div class="content-row-item"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                </div>
                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><g:link controller="Delete" action="confirmFamily" id="${navSelection.id}">Delete</g:link></div>
                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                        <div class="content-action"><g:link controller="Move" action="selectDestinationAddress" id="${navSelection.id}">Move</g:link></div>
                    </g:if>
                    <g:else>
                        <div class="content-action"><a href="#" onclick="alert('As a Block Connector, you are not able to move families. Please ask your Neighbourhood Connector to do this for you.')">Move</a></div>
                    </g:else>
                </div>
            </div>
            <div class="content-section">
                <div class="content-heading">Interview&nbsp;&nbsp;<a href="#" onclick="presentInterviewForm()" style="font-weight:normal;">+ Enter Interview Data</a></div>

                <g:if test="${navSelection.interviewed}">

                    <div class="content-row">
                        <div class="content-row-item" style="width:250px;">Permission to contact: </div>
                        <div class="content-row-item" style="width:50px;">
                            <g:if test="${navSelection.permissionToContact}">
                                Yes
                            </g:if>
                            <g:else>
                                No
                            </g:else>
                        </div>
                        <div class="content-row-item" style="width:160px;">Initial interview date: </div>
                        <div class="content-row-item"><g:formatDate format='yyyy-MM-dd' date='${navSelection.interviewDate}'/></div>
                    </div>

                    <div class="content-row">
                        <div class="content-row-item" style="width:250px;">Agreed to participate in interview: </div>
                        <div class="content-row-item" style="width:50px;">
                            <g:if test="${navSelection.participateInInterview}">
                                Yes
                            </g:if>
                            <g:else>
                                No
                            </g:else>
                        </div>
                        <div class="content-row-item" style="width:160px;">Initial interviewer: </div>
                        <div id="initial-interviewer-value" class="content-row-item"></div>
                    </div>

                </g:if>
                <g:else>
                    <div class="light-text">no interiview data for family</div>
                </g:else>


                <form id="present-interview-form" action="<g:createLink controller='question' method='POST'/>">
                    <input type="hidden" id="familyId-input" name="familyId"/>
                </form>

            </div>

            <div class="content-section">
                <div class="content-heading">Family Members for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal()" style="font-weight:normal;">+ Add New Family Member</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                <div id="listWithHandle">
                    <g:each in="${navChildren.children}" var="child">
                        <div id="${child.id}" class="content-children-row">
                            <span class="drag-handle"><asset:image src="reorder-row.png" width="18" height="18" style="vertical-align:middle;"/></span>
                            <g:link controller='navigate' action='${navChildren.childType.toLowerCase()}' id='${child.id}'>${child.name}</g:link>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no family members</div>
                </g:else>
                </div>
                <div class="content-children-row"></div>
                <form id="reorder-form" action="<g:createLink controller='Family' action='reorder' />" method="POST">
                    <input id="reorder-this-id" type="hidden" name="personId" value=""/>
                    <input id="reorder-after-id" type="hidden" name="afterId" value=""/>
                </form>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container" class="modal">
                <div class="modal-title">Edit Family</div>
                <form id="edit-form" action="<g:createLink controller='family' action='save' />" method="post">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyNoteInput" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveFamily();">Save</div>
                </div>
            </div>

            <div id="new-container" class="modal">
                <div class="modal-title">New Family Member</div>
                <form id="new-form" action="<g:createLink controller='person' action='save' />" method="POST">
                    <input type="hidden" name="familyId" value="${navSelection.id}" />
                    <div class="modal-row">First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></div>
                    <div class="modal-row">Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></div>
                    <div class="modal-row">Birth year: <input id="birthYearInput" type="text" name="birthYear" value="" placeholder="YYYY"/></div>
                    <div class="modal-row">Email address: <input id="emailAddressInput" class="email-style" type="email" name="emailAddress" value="" size="40"/></div>
                    <div class="modal-row">Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyMemberNoteInput" class="note-style" name="note" cols=56 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveFamilyMember();">Save</div>
                </div>
            </div>
    </body>
</html>