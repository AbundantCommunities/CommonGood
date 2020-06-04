<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="navigate"/>
        <title>CommonGood - Address</title>

        <asset:stylesheet src="leaflet/leaflet.css"/>
        <asset:javascript src="leaflet/leaflet.js"/>
        <style type="text/css">
            #mapid { height: 400px; }
        </style>

        <g:if test="${authorized.canWrite()==Boolean.TRUE}">
        <script type="text/javascript">            

            function populateEditModal() {
                document.getElementById('addressTextInput').value = decodeEntities("${navSelection.description}");

                var encodedNote = "${navSelection.note.split('\r\n').join('|')}";
                var decodedNote = encodedNote.split('|').join('\n');

                document.getElementById('addressNoteTextarea').value = decodeEntities(decodedNote);
            }
            function presentEditModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                populateEditModal();

                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("edit-container").style.visibility='visible';
                document.getElementById("addressTextInput").focus();
                document.getElementById("addressTextInput").select();
            }
            function dismissEditModal() {
                document.getElementById("edit-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }


            function addressIsValid(addressText,note) {
                if (addressText == "") {
                    alert("Please enter an address.");
                    return false;
                }
                if (addressText.length > 255) {
                    alert("The address you enter cannot exceed 255 characters in length.");
                    return false;
                }
                if (note.length > 255) {
                    alert("The note you enter cannot exceed 255 characters in length.");
                    return false;
                }
                if (note.indexOf('|') > -1) {
                    alert("Notes cannot contain the '|' character. Please use a different character");
                    return false;
                }
                return true;
            }

            function saveAddress() {
                var addressText = document.getElementById('addressTextInput').value.trim();
                var note = document.getElementById('addressNoteTextarea').value.trim();
                if (addressIsValid(addressText,note)) {
                    dismissEditModal();

                    document.getElementById("addressTextInput").value = document.getElementById("addressTextInput").value.trim();
                    document.getElementById("addressNoteTextarea").value = document.getElementById("addressNoteTextarea").value.trim();

                    document.getElementById('edit-form').submit();
                }
            }





            function presentNewModal() {
                var pagecontainerDiv = document.getElementById("pagecontainer");

                // clear UI before presenting
                document.getElementById("familyNameInput").value = "";
                document.getElementById("familyNoteTextarea").value = "";


                // set height of overlay to match height of pagecontainer height
                document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
                
                // show overlay and new-container divs and focus to family name
                document.getElementById("transparent-overlay").style.visibility='visible';
                document.getElementById("new-container").style.visibility='visible';
                document.getElementById("familyNameInput").focus();
            }

            function dismissNewModal() {
                document.getElementById("new-container").style.visibility='hidden';
                document.getElementById("transparent-overlay").style.visibility='hidden';
            }

            function familyIsValid(familyName,note) {
                if (familyName == "") {
                    alert("Please enter a family name for the new family.");
                    return false;
                }
                if (familyName.length > 255) {
                    alert("The family name you enter cannot exceed 255 characters in length.");
                    return false;
                }
                if (note.length > 255) {
                    alert("The note you enter cannot exceed 255 characters in length.");
                    return false;
                }
                if (note.indexOf('|') > -1) {
                    alert("Notes cannot contain the '|' character. Please use a different character");
                    return false;
                }
                return true;
            }

            function saveFamily() {
                var familyName = document.getElementById('familyNameInput').value.trim();
                var note = document.getElementById('familyNoteTextarea').value.trim();
                if (familyIsValid(familyName,note)) {
                    dismissEditModal();

                    document.getElementById("familyNameInput").value = familyName;
                    document.getElementById("familyNoteTextarea").value = note;

                    document.getElementById('new-form').submit();
                }
            }

        </script>
        </g:if>

        <g:if test="${authorized.canWrite()==Boolean.TRUE}">
        <style type="text/css">

            #edit-container {
                top:90px;
                left:300px;
                width:330px;
            }

            #new-container {
                top:90px;
                left:300px;
                width:330px;
            }

        </style>
        </g:if>

    </head>

    <body>
            <div class="content-section">
                <div class="content-heading">${navSelection.levelInHierarchy}</div>
                <div class="content-row">
                    <div class="content-row-item" style="width:145px;">Address: </div><div class="content-row-item">${navSelection.description}</div>
                </div>
                <div class="content-row">
                    <div class="content-row-item" style="width:145px;">Note: </div><div class="content-row-item"><textarea cols="60" rows="5" style="color: #222222;" disabled>${navSelection.note}</textarea></div>
                </div>

                <g:if test="${authorized.canWrite()==Boolean.TRUE}">
                <div id="content-actions">
                    <div class="content-action"><g:link controller="Address" action="edit" id="${navSelection.id}">Edit</g:link></div>
                    <div class="content-action"><g:link controller="Delete" action="confirmAddress" id="${navSelection.id}">Delete</g:link></div>
                    <g:if test="${authorized.forNeighbourhood()==Boolean.TRUE}">
                        <div class="content-action"><g:link controller="Move" action="selectDestinationBlock" id="${navSelection.id}">Move</g:link></div>
                    </g:if>
                    <g:else>
                        <div class="content-action"><a href="#" onclick="alert('As a Block Connector, you are not able to move addresses. Please ask your Neighbourhood Connector to do this for you.')">Move</a></div>
                    </g:else>
                </div>
                </g:if>
            </div>
            <div class="content-section">
                <div class="content-heading">Families for ${navSelection.levelInHierarchy} ${navSelection.description}<g:if test="${authorized.canWrite()==Boolean.TRUE}">&nbsp;&nbsp;<a onclick="presentNewModal();" href="#" style="font-weight:normal;">+ Add New ${navChildren.childType}</a></g:if></div>
                <div id="listWithHandle" style="width:500px;display:inline-block;vertical-align:top;">
                <g:if test="${navChildren.children.size() > 0}">
                    <g:each in="${navChildren.children}" var="child">
                        <div <g:if test="${authorized.canWrite()==Boolean.TRUE}">id="${child.id}"</g:if> class="content-children-row">
                            <g:if test="${authorized.canWrite()==Boolean.TRUE}"><span class="drag-handle"><asset:image src="reorder-row.png" width="18" height="18" style="vertical-align:middle;"/></span></g:if>
                            <g:link controller='Navigate' action='${navChildren.childType.toLowerCase()}' id='${child.id}'>${child.name}</g:link>
                        </div>
                    </g:each>
                </g:if>
                <g:else>
                    <div class="content-children-row light-text">no families</div>
                </g:else>
                </div>


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

                        }

                        map.fitBounds(boundaryPoly.getBounds());

                        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                            maxZoom: 19,
                            id: 'mapbox/streets-v11',
                            accessToken: '${commongood.GisService.mapboxAccessToken}'
                        }).addTo(map);

                        if (${navSelection.latitude} != 0 || ${navSelection.longitude} != 0) {
                            L.circleMarker(L.latLng(${navSelection.latitude},${navSelection.longitude}), {radius:4}).addTo(map);
                        } else { // neighbourhood, so add caption about block boundary
                            document.getElementById('mapcaption').innerHTML = 'The location for the address has not been specified.<g:if test="${authorized.canWrite()==Boolean.TRUE}"> <span><g:link controller="Address" action="edit" id="${navSelection.id}">Edit</g:link></span> the address to specify its location.</g:if>'
                        }

                    } else {
                        document.getElementById('mapid').style = "position:relative;background-color:darkgrey;";
                        document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                    }

                </script>

                <div class="content-children-row"></div>
                <form id="reorder-form" action="<g:createLink controller='Address' action='reorder' />" method="POST">
                    <input id="reorder-this-id" type="hidden" name="familyId" value=""/>
                    <input id="reorder-after-id" type="hidden" name="afterId" value=""/>
                </form>
            </div>
            <div id="transparent-overlay">
            </div>
            <g:if test="${authorized.canWrite()==Boolean.TRUE}">
            <div id="edit-container" class="modal">
                <div class="modal-title">Edit Address</div>
                <form id="edit-form" action="<g:createLink controller='Address' action='save'/>" method="POST">
                    <input type="hidden" name="id" value="${navSelection.id}" />
                    <div class="modal-row">Address: <input id="addressTextInput" type="text" name="text" value="" style="width:70%;"/></div>
                    <div class="modal-row">Note: <br/><textarea id="addressNoteTextarea" class="note-style" name="note" cols=44 rows=4></textarea></div>
                    <g:hiddenField name="version" value="${navSelection.version}" />
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissEditModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveAddress();">Save</div>
                </div>
            </div>
            <div id="new-container" class="modal">
                <div class="modal-title">New Family</div>
                <form id="new-form" action="<g:createLink controller='Family' action='save'/>" method="POST">
                    <input type="hidden" name="addressId" value="${navSelection.id}" />
                    <div class="modal-row">Family name: <input id="familyNameInput" type="text" name="familyName" value=""/></div>
                    <div class="modal-row">Note: <br/><textarea id="familyNoteTextarea" class="note-style" name="note" cols=44 rows=4></textarea></div>
                </form>
                <div class="button-row">
                    <div class="button" onclick="JavaScript:dismissNewModal();">Cancel</div>
                    <div class="button-spacer"></div>
                    <div class="button bold" onclick="JavaScript:saveFamily();">Save</div>
                </div>
            </div>
            </g:if>
    </body>
</html>