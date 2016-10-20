<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>CommonGood Block Connectors</title>
        <asset:javascript src="copy2clipboard.js"/>

        <script type="text/javascript">

            function doEmailAllBCs() {

                var atLeastOneEmailAddress = false;
                var emails = '';
                <g:if test="${connectors.size() > 0}">
                    <g:each in="${connectors}" var="bc" status="i">
                        <g:if test="${bc.emailAddress.size() > 0}">
                            <g:if test="${i>0}">
                                emails = emails.concat(",");
                            </g:if>
                            emails = emails.concat(decodeEntities("${bc.emailAddress}"));
                            atLeastOneEmailAddress = true;
                        </g:if>
                    </g:each>
                </g:if>
                <g:else>
                    alert('No Block Connectors to email to.');
                </g:else>

                if (atLeastOneEmailAddress) {
                    var numRows = 10;
                    var title = 'Email All Block Connectors';
                    var description = 'CommonGood cannot send email for you, but you can copy the email addresses to the clipboard and then paste to address a new message that you create the way you normally do.';
                    var copyContentTitle = 'Block Connector email addresses'
                    presentForCopy('emaildiv',emails,numRows,title,description,copyContentTitle);
                }

            }

            function doEmailOneBC(emailAddress) {
                if (emailAddress) {
                    var numRows = 1;
                    var title = 'Email Block Connector';
                    var description = 'CommonGood cannot send email for you, but you can copy the email address to the clipboard and then paste to address a new message that you create the way you normally do.';
                    var copyContentTitle = 'Block Connector email address'
                    presentForCopy('emaildiv',emailAddress,numRows,title,description,copyContentTitle);
                }
            }

        </script>

        <style type="text/css">

            #button-row-div {
                position: absolute;
                top:170px;
                left:20px;
            }

            #emaildiv {
                top:90px;
                left:200px;
                width:540px;
            }

        </style>

    </head>
    <body>
        <g:set var="currentBCId" value="" />
        <g:set var="BCCount" value="${0}" />
        <g:if test="${connectors.size()>0}">
            <g:each in="${connectors}" var="bc">
                <g:if test="${bc.id != currentBCId}">
                    <g:set var="BCCount" value="${BCCount+1}" />
                    <g:set var="currentBCId" value="${bc.id}" />
                </g:if>
            </g:each>
        </g:if>

            <div class="content-section">
                <div style="margin-top:-15px;"><h3>Block Connector Contact List for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of Block Connectors in neighbourhood: ${BCCount}<g:if test="${BCCount>0}"> (<a href="#" onclick="doEmailAllBCs();">email all</a>)</g:if></h4></div>
                <g:if test="${connectors.size()>0}">
                    <div id="content-row bold">
                        <div class="cell170">Block Connector</div>
                        <div class="cell140">Phone</div>
                        <div class="cell300">Email</div>
                        <div class="cell230">Block</div>
                    </div>
                    <g:set var="currentBCId" value="" />
                    <g:each in="${connectors}" var="bc">
                        <g:if test="${bc.id != currentBCId}">
                            <g:set var="BCCount" value="${BCCount+1}" />
                            <g:set var="currentBCId" value="${bc.id}" />
                            <div class="content-children-row">
                                <div class="cell170"><g:link controller="navigate" action="familymember" id="${bc.id}">${bc.firstNames} ${bc.lastName}</g:link></div>
                                <div class="cell140">${bc.phone}</div>
                                <div class="cell300"><a href="#" onclick="doEmailOneBC('${bc.emailAddress}');">${bc.emailAddress}</a></div>
                                <div class="cell230"><g:link controller="navigate" action="block" id="${bc.blockId}">(${bc.blockCode}) ${bc.blockDescription}</g:link></div>
                            </div>
                        </g:if>
                        <g:else>
                            <div class="content-children-row-no-line">
                                <div class="cell170"></div>
                                <div class="cell140"></div>
                                <div class="cell300"></div>
                                <div class="cell230"><g:link controller="navigate" action="block" id="${bc.blockId}">(${bc.blockCode}) ${bc.blockDescription}</g:link></div>
                            </div>
                        </g:else>

                    </g:each>
                </g:if>
            </div>
            <div id="transparent-overlay"></div>
            <div id="emaildiv" class="modal"></div>
    </body>
</html>