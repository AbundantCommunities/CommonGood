<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
        <script src="${resource(dir:'js',file:'encoder.js')}"></script>
        <script type="text/javascript">
            function emailAll() {
                var emails = 'mailto:';
                Encoder.EncodeType = "entity";
                <g:if test="${connectors.size() > 0}">
                    <g:each in="${connectors}" var="bc" status="i">
                        <g:if test="${bc.emailAddress.size() > 0}">
                            <g:if test="${i>0}">
                                emails = emails.concat(",");
                            </g:if>
                            emails = emails.concat(Encoder.htmlDecode("${bc.emailAddress}"));
                        </g:if>
                    </g:each>
                </g:if>
                <g:else>
                    alert('No Block Connectors to email to.');
                </g:else>
                document.location.href = emails;
            }
        </script>
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

            <div id="content-children" style="padding-bottom:10px;">
                <div style="margin-top:-15px;"><h3>Block Connector Contact List for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of Block Connectors in neighbourhood: ${BCCount}<g:if test="${BCCount>0}"> (<a href="#" onclick="emailAll();">email all</a>)</g:if></h4></div>
                <g:if test="${connectors.size()>0}">
                    <div id="content-children-heading">
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
                                <div class="cell300"><a href="mailto:${bc.emailAddress}">${bc.emailAddress}</a></div>
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
    </body>
</html>