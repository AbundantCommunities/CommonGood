<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Block</title>
        <script type="text/javascript">

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function populateEditModal() {
                    document.getElementById('blockCodeInput').value = decodeEntities("${navSelection.code}");
                    document.getElementById('blockDescriptionInput').value = decodeEntities("${navSelection.description}");
                }

                function presentEditModal() {
                    var pagecontainerDiv = document.getElementById("pagecontainer");

                    // set height of overlay to match height of pagecontainer height
                    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");

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
                }


                function blockIsValid(code,description) {
                    if (code == "") {
                        alert("Please enter a block code.");
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
                    document.getElementById('addressesInput').value = addresses;
                    document.getElementById("new-form").submit();
                } else {
                    alert('Please enter at least one address.');
                }
            }

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function presentAddBC() {

                    var xmlhttp = new XMLHttpRequest( );


                    var url = '<g:createLink controller="address" action="families"/>/'+document.getElementById('addresses-select').value;

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

                            if (blocks[i].id == ${navSelection.id}) {
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

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                #new-bc-container {
                    top:140px;
                    left:200px;
                    width:540px;
                }

                #edit-container {
                    top:90px;
                    left:280px;
                    width:370px;
                }

            </g:if>

            #new-container {
                top:90px;
                left:260px;
                width:420px;
            }
            #bc-section {
                position: absolute;
                top:7px;
                left:400px;
            }

        </style>
    </head>
    <body>
            <div id="block-detail" class="content-section">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>

                <div class="content-row">
                    <div class="content-row-item" style="width:210px;">Block code: </div><div class="content-row-item">${navSelection.code}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:210px;">Description: </div><div class="content-row-item">${navSelection.description}</div>
                </div>

                <div id="bc-section">

                    <div class="content-heading less-bottom-margin">Block Connector<g:if test="${navSelection.blockConnectors.size() > 1}">s</g:if></div>
                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}"><script type="text/javascript">var existingBCs = [];</script></g:if>
                    <g:if test="${navSelection.blockConnectors.size() > 0}">
                        <g:each in="${navSelection.blockConnectors}" var="bc" status="i">
                            <div style="height:20px;"><g:link controller='Navigate' action='familymember' id='${bc.id}'>${bc.fullName}</g:link><g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}"> <span style="font-size:smaller;">(<a id="revoke|${bc.id}|${navSelection.id}" href="#" onclick="revokeBC(this);">revoke</a>)</span></g:if></div>
                            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}"><script type="text/javascript">existingBCs.push(${bc.id});</script></g:if>
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

                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                        <g:if test="${navSelection.blockConnectors.size() > 0}">
                            <div class="small-top-margin"><a href="#" onclick="presentAddBC();">+ Add Another Block Connector</a></div>
                        </g:if>
                        <g:else>
                            <div class="small-top-margin"><a href="#" onclick="presentAddBC();">+ Add Block Connector</a></div>
                        </g:else>
                    </g:if>

                </div>


                <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                    <div id="content-actions-left-side">
                        <div class="content-left-action"><g:link controller='block' action='contactList' id='${navSelection.id}'>Contact List</g:link></div>
                    </div>

                    <div id="content-actions">
                        <div class="content-action"><a href="#" onclick="presentEditModal();">Edit</a></div>
                        <div class="content-action"><g:link controller="Delete" action="confirmBlock" id="${navSelection.id}">Delete</g:link></div>
                    </div>
                </g:if>
                <g:elseif test="${authorized.forBlock()==Boolean.TRUE}">
                    <div id="content-actions" style="left:820px;">
                        <div class="content-action"><g:link controller='block' action='contactList' id='${navSelection.id}'>Contact List</g:link></div>
                    </div>
                </g:elseif>

            </div>
            <div class="content-section">
                <div class="content-heading">Addresses for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal();" style="font-weight:normal;">+ Add New Addresses</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                <div <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">id="listWithHandle"</g:if>>
                    <g:each in="${navChildren.children}" var="child">
                        <div <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">id="${child.id}"</g:if> class="content-children-row">
                            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}"><span class="drag-handle"><asset:image src="reorder-row.png" width="18" height="18" style="vertical-align:middle;"/></span></g:if>
                            <g:link controller='Navigate' action='${navChildren.childType.toLowerCase()}' id='${child.id}'>${child.address}</g:link>:
                            <g:if test="${child.families.size()>0}">
                            <g:each in="${child.families}" var="family" status="i">
                                <g:link controller='Navigate' action='family' id='${family.id}'><g:if test="${!family.interviewed}"><span style='font-weight:bold'></g:if>${family.name}<g:if test="${!family.interviewed}"></span></g:if></g:link><g:if test="${i+1<child.families.size()}">,</g:if>
                            </g:each>
                            </g:if>
                            <g:else>
                                 <span class="light-text">no family entered for address</span>
                            </g:else>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no addresses</div>
                </g:else>
                </div>
                <div class="content-children-row"></div>
                <form id="reorder-form" action="<g:createLink controller='Block' action='reorder' />" method="POST">
                    <input id="reorder-this-id" type="hidden" name="addressId" value=""/>
                    <input id="reorder-after-id" type="hidden" name="afterId" value=""/>
                </form>
            </div>
            <div id="transparent-overlay">
            </div>

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                <div id="new-bc-container" class="modal" style="height:205px;">
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
                                <option value="${child.id}">${child.address}</option>
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
                        <input type="hidden" name="id" value="${navSelection.id}" />
                    </form>
                    <div id="button-row-div">
                        <div class="button-row">
                            <div class="button" onclick="JavaScript:dismissAddBCModal();">Cancel</div>
                            <div class="button-spacer"></div>
                            <div class="button bold" type="button" onclick="JavaScript:addBC();">Add</div>
                        </div>
                    </div>
                </div>

                <div id="edit-container" class="modal">
                    <div class="modal-title">Edit Block</div>
                    <form id="edit-form" action="<g:createLink controller='block' action='save' />" method="POST">
                        <input type="hidden" name="id" value="${navSelection.id}" />
                        <div class="modal-row">Block code: <input id="blockCodeInput" type="text" name="code" value=""/></div>
                        <div class="modal-row">Block description: <input id="blockDescriptionInput" type="text" name="description" value=""/></div>
                    </form>
                    <div class="button-row">
                        <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                        <div class="button-spacer"></div>
                        <div class="button bold" onclick="JavaScript:saveBlock();">Save</div>
                    </div>
                </div>

            </g:if>

            <div id="new-container" class="modal">
                <div class="modal-title">New Addresses</div>
                <div class="footnote">Add multiple addresses by pressing Return after each.</div>
                <form id="new-form" action="<g:createLink controller='block' action='addAddresses' />" method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Addresses: <br/><textarea id="addressesInput" class="note-style" name="addresses" cols=56 rows=8></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:addAddresses();">Save</div>
                </div>
            </div>

    </body>
</html>