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
        </style>
        <script type="text/javascript">
        
            var people = [];
            var answers = [];

            function showContactInfo() {
                var allContactInfoElements = document.getElementsByClassName('contactInfo');
                var allSearchResultsElements = document.getElementsByClassName('searchResults');

                for (i=0;i<allSearchResultsElements.length;i++) {
                    allSearchResultsElements[i].style.display = 'none';
                }

                for (i=0;i<allContactInfoElements.length;i++) {
                    allContactInfoElements[i].style.display = '';
                }
            }

            function showSearchResults() {
                var allContactInfoElements = document.getElementsByClassName('contactInfo');
                var allSearchResultsElements = document.getElementsByClassName('searchResults');

                for (i=0;i<allSearchResultsElements.length;i++) {
                    allSearchResultsElements[i].style.display = '';
                }

                for (i=0;i<allContactInfoElements.length;i++) {
                    allContactInfoElements[i].style.display = 'none';
                }
            }

            function constructAgeDescription(fromAge,toAge) {
                if (fromAge.length==0 && toAge.length==0) {
                    return "";
                } else if (fromAge.length>0 && toAge.length>0) {
                    if (fromAge==toAge) {
                        return " age "+fromAge;
                    } else {
                        return " aged "+fromAge+" to "+toAge;
                    }
                } else if (fromAge.length>0) {
                    return " age "+fromAge+" or older";
                } else {
                    return " age "+toAge+" or younger";
                }
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
                <g:if test="${people.size()==0 && answers.size()==0}">
                    document.getElementById("failedQueryDescription").innerHTML = constructQueryDescription(failedDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                </g:if>
                <g:if test="${people.size()>0}">
                    var peopleQueryDescriptionElements = document.getElementsByClassName('peopleQueryDescription');
                    var theInnerHTML = constructQueryDescription(peopleDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    for (i=0;i<peopleQueryDescriptionElements.length;i++) {
                        peopleQueryDescriptionElements[i].innerHTML = theInnerHTML;
                    }
                </g:if>
                <g:if test="${answers.size()>0}">
                    var answersQueryDescriptionElements = document.getElementsByClassName('answersQueryDescription');
                    var theInnerHTML = constructQueryDescription(answersDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    for (i=0;i<answersQueryDescriptionElements.length;i++) {
                        answersQueryDescriptionElements[i].innerHTML = theInnerHTML;
                    }
                </g:if>
            }

        </script>

        <style type="text/css">

            #emaildiv {
                top:90px;
                left:200px;
                width:540px;
            }

        </style>

    </head>
    <body>
            <div class="content-section">
                <div style="margin-bottom:7px;">You searched for: golf</div>
                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div class="searchResults" style="margin-bottom:7px;"><span style="font-weight:bold;">Show:</span>  Search Results | <a href="Javascript:showContactInfo();">Contact Info</a></div>
                    <div class="contactInfo" style="display:none;margin-bottom:7px;"><span style="font-weight:bold;">Show:</span>  <a href="Javascript:showSearchResults();">Search Results</a> | Contact Info</div>
                </g:if>
                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div style="width:910px;">
                        <div ><span><a href="JavaScript:emailList();">Email Contact List</a> | </span><a href='JavaScript:doDownload();'>Download Results</a></div>
                    </div>
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

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4 id="failedQueryDescription"></h4>
                </g:if>


                <div class='searchResults'>
                    <div style="display:inline-block;width:470px;">
                        <g:if test="${people.size() > 0}">
                        <div style="margin-bottom:-15px;margin-top:-15px;">
                            <h4 class="peopleQueryDescription"></h4>
                        </div>
                        <g:each in="${people}" var="person">
                            <div class="content-children-row" >
                                <div>
                                    <g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link>
                                </div>
                            </div>
                        </g:each>
                        <div class="content-children-row" style="height:5px;"></div>
                        </g:if>

                        <g:if test="${answers.size() > 0}">
                        <div style="margin-top:-5px;margin-bottom:-15px;">
                            <h4><span class="answersQueryDescription"></span> <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would assist):</span></h4>
                        </div>
                        <g:each in="${answers}" var="answer">
                            <div class="content-children-row" >
                                <div>
                                    <span><g:link controller="navigate" action="familymember" id="${answer.pid}">${answer.firstNames} ${answer.lastName}</g:link> </span>
                                    <span class="<g:if test='${answer.assist}'>bold</g:if>">${answer.text}</span> 
                                    <span style="font-size:x-small;">(${answer.question})</span>
                                </div>
                            </div>
                        </g:each>
                        <div class="content-children-row" style="height:5px;"></div>
                        </g:if>
                    </div>
                    <div style="display:inline-block;width:430px;vertical-align:top;">
                        <div style="display:inline-block;width:420px;"><div style="border:solid gray;"><div id="mapid"></div></div><div id="mapcaption" style="margin:10px;font-size:small;"></div></div>
                        <script type="text/javascript">

                            var boundaryType = '${neighbourhoodBoundary.type}';
                            var boundary = [
                                <g:each in="${neighbourhoodBoundary.coordinates}" var="coord" status="i">
                                    [${coord.getY()},${coord.getX()}],
                                </g:each>
                            ];
                            if (boundaryType != 'nada') {
                                var map = L.map('mapid');

                                var boundaryPoly;
                                var invertedPoly;

                                boundaryPoly = L.polygon(boundary);

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



                                map.fitBounds(boundaryPoly.getBounds());

                                L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
                                    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                                    maxZoom: 19,
                                    id: 'mapbox/streets-v11',
                                    accessToken: 'pk.eyJ1IjoidGltMTIzIiwiYSI6ImNrMmp2YjVoOTFpbWszbnFnems5ZjM2bW8ifQ.oNovhkW55h19gppWuNagQw'
                                }).addTo(map);

                                var bounds = L.latLngBounds();
                                <g:each in="${locations}" var="location">
                                var aLatLng = L.latLng(${location.key.latLon().latitude},${location.key.latLon().longitude});
                                L.circleMarker(aLatLng, {radius:4}).addTo(map);
                                bounds.extend(aLatLng);
                                </g:each>

                                <g:if test="${locations.size()>0}">
                                map.fitBounds(bounds, {padding: [25, 25]});
                                </g:if>

                            } else {
                                document.getElementById('mapid').style = "position:relative;background-color:darkgrey;";
                                document.getElementById('mapid').innerHTML = '<p style="text-align:center;margin:0;line-height:2.0;position:absolute;top:50%;left:50%;margin-right:-50%;transform: translate(-50%, -50%);color:white;">Mapping features are not available.<br>Neighbourhood boundary has not been specified.</p>';
                            }

                        </script>
                    </div>
                </div>


                <div class='contactInfo' style="display:none;">
                    <g:if test="${people.size() > 0}">
                    <div style="margin-top:-15px;margin-bottom:-15px;">
                        <h4 class="peopleQueryDescription"></h4>
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
                    </g:if>

                    <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4><span class="answersQueryDescription"></span> <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would assist):</span></h4>
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
                    </g:if>
                </div>



            </div>
            <div id="transparent-overlay"></div>
            <div id="emaildiv" class="modal"></div>
        <g:each in="${locations}" var="location">
            ${location.key.latLon()} ==> ${location.value}<br/>
        </g:each>
    </body>
</html>
