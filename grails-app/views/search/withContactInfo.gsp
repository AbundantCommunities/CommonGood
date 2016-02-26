<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="margin-top:-10px;">
                    <h3>Searched for "${q}"</h3>
                </div>

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4>"${q}" not found.</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>${people.size()} Family member(s) found:</h4></div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link>
                            ${person[3]} ${person[4]} ${person[5]} 
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>${answers.size()} Answer(s) found: <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would lead, <span style="font-style:italic;">italic</span> = would organize)</span></h4></div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:if test="${answer[1]||answer[2]}">
                                <div class="cell550"><span class="<g:if test='${answer[1]}'>cg-bold </g:if><g:if test='${answer[2]}'>cg-italic</g:if>">${answer[0]}</span> <span style="font-size:x-small;">(${answer[6]})</span></div>
                            </g:if>
                            <g:else>
                                <div class="cell550">${answer[0]} <span style="font-size:x-small;">(${answer[6]})</span></div>
                            </g:else>                            
                            <g:link controller="navigate" action="familymember" id="${answer[3]}"><div class="cell300">${answer[4]} ${answer[5]}</div></g:link>
                            ${answer[7]} ${answer[8]} ${answer[9]} 
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>
