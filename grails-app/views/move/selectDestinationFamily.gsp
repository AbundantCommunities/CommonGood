<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Move Family Member</title>


        <script type="text/javascript">

            function doMove() {

                var blockSelect = document.getElementById('blocks-select');
                if (blockSelect.options[0].value == 0) {
                    alert('Please select a block.');
                } else {
                    var addressSelect = document.getElementById('addresses-select');
                    if (addressSelect.options[0].value == 0) {
                        alert('Please select an address.');
                    } else {
                        var familySelect = document.getElementById('families-select');
                        if (familySelect.options[0].value == 0) {
                            alert('Please select a family');
                        } else {
                            document.getElementById('move-form').submit();
                        }
                    }
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

                document.getElementById('select-family').style.visibility = 'hidden';

                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="block" action="addresses"/>/'+document.getElementById('blocks-select').value;

                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        var addresses = JSON.parse( xmlhttp.responseText );
                        buildAddressesSelect( addresses );
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function buildAddressesSelect( addresses ) {
                    var addressesSelect = document.getElementById('addresses-select')
                    addressesSelect.options.length = 0;

                    addressesSelect.options[addressesSelect.options.length] = new Option('', 0);
                    addressesSelect.options[addressesSelect.options.length-1].disabled = true;

                    for (i = 0; i < addresses.length; i++) {
                        addressesSelect.options[addressesSelect.options.length] = new Option(addresses[i].text, addresses[i].id);
                    }

                    document.getElementById('select-address').style.visibility = 'visible';

                }

            }




            function addressSelected() {

                // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                var addressesSelect = document.getElementById('addresses-select');
                if (addressesSelect.options[0].value == 0) {
                    addressesSelect.remove(0);
                }

                var xmlhttp = new XMLHttpRequest( );
                var url = '<g:createLink controller="address" action="families"/>/'+document.getElementById('addresses-select').value;
                xmlhttp.onreadystatechange = function( ) {
                    if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                        var families = JSON.parse( xmlhttp.responseText );
                        buildFamiliesSelect( families );
                    }
                };

                xmlhttp.open( "GET", url, true );
                xmlhttp.send( );

                function buildFamiliesSelect( families ) {
                    var familiesSelect = document.getElementById('families-select')
                    familiesSelect.options.length = 0;

                    familiesSelect.options[familiesSelect.options.length] = new Option('', 0);
                    familiesSelect.options[familiesSelect.options.length-1].disabled = true;

                    for (i = 0; i < families.length; i++) {
                        familiesSelect.options[familiesSelect.options.length] = new Option(families[i].name, families[i].id);
                    }

                    document.getElementById('select-family').style.visibility = 'visible';

                }
            }

            function familySelected() {

                // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                var familiesSelect = document.getElementById('families-select');
                if (familiesSelect.options[0].value == 0) {
                    familiesSelect.remove(0);
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

                document.getElementById('select-address').style.visibility = 'hidden';
                document.getElementById('select-family').style.visibility = 'hidden';

            }

        </script>

    </head>
    <body>
            <div class="content-section content-container">
                <div class="content-section-embedded" style="width:560px;">
                    <div style="margin-top:-15px;"><h3>Move Family Member</h3></div>

                        <div class="content-row">Select the family to move family member <span class="bold">${moveThis}</span> to:</div>
                        <div class="content-space-row">&nbsp;</div>

                        <div id="select-block" class="modal-row">Select block the family member has moved to: 
                            <select id="blocks-select" onchange="blockSelected();">
                                <option value=""></option>
                            </select>
                        </div>
                        <div id="select-address" class="modal-row">Select address the family member has moved to: 
                            <select id="addresses-select" onchange="addressSelected();">
                                <option value=""></option>
                            </select>
                        </div>

                        <form id="move-form" action="<g:createLink controller='move' action='person' />" method="GET">
                            <div id="select-family" class="modal-row">Select family the family member now belongs to: 
                                <select id="families-select" name="fid" onchange="familySelected();">
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