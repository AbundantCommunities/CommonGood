<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">
            function populateEditModal() {

                document.getElementById('firstNamesInput').value = "${navSelection.firstNames}";
                document.getElementById('lastNameInput').value = "${navSelection.lastName}";
                document.getElementById('birthYearInput').value = "${navSelection.birthYear}";
                document.getElementById('emailAddressInput').value = "${navSelection.emailAddress}";
                document.getElementById('phoneNumberInput').value = "${navSelection.phoneNumber}";
                document.getElementById('orderWithinFamilyInput').value = "${navSelection.orderWithinFamily}";
            }


            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("firstNamesInput").focus();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }


            function familyMemberIsValid (firstNames, lastName) {
                if (firstNames == "") {
                    alert("Please enter a first name for the new family member.");
                    return false;
                }

                if (lastName == "") {
                    alert("Please enter a last name for the new family member.");
                    return false;
                }

                // If initial interview date is non-blank, validate date.

                return true;
            }

            function saveFamilyMember() {
                // Validate new family
                var firstNames = document.getElementById("firstNamesInput").value;
                var lastName = document.getElementById("lastNameInput").value;
                if (familyMemberIsValid(firstNames, lastName)) {
                    dismissEditModal();
                    document.getElementById("edit-form").submit();
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
                <div class="content-detail-value">First names: ${navSelection.firstNames}</div>
                <div class="content-detail-value">Last name: ${navSelection.lastName}</div>
                <div class="content-detail-value">Birth year: ${navSelection.birthYear}</div>
                <div class="content-detail-value">Email address: ${navSelection.emailAddress}</div>
                <div class="content-detail-value">Phone number: ${navSelection.phoneNumber}</div>
                <div class="content-detail-value">Order within family: ${navSelection.orderWithinFamily}</div>
                <br/>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal()">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Answers for ${navSelection.levelInHierarchy} ${navSelection.description}</div>
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
                <p style="font-weight:bold;font-size:14px;">Edit Family Member</p>
                <form id="edit-form" action=${resource(file:'Person/save')} method="post">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <p>First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></p>
                    <p>Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></p>
                    <p>Birth year: <input id="birthYearInput" type="number" pattern="[12][90][0-9][0-9]" name="birthYear" value=""/></p>
                    <p>Email address: <input id="emailAddressInput" type="email" name="emailAddress" value=""/></p>
                    <p>Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></p>
                    <p>Order within family: <input id="orderWithinFamilyInput" type="text" name="orderWithinFamily" value=""/></p>
                </form>
                <button id="edit-savebutton" type="button" onclick="JavaScript:saveFamilyMember();">Save</button>
                <button id="edit-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</button>
            </div>
        </div>
    </body>
</html>