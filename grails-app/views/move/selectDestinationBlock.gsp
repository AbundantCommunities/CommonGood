<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Move Address</title>


        <script type="text/javascript">

            function doMove() {

                var blockSelect = document.getElementById('blocks-select');
                if (blockSelect.options[0].value == 0) {
                    alert('Please select a block.');
                } else {
                    document.getElementById('move-form').submit();
                }

            }


            function doCancel() {
                // Cancel delete person.

                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="move" action="cancel"/>';
                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        // no response expected
                        completeCancel();
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function completeCancel() {
                    document.getElementById('cancel-form').submit();
                }
            }


            function blockSelected() {

                var blockSelect = document.getElementById('blocks-select');
                if (blockSelect.options[0].value == 0) {
                    blockSelect.remove(0);
                }

            }



            window.onload = function onWindowLoad() {

                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="neighbourhood" action="blocks"/>/${nid}';

                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        var blocks = JSON.parse( xmlhttp.responseText );
                        buildBlocksSelect( blocks );
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function buildBlocksSelect( blocks ) {

                    var blocksSelect = document.getElementById('blocks-select')
                    blocksSelect.options.length = 0;

                    blocksSelect.options[blocksSelect.options.length] = new Option('', 0);
                    blocksSelect.options[blocksSelect.options.length-1].disabled = true;

                    for (i = 0; i < blocks.length; i++) {
                        var selectText;
                        if (blocks[i].description.length > 0) {
                            selectText = blocks[i].code+' ('+blocks[i].description+')';
                        } else {
                            selectText = blocks[i].code;
                        }
                        blocksSelect.options[blocksSelect.options.length] = new Option(selectText, blocks[i].id);

                    }

                    blocksSelect.selectedIndex = 0;

                }

            }

        </script>

    </head>
    <body>
            <div class="content-section content-container">
                <div class="content-section-embedded" style="width:560px;">
                    <div style="margin-top:-15px;"><h3>Move Address</h3></div>

                        <div class="content-row">Select the block to move address <span class="bold">${moveThis}</span> to:</div>
                        <div class="content-space-row">&nbsp;</div>

                        <form id="move-form" action="<g:createLink controller='move' action='address' />" method="GET">
                            <div id="select-block" class="modal-row">Select block the address has moved to: 
                                <select id="blocks-select" name="bid" onchange="blockSelected();">
                                    <option value=""></option>
                                </select>
                            </div>
                            <input type="hidden" name="id" value="${id}" />
                            <input type="hidden" name="magicToken" value="${magicToken}"/>
                        </form>

                        <div class="content-space-row">&nbsp;</div>

                        <div class="button-row center"><a href="#" onclick="doCancel();"><div class="button bold" >Cancel</div></a><div class="button-spacer"></div><a href="#" onclick="doMove();"><div class="button">Move</div></a></div>

                        <form id="cancel-form" action="<g:createLink controller='navigate' action='${session.lastNavigationLevel}' id='${session.lastNavigationId}'/>" method="GET">
                        </form>

                </div>
            </div>
    </body>
</html>