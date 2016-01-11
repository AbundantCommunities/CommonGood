<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">
            var col1=[];
            var col2=[];
            var col3=[];
            var col4=[];
            var col5=[];
            var col6=[];
            var col7=[];
            var col8=[];
            var col9=[];
            var col10=[];

            function showBCs() {
                for (i = 0; i < col7.length; i++) {
                    col2[i].style.display='inline-block';
                    col3[i].style.display='inline-block';
                    col4[i].style.display='inline-block';

                    col5[i].style.display='none';
                    col6[i].style.display='none';
                    col7[i].style.display='none';
                    col8[i].style.display='none';
                    col9[i].style.display='none';
                    col10[i].style.display='none';
                }
            }

            function showStats() {
                for (i = 0; i < col7.length; i++) {
                    col2[i].style.display='none';
                    col3[i].style.display='none';
                    col4[i].style.display='none';

                    col5[i].style.display='inline-block';
                    col6[i].style.display='inline-block';
                    col7[i].style.display='inline-block';
                    col8[i].style.display='inline-block';
                    col9[i].style.display='inline-block';
                    col10[i].style.display='inline-block';
                }
            }


        </script>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">
                <div style="margin-top:-15px;"><h3>Block Summary for ${session.neighbourhood.name}</h3></div>
                <div style="margin-top:-10px;"><h4>Number of blocks in neighbourhood: ${result.blocks.size()}</h4></div>
                <div style="margin-top:-10px;margin-bottom:15px;">
                    Show: 
                    <input type="radio" name="optradio" onclick="showBCs();" checked>Block Connectors</input>
                    <input type="radio" name="optradio" onclick="showStats();">Block Stats</input>
                </div>
                <div id="content-children-heading">
                    <div id="col1row0" class="cell60">Block</div>
                    <div id="col2row0" class="cell150">Block Connector</div>
                    <div id="col3row0" class="cell110">Phone</div>
                    <div id="col4row0" class="cell230">Email</div>
                    <div id="col5row0" class="cell140">First Interview</div>
                    <div id="col6row0" class="cell140">Last Interview</div>
                    <div id="col7row0" class="cell100">Families</div>
                    <div id="col8row0" class="cell100">Interviews</div>
                    <div id="col9row0" class="cell100">Declined</div>
                    <div id="col10row0" class="cell100">Remaining</div>
                    <script type="text/javascript">
                        col1.push(document.getElementById('col1row0'));
                        col2.push(document.getElementById('col2row0'));
                        col3.push(document.getElementById('col3row0'));
                        col4.push(document.getElementById('col4row0'));
                        col5.push(document.getElementById('col5row0'));
                        col6.push(document.getElementById('col6row0'));
                        col7.push(document.getElementById('col7row0'));
                        col8.push(document.getElementById('col8row0'));
                        col9.push(document.getElementById('col9row0'));
                        col10.push(document.getElementById('col10row0'));
                    </script>
                </div>
                <g:each in="${result.blocks}" var="block" status="row">
                    <div class="content-children-row">
                        <div id="col1row${row+1}" style="display: inline-block;width: 60px;">${block.code}</div>
                        <div id="col2row${row+1}" style="display: inline-block;width: 150px;">${block.bcName}</div>
                        <div id="col3row${row+1}" style="display: inline-block;width: 110px;">${block.bcPhone}</div>
                        <div id="col4row${row+1}" style="display: inline-block;width: 230px;">${block.bcEmail}</div>
                        <div id="col5row${row+1}" style="display: inline-block;width: 140px;"><g:formatDate format="yyyy-MM-dd" date="${block.firstInterview}"/></div>
                        <div id="col6row${row+1}" style="display: inline-block;width: 140px;"><g:formatDate format="yyyy-MM-dd" date="${block.lastInterview}"/></div>
                        <div id="col7row${row+1}" style="display: inline-block;width: 100px;">${block.numFamilies}</div>
                        <div id="col8row${row+1}" style="display: inline-block;width: 100px;">${block.numInterviews}</div>
                        <div id="col9row${row+1}" style="display: inline-block;width: 100px;">${block.numDeclined}</div>
                        <div id="col10row${row+1}" style="display: inline-block;width: 100px;">${block.numRemaining}</div>
                        <script type="text/javascript">
                            col1.push(document.getElementById('col1row${row+1}'));
                            col2.push(document.getElementById('col2row${row+1}'));
                            col3.push(document.getElementById('col3row${row+1}'));
                            col4.push(document.getElementById('col4row${row+1}'));
                            col5.push(document.getElementById('col5row${row+1}'));
                            col6.push(document.getElementById('col6row${row+1}'));
                            col7.push(document.getElementById('col7row${row+1}'));
                            col8.push(document.getElementById('col8row${row+1}'));
                            col9.push(document.getElementById('col9row${row+1}'));
                            col10.push(document.getElementById('col10row${row+1}'));
                        </script>
                    </div>
                </g:each>
                <script type="text/javascript">
                    showBCs();
                </script>
            </div>
    </body>
</html>