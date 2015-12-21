<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">
            function presentNewModal() {
                document.getElementById("new-container").style.visibility='visible';
            }
            function dismissNewModal() {
                document.getElementById("new-container").style.visibility='hidden';
            }
        </script>
        <style type="text/css">
            #new-container {
                position:absolute;;
                top:100px;
                left:300px;
                width:330px;
                height:350px;
                padding:20px;
                padding-top: 10px;
                box-shadow: 0px 0px 20px #000000;
                background-color: #FFFFFF;
                border-radius:5px;
                border-width: 2px;
                border-color: #B48B6A;
                border-style: solid;
                visibility:hidden;
            }
            input#new-savebutton{
                position: absolute;
                left:180px;
                top:340px;
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
                top:340px;
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
                    <div class="content-action"><a href="#">Search</a></div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">${navChildren.childType+'s'} for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a onclick="presentNewModal()" href="#">+ Add New ${navChildren.childType}</a></div>
                <div id="content-children-heading">Name</div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
            </div>
            <div id="footer">
                &copy;2015 Common Good, A Society for Connected Neighbourhoods. All rights reserved.
            </div>
            <div id="new-container">
                <p style="font-weight:bold;font-size:14px;">New Family</p>
                <form action=${resource(file:'saveFamily')} method="post">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <p>Family name: <input type="text" name="name" /></p>
                    <p>Initial interview date: <input type="date" name="interviewDate" placeholder="MM/DD/YYYY"/></p>
                    <p>Initial interviewer: <input type="text" name="interviewer"/></p>
                    <p><input type="checkbox" name="permissionToContact" /> Permission to contact</p>
                    <p><input type="checkbox" name="participateInInterview" /> Has agreed to interview</p>
                    <p>Order within address: <input type="text" name="orderWithinAddress" /></p>
                    <p>Note:</p>
                    <p><textarea name="note" cols=44 rows=4></textarea></p>
                    <input id="new-savebutton" type="submit" value="Save">
                </form>
                <button id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</button>
            </div>


        </div>
    </body>
</html>