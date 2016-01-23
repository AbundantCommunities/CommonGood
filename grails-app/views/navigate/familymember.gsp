<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">
            function populateEditModal() {

                document.getElementById('firstNamesInput').value = "${navSelection.firstNames}";
                document.getElementById('lastNameInput').value = "${navSelection.lastName}";
                document.getElementById('birthYearInput').value = "${navSelection.birthYear}";
                var emailToEncode = "${navSelection.emailAddress}";
                var email = emailToEncode.split('&#64;').join('@');
                document.getElementById('emailAddressInput').value = email;

                document.getElementById('phoneNumberInput').value = "${navSelection.phoneNumber}";
                document.getElementById('orderWithinFamilyInput').value = "${navSelection.orderWithinFamily}";

                document.getElementById('noteInput').value = "${navSelection.note}";
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


            function familyMemberIsValid (firstNames, lastName, note) {
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
                var note = document.getElementById("noteInput").value;
                if (familyMemberIsValid(firstNames, lastName, note)) {
                    dismissEditModal();
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
                    document.getElementById('would-lead-input').checked = answerValues.wouldLead;
                    document.getElementById('would-organize-input').checked = answerValues.wouldOrganize;

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

        </script>
        <style type="text/css">
            #content-detail {
                height:250px;
            }
            #first-names-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #first-names-value {
                position: absolute;
                top:30px;
                left: 160px;
            }
            #last-name-heading {
                position: absolute;
                top:50px;
                left: 10px;
            }
            #last-name-value {
                position: absolute;
                top:50px;
                left: 160px;
            }
            #birth-year-heading {
                position: absolute;
                top:70px;
                left: 10px;
            }
            #birth-year-value {
                position: absolute;
                top:70px;
                left: 160px;
            }
            #email-address-heading {
                position: absolute;
                top:90px;
                left: 10px;
            }
            #email-address-value {
                position: absolute;
                top:90px;
                left: 160px;
            }
            #phone-number-heading {
                position: absolute;
                top:110px;
                left: 10px;
            }
            #phone-number-value {
                position: absolute;
                top:110px;
                left: 160px;
            }
            #order-within-family-heading {
                position: absolute;
                top:130px;
                left: 10px;
            }
            #order-within-family-value {
                position: absolute;
                top:130px;
                left: 160px;
            }
            #note-heading {
                position: absolute;
                top:150px;
                left: 10px;
            }
            #note-value {
                position: absolute;
                top:150px;
                left: 160px;
            }



            .modal-title {
                margin-top: 10px;
                font-weight:bold;
                font-size:14px;
            }

            #edit-fm-container {
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
            #edit-fm-cancelbutton{
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
            #edit-fm-savebutton{
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

            .modal-row {
                margin-top: 10px;
            }

            .email-style {
                width:70%;
            }

            .note-style {
                width:95%;
            }


            #edit-answer-container {
                position:absolute;
                top:140px;
                left:260px;
                width:420px;
                padding:20px;
                padding-top: 10px;
                background-color: #FFFFFF;
                border-radius:10px;
                visibility:hidden;
            }

            #question-div {
                margin-top:15px;
            }

            #answer-input-div {
                margin-top: 15px;
                margin-left: 10px;
            }

            #would-lead-div {
                margin-top: 15px;
                margin-left: 10px;
            }

            #would-organize-div {
                margin-top: 5px;
                margin-left: 10px;
            }

            .button-row {
                margin-top: 20px;
                margin-left: 0px;
                width: 100%;
            }
            #edit-answer-cancelbutton{
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
            #edit-answer-savebutton{
                display: inline-block;
                height: 22px;
                width: 80px;
                margin-left: 10px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                font-weight: bold;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }
            #edit-answer-deletebutton{
                display: inline-block;
                position: absolute;
                right:20px;
                height: 22px;
                width: 130px;
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
            }









        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div id="first-names-heading">First names: </div>
                <div id="first-names-value">${navSelection.firstNames}</div>
                <div id="last-name-heading">Last name: </div>
                <div id="last-name-value">${navSelection.lastName}</div>
                <div id="birth-year-heading">Birth year: </div>
                <div id="birth-year-value">${navSelection.birthYear}</div>
                <div id="email-address-heading">Email address: </div>
                <div id="email-address-value">${navSelection.emailAddress}</div>
                <div id="phone-number-heading">Phone number: </div>
                <div id="phone-number-value">${navSelection.phoneNumber}</div>
                <div id="order-within-family-heading">Order within family: </div>
                <div id="order-within-family-value">${navSelection.orderWithinFamily}</div>
                <div id="note-heading">Note: </div>
                <div id="note-value"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                <br/>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Answers for Family Member ${navSelection.description}</div>
                <g:if test="${questionsAndAnswers.size() > 0}">
                    <g:each in="${questionsAndAnswers}" var="qa">
                        <div class="content-children-row">${qa.question}: <g:each in="${qa.answers}" var="answer" status="i"><g:if test="${i>0}">, </g:if><span id="answer_${answer.id}" style="cursor:pointer;color:#B48B6A;" onclick="editAnswer(this);">${answer.text}</span></g:each></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row" style="color:#CCCCCC;">none</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-fm-container">
                <div class="modal-title">Edit Family Member</div>
                <form id="edit-fm-form" action=${resource(file:'Person/save')} method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></div>
                    <div class="modal-row">Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></div>
                    <div class="modal-row">Birth year: <input id="birthYearInput" type="text" pattern="[12][90][0-9][0-9]" name="birthYear" value="" placeholder="YYYY"/></div>
                    <div class="modal-row">Email address: <input id="emailAddressInput" class="email-style" type="email" name="emailAddress" value="" size="40"/></div>
                    <div class="modal-row">Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></div>
                    <div class="modal-row">Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="noteInput" class="note-style" name="note" cols=56 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="edit-fm-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div id="edit-fm-savebutton" type="button" onclick="JavaScript:saveFamilyMember();">Save</div>
                </div>
            </div>
            <div id="edit-answer-container">
                <div class="modal-title">Edit Answer</div>
                <form id="edit-answer-form" action=${resource(file:'Answer/save')} method="POST">
                    <input id="answer-id-input" type="hidden" name="id" value="" />
                    <div id="question-div"></div>
                    <div id="answer-input-div"><input id="answer-text-input" name="text" type="text" size="50"/></div>
                    <div id="would-lead-div"><input id="would-lead-input" name="wouldLead" type="checkbox" /> Would lead</div>
                    <div id="would-organize-div"><input id="would-organize-input" name="wouldOrganize" type="checkbox" /> Would organize</div>
                </form>
                <div class="button-row">
                    <div id="edit-answer-cancelbutton" type="button" onclick="JavaScript:cancelEditAnswer();">Cancel</div>
                    <div id="edit-answer-savebutton" type="button" onclick="JavaScript:saveAnswer();">Save</div>
                    <div id="edit-answer-deletebutton" type="button" onclick="JavaScript:deleteAnswer();">Delete Answer</div>
                </div>
                <form id="delete-answer-form" action=${resource(file:'Answer/delete')} method="POST">
                    <input id="delete-answer-id-input" type="hidden" name="id" value="" />
                </form>
            </div>
    </body>
</html>