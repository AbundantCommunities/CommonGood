<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Public Inbox</title>
        <script type="text/javascript">

            <g:if test="${authorized.canWrite()==Boolean.TRUE}">
            function deleteSelected() {
                document.getElementById("inboxHeader").style.display = "none";
                document.getElementById("confirmDeleteHeader").style.display = "block";

                document.getElementById("headerDeleteCheckbox").style.visibility = "hidden";

                var checkboxElements = document.getElementsByClassName("deleteCheckbox");
                for (i=0; i<checkboxElements.length; i++) {
                    if (!checkboxElements[i].checked) {
                        var uncheckedRowElement = document.getElementById("row"+i);
                        uncheckedRowElement.style.display = "none";
                    } else {
                        checkboxElements[i].disabled = true;
                    }
                }
            }

            function doDeleteSelected() {

                var allIds = "";
                var checkboxElements = document.getElementsByClassName("deleteCheckbox");

                for (i=0; i<checkboxElements.length; i++) {
                    if (checkboxElements[i].checked) {
                        if (allIds != "") {
                            allIds = allIds+"|";
                        }
                        allIds = allIds+checkboxElements[i].name;
                    }
                }

                var allIdsFormInputElement = document.getElementById("deleteIds-input");
                allIdsFormInputElement.value = allIds;

                document.getElementById("delete-form").submit();

            }

            function cancelDeleteSelected() {
                document.getElementById("inboxHeader").style.display = "block";
                document.getElementById("confirmDeleteHeader").style.display = "none";

                document.getElementById("headerDeleteCheckbox").style.visibility = "visible";


                var allChecked = true;
                var atLeastOneChecked = false;
                var checkboxElements = document.getElementsByClassName("deleteCheckbox");

                for (i=0; i<checkboxElements.length; i++) {
                    checkboxElements[i].disabled = false;
                    var uncheckedRowElement = document.getElementById("row"+i);
                    uncheckedRowElement.style.display = "block";

                    if (checkboxElements[i].checked) {
                        atLeastOneChecked = true;
                    } else {
                        allChecked = false;
                    }

                }

                var selectAllCheckbox = document.getElementById("headerDeleteCheckbox");
                selectAllCheckbox.checked = allChecked;

                var deleteButton = document.getElementById("deleteButton");
                if (atLeastOneChecked) {
                    deleteButton.style.display = "block";
                } else {
                    deleteButton.style.display = "none";
                }

            }

            function selectAllClicked() {
                var selectAllCheckbox = document.getElementById("headerDeleteCheckbox");
                var selectAllCheckboxChecked = selectAllCheckbox.checked;
                var checkboxElements = document.getElementsByClassName("deleteCheckbox");
                for (i=0; i<checkboxElements.length; i++) {
                    checkboxElements[i].checked = selectAllCheckboxChecked;
                }
                if (selectAllCheckboxChecked) {
                    deleteButton.style.display = "block";
                } else {
                    deleteButton.style.display = "none";
                }
            }

            function checkboxClicked() {
                var checkboxElements = document.getElementsByClassName("deleteCheckbox");
                var allChecked = true;
                var atLeastOneChecked = false;
                for (i=0; i<checkboxElements.length; i++) {
                    if (checkboxElements[i].checked) {
                        atLeastOneChecked = true;
                    } else {
                        allChecked = false;
                    }
                }
                var selectAllCheckbox = document.getElementById("headerDeleteCheckbox");
                selectAllCheckbox.checked = allChecked;

                var deleteButton = document.getElementById("deleteButton");
                if (atLeastOneChecked) {
                    deleteButton.style.display = "block";
                } else {
                    deleteButton.style.display = "none";
                }
            }
            </g:if>

        </script>
    </head>
    <body>
            <div id="inbox" class="content-section">
                <div style="margin-top:-15px;"><h3>Public Inbox for ${session.neighbourhood.name}</h3></div>
                <div id="inboxHeader" style="display:block;">
                    <div style="margin-top:-10px;"><h4>Number of messages in inbox: ${requests.size()}</h4></div>
                    <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                    <div id="deleteButton" class="button" onclick="JavaScript:deleteSelected();" style="top:20px;right:10px;position:absolute;display:none;">Delete Selected Messages</div>
                    </g:if>
                </div>
                <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                <div id="confirmDeleteHeader" style="display:none;">
                    <div style="margin-top:-10px;"><h4>Confirm deletion of messages below.</h4></div>
                    <div class="button" onclick="JavaScript:cancelDeleteSelected();" style="top:20px;right:270px;position:absolute;">Cancel</div>
                    <div class="button" onclick="JavaScript:doDeleteSelected();" style="top:20px;right:10px;position:absolute;">Permanently Delete Messages</div>
                </div>
                </g:if>
                <div class="content-row bold">
                    <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                    <div class="cell20"><input id="headerDeleteCheckbox" type="checkbox" name="" value="" onclick="javascript:selectAllClicked();"/></div>
                    </g:if>
                    <div class="cell100">Date</div>
                    <div class="cell80">Time</div>
                    <div class="cell170">Neighbour</div>
                    <div class="cell130">Context</div>
                    <div class="cell350">Message</div>
                </div>
                <g:if test="${requests.size()>0}">
                <g:each in="${requests}" var="request" status="row">
                    <div id="row${row}" class="content-children-row">
                        <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                        <div class="cell20"><input id="request${row}" class="deleteCheckbox" type="checkbox" name="${request.id}" value="" onclick="javascript:checkboxClicked();"/></div>
                        </g:if>
                        <div class="cell100"><g:formatDate format="yyyy-MM-dd" date="${request.dateCreated}" /></div>
                        <div class="cell80"><g:formatDate date="${request.dateCreated}" type="time" style="SHORT" /></div>
                        <div class="cell170">${request.residentName}<g:if test="${request.homeAddress.trim().size()>0}"><br>${request.homeAddress}</g:if><g:if test="${request.phoneNumber.trim().size()>0}"><br>${request.phoneNumber}</g:if><g:if test="${request.emailAddress.trim().size()>0}"><br>${request.emailAddress}</g:if></div>
                        <div class="cell130">${request.requestContext}</div>
                        <div class="cell350">${request.comment}</div>
                    </div>
                </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row">
                    <div class="cell20"></div>
                        <div class="cell100 light-text">no messages</div>
                    </div>
                </g:else>
                <div class="content-children-row"></div>

                <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                <form id="delete-form" action="<g:createLink controller='anonymousRequest' action='delete' method='POST'/>">
                    <input type="hidden" id="deleteIds-input" name="deleteIds" />
                </form>
                </g:if>

            </div>
    </body>
</html>