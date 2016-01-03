<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">

            function currentDate() {
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth()+1; //January is 0!
                var yyyy = today.getFullYear();

                if(dd<10) {
                    dd='0'+dd
                } 

                if(mm<10) {
                    mm='0'+mm
                } 

                today = yyyy+'-'+mm+'-'+dd;

                return today;

            }
            
            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("familyNameInput").value = "";
                document.getElementById("initialInterviewDateInput").value = currentDate();
                document.getElementById("permissionToContactCheckbox").checked = false;
                document.getElementById("participateInInterviewCheckbox").checked = false;
                document.getElementById("orderWithinAddressInput").value = "";
                document.getElementById("noteTextarea").value = "";


                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // show overlay and new-container divs and focus to family name
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("new-container").style.visibility='visible';
                document.getElementById("familyNameInput").focus();
            }

            function dismissNewModal() {
                document.getElementById("new-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function newFamilyIsValid (familyName, initialInterviewDate, note) {
                if (familyName == "") {
                    alert("Please enter a family name for the new family.");
                    return false;
                }

                if (note.indexOf('|') > -1) {
                    alert("A note cannot contain the '|' character. Please use a different character.");
                    return false;
                }
                // If initial interview date is non-blank, validate date.

                return true;
            }

            function saveFamily() {
                // Validate new family
                var familyName = document.getElementById("familyNameInput").value;
                var initialInterviewDate = document.getElementById("initialInterviewDateInput").value;
                var note = document.getElementById("noteTextarea").value;
                if (newFamilyIsValid(familyName, initialInterviewDateInput, note)) {
                    dismissNewModal();
                    var newForm = document.getElementById('new-form');
                    var possibleInterviewerSelect = document.getElementById( "possibleInterviewerSelect" );
                    var interviewerId = possibleInterviewerIds[possibleInterviewerSelect.selectedIndex];
                    document.getElementById('interviewerId').value = interviewerId;
                    newForm.submit();
                }
            }
            
            // Initialize array to hold ids for possible interviewers.
            var possibleInterviewerIds = [ ];
            
        </script>
        <style type="text/css">
            #content-detail {
                height:180px;
            }
            #address-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #address-value {
                position: absolute;
                top:30px;
                left: 155px;
            }
            #order-within-block-heading {
                position: absolute;
                top:50px;
                left: 10px;
            }
            #order-within-block-value {
                position: absolute;
                top:50px;
                left: 155px;
            }
            #note-heading {
                position: absolute;
                top:70px;
                left: 10px;
            }
            #note-value {
                position: absolute;
                top:70px;
                left: 155px;
            }
            #new-container {
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
            button#new-savebutton{
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
            button#new-cancelbutton{
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
                <div id="address-heading">Address: </div>
                <div id="address-value">${navSelection.description}</div>
                <div id="order-within-block-heading">Order within block: </div>
                <div id="order-within-block-value">${navSelection.orderWithinBlock}</div>
                <div id="note-heading">Note: </div>
                <div id="note-value"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>

                <g:if test="${navSelection.levelInHierarchy.toLowerCase() == 'neighbourhood'}">
                    <div id="content-actions-left-side">
                        <div class="content-left-action"><a href="${resource(dir:'blockSummary',file:"index")}" target="_blank">Block Summary</a></div>
                        <div class="content-left-action"><a href="${resource(dir:'blockConnectorSummary',file:"index")}" target="_blank">Block Connector Summary</a></div>
                    </div>
                </g:if>

                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Families for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a onclick="presentNewModal();" href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
            <div id="footer">
                &copy;2015 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="new-container">
                <p style="font-weight:bold;font-size:14px;">New Family</p>
                <form id="new-form" action=${resource(file:'Family/save')} method="post">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <p>Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></p>
                    <p>Initial interview date: <input id="initialInterviewDateInput" type="date" name="initialInterviewDate" placeholder="yyyy-MM-dd" value=""/></p>
                    <p>Initial interviewer: 
                        <select id="possibleInterviewerSelect">
                            <g:each in="${navSelection.possibleInterviewers}" var="possibleInterviewer">
                                <option value="${possibleInterviewer.fullName}">${possibleInterviewer.fullName}</option>
                                <script type="text/javascript">
                                    possibleInterviewerIds.push(${possibleInterviewer.id});
                                </script>
                            </g:each>
                        </select>
                    </p>
                    <input id="interviewerId" type="hidden" name="interviewerId" value="" />
                    <p><input id="permissionToContactCheckbox" type="checkbox" name="permissionToContact" /> Permission to contact</p>
                    <p><input id="participateInInterviewCheckbox" type="checkbox" name="participateInInterview" /> Agreed to participate in interview</p>
                    <p>Order within address: <input id="orderWithinAddressInput" type="text" name="orderWithinAddress" value="" /></p>
                    <p>Note:</p>
                    <p><textarea id="noteTextarea" name="note" cols=44 rows=4></textarea></p>
                </form>
                <button id="new-savebutton" type="button" onclick="JavaScript:saveFamily();">Save</button>
                <button id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</button>
            </div>


        </div>
    </body>
</html>