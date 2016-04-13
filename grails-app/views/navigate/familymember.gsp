<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Family Member</title>
        <script type="text/javascript">
            function populateEditModal() {
                document.getElementById('firstNamesInput').value = decodeEntities("${navSelection.firstNames}");
                document.getElementById('lastNameInput').value = decodeEntities("${navSelection.lastName}");
                <g:if test="${navSelection.birthYear == 0}">
                    document.getElementById('birthYearInput').value = "";
                </g:if>
                <g:else>
                    document.getElementById('birthYearInput').value = "${navSelection.birthYear}";
                </g:else>
                
                document.getElementById('emailAddressInput').value = decodeEntities("${navSelection.emailAddress}");

                document.getElementById('phoneNumberInput').value = decodeEntities("${navSelection.phoneNumber}");
                document.getElementById('orderWithinFamilyInput').value = "${navSelection.orderWithinFamily}";

                var encodedNote = "${navSelection.note.split('\r\n').join('|')}";
                var decodedNote = encodedNote.split('|').join('\n');
                document.getElementById('noteInput').value = decodeEntities(decodedNote);
            }


            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-fm-container").style.visibility='visible';
                document.getElementById("firstNamesInput").focus();
                document.getElementById("firstNamesInput").select();
            }
            function dismissEditModal() {
                document.getElementById("edit-fm-container").style.visibility='hidden';
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

            function familyMemberIsValid (firstNames, lastName, birthYear, email, note, order) {
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
                                } else {
                                    if (!orderOk(order)) {
                                        alert("Please enter a valid order. Must be a number.");
                                        return false;
                                    }
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
                var note = document.getElementById("noteInput").value.trim();
                var order = document.getElementById("orderWithinFamilyInput").value.trim();
                if (familyMemberIsValid(firstNames, lastName, birthYear, email, note, order)) {
                    dismissEditModal();
                    // trim all values
                    document.getElementById("firstNamesInput").value = document.getElementById("firstNamesInput").value.trim();
                    document.getElementById("lastNameInput").value = document.getElementById("lastNameInput").value.trim();
                    document.getElementById('birthYearInput').value = document.getElementById('birthYearInput').value.trim();
                    document.getElementById("emailAddressInput").value = document.getElementById("emailAddressInput").value.trim();
                    document.getElementById("noteInput").value = document.getElementById("noteInput").value.trim();
                    document.getElementById("orderWithinFamilyInput").value = document.getElementById("orderWithinFamilyInput").value.trim();
                    // check if birth year blank. if yes, set it to '0'.
                    if (document.getElementById('birthYearInput').value.length == 0) {
                        document.getElementById('birthYearInput').value = '0';
                    }
                    document.getElementById("edit-fm-form").submit();
                }
            }

            function editAnswer(element) {

                var answerIdParts = element.id.split('_');
                if (answerIdParts.length != 2) {
                    alert('unexpected element id for answer id');
                    return;
                }

                var answerId = answerIdParts[1];

                // Get answer row.
                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="answer" action="get"/>/'+answerId;
                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        var answerValues = JSON.parse( xmlhttp.responseText );
                        presentEditAnswerModal( answerValues );
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function presentEditAnswerModal( answerValues ) {


                    document.getElementById('answer-id-input').value = answerValues.id;
                    document.getElementById('delete-answer-id-input').value = answerValues.id;
                    document.getElementById('question-div').innerHTML = answerValues.question;
                    document.getElementById('answer-text-input').value = answerValues.text;
                    document.getElementById('would-assist-input').checked = answerValues.wouldAssist;
                    document.getElementById('answer-note-input').value = answerValues.note;

                    var pagecontainerDiv = document.getElementById("pagecontainer");
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                    document.getElementById("transparent-overlay").style.visibility='visible';
                    document.getElementById("edit-answer-container").style.visibility='visible';
                    document.getElementById("answer-text-input").focus();
                    document.getElementById("answer-text-input").select();

                }

            }

            function dismissEditAnswerModal() {
                document.getElementById("edit-answer-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function answerIsValid(answerText) {
                if (answerText != '') {
                    return true;
                } else {
                    alert('Please enter an answer.');
                    return false;
                }
            }

            function saveAnswer() {
                if (answerIsValid(document.getElementById('answer-text-input').value)) {
                    dismissEditAnswerModal();
                    document.getElementById('edit-answer-form').submit();
                }
            }


            function deleteAnswer() {
                dismissEditAnswerModal();
                document.getElementById('delete-answer-form').submit();
            }


            function cancelEditAnswer() {
                dismissEditAnswerModal();
            }

            <g:if test="${navSelection.birthYear == 0}">
                window.onload = function onWindowLoad() {
                    document.getElementById('birth-year-value').innerHTML = '';
                }
            </g:if>


        </script>
        <style type="text/css">

            #edit-fm-container {
                top:90px;
                left:260px;
                width:420px;
            }
            #edit-answer-container {
                top:140px;
                left:260px;
                width:420px;
            }

            #question-div {
                margin-top:15px;
            }
            #answer-input-div {
                margin-top: 15px;
                margin-left: 10px;
            }
            #would-assist-div {
                margin-top: 15px;
                margin-left: 10px;
            }
            #answer-note-title-div {
                margin-top: 15px;
                margin-left: 10px;
            }
            #answer-note-input-div {
                margin-top: 0px;
                margin-left: 10px;
            }
            #answer-text-input {
                width: 400px;
            }
            #answer-note-input {
                width: 400px;
            }

        </style>
    </head>

    <body>
            <div class="content-section">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>

                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">First names: </div><div class="content-row-item">${navSelection.firstNames}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Last name: </div><div class="content-row-item">${navSelection.lastName}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Birth year: </div><div class="content-row-item">${navSelection.birthYear}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Email address: </div><div class="content-row-item">${navSelection.emailAddress}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Phone number: </div><div class="content-row-item">${navSelection.phoneNumber}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Order within family: </div><div class="content-row-item">${navSelection.orderWithinFamily}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:150px;">Note: </div><div class="content-row-item"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Delete</a></div>
                </div>
            </div>
            <div class="content-section">
                <div class="content-heading">Answers for ${navSelection.description}</div>
                <g:if test="${questionsAndAnswers.size() > 0}">
                    <g:each in="${questionsAndAnswers}" var="qa">
                        <div class="content-children-row">${qa.question}: <g:each in="${qa.answers}" var="answer" status="i"><g:if test="${i>0}">, </g:if><span id="answer_${answer.id}" style="cursor:pointer;color:#B48B6A;" onclick="editAnswer(this);">${answer.text}</span></g:each></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no answers</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-fm-container" class="modal">
                <div class="modal-title">Edit Family Member</div>
                <form id="edit-fm-form" action="<g:createLink controller='person' action='save' />" method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></div>
                    <div class="modal-row">Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></div>
                    <div class="modal-row">Birth year: <input id="birthYearInput" type="text" name="birthYear" value="" placeholder="YYYY"/></div>
                    <div class="modal-row">Email address: <input id="emailAddressInput" class="email-style" type="email" name="emailAddress" value="" size="40"/></div>
                    <div class="modal-row">Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></div>
                    <div class="modal-row">Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value="" size="12"/></div>
                    <div class="modal-row">Note: <br/><textarea id="noteInput" class="note-style" name="note" cols=56 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveFamilyMember();">Save</div>
                </div>
            </div>
            <div id="edit-answer-container" class="modal">
                <div class="modal-title">Edit Answer</div>
                <form id="edit-answer-form" action="<g:createLink controller='answer' action='save' />" method="POST">
                    <input id="answer-id-input" type="hidden" name="id" value="" />
                    <div id="question-div"></div>
                    <div id="answer-input-div"><input id="answer-text-input" name="text" type="text" size="45"/></div>
                    <div id="would-assist-div"><input id="would-assist-input" name="wouldAssist" type="checkbox" /> Would assist</div>
                    <div id="answer-note-title-div">Note:</div>
                    <div id="answer-note-input-div"><input id="answer-note-input" name="note" type="text" size="45"/></div>
                </form>
                <div>&nbsp;</div>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:cancelEditAnswer();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveAnswer();">Save</div>
                    <div class="button" style="float:right;" onclick="JavaScript:deleteAnswer();">Delete Answer</div>
                </div>
                <form id="delete-answer-form" action="<g:createLink controller='answer' action='delete' />" method="POST">
                    <input id="delete-answer-id-input" type="hidden" name="id" value="" />
                </form>
            </div>
    </body>
</html>