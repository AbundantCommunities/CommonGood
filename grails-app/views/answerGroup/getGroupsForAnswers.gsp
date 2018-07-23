<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Put Answers into Group</title>

        <script type="text/javascript">

            function validate() {

                // If creating new group, validate group name.


                if (document.getElementById('new-group').checked) {
                    // new group, make sure group name is not blank
                    // TODO: more validation on group name

                    if (document.getElementById('new-group-input').value != '') {
                        return true;
                    } else {
                        alert("Please enter a name for the new group.");
                        return false;
                    }

                } else {
                    // an existing group must be selected
                    return true;
                }

            }


            function doGrouping() {
                if (validate()) {
                    document.getElementById('group-form').submit();
                }
            }

            function groupRadioClicked() {
                document.getElementById('new-group-input').value = "";
                document.getElementById('new-group-input').disabled = true;
            }

            function newGroupRadioSelected() {
                document.getElementById('new-group-input').disabled = false;
                document.getElementById('new-group-input').focus();
            }

            window.onload = function onWindowLoad() {
                document.getElementById('new-group').checked = true;
                document.getElementById('new-group-input').disabled = false;
                document.getElementById('new-group-input').focus();
            }

        </script>

    </head>
    <body>

            <div class="content-section">
                <div style="margin-top:-10px;"><h3>Put Answers into Group</h3></div>
                <div ><h3>Selected Answers</h3></div>

                <g:each in="${result.answers}" var="answer">
                    <div class="content-children-row">${answer.text}</div>
                </g:each>
                <div class="content-children-row">&nbsp;</div>

                <div ><h3>Groups</h3></div>

                <div>Create a new group or select an existing group, then click "Put in Group."</div>


                <form id="group-form" action="<g:createLink action='putAnswersInGroup' />" method="POST">
                    <input type="text" hidden name="answerIds" value="${result.answerIds}"><br/>

                    <div class="content-children-row" style="vertical-align:middle;">
                        <div class="cell20"><input id="new-group" type="radio" name="groupId" value="" onclick="newGroupRadioSelected();"/></div>
                        <div class="cell550"><input id="new-group-input" type="text" name="newGroupName" maxlength="30" placeholder="New Group Name" disabled/></div>
                    </div>

                    <g:each in="${result.groups}" var="group" status="i">
                    <div class="content-children-row">
                        <div class="cell20"><input id="group${i}" type="radio" name="groupId" value="${group.id}" onclick="groupRadioClicked();"/></div>
                        <div class="cell550">${group.name}</div>
                    </div>
                    </g:each>
                    <div class="content-children-row"></div>
                </form>
                <div class="button-row" style="margin-top:10px;">
                    <g:link><div class="button">Cancel</div></g:link>
                    <div class="button-spacer"></div>
                    <a href="#"><div class="button bold" onclick="doGrouping();">Put in Group</div></a>
                </div>
                <div>&nbsp;</div>

        </div>
    </body>
</html>
