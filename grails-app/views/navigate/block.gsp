<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">

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


            function addAddresses() {
                // Validate addresses
                if (document.getElementById('addressesInput').value.length > 0) {
                    document.getElementById("new-form").submit();
                } else {
                    alert('Please enter at least one address.');
                }
            }


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
                    alert('Please add the address of the block connector first.');
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
                    alert("Before adding a block connector, you must add the block connector's address to the block.");

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

                        familiesSelect.options[familiesSelect.options.length] = new Option('', -1);
                        familiesSelect.options[familiesSelect.options.length-1].disabled = true;
                        familiesSelect.options[familiesSelect.options.length] = new Option('Family not listed ...', -2);

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





                // Check if 'new ...' selected

                if (document.getElementById('families-select').value != -2) {

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

                        membersSelect.options[membersSelect.options.length] = new Option('', 0);
                        membersSelect.options[membersSelect.options.length-1].disabled = true;

                        membersSelect.options[membersSelect.options.length] = new Option('Person not listed', -2);

                        document.getElementById('select-member').style.display = 'block';

                    }

                } else {

                    // User chose "Family not listed", so put up alert saying family must be added first
                    var blankMember = new Option('',0);
                    blankMember.disabled = true;

                    familiesSelect.insertBefore(blankMember, familiesSelect.firstChild);
                    familiesSelect.selectedIndex = 0;

                    alert("Before adding a block connector, you must add the block connector's family.");


                }


            }

            function memberSelected() {
                // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                var membersSelect = document.getElementById('members-select');
                if (membersSelect.options[0].value == 0) {
                    membersSelect.remove(0);
                }



                if (membersSelect.value == -2) {
                    // User chose "Person not listed", so put up alert saying address must be added first
                    var blankMember = new Option('',0);
                    blankMember.disabled = true;

                    membersSelect.insertBefore(blankMember, membersSelect.firstChild);
                    membersSelect.selectedIndex = 0;

                    alert("Before adding a block connector, you must add the block connector as a family member.");

                }
            }

            function addBC() {
                // Just implement case of adding family/family member.
                // Just need to set the value of the "addressId" input form element to the selected address,
                // then submit the form.
                if (document.getElementById('addresses-select').value > 0) {
                    if (document.getElementById('families-select').value > 0) {
                        if (document.getElementById('members-select').value > 0) {
                            document.getElementById('new-bc-container').style.visibility = false;
                            document.getElementById('transparent-overlay').style.visibility = false;
                            document.getElementById('address-id').value = document.getElementById('addresses-select').value;
                            document.getElementById('new-bc-form').submit();
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

        </script>
        <style type="text/css">
            #content-detail {
                height:100px;
            }
            #block-code-heading {
                position: absolute;
                top:30px;
                left: 10px;
            }
            #block-code-value {
                position: absolute;
                top:30px;
                left: 155px;
            }
            #block-description-heading {
                position: absolute;
                top:50px;
                left: 10px;
            }
            #block-description-value {
                position: absolute;
                top:50px;
                left: 155px;
            }
            #order-within-neighbourhood-heading {
                position: absolute;
                top:70px;
                left: 10px;
            }
            #order-within-neighbourhood-value {
                position: absolute;
                top:70px;
                left: 155px;
            }

            #bc-title {
                font-weight:bold;
                position: absolute;
                top:7px;
                left: 330px;
            }
            .bc {
                position: absolute;
                left: 330px;
            }



            #new-bc-container {
                position:absolute;
                top:140px;
                left:260px;
                width:420px;
                height:165px;
                padding:20px;
                padding-top: 10px;
                background-color: #FFFFFF;
                border-radius:10px;
                visibility:hidden;
            }

            #new-bc-cancelbutton{
                display: inline-block;
                height: 22px;
                width: 80px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }
            #new-bc-savebutton{
                display: inline-block;
                height: 22px;
                width: 80px;
                margin-left: 10px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                font-weight: bold;
            }

            .modal-title {
                margin-top: 10px;
                font-weight:bold;
                font-size:14px;
            }

            .modal-row {
                margin-top: 10px;
            }

            .button-row {
                margin-top: 20px;
                margin-left: 0px;
                width: 100%;
            }
            
            #button-row-div {
                position: absolute;
                top:130px;
                left:20px;
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

            #new-container {
                position:absolute;
                top:90px;
                left:260px;
                width:420px;
                padding:20px;
                padding-top: 10px;
                background-color: #FFFFFF;
                border-radius:10px;
                visibility:hidden;
            }
            #new-cancelbutton{
                display: inline-block;
                height: 22px;
                width: 80px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }
            #new-savebutton{
                display: inline-block;
                height: 22px;
                width: 80px;
                margin-left: 10px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                font-weight: bold;
            }

            .note-style {
                width:95%;
            }



        </style>
    </head>
    <body>
            <div id="content-detail">
                <div id="content-detail-title">${navSelection.levelInHierarchy}</div>

                <div id="block-code-heading">Block code: </div>
                <div id="block-code-value">${navSelection.code}</div>
                <div id="block-description-heading">Description: </div>
                <div id="block-description-value">${navSelection.description}</div>
                <div id="order-within-neighbourhood-heading">Order within hood: </div>
                <div id="order-within-neighbourhood-value">${navSelection.orderWithinNeighbourhood}</div>

                <g:if test="${navSelection.blockConnectors.size() > 1}">
                    <div id="bc-title">Block Connectors</div>
                </g:if>
                <g:else>
                    <div id="bc-title">Block Connector</div>
                </g:else>

                <g:if test="${navSelection.blockConnectors.size() > 0}">
                    <g:each in="${navSelection.blockConnectors}" var="bc" status="i">
                        <div class="bc" style="top:${(i*20)+30}px;"><a href="${resource(dir:'navigate/familymember',file:"${bc.id}")}">${bc.fullName}</a> <span style="font-size:smaller;">(<a href="${resource(dir:'authorization',file:'deauthorizeBlockConnector')}/${bc.id}?blockId=${navSelection.id}">revoke</a>)</span></div>
                    </g:each>

                </g:if>
                <g:else>
                    <div class="bc" style="top:30px;">no assigned block connector</div>

                </g:else>


                <g:if test="${navSelection.blockConnectors.size() > 0}">
                    <div class="bc" style="top:${(navSelection.blockConnectors.size()*20)+35}px;"><a href="#" onclick="presentAddBC();">+ Add Another Block Connector</a></div>
                </g:if>
                <g:else>
                    <div class="bc" style="top:55px;"><a href="#" onclick="presentAddBC();">+ Add Block Connector</a></div>
                </g:else>

                <div id="content-actions-left-side">
                    <div class="content-left-action"><a href="${resource(dir:'block',file:"contactList")}/${navSelection.id}">Contact List</a></div>
                </div>

                <div id="content-actions">
                    <div class="content-action"><a href="#">Edit</a></div>
                    <div class="content-action"><a href="#">Delete</a></div>
                    <div class="content-action"><a href="#">Print</a> (<a href="#">preferences</a>)</div>
                </div>
            </div>
            <div id="content-children">
                <div id="content-children-title">Addresses for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#" onclick="presentNewModal();">+ Add New Addresses</a></div>
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row" style="color:#CCCCCC;">no addresses</div>
                </g:else>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>

            <div id="new-bc-container">
                <div class="modal-title">Add Block Connector</div>
                <div class="modal-row">Select address of block connector: 
                    <select id="addresses-select" onchange="addressSelected();">
                        <option value="0"></option>
                        <g:each in="${navChildren.children}" var="address">
                            <option value="${address.id}">${address.name}</option>
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
                <form id="new-bc-form" action=${resource(file:'person/setBlockConnector')} method="POST">
                    <input id="address-id" type="hidden"/>
                    <div id="select-member" class="modal-row">Select block connector: 
                            <select id="members-select" name="id" onchange="memberSelected();">
                                <option value=""></option>
                            </select>
                    </div>
                </form>
                <div id="button-row-div">
                    <div class="button-row">
                        <div id="new-bc-cancelbutton" type="button" onclick="JavaScript:dismissAddBCModal();">Cancel</div>
                        <div id="new-bc-savebutton" type="button" onclick="JavaScript:addBC();">Add</div>
                    </div>
                </div>
            </div>

            <div id="new-container">
                <div class="modal-title">New Addresses</div>
                <div>Add multiple addresses by pressing Return after each.</div>
                <form id="new-form" action=${resource(file:'Block/addAddresses')} method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Addresses: <br/><textarea id="addressesInput" class="note-style" name="addresses" cols=56 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div id="new-cancelbutton" type="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div id="new-savebutton" type="button" onclick="JavaScript:addAddresses();">Save</div>
                </div>
            </div>


    </body>
</html>