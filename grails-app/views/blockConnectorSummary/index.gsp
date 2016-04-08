<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Block Connectors</title>
        <script type="text/javascript">
            function emailAll() {
                var emails = 'mailto:';
                Encoder.EncodeType = "entity";
                <g:if test="${result.connectors.size() > 0}">
                    <g:each in="${result.connectors}" var="bc" status="i">
                        <g:if test="${bc.bcEmail.size() > 0}">
                            <g:if test="${i>0}">
                                emails = emails.concat(",");
                            </g:if>
                            emails = emails.concat(Encoder.htmlDecode("${bc.bcEmail}"));
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
            <div class="content-section">
                <div style="margin-top:-15px;"><h3>Block Connector Contact List for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of block connectors in neighbourhood: ${result.connectors.size()} (<a href="#" onclick="emailAll();">email all</a>)</h4></div>
                <div id="content-row bold">
                    <div class="cell150">Block Connector</div>
                    <div class="cell230">Email</div>
                    <div class="cell110">Phone</div>
                    <div class="cell100">First Int</div>
                    <div class="cell100">Last Int</div>
                    <div class="cell80">Families</div>
                    <div class="cell80">Declined</div>
                </div>
                <g:each in="${result.connectors}" var="bc">
                    <div class="content-children-row">
                        <div class="cell150">${bc.bcName}</div>
                        <div class="cell230"><a href="mailto:${bc.bcEmail}">${bc.bcEmail}</a></div>
                        <div class="cell110">${bc.bcPhone}</div>
                        <div class="cell100"><g:formatDate format="yyyy-MM-dd" date="${bc.firstInterview}"/></div>
                        <div class="cell100"><g:formatDate format="yyyy-MM-dd" date="${bc.lastInterview}"/></div>
                        <div class="cell80">${bc.numFamilies}</div>
                        <div class="cell80">${bc.numDeclined}</div>
                        </p>
                    </div>
                </g:each>
            </div>
    </body>
</html>