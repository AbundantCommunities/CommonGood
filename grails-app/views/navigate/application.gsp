<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <g:if test="${navChildren.childType.toLowerCase() == 'family'}">
            <script type="text/javascript">
                function presentFamilyModal() {
                    document.getElementById("add-edit-family-container").style.visibility='visible';
                }
                function dismissFamilyModal() {
                    document.getElementById("add-edit-family-container").style.visibility='hidden';
                }
            </script>
        </g:if>
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
                <div>Name: ${navSelection.description}</div>

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
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a <g:if test="${navChildren.childType.toLowerCase() == 'family'}">onclick="presentFamilyModal()"</g:if> href="#">+ Add New ${navChildren.childType}</a></div>
                <div id="content-children-heading">Name</div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
            <div id="footer">
                &copy;2016 The Abundant Community Initiative Canada.
            </div>
            <g:if test="${navChildren.childType.toLowerCase() == 'family'}">
                <div id="add-edit-family-container">
                    <p style="font-weight:bold;font-size:14px;">New Family</p>
                    <form action=${resource(file:'saveFamily')} method="post">
                        Family name: <input type="text" name="familyName" />
                        <br />
                        <input type="checkbox" name="permissionToContact" /> Permission to contact
                        <br />
                        <input type="checkbox" name="participateInInterview" /> Has agreed to interview
                        <br />

                        <input id="savebutton" type="submit" value="Save">
                    </form>
                    <button id="cancelbutton" type="button" onclick="JavaScript:dismissFamilyModal();">Cancel</button>
                </div>
            </g:if>
        </div>
    </body>
</html>