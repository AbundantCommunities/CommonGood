<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>CommonGood Search</title>
        <asset:javascript src="copy2clipboard.js"/>
        <script type="text/javascript">
        
            function showContactInfo() {
                document.getElementById('show-contact-form').submit();
            }
            function showSearchResults() {
                document.getElementById('show-search-form').submit();
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



            <g:if test="${contactInfo=='yes'}">
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

                var pFNames = [];
                var pLName = [];
                var pPhone = [];
                var pEmail = [];
                var pAddress = [];

                var aQuestion = [];
                var aAnswer = [];
                var aFNames = []
                var aLName = [];
                var aPhone = []
                var aEmail = [];
                var aAddress = [];

                var aAssistQuestion = [];
                var aAssistAnswer = [];
                var aAssistFNames = [];
                var aAssistLName = [];
                var aAssistPhone = [];
                var aAssistEmail = [];
                var aAssistAddress = [];

                <g:if test="${people.size() > 0}">
                    <g:each in="${people}" var="person">
                        pFNames.push(decodeEntities('${person[1]}'));
                        pLName.push(decodeEntities('${person[2]}'));
                        pPhone.push(decodeEntities('${person[3]}'));
                        pEmail.push(decodeEntities('${person[4]}'));
                        pAddress.push(decodeEntities('${person[5]}'));
                    </g:each>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <g:each in="${answers}" var="answer">
                        <g:if test="${answer.assist}">
                            aAssistQuestion.push(decodeEntities('${answer.question}'));
                            aAssistAnswer.push(decodeEntities('${answer.text}'));
                            aAssistFNames.push(decodeEntities('${answer.firstNames}'));
                            aAssistLName.push(decodeEntities('${answer.lastName}'));
                            aAssistPhone.push(decodeEntities('${answer.phoneNumber}'));
                            aAssistEmail.push(decodeEntities('${answer.emailAddress}'));
                            aAssistAddress.push(decodeEntities('${answer.homeAddress}'));
                        </g:if>
                        <g:else>
                            aQuestion.push(decodeEntities('${answer.question}'));
                            aAnswer.push(decodeEntities('${answer.text}'));
                            aFNames.push(decodeEntities('${answer.firstNames}'));
                            aLName.push(decodeEntities('${answer.lastName}'));
                            aPhone.push(decodeEntities('${answer.phoneNumber}'));
                            aEmail.push(decodeEntities('${answer.emailAddress}'));
                            aAddress.push(decodeEntities('${answer.homeAddress}'));
                        </g:else>
                    </g:each>
                </g:if>

                var lineIsClean;
                var body = '\n\n\n\n-----------------------------------------------------------\nSearch results from CommonGood:\n\n';

                if (pLName.length>0) {
                    body = body+constructQueryDescription(peopleDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    body = body+'\n\n';
                    for (i=0; i<pLName.length;i++) {
                        body = body+constructLine(pFNames[i],pLName[i],pPhone[i],pEmail[i],pAddress[i]);
                    }
                    body = body+'\n';
                }

                if (${answers.size()}>0) {
                    if (pLName.length>0) {
                        body = body+'\n';
                    }
                    body = body+constructQueryDescription(answersDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                    body = body+':\n\n';
                }

                if (aLName.length>0) {
                    for (i=0;i<aLName.length;i++) {
                        body = body+'Answer: '+aAnswer[i]+' (Question: '+aQuestion[i]+')\n';
                        body = body+constructLine(aFNames[i],aLName[i],aPhone[i],aEmail[i],aAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aAssistLName.length>0) {
                    body = body+'Those who would assist:\n\n';
                    for (i=0;i<aAssistLName.length;i++) {
                        body = body+'Answer: '+aAssistAnswer[i]+' (Question: '+aAssistQuestion[i]+')\n';
                        body = body+constructLine(aAssistFNames[i],aAssistLName[i],aAssistPhone[i],aAssistEmail[i],aAssistAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aLName.length>0&&aAssistLName.length==0) {
                    body = body+'No one has offered to assist.\n';
                }

                // body = encodeURIComponent(body);
                // var email = 'mailto:?body='+body;
                // document.location.href = email;

                var numRows = 20;
                var title = 'Email Contact Information';
                var description = 'CommonGood cannot send email for you, but you can copy the message below to the clipboard, then paste it into a new message that you create the way you normally do.';
                var copyContentTitle = 'Contact information for search results'
                presentForCopy('emaildiv',body,numRows,title,description,copyContentTitle);

            }
            </g:if>

            window.onload = function onWindowLoad() {
                <g:if test="${people.size()==0 && answers.size()==0}">
                    document.getElementById("failedQueryDescription").innerHTML = constructQueryDescription(failedDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                </g:if>
                <g:if test="${people.size()>0}">
                    document.getElementById("peopleQueryDescription").innerHTML = constructQueryDescription(peopleDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
                </g:if>
                <g:if test="${answers.size()>0}">
                    document.getElementById("answersQueryDescription").innerHTML = constructQueryDescription(answersDescription,'${q}','${fromAge}','${toAge}',${people.size()},${answers.size()});
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

                <div style="width:910px;">
                    <div class="content-heading" style="display:inline-block;">&nbsp;</div>
                    <g:if test="${people.size()>0 || answers.size()>0}">
                        <g:if test="${contactInfo=='yes'}">
                            <div style="display:inline-block;float:right;"><span style="font-weight:bold;">Show:</span>  <a href="#" onclick="showSearchResults();">Search Results</a> | Contact Info</div>
                            <form id="show-search-form" action="<g:createLink controller='search' />" method="get">
                                <input id="show-contact-criteria" type="hidden" name="q" value="${q}" />
                                <input type="hidden" name="contactInfo" value="no"/>
                                <input type="hidden" name="fromAge" value="${fromAge}"/>
                                <input type="hidden" name="toAge" value="${toAge}"/>
                            </form>
                        </g:if>
                        <g:else>
                            <div style="display:inline-block;float:right;"><span style="font-weight:bold;">Show:</span>  Search Results | <a href="#" onclick="showContactInfo();">Contact Info</a></div>
                            <form id="show-contact-form" action="<g:createLink controller='search' />" method="get">
                                <input id="show-contact-criteria" type="hidden" name="q" value="${q}" />
                                <input type="hidden" name="contactInfo" value="yes"/>
                                <input type="hidden" name="fromAge" value="${fromAge}"/>
                                <input type="hidden" name="toAge" value="${toAge}"/>
                            </form>
                        </g:else>
                    </g:if>
                </div>

                <g:if test="${people.size()>0 || answers.size()>0}">
                    <g:if test="${contactInfo=='yes'}">
                        <div style="width:910px;">
                            <div style="display:inline-block;float:right;"><a href="#" onclick="emailList();">Email Contact List</a></div>
                        </div>
                    </g:if>
                </g:if>

                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div style="width:910px;">&nbsp;</div>
                </g:if>

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4 id="failedQueryDescription"></h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4 id="peopleQueryDescription"></h4>
                    </div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <g:if test="${contactInfo=='yes'}">
                                <div class="cell190"><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></div>
                                <div class="cell120">${person[3]}</div>
                                <div class="cell300"><a href="mailto:${person[4]}">${person[4]}</a></div>
                                <div class="cell250">${person[5]}</div>
                            </g:if>
                            <g:else>
                                <g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link>
                            </g:else>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4><span id="answersQueryDescription"></span> <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would assist):</span></h4>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:if test="${contactInfo=='yes'}">
                                <g:link controller="navigate" action="familymember" id="${answer.pid}"><div class="cell190 <g:if test='${answer.assist}'>bold</g:if>">${answer.firstNames} ${answer.lastName}</div></g:link>
                                <div class="cell120">${answer.phoneNumber}</div>
                                <div class="cell300"><a href="mailto:${answer.emailAddress}">${answer.emailAddress}</a></div>
                                <div class="cell250">${answer.homeAddress}</div>
                            </g:if>
                            <g:else>
                                <div class="cell550">
                                    <span class="<g:if test='${answer.assist}'>bold</g:if>">${answer.text}</span> 
                                    <span style="font-size:x-small;">(${answer.question})</span>
                                </div>
                                <g:link controller="navigate" action="familymember" id="${answer.pid}"><div class="cell300">${answer.firstNames} ${answer.lastName}</div></g:link>
                            </g:else>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

            </div>
            <div id="transparent-overlay"></div>
            <div id="emaildiv" class="modal"></div>
    </body>
</html>
