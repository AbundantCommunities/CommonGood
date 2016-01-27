<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">
            function emailAll() {
                alert('not yet implemented');
                var emails = '';
                <g:if test="${result.connectors.size() > 0}">
                    <g:each in="${result.connectors}" var="bc" status="i">
                        <g:if test="${bc.bcEmail.size() > 0}">
                        </g:if>
                    </g:each>
                </g:if>

                //document.location.href = "mailto:xyz@something.com";
            }
        </script>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">
                <div style="margin-top:-15px;"><h3>Block Connector Summary for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of block connectors in neighbourhood: ${result.connectors.size()} (<a href="#" onclick="emailAll();">email all</a>)</h4></div>
                <div id="content-children-heading">
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
                        <div class="cell230">${bc.bcEmail}</div>
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