<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Block Summary</title>
    </head>
    <body>
            <div class="content-section">
                <div style="margin-top:-15px;"><h3>Block Summary for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of blocks in neighbourhood: ${result.blocks.size()}</h4></div>
                <div class="content-row bold">
                    <div class="cell250">Block</div>
                    <div class="cell130">First Interview</div>
                    <div class="cell130">Last Interview</div>
                    <div class="cell80">Families</div>
                    <div class="cell100">Interviews</div>
                    <div class="cell80">Declined</div>
                    <div class="cell100">Remaining</div>
                </div>
                <g:each in="${result.blocks}" var="block" status="row">
                    <div class="content-children-row">
                        <div class="cell250"><g:link controller="navigate" action="block" id="${block.id}">(${block.code}) ${block.description}</g:link></div>
                        <div class="cell130"><g:formatDate format="yyyy-MM-dd" date="${block.firstInterview}"/></div>
                        <div class="cell130"><g:formatDate format="yyyy-MM-dd" date="${block.lastInterview}"/></div>
                        <div class="cell80">${block.numFamilies}</div>
                        <div class="cell100">${block.numInterviews}</div>
                        <div class="cell80">${block.numDeclined}</div>
                        <div class="cell100">${block.numRemaining}</div>
                    </div>
                </g:each>
                <script type="text/javascript">
                    showBCs();
                </script>
            </div>
    </body>
</html>