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
            

            function populateEditModal() {
                Encoder.EncodeType = "entity";
                document.getElementById('addressTextInput').value = Encoder.htmlDecode("${navSelection.description}");
                document.getElementById('orderWithinBlockInput').value = "${navSelection.orderWithinBlock}";

                var encodedNote = "${navSelection.note.split('\r\n').join('|')}";
                var decodedNote = encodedNote.split('|').join('\n');

                document.getElementById('addressNoteTextarea').value = Encoder.htmlDecode(decodedNote);
            }
            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("addressTextInput").focus();
                document.getElementById("addressTextInput").select();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }


            function addressIsValid(addressText,order,note) {
                if (addressText == "") {
                    alert("Please enter an address.");
                    return false;
                } else {
                    if (!orderOk(order)) {
                        alert("Please enter a valid order. Must be a number.");
                        return false;
                    } else {
                        if (note.indexOf('|') > -1) {
                            alert("Notes cannot contain the '|' character. Please use a different character");
                            return false;
                        }
                    }
                }
                return true;
            }

            function saveAddress() {
                var addressText = document.getElementById('addressTextInput').value.trim();
                var order = document.getElementById('orderWithinBlockInput').value.trim();
                var note = document.getElementById('addressNoteTextarea').value.trim();
                if (addressIsValid(addressText,order,note)) {
                    dismissEditModal();

                    document.getElementById("addressTextInput").value = document.getElementById("addressTextInput").value.trim();
                    document.getElementById("orderWithinBlockInput").value = document.getElementById("orderWithinBlockInput").value.trim();
                    document.getElementById("addressNoteTextarea").value = document.getElementById("addressNoteTextarea").value.trim();

                    document.getElementById('edit-form').submit();
                }
            }





            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("familyNameInput").value = "";
                document.getElementById("familyNoteTextarea").value = "";


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
                var note = document.getElementById('familyNoteTextarea').value.trim();
                if (familyIsValid(familyName,note)) {
                    dismissEditModal();

                    document.getElementById("familyNameInput").value = familyName;
                    document.getElementById("familyNoteTextarea").value = note;

                    document.getElementById('new-form').submit();
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

            #edit-container {
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
            #edit-cancelbutton{
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
            #edit-savebutton{
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
            .noteTextarea {
                width: 95%;
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
                        <div class="content-left-action"><a href="${resource(dir:'blockConnectorSummary',file:"index")}" target="_blank">Block Connector Contact List</a></div>
                    </div>
                </g:if>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal();">Edit</a></div>
                    <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Delete</a></div>
                </div>
            </div>
            <div id="content-children">
                <div class="content-heading">Families for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a onclick="presentNewModal();" href="#" style="font-weight:normal;">+ Add New ${navChildren.childType}</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row" style="color:#CCCCCC;">no families</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container">
                <div class="modal-title">Edit Address</div>
                <form id="edit-form" action=${resource(file:'Address/save')} method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Address: <input id="addressTextInput" type="text" name="text" value="" style="width:70%;"/></div>
                    <div class="modal-row">Order within block: <input id="orderWithinBlockInput" type="text" name="orderWithinBlock" value="" size="12"/></div>
                    <div class="modal-row">Note: <br/><textarea id="addressNoteTextarea" class="noteTextarea" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div id="new-savebutton" type="button" onclick="JavaScript:saveAddress();">Save</div>
                </div>
            </div>
            <div id="new-container">
                <div class="modal-title">New Family</div>
                <form id="new-form" action=${resource(file:'Family/save')} method="POST">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <div class="modal-row">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyNoteTextarea" class="noteTextarea" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div id="new-savebutton" type="button" onclick="JavaScript:saveFamily();">Save</div>
                </div>
            </div>
    </body>
</html>