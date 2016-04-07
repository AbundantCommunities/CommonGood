<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Address</title>
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
            #edit-container {
                top:90px;
                left:300px;
                width:330px;
            }

            #new-container {
                top:90px;
                left:300px;
                width:330px;
            }
        </style>

    </head>

    <body>
            <div class="content-section">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>
                <div class="content-row">
                    <div class="content-row-item" style="width:145px;">Address: </div><div class="content-row-item">${navSelection.description}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:145px;">Order within block: </div><div class="content-row-item">${navSelection.orderWithinBlock}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:145px;">Note: </div><div class="content-row-item"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#" onclick="presentEditModal();">Edit</a></div>
                    <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Delete</a></div>
                </div>
            </div>
            <div class="content-section">
                <div class="content-heading">Families for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a onclick="presentNewModal();" href="#" style="font-weight:normal;">+ Add New ${navChildren.childType}</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row"><g:link controller='Navigate' action='${navChildren.childType.toLowerCase()}' id='${child.id}'>${child.name}</g:link></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no families</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>
            <div id="edit-container" class="modal">
                <div class="modal-title">Edit Address</div>
                <form id="edit-form" action="<g:createLink controller='Address' action='save'/>" method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Address: <input id="addressTextInput" type="text" name="text" value="" style="width:70%;"/></div>
                    <div class="modal-row">Order within block: <input id="orderWithinBlockInput" type="text" name="orderWithinBlock" value="" size="12"/></div>
                    <div class="modal-row">Note: <br/><textarea id="addressNoteTextarea" class="note-style" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveAddress();">Save</div>
                </div>
            </div>
            <div id="new-container" class="modal">
                <div class="modal-title">New Family</div>
                <form id="new-form" action="<g:createLink controller='Family' action='save'/>" method="POST">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <div class="modal-row">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyNoteTextarea" class="note-style" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button bold" onclick="JavaScript:saveFamily();">Save</div>
                </div>
            </div>
    </body>
</html>