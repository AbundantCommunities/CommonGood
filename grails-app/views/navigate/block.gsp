<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">

            function clearNewMemberInputs() {
                document.getElementById("firstNamesInput").value = "";
                document.getElementById("lastNameInput").value = "";
                document.getElementById("birthYearInput").value = "";
                document.getElementById("emailAddressInput").value = "";
                document.getElementById("phoneNumberInput").value = "";
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
                    document.getElementById('all-input-div').style.display = 'none';

                    var pagecontainerDiv = document.getElementById("pagecontainer");

                    // clear UI before presenting
                    clearNewMemberInputs();

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
                document.getElementById('all-input-div').style.display = 'none';

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
                        familiesSelect.options[familiesSelect.options.length] = new Option('new ...', -2);

                        document.getElementById('select-family').style.display = 'block';

                    }
                }
            }

            function familySelected() {

                // Check if select still starts with blank item. If yes, remove it so no longer selectable.
                var familesSelect = document.getElementById('families-select');
                if (familesSelect.options[0].value == 0) {
                    familesSelect.remove(0);
                }





                // Check if 'new ...' selected

                if (document.getElementById('families-select').value != -2) {

                    document.getElementById('all-input-div').style.display = 'none';
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
                    // add new family and member
                    
                    // Clear inputs
                    clearNewMemberInputs();

                    document.getElementById('select-member').style.display = 'none';
                    document.getElementById('all-input-div').style.display = 'block';
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
                alert('not implemented');
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
                height:385px;
                padding:20px;
                padding-top: 10px;
                box-shadow: 0px 0px 20px #000000;
                background-color: #FFFFFF;
                border-radius:10px;
                border-width: 2px;
                border-color: #B48B6A;
                border-style: solid;
                visibility:hidden;
            }


            button#new-bc-savebutton{
                position: absolute;
                left:230px;
                top:375px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
                font-weight: bold;
            }
            button#new-bc-cancelbutton{
                position: absolute;
                left:130px;
                top:375px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                padding:5px 25px; /*add some padding to the inside of the button*/
                background:transparent; /*the colour of the button*/
                border:0px;
                color:#B48B6A;
                font-size: 14px;
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

            #all-input-div {
                position: absolute;
                display: none;
                top:105px;
                left: 20px;
                width: 90%;
            }

            .fm-input {
                margin-bottom: 5px;
            }

            .section-div {
                width:100%;
                border:none;
                border-top:solid;
                border-width: thin;
                border-color: #CCCCCC;
                padding-bottom: 5px;
            }

            .section-heading {
                font-size: x-small;
                margin-top: 0px;
                margin-bottom: 4px;
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
                <div id="order-within-neighbourhood-heading">Order within block: </div>
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
                <div id="content-children-title">Addresses for ${navSelection.levelInHierarchy} ${navSelection.description}&nbsp;&nbsp;<a href="#">+ Add New ${navChildren.childType}</a></div>
                <g:each in="${navChildren.children}" var="child">
                    <div class="content-children-row"><a href="${resource(dir:'navigate/'+navChildren.childType.toLowerCase(),file:"${child.id}")}">${child.name}</a></div>
                </g:each>
                <div class="content-children-row"></div>
            </div>
            <div id="transparent-overlay">
            </div>

            <div id="new-bc-container">
                <div style="font-weight:bold;font-size:14px;">Add Block Connector</div>
                <form id="new-form" action=${resource(file:'Person/save')} method="post">
                    <div id="select-address">Select address of block connector: 
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
                    <div id="select-family">Select family of block connector: 
                        <select id="families-select" onchange="familySelected();">
                            <option value=""></option>
                        </select>
                    </div>
                    <div id="select-member">Select block connector: 
                        <select id="members-select" onchange="memberSelected();">
                            <option value=""></option>
                        </select>
                    </div>
                    <div id="all-input-div">
                        <div id="new-family" class="section-div">
                            <div class="section-heading">Add family for Block Connector:</div>
                            <div class="fm-input">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                        </div>
                        <div id="new-family-member" class="section-div">
                            <div class="section-heading">Add family member for Bock Connector:</div>
                            <div class="fm-input">First names: <input id="firstNamesInput" type="text" name="firstNames" value=""/></div>
                            <div class="fm-input">Last name: <input id="lastNameInput" type="text" name="lastName" value=""/></div>
                            <div class="fm-input">Birth year: <input id="birthYearInput" type="text" pattern="[12][90][0-9][0-9]" name="birthYear" value="" placeholder="YYYY"/></div>
                            <div class="fm-input">Email address: <input id="emailAddressInput" type="email" name="emailAddress" value="" size="35"/></div>
                            <div class="fm-input">Phone number: <input id="phoneNumberInput" type="text" name="phoneNumber" value=""/></div>
                        </div>
                        <div class="section-div">
                        </div>
                    </div>
                </form>
                <button id="new-bc-savebutton" type="button" onclick="JavaScript:addBC();">Add</button>
                <button id="new-bc-cancelbutton" type="button" onclick="JavaScript:dismissAddBCModal();">Cancel</button>
            </div>




    </body>
</html>