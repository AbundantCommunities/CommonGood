<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Edit Address</title>
        <asset:stylesheet src="leaflet/leaflet.css"/>
        <asset:javascript src="leaflet/leaflet.js"/>
        <style type="text/css">
            #mapid { height: 400px; }
        </style>


        <script type="text/javascript">

            var addressMarker = null;

            function doSave() {
                <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')}">
                if (addressMarker != null) {
                    var addressLat = addressMarker.getLatLng().lat;
                    var addressLng = addressMarker.getLatLng().lng;
                    document.getElementById('latitude-input').value = addressLat;
                    document.getElementById('longitude-input').value = addressLng;
                } else {
                    document.getElementById('latitude-input').value = 0.0;
                    document.getElementById('longitude-input').value = 0.0;
                }
                </g:if>
                document.getElementById('edit-form').submit();
            }


            function doCancel() {
                document.getElementById('cancel-edit-form').submit();
            }


        </script>
    </head>
    <body>
            <div class="content-section content-container">
                <div class="content-section-embedded" style="width:460px">
                    <div style="margin-top:-15px;"><h3>Edit Address</h3></div>

                    <form id="edit-form" action="<g:createLink controller='address' action='save' />" method="POST">
                        <input type="hidden" name="id" value="${address.id}" />
                        <input type="hidden" name="version" value="${address.version}" />
                        <input id="latitude-input" type="hidden" name="latitude" value="" />
                        <input id="longitude-input" type="hidden" name="longitude" value="" />
                        <div class="content-row">
                            <div class="content-row-item" style="width:80px;">Address: </div><input type="text" id="text" name="text" value="${address.text}"/>
                        </div>
                        <div class="content-row">
                            <div class="content-row-item" style="width:80px;">Note: </div><div class="content-row-item"><textarea id="note" name="note" rows="4" cols="48">${address.note}</textarea></div>
                        </div>
                        <g:if test="${session.neighbourhood.featureFlags.contains('gismaps')}">
                        <div class="content-row">
                            <div style="height:474px;border:black solid 2px;background-color:gray;padding:5px;margin-top:10px;">
                                <div id="mapid"></div>
                                <div id="mapbuttons" style="width:100px;height:66px;display:inline-block;padding-right:10px;border-right:white solid 1px;margin-top:5px;">
                                    <div id="start_over_button" class="button-small" style="width:60px;" onclick="javascript:startOver()">Start Over</div>
                                </div>
                                <div id="mapinstructions" style="display:inline-block;vertical-align:top;margin-top:5px;font-family:sans-serif;font-size:small;color:white;word-wrap: normal;">
                                    <div id="help_text_div" style="width:280px;margin-left:10px;">The location of the address has not been specified. On the map above, click the location.</div>
                                </div>
                            </div>
                            <script type="text/javascript">
                                var map = null;
                                var boundaryType = '${boundary.type}';
                                var boundary = [
                                    <g:each in="${boundary.coordinates}" var="coord" status="i">
                                        [${coord.getY()},${coord.getX()}],
                                    </g:each>
                                ];

                                if (boundaryType != 'nada') {
                                    map = L.map('mapid');

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
                                        accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                                    }).addTo(map);

                                    function onMapClick(e) {
                                        addressMarker = L.marker(e.latlng, { draggable: true } );
                                        if (boundaryPoly.getBounds().contains(addressMarker.getLatLng())) {
                                            map.off('click', onMapClick);
                                            document.getElementById('help_text_div').innerHTML = "To adjust the location of the address, simply click and drag the marker. To start over, click the 'Start Over' button.";
                                            document.getElementById('start_over_button').style.display = '';
                                            map.addLayer(addressMarker);
                                        } else {
                                            addressMarker = null;
                                            alert("That location appears to be outside of the block's boundary.");
                                        }

                                    }

                                    if (${address.latitude} != 0 && ${address.longitude} != 0) {
                                        // address already has a location, so add it to map
                                        addressMarker = L.marker(L.latLng(${address.latitude}, ${address.longitude}), { draggable: true } );
                                        document.getElementById('help_text_div').innerHTML = "To adjust the location of the address, simply click and drag the marker. To start over, click the 'Start Over' button.";
                                        document.getElementById('start_over_button').style.display = '';
                                        map.addLayer(addressMarker);
                                    } else {
                                        map.on('click', onMapClick);
                                        document.getElementById('help_text_div').innerHTML = "The location of the address has not been specified. On the map above, click the location.";
                                        document.getElementById('start_over_button').style.display = 'none';
                                    }

                                } else {
                                    document.getElementById('mapid').style = "position:relative;";
                                    document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                                    document.getElementById('mapbuttons').style = 'display:none;';
                                    document.getElementById('mapinstructions').style = 'display:none;';
                                }

                                function startOver() {
                                    // remove marker
                                    if (addressMarker != null) {
                                        map.removeLayer(addressMarker);
                                        addressMarker = null;
                                    }
                                    document.getElementById('help_text_div').innerHTML = "The location of the address has not been specified. On the map above, click the location.";
                                    document.getElementById('start_over_button').style.display = 'none';
                                    map.fitBounds(boundaryPoly.getLatLngs());
                                    map.on('click', onMapClick);
                                }

                            </script>



                        </div>
                        </g:if>
                    </form>
                    <div class="button-row">
                        <div class="button" onclick="JavaScript:doCancel();">Cancel</div>
                        <div class="button-spacer"></div>
                        <div class="button bold" onclick="JavaScript:doSave();">Save</div>
                    </div>
                    <form id="cancel-edit-form" action="<g:createLink controller='navigate' action='address' id="${address.id}"/>" method="GET">
                    </form>

                </div>
            </div>
    </body>
</html>
