<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Block</title>
        <script type="text/javascript">

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                function populateEditModal() {
                    Encoder.EncodeType = "entity";
                    document.getElementById('blockCodeInput').value = Encoder.htmlDecode("${navSelection.code}");
                    document.getElementById('blockDescriptionInput').value = Encoder.htmlDecode("${navSelection.description}");
                    document.getElementById('orderWithinNeighbourhoodInput').value = "${navSelection.orderWithinNeighbourhood}";
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

                

                function orderOk(order) {
                    if (order.length == 0) {
                        return false;
                    } else {
                        for (i=0; i<order.length; i++) {
                            if ('0123456789'.indexOf(order.substr(i,1)) < 0) {
                                return false;
                            }
                        }
                    }
                    return true;
                }

                function blockIsValid(code,description,order) {
                    if (code == "") {
                        alert("Please enter a block code.");
                        return false;
                    } else {
                        if (description == "") {
                            alert("Please enter a block description.");
                            return false;
                        } else {
                            if (!orderOk(order)) {
                                alert("Please enter a valid order. Must be a number.");
                                return false;
                            }
                        }
                    }
                    return true;
                }

                function saveBlock() {
                    var blockCode = document.getElementById('blockCodeInput').value.trim();
                    var blockDescription = document.getElementById('blockDescriptionInput').value.trim();
                    var order = document.getElementById('orderWithinNeighbourhoodInput').value.trim();
                    if (blockIsValid(blockCode,blockDescription,order)) {
                        dismissEditModal();

                        document.getElementById("blockCodeInput").value = blockCode;
                        document.getElementById("blockDescriptionInput").value = blockDescription;
                        document.getElementById("orderWithinNeighbourhoodInput").value = order;
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
                    if (${navChildren.children.size() > 0}) {

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
                    } else {
                        alert('Please add the address, family and family member of the block connector first.');
                    }
                }


                function dismissAddBCModal() {
                    document.getElementById("new-bc-container").style.visibility='hidden';
                    document.getElementById("transparent-overlay").style.visibility='hidden';
                }

                function addressSelected() {

                    document.getElementById('select-member').style.display = 'none';

                    // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                    var addressesSelect = document.getElementById('addresses-select');
                    if (addressesSelect.options[0].value == 0) {
                        addressesSelect.remove(0);
                    }

                    if (addressesSelect.value == -2) {
                        // User chose "address not in list", so put up alert saying address must be added first
                        var blankAddress = new Option('',0);
                        blankAddress.disabled = true;

                        addressesSelect.insertBefore(blankAddress, addressesSelect.firstChild);
                        addressesSelect.selectedIndex = 0;

                        document.getElementById('select-family').style.display = 'none';
                        alert("Before adding a block connector, you must add the block connector's address, family and family member to the block.");

                    } else {
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
                top:130px;
                left:20px;
            }

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                #new-bc-container {
                    top:140px;
                    left:260px;
                    width:420px;
                }

                #select-address {
                    position: absolute;
                    top:35px;
                    left: 20px;
                }
                #select-family {
                    position: absolute;
                    top:65px;
                    left: 20px;
                    display: none;
                }
                #select-member {
                    position: absolute;
                    top:95px;
                    left: 20px;
                    display: none;
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
                <div class="content-row">
                    <div class="content-row-item" style="width:210px;">Order within neighbourhood: </div><div class="content-row-item">${navSelection.orderWithinNeighbourhood}</div>
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
                            <form id="revoke-form" action="<g:createLink controller='authorization' action='deauthorizeBlockConnector'/>" method="DELETE">
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
                        <div class="content-action"><a href="#" onclick="alert('not yet implemented');">Delete</a></div>
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
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row">
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
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>

            <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">

                <div id="new-bc-container" class="modal" style="height:165px;">
                    <div class="modal-title">Add Block Connector</div>
                    <div class="modal-row">Select address of block connector: 
                        <select id="addresses-select" onchange="addressSelected();">
                            <option value="0"></option>
                            <g:each in="${navChildren.children}" var="child">
                                <option value="${child.id}">${child.address}</option>
                            </g:each>
                            <option value="-1"></option>
                            <option value="-2">Address not listed</option>
                        </select>
                        <script type="text/javascript">
                            document.getElementById('addresses-select').options[0].disabled = true;
                        </script>

                    </div>
                    <div id="select-family" class="modal-row">Select family of block connector: 
                        <select id="families-select" onchange="familySelected();">
                            <option value=""></option>
                        </select>
                    </div>
                    <form id="new-bc-form" action="<g:createLink controller='person' action='setBlockConnector' />" method="POST">
                        <div id="select-member" class="modal-row">Select block connector: 
                            <select id="members-select" name="id" onchange="memberSelected();">
                                <option value=""></option>
                            </select>
                        </div>
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
                        <div class="modal-row">Order within neighbourhood: <input id="orderWithinNeighbourhoodInput" type="text" name="orderWithinNeighbourhood" value="" size="12"/></div>
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