<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Common Good</title>
        <meta name="description" content="Common Good likes to connect neighbourhoods." />
        <style type="text/css">
            body {
                font-family: "Helvetica";
                font-size: small;
            }
        div.myRow {
            display: block;
            height: 20px;
        }
        div.myRowHidden {
            display: none;
            height: 20px;
        }
        div.myCell1 {
            display: inline-block;
            width: 70px;
        }
        div.myCell2 {
            display: inline-block;
            width: 150px;
        }
        div.myCell3 {
            display: inline-block;
            width: 100px;
        }
        div.myCell4 {
            display: inline-block;
            width: 180px;
        }
        div.myCell5 {
            display: inline-block;
            width: 110px;
        }
        div.myCell6 {
            display: inline-block;
            width: 110px;
        }
        div.myCell7 {
            display: inline-block;
            width: 110px;
        }
        div.myCell8 {
            display: inline-block;
            width: 80px;
        }
        div.myCell9 {
            display: inline-block;
            width: 80px;
        }
        div.myCell10 {
            display: inline-block;
            width: 80px;
        }
        div.myCell11 {
            display: inline-block;
            width: 80px;
        }
        
            </style>
    </head>
    <body>
        <div><h2>Welcome ${result.ncName}, Neighbourhood Connector for ${result.nhName}.</h2></div>
        <div><h3>Number of blocks in neighbourhood: ${result.blocks.size()}</h3></div>
        <div class="myRow">
            <div class="myCell1" style="font-weight: bold;">Block</div>
            <div class="myCell2" style="font-weight: bold;">Block Connector</div>
            <div class="myCell3" style="font-weight: bold;">Phone</div>
            <div class="myCell4" style="font-weight: bold;">Email</div>
            <div class="myCell5" style="font-weight: bold;">Last Access</div>
            <div class="myCell6" style="font-weight: bold;">First Interview</div>
            <div class="myCell7" style="font-weight: bold;">Last Interview</div>
            <div class="myCell8" style="font-weight: bold;"># Families</div>
            <div class="myCell9" style="font-weight: bold;"># Interviews</div>
            <div class="myCell10" style="font-weight: bold;"># Declined</div>
            <div class="myCell11" style="font-weight: bold;"># Remaining</div>
        </div>
        <g:each in="${result.blocks}" var="block">
            <div class="myCell1">${block.code}</div>
            <div class="myCell2">${block.bcName}</div>
            <div class="myCell3">${block.bcPhone}</div>
            <div class="myCell4">${block.bcEmail}</div>
            <div class="myCell5"></div>
            <div class="myCell6"><g:formatDate format="yyyy-MM-dd" date="${block.firstInterview}"/></div>
            <div class="myCell7"><g:formatDate format="yyyy-MM-dd" date="${block.lastInterview}"/></div>
            <div class="myCell8">${block.numFamilies}</div>
            <div class="myCell9">${block.numInterviews}</div>
            <div class="myCell10">${block.numDeclined}</div>
            <div class="myCell11">${block.numRemaining}</div>
            </p>
        </g:each>
    </body>
</html>