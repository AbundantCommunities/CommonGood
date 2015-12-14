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
        div.myCell2 {
            display: inline-block;
            width: 150px;
        }
        div.myCell3 {
            display: inline-block;
            width: 220px;
        }
        div.myCell4 {
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
        div.myCell10 {
            display: inline-block;
            width: 80px;
        }
        
            </style>
    </head>
    <body>
        <div><h2>Welcome ${result.ncName}, Neighbourhood Connector for ${result.nhName}.</h2></div>
        <div><h3>Number of block connectors in neighbourhood: ${result.connectors.size()}</h3></div>
        <div class="myRow">
            <div class="myCell2" style="font-weight: bold;">Block Connector</div>
            <div class="myCell3" style="font-weight: bold;">Email</div>
            <div class="myCell4" style="font-weight: bold;">Phone</div>
            <div class="myCell6" style="font-weight: bold;">First Interview</div>
            <div class="myCell7" style="font-weight: bold;">Last Interview</div>
            <div class="myCell8" style="font-weight: bold;"># Families</div>
            <div class="myCell10" style="font-weight: bold;"># Declined</div>
        </div>
        <g:each in="${result.connectors}" var="bc">
            <div class="myCell2">${bc.bcName}</div>
            <div class="myCell3">${bc.bcEmail}</div>
            <div class="myCell4">${bc.bcPhone}</div>
            <div class="myCell6"><g:formatDate format="yyyy-MM-dd" date="${bc.firstInterview}"/></div>
            <div class="myCell7"><g:formatDate format="yyyy-MM-dd" date="${bc.lastInterview}"/></div>
            <div class="myCell8">${bc.numFamilies}</div>
            <div class="myCell10">${bc.numDeclined}</div>
            </p>
        </g:each>
    </body>
</html>