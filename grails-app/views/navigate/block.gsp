<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Block</title>

        <asset:stylesheet src="leaflet/leaflet.css"/>
        <asset:javascript src="leaflet/leaflet.js"/>

        <asset:javascript src="draw/Leaflet.draw.js"/>
        <asset:javascript src="draw/Leaflet.Draw.Event.js"/>
        <asset:stylesheet src="draw/leaflet.draw.css"/>

        <asset:javascript src="draw/Toolbar.js"/>
        <asset:javascript src="draw/Tooltip.js"/>

        <asset:javascript src="draw/ext/GeometryUtil.js"/>
        <asset:javascript src="draw/ext/LatLngUtil.js"/>
        <asset:javascript src="draw/ext/LineUtil.Intersect.js"/>
        <asset:javascript src="draw/ext/Polygon.Intersect.js"/>
        <asset:javascript src="draw/ext/Polyline.Intersect.js"/>
        <asset:javascript src="draw/ext/TouchEvents.js"/>

        <asset:javascript src="draw/draw/DrawToolbar.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Feature.js"/>
        <asset:javascript src="draw/draw/handler/Draw.SimpleShape.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Polyline.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Marker.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Circle.js"/>
        <asset:javascript src="draw/draw/handler/Draw.CircleMarker.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Polygon.js"/>
        <asset:javascript src="draw/draw/handler/Draw.Rectangle.js"/>


        <asset:javascript src="draw/edit/EditToolbar.js"/>
        <asset:javascript src="draw/edit/handler/EditToolbar.Edit.js"/>
        <asset:javascript src="draw/edit/handler/EditToolbar.Delete.js"/>

        <asset:javascript src="draw/Control.Draw.js"/>

        <asset:javascript src="draw/edit/handler/Edit.Poly.js"/>
        <asset:javascript src="draw/edit/handler/Edit.SimpleShape.js"/>
        <asset:javascript src="draw/edit/handler/Edit.Rectangle.js"/>
        <asset:javascript src="draw/edit/handler/Edit.Marker.js"/>
        <asset:javascript src="draw/edit/handler/Edit.CircleMarker.js"/>
        <asset:javascript src="draw/edit/handler/Edit.Circle.js"/>
        <style type="text/css">
            #mapid { height: 400px; }
        </style>
        <script type="text/javascript">

            <g:if test="${authorized.canWrite()==Boolean.TRUE}">
            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function populateEditModal() {
                    document.getElementById('blockCodeInput').value = decodeEntities("${navSelection.block.code}");
                    document.getElementById('blockDescriptionInput').value = decodeEntities("${navSelection.block.description}");

                }

                function presentEditModal() {
                    var pagecontainerDiv = document.getElementById("pagecontainer");

                    // set height of overlay to match height of pagecontainer height
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");

                    <g:if test="${navSelection.block.neighbourhood.hasFeature('gismaps')}">
                    setup_edit_map();
                    </g:if>
                    populateEditModal();
                    
                    // show overlay and new-container divs and focus to family name
                    document.getElementById("transparent-overlay").style.visibility='visible';
                    document.getElementById("edit-container").style.visibility='visible';
                    document.getElementById("blockCodeInput").focus();
                    document.getElementById("blockCodeInput").select();
                }

                function dismissEditModal() {
                    document.getElementById("edit-container").style.visibility='hidden';
                    document.getElementById("transparent-overlay").style.visibility='hidden';
                    <g:if test="${navSelection.block.neighbourhood.hasFeature('gismaps')}">
                    cancel_edit_block();
                    </g:if>
                }


                function blockIsValid(code,description) {
                    if (code == "") {
                        alert("Please enter a code for the new block.");
                        return false;
                    }
                    if (code.length > 255) {
                        alert("The block code cannot exceed 255 characters in length.");
                        return false;
                    }
                    if (description.length > 255) {
                        alert("The block description cannot exceed 255 characters in length.");
                        return false;
                    }
                    return true;
                }


                function saveBlock() {
                    var blockCode = document.getElementById('blockCodeInput').value.trim();
                    var blockDescription = document.getElementById('blockDescriptionInput').value.trim();
                    if (blockIsValid(blockCode,blockDescription)) {
                        dismissEditModal();

                        document.getElementById("blockCodeInput").value = blockCode;
                        document.getElementById("blockDescriptionInput").value = blockDescription;

                        <g:if test="${navSelection.block.neighbourhood.hasFeature('gismaps')}">
                        var blockPolygonArray = [];

                        if (editBoundaryPoly != null) {

                            for (i=0;i<editBoundaryPoly.getLatLngs()[0].length;i++) {
                                blockPolygonArray.push([editBoundaryPoly.getLatLngs()[0][i].lng,editBoundaryPoly.getLatLngs()[0][i].lat]);
                            }

                        }

                        var blockPolygonJSON = JSON.stringify(blockPolygonArray);

                        document.getElementById("blockBoundaryInput").value = blockPolygonJSON;
                        </g:if>

                        document.getElementById('edit-form').submit();
                    }
                }

            </g:if>


            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("addressesInput").value = "";

                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // show overlay and new-container divs and focus to family name
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("new-container").style.visibility='visible';
                document.getElementById("addressesInput").focus();
            }

            function dismissNewModal() {
                document.getElementById("new-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }


            function trimTrailingReturns(addresses) {
                var trimedAddresses = addresses;
                if (trimedAddresses.length > 0) {
                    if (trimedAddresses.charCodeAt(trimedAddresses.length-1) == 10) {
                        var done = false;
                        var i = trimedAddresses.length-1;
                        while (!done) {
                            trimedAddresses = trimedAddresses.substr(0,trimedAddresses.length-1);
                            if (trimedAddresses.length == 0 || trimedAddresses.charCodeAt(trimedAddresses.length-1) != 10) {
                                done = true;
                            }
                        }
                    }
                }
                return trimedAddresses;
            }


            function addAddresses() {
                // trim trailing returns.
                var addresses = trimTrailingReturns(document.getElementById('addressesInput').value);

                // make sure at least one line (address).
                if (addresses.length > 0) {
                    if (addresses.length <= 255) {
                        document.getElementById('addressesInput').value = addresses;
                        document.getElementById("new-form").submit();
                    } else {
                        alert('The total length of the addresses you enter cannot exceed 255 characters.');
                    }
                } else {
                    alert('Please enter at least one address.');
                }
            }

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function presentAddBC() {

                    var xmlhttp = new XMLHttpRequest( );
                    var url = '<g:createLink controller="neighbourhood" action="blocks"/>/${navContext[0].id}';
                    
                    xmlhttp.onreadystatechange = function( ) {
                        if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                            var blocks = JSON.parse( xmlhttp.responseText );
                            buildBlocksSelect( blocks );
                        }
                    };

                    xmlhttp.open( "GET", url, true );
                    xmlhttp.send( );

                    function buildBlocksSelect( blocks ) {

                        var optionToSelect = 0;

                        var blocksSelect = document.getElementById('blocks-select')
                        blocksSelect.options.length = 0;

                        for (i = 0; i < blocks.length; i++) {
                            var selectText;
                            if (blocks[i].description.length > 0) {
                                selectText = blocks[i].code+' ('+blocks[i].description+')';
                            } else {
                                selectText = blocks[i].code;
                            }
                            blocksSelect.options[blocksSelect.options.length] = new Option(selectText, blocks[i].id);

                            if (blocks[i].id == ${navSelection.block.id}) {
                                optionToSelect = i;
                            }
                        }

                        blocksSelect.selectedIndex = optionToSelect;

                    }

                    var addressesSelect = document.getElementById('addresses-select');

                    if (addressesSelect.options[0].value != 0) {
                        // Need to add blank disabled option as first option

                        var blankAddress = new Option('',0);
                        blankAddress.disabled = true;

                        addressesSelect.insertBefore(blankAddress, addressesSelect.firstChild);
                    }

                    document.getElementById('addresses-select').selectedIndex = 0;
                    document.getElementById('select-family').style.display = 'none';
                    document.getElementById('select-member').style.display = 'none';

                    var pagecontainerDiv = document.getElementById("pagecontainer");

                    // set height of overlay to match height of pagecontainer height
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                    
                    // show overlay and new-container divs and focus to family name
                    document.getElementById("transparent-overlay").style.visibility='visible';
                    document.getElementById("new-bc-container").style.visibility='visible';

                }


                function dismissAddBCModal() {
                    document.getElementById("new-bc-container").style.visibility='hidden';
                    document.getElementById("transparent-overlay").style.visibility='hidden';
                }


                function blockSelected() {

                    document.getElementById('select-family').style.display = 'none';
                    document.getElementById('select-member').style.display = 'none';

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

                        document.getElementById('select-address').style.display = 'block';

                    }

                }




                function addressSelected() {

                    document.getElementById('select-member').style.display = 'none';

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

                        document.getElementById('select-family').style.display = 'block';

                    }
                }

                function familySelected() {

                    // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                    var familiesSelect = document.getElementById('families-select');
                    if (familiesSelect.options[0].value == 0) {
                        familiesSelect.remove(0);
                    }

                    var xmlhttp = new XMLHttpRequest( );
                    var url = '<g:createLink controller="family" action="members"/>/'+document.getElementById('families-select').value;

                    xmlhttp.onreadystatechange = function( ) {
                        if( xmlhttp.readyState == 4 /* && xmlhttp.status == 200 */ ) {
                            var members = JSON.parse( xmlhttp.responseText );
                            buildMembersSelect( members );
                        }
                    };

                    xmlhttp.open( "GET", url, true );
                    xmlhttp.send( );

                    function buildMembersSelect( members ) {
                        var membersSelect = document.getElementById('members-select')
                        membersSelect.options.length = 0;

                        membersSelect.options[membersSelect.options.length] = new Option('', 0);
                        membersSelect.options[membersSelect.options.length-1].disabled = true;

                        for (i = 0; i < members.length; i++) {
                            membersSelect.options[membersSelect.options.length] = new Option(members[i].name, members[i].id);
                        }

                        document.getElementById('select-member').style.display = 'block';

                    }

                }

                function memberSelected() {
                    // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                    var membersSelect = document.getElementById('members-select');
                    if (membersSelect.options[0].value == 0) {
                        membersSelect.remove(0);
                    }
                }

                function personIsNotExistingBC(personId) {
                    if (existingBCs.length > 0) {
                        for (i=0;i<existingBCs.length;i++) {
                            if (personId == existingBCs[i]) {
                                return false;
                            }
                        }
                    }
                    return true;
                }

                function addBC() {
                    if (document.getElementById('addresses-select').value > 0) {
                        if (document.getElementById('families-select').value > 0) {
                            if (document.getElementById('members-select').value > 0) {
                                if (personIsNotExistingBC(document.getElementById('members-select').value)) {
                                    document.getElementById('new-bc-container').style.visibility = false;
                                    document.getElementById('transparent-overlay').style.visibility = false;
                                    document.getElementById('new-bc-form').submit();
                                } else {
                                    alert ('The person you selected is already a Block Connector for the block.');
                                }
                            } else {
                                alert ('Please select the block connector.');
                            }
                        } else {
                            alert ("Please select the block connector's family.");
                        }
                    } else {
                        alert("Please select the block connector's address.");
                    }
                }

                function revokeBC(which) {
                    var bcId = which.id.split('|')[1];
                    var blockId = which.id.split('|')[2];
                    document.getElementById('revoke-bc-id').value = bcId;
                    document.getElementById('revoke-bc-block-id').value = blockId;
                    document.getElementById('revoke-form').submit();
                }

            </g:if>
            </g:if>

            <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
            var addressLatLngs = [];
            </g:if>

            window.onload = function onWindowLoad() {
                // Need to set height of block detail section based on current number of block connectors and NC vs BC authorization.

                var numBCs = ${navSelection.blockConnectors.size()};
                if (numBCs == 0) {
                    numBCs = 1;
                }

                var newHeight = 14 /* space above first BC */ + (numBCs*20) + 20 /* space below last BC, not including '+ Add BC' button */;

                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                    newHeight = newHeight + 20;

                </g:if>

                document.getElementById("block-detail").setAttribute("style","min-height:94px;height:"+newHeight+"px;");
            }


        </script>
        <style type="text/css">

            #button-row-div {
                position: absolute;
                top:170px;
                left:20px;
            }

            <g:if test="${authorized.canWrite()==Boolean.TRUE}">
            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                #new-bc-container {
                    top:140px;
                    left:200px;
                    width:540px;
                }

                #edit-container {
                    top:70px;
                    left:180px;
                    width:570px;
                }

            </g:if>

            #new-container {
                top:90px;
                left:260px;
                width:420px;
            }
            </g:if>
            #bc-section {
                position: absolute;
                top:7px;
                left:500px;
            }

            #editmapid { height: 380px;  }


        </style>
    </head>
    <body>
            <div id="block-detail" class="content-section">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>

                <div class="content-row">
                    <div class="content-row-item" style="width:210px;">Block code: </div><div class="content-row-item">${navSelection.block.code}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:210px;">Description: </div><div class="content-row-item">${navSelection.block.description}</div>
                </div>

                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}">
                    <div id="content-actions-left-side">
                        <div class="content-left-action"><g:link controller='block' action='contactList' id='${navSelection.block.id}'>Contact List</g:link></div>
                        <div class="content-left-action">&nbsp;</div>
                    </div>

                    <div id="content-actions">
                        <div class="content-action"><a href="#" onclick="presentEditModal();">Edit</a></div>
                        <div class="content-action"><g:link controller="Delete" action="confirmBlock" id="${navSelection.block.id}">Delete</g:link></div>
                    </div>
                </g:if>
                <g:else>
                    <div id="content-actions" style="left:820px;">
                        <div class="content-action"><g:link controller='block' action='contactList' id='${navSelection.block.id}'>Contact List</g:link></div>
                    </div>
                </g:else>

                <div id="bc-section">
                    <div class="content-heading less-bottom-margin">Block Connector<g:if test="${navSelection.blockConnectors.size() > 1}">s</g:if></div>
                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}"><script type="text/javascript">var existingBCs = [];</script></g:if>
                    <g:if test="${navSelection.blockConnectors.size() > 0}">
                        <g:each in="${navSelection.blockConnectors}" var="bc" status="i">
                            <div style="height:20px;"><g:link controller='Navigate' action='familymember' id='${bc.id}'>${bc.fullName}</g:link><g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}"> <span style="font-size:smaller;">(<a id="revoke|${bc.id}|${navSelection.block.id}" href="#" onclick="revokeBC(this);">revoke</a>)</span></g:if></div>
                            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}"><script type="text/javascript">existingBCs.push(${bc.id});</script></g:if>
                        </g:each>
                        <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                            <form id="revoke-form" action="<g:createLink controller='authorization' action='deauthorizeBlockConnector'/>" method="POST">
                                <input id="revoke-bc-id" type="hidden" name="id"/>
                                <input id="revoke-bc-block-id" type="hidden" name="blockId"/>
                            </form>
                        </g:if>
                    </g:if>
                    <g:else>
                        <div class="bc light-text" >no assigned block connector</div>
                    </g:else>

                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE && authorized.canWrite()==Boolean.TRUE}">
                        <g:if test="${navSelection.blockConnectors.size() > 0}">
                            <div class="small-top-margin"><a href="#" onclick="presentAddBC();">+ Add Another Block Connector</a></div>
                        </g:if>
                        <g:else>
                            <div class="small-top-margin"><a href="#" onclick="presentAddBC();">+ Add Block Connector</a></div>
                        </g:else>
                    </g:if>
                </div>

            </div>
            <div class="content-section">
                <div class="content-heading">Addresses for ${navSelection.levelInHierarchy} ${navSelection.block.description}<g:if test="${authorized.canWrite()==Boolean.TRUE}">&nbsp;&nbsp;<a href="#" onclick="presentNewModal();" style="font-weight:normal;">+ Add New Addresses</a></g:if></div>
                <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
                <div id="listWithHandle" style="width:500px;display:inline-block;vertical-align:top;">
                </g:if>
                <g:else>
                <div id="listWithHandle" style="width:900px;display:inline-block;vertical-align:top;">
                </g:else>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div <g:if test="${authorized.canWrite()==Boolean.TRUE}">id="${child.id}"</g:if> class="content-children-row">
                            <g:if test="${authorized.canWrite()==Boolean.TRUE}"><span class="drag-handle"><asset:image src="reorder-row.png" width="18" height="18" style="vertical-align:middle;"/></span></g:if>
                            <g:link controller='Navigate' action='${navChildren.childType.toLowerCase()}' id='${child.id}'>${child.text}</g:link>:
                            <g:if test="${child.families.size()>0}">
                            <g:each in="${child.families}" var="family" status="i">
                                <g:link controller='Navigate' action='family' id='${family.id}'><g:if test="${!family.interviewed}"><span style='font-weight:bold'></g:if>${family.name}<g:if test="${!family.interviewed}"></span></g:if></g:link><g:if test="${i+1<child.families.size()}">,</g:if>
                            </g:each>
                            </g:if>
                            <g:else>
                                 <span class="light-text">no family entered for address</span>
                            </g:else>
                        </div>
                        <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')==Boolean.TRUE}">
                        <script type="text/javascript">
                            var addressLatLng = {lat:${child.latitude}, lng:${child.longitude}};
                            addressLatLngs.push(addressLatLng);
                        </script>
                        </g:if>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no addresses</div>
                </g:else>
                </div>


                <g:if test="${navSelection.block.neighbourhood.hasFeature('gismaps')}">
                <div style="display:inline-block;width:400px;"><div style="border:solid gray;"><div id="mapid"></div></div><div id="mapcaption" style="margin:10px;font-size:small;"></div></div>
                <script type="text/javascript">

                    var boundaryType = '${navSelection.boundary.type}';
                    var boundary = [
                        <g:each in="${navSelection.boundary.coordinates}" var="coord" status="i">
                            [${coord.getY()},${coord.getX()}],
                        </g:each>
                    ];

                    if (boundaryType != 'nada') {
                        var map = L.map('mapid');

                        var boundaryPoly;
                        var invertedPoly;

                        if (boundaryType=='neighbourhood' || boundaryType=='block') {
                            boundaryPoly = L.polygon(boundary);
                        }

                        if (boundaryType=='block') {
                            // add inverted polygon to map
                            invertedPoly = L.polygon(
                                [[[90, -180],
                                 [90, 180],
                                 [-90, 180],
                                 [-90, -180]], //outer ring, the world
                                 boundaryPoly.getLatLngs()],
                                 {opacity:0.4} // cutout
                                );

                            map.addLayer(invertedPoly);

                        } else { // neighbourhood, so add caption about block boundary
                            document.getElementById('mapcaption').innerHTML = 'The boundary for the block has not been specified. <span><a href="JavaScript:presentEditModal();">Edit</a></span> the block to specify its boundary.'
                        }

                        map.fitBounds(boundaryPoly.getBounds());

                        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                            maxZoom: 19,
                            id: 'mapbox/streets-v11',
                            accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                        }).addTo(map);

                        // add markers for any address lat/lngs
                        if (addressLatLngs.length > 0) {
                            for (i=0;i<addressLatLngs.length;i++) {
                                L.circleMarker(L.latLng(addressLatLngs[i].lat,addressLatLngs[i].lng), {radius:4}).addTo(map);
                            }
                        }


                    } else {
                        document.getElementById('mapid').style = "position:relative;";
                        document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                    }

                </script>
                </g:if>  <%-- End of test for featureFlag gismaps --%>


                <div class="content-children-row"></div>
                <form id="reorder-form" action="<g:createLink controller='Block' action='reorder' />" method="POST">
                    <input id="reorder-this-id" type="hidden" name="addressId" value=""/>
                    <input id="reorder-after-id" type="hidden" name="afterId" value=""/>
                </form>
            </div>
            <div id="transparent-overlay">
            </div>
            <g:if test="${authorized.canWrite()==Boolean.TRUE}">
            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                <div id="new-bc-container" class="modal" style="height:205px;z-index:2001;">
                    <div class="modal-title">Add Block Connector</div>
                    <div id="select-block" class="modal-row">Select block that the Block Connector lives on: 
                        <select id="blocks-select" onchange="blockSelected();">
                            <option value=""></option>
                        </select>
                    </div>
                    <div id="select-address" class="modal-row">Select address of Block Connector: 
                        <select id="addresses-select" onchange="addressSelected();">
                            <option value="0"></option>
                            <g:each in="${navChildren.children}" var="child">
                                <option value="${child.id}">${child.text}</option>
                            </g:each>
                        </select>
                        <script type="text/javascript">
                            document.getElementById('addresses-select').options[0].disabled = true;
                        </script>

                    </div>
                    <div id="select-family" class="modal-row">Select family of Block Connector: 
                        <select id="families-select" onchange="familySelected();">
                            <option value=""></option>
                        </select>
                    </div>
                    <form id="new-bc-form" action="<g:createLink controller='block' action='addBlockConnector' />" method="POST">
                        <div id="select-member" class="modal-row">Select Block Connector: 
                            <select id="members-select" name="pid" onchange="memberSelected();">
                                <option value=""></option>
                            </select>
                        </div>
                        <input type="hidden" name="id" value="${navSelection.block.id}" />
                    </form>
                    <div id="button-row-div">
                        <div class="button-row">
                            <div class="button" onclick="JavaScript:dismissAddBCModal();">Cancel</div>
                            <div class="button-spacer"></div>
                            <div class="button bold" type="button" onclick="JavaScript:addBC();">Add</div>
                        </div>
                    </div>
                </div>

                <g:if test="${navSelection.block.neighbourhood.hasFeature('gismaps')}">
                <div id="edit-container" class="modal" style="z-index:2001;">
                    <div class="modal-title">Edit Block</div>
                    <form id="edit-form" action="<g:createLink controller='block' action='save' />" method="POST">
                        <input type="hidden" name="id" value="${navSelection.block.id}" />
                        <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                        <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                        <input id="blockBoundaryInput" type="hidden" name="boundary" value="" />
                    </form>
                    <div style="height:474px;border:black solid 2px;background-color:gray;padding:5px;margin-top:10px;">
                        <div id="editmapid"></div>
                        <div id="editmapbuttons" style="width:150px;height:90px;display:inline-block;padding-right:10px;border-right:white solid 1px;margin-top:5px;">
                            <div id="draw_button" class="button-small" style="width:110px;" onclick="javascript:drawStart();">Draw Block Boundary</div>
                            <div id="done_drawing_button" class="button-small" style="width:110px;" onclick="javascript:drawDone();">Done Drawing</div>
                            <div id="cancel_drawing_button" class="button-small" style="width:110px;" onclick="javascript:drawCancel();">Cancel Drawing</div>
                            <div id="edit_button" class="button-small" style="width:110px;" onclick="javascript:editStart()">Edit Block Boundary</div>
                            <div id="done_editing_button" class="button-small" style="width:110px;" onclick="javascript:editDone()">Done Editing</div>
                            <div id="start_over_button" class="button-small" style="width:110px;" onclick="javascript:startOver()">Start Over</div>
                            <div id="done_button" class="button-small" style="width:110px;" onclick="javascript:done()">done</div>
                        </div>
                        <div id="editmapinstructions" style="display:inline-block;vertical-align:top;margin-top:5px;font-family:sans-serif;font-size:small;color:white;word-wrap: normal;">
                            <div id="help_text_div" style="width:330px;margin-left:10px;">To draw the block's boundary, start by clicking the 'Draw Block Boundary' button.</div>
                        </div>
                    </div>


                    <div class="button-row">
                        <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                        <div class="button-spacer"></div>
                        <div class="button bold" onclick="JavaScript:saveBlock();">Save</div>
                    </div>
                </div>
                <script type="text/javascript">
                    if (boundaryType!='nada') {
                        var editmap = L.map('editmapid');

                        var editBoundaryPoly = null;
                        var editInvertedPoly = null;

                        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                            maxZoom: 19,
                            id: 'mapbox/streets-v11',
                            accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                        }).addTo(editmap);



                        editmap.on('draw:created', function (e) {
                            editBoundaryPoly = e.layer;
                            polygonDrawer.disable();

                            document.getElementById('help_text_div').innerHTML = "To edit the block's boundary, click the 'Edit Block Boundary' button. To start over click the 'Start Over' buttton.";
                            document.getElementById('done_drawing_button').style.display = 'none';
                            document.getElementById('cancel_drawing_button').style.display = 'none';
                            document.getElementById('edit_button').style.display = '';
                            document.getElementById('start_over_button').style.display = '';

                            invert_and_fit();

                        });
                    }

                    function setup_edit_map() {
                        if (boundaryType!='nada') {
                            if (boundaryType=='neighbourhood' || boundaryType=='block') {
                                editBoundaryPoly = L.polygon(boundary);
                            }

                            if (boundaryType=='block') {
                                // add inverted polygon to map
                                editInvertedPoly = L.polygon(
                                    [[[90, -180],
                                     [90, 180],
                                     [-90, 180],
                                     [-90, -180]], //outer ring, the world
                                     boundaryPoly.getLatLngs()], // cutout
                                     {opacity:0.4}
                                    );

                                editmap.addLayer(editInvertedPoly);
                            }

                            editmap.fitBounds(editBoundaryPoly.getBounds());

                            if (boundaryType=='neighbourhood') {
                                editBoundaryPoly = null;
                            }

                            init_map_ui();
                        }
                    }

                    function cancel_edit_block() {
                        if (boundaryType!='nada') {
                            if (editmap.hasLayer(editBoundaryPoly)) {
                                editmap.removeLayer(editBoundaryPoly);
                            }
                            if (editmap.hasLayer(editInvertedPoly)) {
                                editmap.removeLayer(editInvertedPoly);
                            }
                        }
                    }

                    function init_map_ui() {
                        if (boundaryType=='block' && editBoundaryPoly != null) {
                            document.getElementById('help_text_div').innerHTML = "To edit the block's boundary, click the 'Edit Block Boundary' button. To start over click the 'Start Over' buttton.";
                            document.getElementById('draw_button').style.display = 'none';
                            document.getElementById('done_drawing_button').style.display = 'none';
                            document.getElementById('cancel_drawing_button').style.display = 'none';
                            document.getElementById('edit_button').style.display = '';
                            document.getElementById('done_editing_button').style.display = 'none';
                            document.getElementById('start_over_button').style.display = '';
                            document.getElementById('done_button').style.display = 'none';
                        } else {
                            document.getElementById('help_text_div').innerHTML = "To draw the block's boundary, start by clicking the 'Draw Block Boundary' button.";
                            document.getElementById('draw_button').style.display = '';
                            document.getElementById('done_drawing_button').style.display = 'none';
                            document.getElementById('cancel_drawing_button').style.display = 'none';
                            document.getElementById('edit_button').style.display = 'none';
                            document.getElementById('done_editing_button').style.display = 'none';
                            document.getElementById('start_over_button').style.display = 'none';
                            document.getElementById('done_button').style.display = 'none';
                        }
                    }

                    function drawStart() {
                        document.getElementById('help_text_div').innerHTML = "Click points to draw a path around the block's boundary. To complete the boundary, click the first point or click the 'Done Drawing' button. To cancel drawing, click the 'Cancel Drawing' button.";
                        document.getElementById('draw_button').style.display = 'none';
                        document.getElementById('done_drawing_button').style.display = '';
                        document.getElementById('cancel_drawing_button').style.display = '';
                        editInvertedPoly = null;
                        polygonDrawer.enable();
                    }

                    function drawDone() {
                        polygonDrawer.completeShape();
                    }


                    function drawCancel() {
                        //polygonDrawer.completeShape();
                        polygonDrawer.disable();
                        init_map_ui();
                    }


                    function editStart() {

                        invert_to_edit();
                        editmap.fitBounds(editBoundaryPoly.getLatLngs());

                        document.getElementById('help_text_div').innerHTML = "To move a point on the block's boundary path, click and drag it. To delete a point on the path, simply click it. To add a new point to the path, click and drag the square mid-point on the path where you would like to add a new point. When done editing, clikc the 'Done Editing' button.";
                        document.getElementById('edit_button').style.display = 'none';
                        document.getElementById('start_over_button').style.display = 'none';
                        document.getElementById('done_editing_button').style.display = '';
                        editHandler._enableLayerEdit(editBoundaryPoly);

                    }

                    function editDone() {
                        editBoundaryPoly.editing.disable();

                        editmap.removeLayer(editBoundaryPoly);


                        document.getElementById('help_text_div').innerHTML = "To edit the block's boundary, click the 'Edit Block Boundary' button. To start over click the 'Start Over' buttton.";
                        document.getElementById('done_editing_button').style.display = 'none';
                        document.getElementById('edit_button').style.display = '';
                        document.getElementById('start_over_button').style.display = '';

                        invert_and_fit();
                    }


                    function startOver() {
                        editmap.removeLayer(editInvertedPoly);
                        editBoundaryPoly = null;
                        editInvertedPoly = null;
                        init_map_ui();
                    }

                    function done() {
                        if (editBoundaryPoly != null) {
                            editmap.fitBounds(editBoundaryPoly.getLatLngs());
                        }
                    }


                    function invert_and_fit() {

                        editInvertedPoly = L.polygon(
                            [[[90, -180],
                             [90, 180],
                             [-90, 180],
                             [-90, -180]], //outer ring, the world
                             editBoundaryPoly.getLatLngs()], // cutout
                             {opacity:0.4}
                            );


                        editmap.addLayer(editInvertedPoly);

                        editmap.fitBounds(editBoundaryPoly.getLatLngs());

                    }


                    function invert_to_edit() {
                        editmap.removeLayer(editInvertedPoly);
                        editmap.addLayer(editBoundaryPoly);
                    }


                    if (boundaryType!='nada') {
                        var polygonDrawer = new L.Draw.Polygon(editmap);

                        // disable the original edit toolbar so that there aren't two ways to edit layers
                        drawControl = new L.Control.Draw({edit: false});

                        editFeatureGroup = L.featureGroup();

                        // manually create an edit toolbar (which won't be visible) when the page loads
                        toolbar = new L.EditToolbar({
                          featureGroup: editFeatureGroup
                        })

                        // and get its edit handler (this should probably be done with a loop like in the OP)
                        editHandler = toolbar.getModeHandlers()[0].handler;

                        init_map_ui();
                    } else {
                        document.getElementById('editmapid').style = "position:relative;";
                        document.getElementById('editmapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                        document.getElementById('editmapbuttons').style = "border:solid 0px;";
                        document.getElementById('editmapbuttons').innerHTML = '';
                        document.getElementById('editmapinstructions').innerHTML = '';
                    }

                </script>
                </g:if>
                <g:else>
                <div id="edit-container" class="modal" style="z-index:2001;">
                    <div class="modal-title">Edit Block</div>
                    <form id="edit-form" action="<g:createLink controller='block' action='save' />" method="POST">
                        <input type="hidden" name="id" value="${navSelection.block.id}" />
                        <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                        <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                    </form>
                    <div class="button-row">
                        <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                        <div class="button-spacer"></div>
                        <div class="button bold" onclick="JavaScript:saveBlock();">Save</div>
                    </div>
                </div>
                </g:else>
            </g:if>

            <div id="new-container" class="modal" style="z-index:2001;">
                <div class="modal-title">New Addresses</div>
                <div class="footnote">Add multiple addresses by pressing Return after each.</div>
                <form id="new-form" action="<g:createLink controller='block' action='addAddresses' />" method="POST">
                    <input type="hidden" name="id" value="${navSelection.block.id}" />
                    <div class="modal-row">Addresses: <br/><textarea id="addressesInput" class="note-style" name="addresses" cols=56 rows=8></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:addAddresses();">Save</div>
                </div>
            </div>
            </g:if>
    </body>
</html>