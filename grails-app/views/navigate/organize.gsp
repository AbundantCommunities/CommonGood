<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
    </head>
    <body>
        <div id="pagecontainer">
            <div id="aci-logo-line">
                <img src="${resource(dir:'images',file:'aci-logo.png')}" />
                <div id="welcome-line">Welcome Mark Gordon <span id="sign-out"><a href="#">sign out</a> | <a href="#">account</a></span></div>
                <div id="role-line">Neighbourhood Connector for Bonnie Doon</div>
            </div>
            <div id="nav-path">
                <g:each in="${navContext}" var="oneLevel">
                    <span>${oneLevel.level}: <span style="font-weight:bold;"><a href="${resource(dir:'navigate/'+oneLevel.level.toLowerCase(),file:"${oneLevel.id}")}">${oneLevel.description}</a></span></span><span class="nav-path-space"></span>
                </g:each>
            </div>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>
                <div>Name: ${navSelection.description}</div>
                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#">+ Add New ${navChildren.childType}</a></div>
                <div id="content-children-heading">Name</div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
            <div id="footer">
                &copy;2015 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
        </div>
    </body>
</html>