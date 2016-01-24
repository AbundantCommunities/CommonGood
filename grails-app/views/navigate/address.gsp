<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
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

            function newFamilyIsValid (familyName, note) {
                if (familyName == "") {
                    alert("Please enter a family name for the new family.");
                    return false;
                }

                if (note.indexOf('|') > -1) {
                    alert("A note cannot contain the '|' character. Please use a different character.");
                    return false;
                }

                return true;
            }

            function saveFamily() {
                // Validate new family
                var familyName = document.getElementById("familyNameInput").value;
                var note = document.getElementById("noteTextarea").value;
                if (newFamilyIsValid(familyName, note)) {
                    dismissNewModal();
                    var newForm = document.getElementById('new-form');
                    newForm.submit();
                }
            }
            
            
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
                position:absolute;
                top:90px;
                left:300px;
                width:330px;
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
        </style>
    </head>
    <body>
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
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Families for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a onclick="presentNewModal();" href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="new-container">
                <div class="modal-title">New Family</div>
                <form id="new-form" action=${resource(file:'Family/save')} method="POST">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <div class="modal-row">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                    <div class="modal-row">Order within address: <input id="orderWithinAddressInput" type="text" name="orderWithinAddress" value="" /></div>
                    <div class="modal-row">Note: <br/><textarea id="noteTextarea" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div id="new-savebutton" type="button" onclick="JavaScript:saveFamily();">Save</div>
                </div>
            </div>
    </body>
</html>