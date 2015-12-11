<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton"/>
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <script type="text/javascript">
            function myFunction() {
                document.getElementById("add-edit-container").style.visibility='visible';
            }
        </script>
    </head>
    <body>
        <div id="pagecontainer" style="width:1230px;">
            <div style="margin-left:15px;padding-top:5px;"><h2>Block Summary for ${result.nhName}.</h2></div>
            <div style="margin-left:15px;margin-top:15px;"><h3>Number of blocks in neighbourhood: ${result.blocks.size()}</h3></div>
            <div id="content-children" style="width:1190px;padding-bottom:10px;">
                <div id="content-children-heading">
                    <div class="cell60">Block</div>
                    <div class="cell140">Block Connector</div>
                    <div class="cell100">Phone</div>
                    <div class="cell190">Email</div>
                    <div class="cell110">First Interview</div>
                    <div class="cell110">Last Interview</div>
                    <div class="cell100"># Families</div>
                    <div class="cell100"># Interviews</div>
                    <div class="cell100"># Declined</div>
                    <div class="cell100"># Remaining</div>
                </div>
                <g:each in="${result.blocks}" var="block">
                    <div class="content-children-row">
                        <div class="cell60">${block.code}</div>
                        <div class="cell140">${block.bcName}</div>
                        <div class="cell100">${block.bcPhone}</div>
                        <div class="cell190">${block.bcEmail}</div>
                        <div class="cell110"><g:formatDate format="yyyy-MM-dd" date="${block.firstInterview}"/></div>
                        <div class="cell110"><g:formatDate format="yyyy-MM-dd" date="${block.lastInterview}"/></div>
                        <div class="cell100">${block.numFamilies}</div>
                        <div class="cell100">${block.numInterviews}</div>
                        <div class="cell100">${block.numDeclined}</div>
                        <div class="cell100">${block.numRemaining}</div>
                    </div>
                </g:each>
            </div>
            <br/>
        </div>
    </body>
</html>