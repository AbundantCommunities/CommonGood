<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>CommonGood Search</title>
        <asset:javascript src="copy2clipboard.js"/>
        <asset:stylesheet src="leaflet/leaflet.css"/>
        <asset:javascript src="leaflet/leaflet.js"/>
        <style type="text/css">
            #mapid { height: 400px; }

            .leaflet-tooltip-pane .text {
              color: white; 
              font-weight: bold;
              background: transparent;
              border:0;
              box-shadow: none;
              font-size:1em;
            }

            #emaildiv {
                top:90px;
                left:200px;
                width:540px;
            }


        </style>
        <script type="text/javascript">
        
            var people = [];
            var answers = [];
            var currentViewElement;
            var currentShowElement;


            function showAnswers() {
                document.getElementById('resultsAnswersSelected').style.display='';
                document.getElementById('resultsPeopleSelected').style.display='none';
                currentViewElement.style.display='none';
                document.getElementById('mapAnswerResults').style.display='';
                currentViewElement = document.getElementById('mapAnswerResults');

                document.getElementById('showMapAnswerResultsSelected').style.display='';
                document.getElementById('showAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoPeopleResultsSelected').style.display='none';

            }

            function showFamilyMembers() {
                document.getElementById('resultsAnswersSelected').style.display='none';
                document.getElementById('resultsPeopleSelected').style.display='';
                currentViewElement.style.display='none';
                document.getElementById('contactInfoPeopleResults').style.display='';
                currentViewElement = document.getElementById('contactInfoPeopleResults');

                document.getElementById('showMapAnswerResultsSelected').style.display='none';
                document.getElementById('showAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoPeopleResultsSelected').style.display='';


            }

            function showMapAnswerResults() {
                currentViewElement.style.display='none';
                document.getElementById('mapAnswerResults').style.display='';
                currentViewElement = document.getElementById('mapAnswerResults');

                document.getElementById('showMapAnswerResultsSelected').style.display='';
                document.getElementById('showAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoPeopleResultsSelected').style.display='none';
            }

            function showAnswerResults() {
                currentViewElement.style.display='none';
                document.getElementById('answerResults').style.display='';
                currentViewElement = document.getElementById('answerResults');

                document.getElementById('showMapAnswerResultsSelected').style.display='none';
                document.getElementById('showAnswerResultsSelected').style.display='';
                document.getElementById('showContactInfoAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoPeopleResultsSelected').style.display='none';

            }

            function showContactInfoAnswerResults() {
                currentViewElement.style.display='none';
                document.getElementById('contactInfoAnswerResults').style.display='';
                currentViewElement = document.getElementById('contactInfoAnswerResults');

                document.getElementById('showMapAnswerResultsSelected').style.display='none';
                document.getElementById('showAnswerResultsSelected').style.display='none';
                document.getElementById('showContactInfoAnswerResultsSelected').style.display='';
                document.getElementById('showContactInfoPeopleResultsSelected').style.display='none';
            }



            function constructAgeDescription(fromAge,toAge) {
                if (fromAge.length==0 && toAge.length==0) {
                    return ".";
                } else if (fromAge.length>0 && toAge.length>0) {
                    if (fromAge==toAge) {
                        return ", to include only family members age "+fromAge+".";
                    } else {
                        return ", to include only family members age "+fromAge+" to "+toAge+".";
                    }
                } else if (fromAge.length>0) {
                    return ", to include only family members age "+fromAge+" or older.";
                } else {
                    return ", to include only family members age "+toAge+" or younger.";
                }
            }

            function constructSearchCriteria(q,fromAge,toAge) {
                return 'You searched for &quot;'+q+'&quot;'+constructAgeDescription(fromAge,toAge);
            }


            var failedDescription = 1;
            var peopleDescription = 2;
            var answersDescription = 3;

            function constructQueryDescription(whichDescription,q,fromAge,toAge,peopleCount,answerCount) {
                var returnString = '';
                if (whichDescription == failedDescription) {
                    if (q.length>0) {
                        returnString = 'Failed to find "'+q+'"';
                        if (fromAge.length>0 || toAge.length>0) {
                            returnString = returnString+' for family members '+constructAgeDescription(fromAge,toAge);
                        }
                    } else {
                        returnString = 'Failed to find family members '+constructAgeDescription(fromAge,toAge);
                    }
                    returnString = returnString+'.';
                } else if (whichDescription == peopleDescription) {
                    returnString = 'Found ';
                    if (q.length>0) {
                        returnString = returnString+'"'+q+'" in '+peopleCount+' family member';
                        if (peopleCount>1) {
                            returnString = returnString+'s';
                        }
                        if (fromAge.length>0 || toAge.length>0) {
                            returnString = returnString+' '+constructAgeDescription(fromAge,toAge);
                        }
                    } else {
                        returnString = returnString+peopleCount+' family member';
                        if (peopleCount>1) {
                            returnString = returnString+'s';
                        }
                        if (fromAge.length>0 || toAge.length>0) {
                            returnString = returnString+' '+constructAgeDescription(fromAge,toAge);
                        }
                    }
                    returnString = returnString+':';
                } else if (whichDescription == answersDescription) {
                    returnString = 'Found ';
                    if (q.length>0) {
                        returnString = returnString+'"'+q+'" in '+answerCount+' answer';
                        if (answerCount>1) {
                            returnString = returnString+'s';
                        }
                        if (fromAge.length>0 || toAge.length>0) {
                            returnString = returnString+' for family members'+constructAgeDescription(fromAge,toAge);
                        }
                    } else {
                        returnString = returnString+answerCount+' answer';
                        if (answerCount>1) {
                            returnString = returnString+'s';
                        }
                        if (fromAge.length>0 || toAge.length>0) {
                            returnString = returnString+' for family members'+constructAgeDescription(fromAge,toAge);
                        }
                    }
                }
                return returnString;
            }


            function constructLine(fNames,lName,phone,email,address) {

                var lineIsClean = true;
                var constructedLine = '';

                if (fNames.length>0) {
                    constructedLine = constructedLine+fNames;
                    lineIsClean = false;
                }
                if (lName.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+' ';
                    }
                    constructedLine = constructedLine+lName;
                    lineIsClean = false;
                }
                if (phone.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+phone;
                    lineIsClean = false;
                }
                if (email.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+email;
                    lineIsClean = false;
                }
                if (address.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+address;
                }
                constructedLine = constructedLine+'\n';

                return constructedLine;
            }


            function emailList() {

                var wouldAssistBody = 'Those who would assist:\n\n';
                var atLeastOneAssist = false;
                var body = '\n\n\n\n-----------------------------------------------------------\nSearch results from CommonGood:\n\n';

                if (people.length>0) {
                    body = body+constructQueryDescription(peopleDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    body = body+'\n\n';
                    for (i=0; i<people.length;i++) {
                        body = body+constructLine(people[i].firstNames,people[i].lastName,people[i].phoneNumber,people[i].emailAddress,people[i].homeAddress);
                    }
                    body = body+'\n';
                }

                if (answers.length>0) {
                    if (people.length>0) {
                        body = body+'\n';
                    }
                    body = body+constructQueryDescription(answersDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    body = body+':\n\n';
                }

                if (answers.length>0) {
                    for (i=0;i<answers.length;i++) {
                        if (!answers[i].assist) {
                            body = body+'Answer: '+answers[i].answer+' (Question: '+answers[i].question+')\n';
                            body = body+constructLine(answers[i].firstNames,answers[i].lastName,answers[i].phoneNumber,answers[i].emailAddress,answers[i].homeAddress)+'\n';
                        } else {
                            atLeastOneAssist = true;
                            wouldAssistBody = wouldAssistBody+'Answer: '+answers[i].answer+' (Question: '+answers[i].question+')\n';
                            wouldAssistBody = wouldAssistBody+constructLine(answers[i].firstNames,answers[i].lastName,answers[i].phoneNumber,answers[i].emailAddress,answers[i].homeAddress)+'\n';
                        }
                    }

                    if (atLeastOneAssist) {
                        body = body+wouldAssistBody;
                    } else {
                        body = body+'No one has offered to assist.\n';
                    }

                }

                var numRows = 20;
                var title = 'Email Contact Information';
                var description = 'CommonGood cannot send email for you, but you can copy the message below to the clipboard, then paste it into a new message that you create the way you normally do.';
                var copyContentTitle = 'Contact information for search results'
                presentForCopy('emaildiv',body,numRows,title,description,copyContentTitle);

            }


            function doEmailOne(emailAddress) {
                if (emailAddress) {
                    var numRows = 1;
                    var title = 'Email Person';
                    var description = 'CommonGood cannot send email for you, but you can copy the email address to the clipboard and then paste to address a new message that you create the way you normally do.';
                    var copyContentTitle = 'Person email address'
                    presentForCopy('emaildiv',emailAddress,numRows,title,description,copyContentTitle);
                }
            }


            function downloadSupported() {
                var a = document.createElement('a');
                return typeof a.download != "undefined";
            }


            function csvFriendlyValue(value) {

                var friendlyValue = value;

                // .includes() not supported in some browsers that otherwise support CommonGood's download search results feature.
                // Using .indexOf instead.
                if (friendlyValue.indexOf(",")>=0 || friendlyValue.indexOf('"')>=0 || friendlyValue.indexOf('\n')>=0 || friendlyValue.indexOf('\r')>=0 || friendlyValue.indexOf('\r\n')>=0) {
                    if (friendlyValue.indexOf('"')>=0) {
                        friendlyValue = friendlyValue.replace(/"/g,'""');
                    }
                    friendlyValue = '"'+friendlyValue+'"';
                }

                return friendlyValue;

            }


            function doDownload() {
                if (downloadSupported) {
                    if (people.length > 0 || answers.length > 0) {
                        
                        var filename = 'CommonGood Search Results.csv';

                        var content;

                        if (answers.length>0) {
                            content = "Question,Answer,Name,Phone,Email,Address\n";
                        } else {
                            content = "Name,Phone,Email,Address\n";
                        }
                        if (people.length > 0) {
                            for (i=0;i<people.length;i++) {
                                if (answers.length>0) {
                                    content = content + ",,";
                                }
                                content = content+csvFriendlyValue(people[i].firstNames)+" "
                                    +csvFriendlyValue(people[i].lastName)+","
                                    +csvFriendlyValue(people[i].phoneNumber)+","
                                    +csvFriendlyValue(people[i].emailAddress)+","
                                    +csvFriendlyValue(people[i].homeAddress)+"\n";
                            }
                        }

                        if (answers.length > 0) {
                            for (i=0;i<answers.length;i++) {
                                content = content+csvFriendlyValue(answers[i].question)+","
                                    +csvFriendlyValue(answers[i].answer)+","
                                    +csvFriendlyValue(answers[i].firstNames)+" "
                                    +csvFriendlyValue(answers[i].lastName)+","
                                    +csvFriendlyValue(answers[i].phoneNumber)+","
                                    +csvFriendlyValue(answers[i].emailAddress)+","
                                    +csvFriendlyValue(answers[i].homeAddress)+"\n";
                            }
                        }

                        try {

                            var element = document.createElement('a');
                            element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(content));
                            element.setAttribute('download', filename);
                            element.style.display = 'none';
                            element.innerHTML = 'hello world';
                            document.body.appendChild(element);

                            element.click();

                            document.body.removeChild(element);

                        } catch (e) {
                            alert("Your browser does not support CommonGood's download feature. Try https://updatemybrowser.org.");
                        }

                    } else {
                        alert('There are no search results to download.');
                    }

                } else {
                    alert("Your browser does not support CommonGood's download feature.  Try https://updatemybrowser.org.")
                }
            }


            window.onload = function onWindowLoad() {
                document.getElementById('search-criteria-div').innerHTML = constructSearchCriteria("${q}","${fromAge}","${toAge}");
                if (${answers.size()>0}) {
                    currentViewElement = document.getElementById('mapAnswerResults');
                } else {
                    currentViewElement = document.getElementById('contactInfoPeopleResults');
                }
            }

        </script>

    </head>
    <body>
            <div class="content-section">
                <div id="search-criteria-div" style="margin-bottom:7px;">You searched for </div>
                <g:if test="${answers.size()>0 && people.size()>0}">
                <div id="resultsAnswersSelected">
                    <div style="height:25px;line-height:25px;margin-bottom:10px;">
                        <div style="display:inline-block;width:105px;">Search found: </div><div style="width:200px;text-align:center;display:inline-block;margin-bottom:7px;border:solid black thin;border-color:#B48B6A;border-radius:5px;color:white;background-color:#B48B6A;">${answers.size()} answer(s)</div>
                    </div>
                    <div style="height:25px;line-height:25px;margin-bottom:10px;">
                        <div style="display:inline-block;width:105px;"></div><a href="javascript:showFamilyMembers();"><div style="width:200px;text-align:center;display:inline-block;margin-bottom:7px;border:solid black thin;border-color:#B48B6A;border-radius:5px;">${people.size()} family member(s)</div></a>
                    </div>
                </div>
                <div id="resultsPeopleSelected" style="display:none;">
                    <div style="height:25px;line-height:25px;margin-bottom:10px;">
                        <div style="display:inline-block;width:105px;">Search found: </div><a href="javascript:showAnswers();"><div style="width:200px;text-align:center;display:inline-block;margin-bottom:7px;border:solid black thin;border-color:#B48B6A;border-radius:5px;">${answers.size()} answer(s)</div></a>
                    </div>
                    <div style="height:25px;line-height:25px;margin-bottom:10px;">
                        <div style="display:inline-block;width:105px;"></div><div style="width:200px;text-align:center;display:inline-block;margin-bottom:7px;border:solid black thin;border-color:#B48B6A;border-radius:5px;color:white;background-color:#B48B6A;">${people.size()} family member(s)</div>
                    </div>
                </div>
                </g:if>
                <g:elseif test="${answers.size()>0}">
                <div>
                <div style="display:inline-block;width:105px;">Search found: </div><div style="display:inline-block;margin-bottom:7px;">${answers.size()} answer(s)</div>
                </div>
                </g:elseif>
                <g:elseif test="${people.size()>0}">
                <div>
                <div style="display:inline-block;width:105px;">Search found: </div><div style="display:inline-block;margin-bottom:7px;">${people.size()} family member(s)</div>
                </div>
                </g:elseif>
                <g:else>
                <div style="display:inline-block;width:105px;">Search found: </div><div style="display:inline-block;margin-bottom:7px;">&quot;${q}&quot; not found.</div>
                </g:else>


                <g:if test="${answers.size()>0}">
                    <div id="showMapAnswerResultsSelected" style="margin-bottom:7px;">Show: Map | <a href="Javascript:showAnswerResults();">Answers</a> | <a href="Javascript:showContactInfoAnswerResults();">Contact Info</a></div>
                    <div id="showAnswerResultsSelected" style="display:none;margin-bottom:7px;">Show: <a href="Javascript:showMapAnswerResults();">Map</a> | Answers | <a href="Javascript:showContactInfoAnswerResults();">Contact Info</a></div>
                    <div id="showContactInfoAnswerResultsSelected" style="display:none;margin-bottom:7px;">Show: <a href="Javascript:showMapAnswerResults();">Map</a> | <a href="Javascript:showAnswerResults();">Answers</a> | Contact Info</div>
                    <div id="showContactInfoPeopleResultsSelected" style="display:none;margin-bottom:7px;">Show: <span style="color:lightgrey">Map</span> | <span style="color:lightgrey">Answers</span> | Contact Info</div>
                </g:if>
                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div ><span><a href="JavaScript:emailList();">Email Contact List</a> | </span><a href='JavaScript:doDownload();'>Download Results</a></div>
                </g:if>




            </div>
            <div class="content-section">

                <g:if test="${answers.size() > 0}">
                <g:each in="${answers}" var="answer">
                <script type="text/javascript">
                    var anAnswer = {question:decodeEntities('${answer.question}'), answer:decodeEntities('${answer.text}'), firstNames:decodeEntities('${answer.firstNames}'), lastName:decodeEntities('${answer.lastName}'), phoneNumber:decodeEntities('${answer.phoneNumber}'), emailAddress:decodeEntities('${answer.emailAddress}'), homeAddress:decodeEntities('${answer.homeAddress}'), assist:${answer.assist}};
                    answers.push(anAnswer);
                </script>
                </g:each>
                </g:if>

                <g:if test="${people.size() > 0}">
                <g:each in="${people}" var="person">
                <script type="text/javascript">
                    var aPerson = {firstNames:decodeEntities('${person[1]}'), lastName:decodeEntities('${person[2]}'), phoneNumber:decodeEntities('${person[3]}'), emailAddress:decodeEntities('${person[4]}'), homeAddress:decodeEntities('${person[5]}')};
                    people.push(aPerson);
                </script>
                </g:each>
                </g:if>

                <g:if test="${locations.keySet().size()>0}">
                <script type="text/javascript">
                    var blocksToMap = [];
                    var aBlock;

                    <g:set var="countLocationUnknown" value="${0}" />
                    <g:set var="countLocationKnown" value="${0}" />

                    <g:each in="${locations.keySet()}" var="block">
                        <g:if test="${block.latLon().unknown == false}">
                            <g:set var="countLocationKnown" value="${countLocationKnown + 1}" />
                            aBlock = { legendId: ${countLocationKnown}, centroidLatitude: ${block.latLon().latitude}, centroidLongitude: ${block.latLon().longitude} };
                            blocksToMap.push(aBlock);
                        </g:if>
                        <g:else>
                            <g:set var="countLocationUnknown" value="${countLocationUnknown + 1}" />
                        </g:else>
                    </g:each>

                    var blockBoundariesToMap = [];
                    var coordinates;

                    <g:each in="${blockBoundaries.keySet()}" var="block" status="i">
                        coordinates = [];
                        <g:if test="${blockBoundaries[block].type == 'block'}">
                        <g:each in="${blockBoundaries[block].coordinates}" var="coord">
                            coordinates.push([${coord.getY()},${coord.getX()}]);
                        </g:each>
                        </g:if>
                        if (coordinates.length>0) {
                            blockBoundariesToMap.push(coordinates);
                        }
                    </g:each>

                </script>
                </g:if>

                <g:if test="${locations.keySet().size()>0}">
                <div id='mapAnswerResults'>
                    <div style="margin-bottom:8px;">People with answers containing &quot;${q}&quot; live on ${locations.keySet().size()} block(s) in the neighbourhood.</div>
                    <g:if test="${countLocationUnknown == 1}">
                    <div style="margin-bottom:8px;">1 of these blocks does not have location information and, therefore is not highlighted on the map.</div>
                    </g:if>
                    <g:elseif test="${countLocationUnknown > 1}">
                    <div style="margin-bottom:18px;">${countLocationUnknown} of these blocks do not have location information and, therefore, are not highlighted on the map.</div>
                    </g:elseif>
                    <div style="display:inline-block;width:400px;">
                        <g:set var="counter" value="${1}" />
                        <g:each in="${locations.keySet()}" var="block" status="i">
                        <div class="content-children-row">

                            <div style="display:inline-block;width:20px;font-weight:bold;">
                                <g:if test="${block.latLon().unknown != true}">${counter}<g:set var="counter" value="${counter + 1}" /></g:if>
                            </div>
                            <div style="display:inline-block;width:300px;"><g:link controller="Navigate" action="block" id="${block.id}"><b>Block ${block.code} (${block.description})</b></g:link></div>
                            <g:each in="${locations[block].keySet()}" var="person">
                            <div>
                                <div style="display:inline-block;width:20px;"></div>
                                <div style="display:inline-block;width:300px;"><g:link controller="Navigate" action="familymember" id="${person.id}">${person.firstNames} ${person.lastName}</g:link></div>
                            </div>
                            </g:each>
                        </div>
                        </g:each>
                        <div class="content-children-row" style="height:5px;"></div>
                    </div>

                    <div style="display:inline-block;width:500px;vertical-align:top;">
                        <div style="display:inline-block;width:490px;"><div style="border:solid gray;"><div id="mapid"></div></div><div id="mapcaption" style="margin:10px;font-size:small;"></div></div>
                        <script type="text/javascript">

                            var boundaryType = '${neighbourhoodBoundary.type}';
                            var boundary = [ ];
                            <g:each in="${neighbourhoodBoundary.coordinates}" var="coord">
                                boundary.push([${coord.getY()},${coord.getX()}]);
                            </g:each>

                            var boundaryPoly;
                            
                            if (boundaryType != 'nada') {
                                var map = L.map('mapid');

                                var invertedPoly;

                                boundaryPoly = L.polygon(boundary);

                                // add inverted polygon to map
                                invertedPoly = L.polygon(
                                    [[[90, -180],
                                     [90, 180],
                                     [-90, 180],
                                     [-90, -180]], //outer ring, the world
                                     boundaryPoly.getLatLngs()],
                                     {opacity:0.4,stroke:false,fillColor:"gray",fillOpacity:0.3} // cutout
                                    );

                                map.addLayer(invertedPoly);

                                L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                                    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                                    maxZoom: 19,
                                    id: 'mapbox/streets-v11',
                                    accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                                }).addTo(map);

                                if (blocksToMap.length>0) {
                                    var aLatLng;
                                    var blockMarkersData = [];

                                    for (i=0;i<blocksToMap.length;i++) {
                                        aLatLng = L.latLng(blocksToMap[i].centroidLatitude,blocksToMap[i].centroidLongitude);

                                        blockMarkersData.push({
                                            "type": "Feature",
                                            "geometry": {
                                                "type": "Point",
                                                "coordinates": [blocksToMap[i].centroidLongitude,blocksToMap[i].centroidLatitude]
                                            },
                                            "properties": {
                                                "text": blocksToMap[i].legendId.toString(),
                                                "radius": 10
                                            }
                                        });

                                    }

                                    var blockMarkers = new L.geoJson(blockMarkersData, {
                                        pointToLayer: function(feature, latlng) {
                                            return new L.CircleMarker([latlng.lat, latlng.lng], {radius: feature.properties.radius, fillColor: '#3388ff', fillOpacity: 1.0});
                                        },
                                        onEachFeature: function(feature, layer) {
                                            var text = L.tooltip({
                                                permanent: true,
                                                direction: 'center',
                                                className: 'text'
                                            })
                                            .setContent(feature.properties.text)
                                            .setLatLng(layer.getLatLng());
                                            text.addTo(map);
                                        }
                                    }).addTo(map);

                                }

                                if (blockBoundariesToMap.length>0) {
                                    var bounds = L.latLngBounds();
                                    var aPolygon;

                                    for (i=0;i<blockBoundariesToMap.length;i++) {
                                        aPolygon = L.polygon(blockBoundariesToMap[i],{stroke:false});
                                        map.addLayer(aPolygon);
                                        bounds.extend(aPolygon.getBounds());
                                    }

                                    map.fitBounds(bounds);

                                } else {
                                    map.fitBounds(boundaryPoly.getBounds());
                                }

                            } else {
                                document.getElementById('mapid').style = "position:relative;background-color:darkgrey;";
                                document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                            }

                        </script>
                    </div>
                </div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                <div id='answerResults' style="display:none;">
                    <div style="height:25px;"><span style="font-weight:bold;">bold</span> = would assist</div>
                    <div>
                        <div class="cell190 name">Name</div>
                        <div class="cell300 answer">Answer</div>
                        <div class="cell190 question">Question</div>
                    </div>
                    <g:each in="${answers}" var="answer">
                    <div class="content-children-row" >
                        <div class="cell190 name <g:if test='${answer.assist}'>bold</g:if>"><g:link controller="navigate" action="familymember" id="${answer.pid}">${answer.firstNames} ${answer.lastName}</g:link></div>
                        <div class="cell300 answer">${answer.text}</div>
                        <div class="cell190 question">${answer.question}</div>
                    </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </div>                
                </g:if>


                <g:if test="${people.size() > 0}">
                <g:if test="${answers.size() > 0}">
                <div id='contactInfoPeopleResults' style="display:none;">
                </g:if>
                <g:else>
                <div id='contactInfoPeopleResults'>
                </g:else>                
                    <div style="height:10px;">&nbsp;</div>
                    <div>
                        <div class="cell190 name">Name</div>
                        <div class="cell120 phone">Phone</div>
                        <div class="cell300 email">Email</div>
                        <div class="cell250 address">Address</div>
                    </div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <div class="cell190 name"><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></div>
                            <div class="cell120 phone">${person[3]}</div>
                            <div class="cell300 email"><a href="#" onclick="doEmailOne('${person[4]}');">${person[4]}</a></div>
                            <div class="cell250 address">${person[5]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </div>
                </g:if>


                <g:if test="${answers.size() > 0}">
                <div id='contactInfoAnswerResults' style="display:none;">
                    <div style="height:25px;"><span style="font-weight:bold;">bold</span> = would assist</div>
                    <div>
                        <div class="cell190 name">Name</div>
                        <div class="cell120 phone">Phone</div>
                        <div class="cell300 email">Email</div>
                        <div class="cell250 address">Address</div>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${answer.pid}"><div class="cell190 name <g:if test='${answer.assist}'>bold</g:if>">${answer.firstNames} ${answer.lastName}</div></g:link>
                            <div class="cell120 phone">${answer.phoneNumber}</div>
                            <div class="cell300 email"><a href="#" onclick="doEmailOne('${answer.emailAddress}');">${answer.emailAddress}</a></div>
                            <div class="cell250 address">${answer.homeAddress}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </div>
                </g:if>

                <g:if test="${answers.size() == 0 && people.size() == 0}">
                <div id='noResults'>Search failed to find &quot;${q}&quot;.</div>
                </g:if>

            </div>
            <div id="transparent-overlay"></div>
            <div id="emaildiv" class="modal" style="z-index:1000;"></div>
    </body>
</html>
