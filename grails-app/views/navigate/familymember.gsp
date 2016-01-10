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

                document.getElementById('noteInput').value = "note not yet hooked up";
            }


            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("firstNamesInput").focus();
                document.getElementById("firstNamesInput").select();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
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
                    document.getElementById("edit-form").submit();
                }
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
            #edit-container {
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
            button#edit-savebutton{
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
            button#edit-cancelbutton{
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
                <div id="note-value"><textarea cols="60" rows="5" style="color: #222222;" disabled>note not yet hooked up</textarea></div>
                <br/>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Answers for ${navSelection.levelInHierarchy} ${navSelection.description}</div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container">
                <p style="font-weight:bold;font-size:14px;">Edit Family Member</p>
                <form id="edit-form" action=${resource(file:'Person/save')} method="post">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <p>First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></p>
                    <p>Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></p>
                    <p>Birth year: <input id="birthYearInput" type="text" pattern="[12][90][0-9][0-9]" name="birthYear" value="" placeholder="YYYY"/></p>
                    <p>Email address: <input id="emailAddressInput" type="email" name="emailAddress" value="" size="40"/></p>
                    <p>Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></p>
                    <p>Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value=""/></p>
                    <p>Note: </p>
                    <p><textarea id="noteInput" name="note" cols=56 rows=4></textarea></p>
                </form>
                <button id="edit-savebutton" type="button" onclick="JavaScript:saveFamilyMember();">Save</button>
                <button id="edit-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</button>
            </div>
    </body>
</html>