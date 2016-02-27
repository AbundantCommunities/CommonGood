<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>

        <script type="text/javascript">
            function showSearchResults() {
                document.getElementById('show-results-form').submit();
            }

            function emailList() {
                alert('not yet implemented');
                var body = 'mybody is there \nk second line\nthird line';
                var email = 'mailto:?body='+encodeURIComponent(body);
                //document.location.href = email;
            }
        </script>

    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="width:910px;">
                    <div class="content-heading" style="display:inline-block;">Searched for "${q}"</div>
                    <g:if test="${people.size()>0 || answers.size()>0}">
                        <div style="display:inline-block;float:right;"><span style="font-weight:bold;">Show:</span>  <a href="#" onclick="showSearchResults();">Search Results</a> | Contact Info</div>
                    </g:if>
                    <form id="show-results-form" action="<g:createLink controller='search' />" method="get">
                        <input id="show-results-criteria" type="hidden" name="q" value="${q}" />
                    </form>
                </div>

                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div style="width:910px;">
                        <div style="display:inline-block;float:right;"><a href="#" onclick="emailList();">Email Contact List</a></div>
                    </div>
                </g:if>

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4>"${q}" not found.</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>Found in ${people.size()} family member<g:if test="${people.size()>1}">s</g:if>:</h4></div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <div class="cell190"><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></div>
                            <div class="cell120">${person[3]}</div>
                            <div class="cell300"><a href="mailto:${person[4]}">${person[4]}</a></div>
                            <div class="cell250">${person[5]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4>Found in ${answers.size()} answer<g:if test="${answers.size()>1}">s</g:if>: <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would lead, <span style="font-style:italic;">italic</span> = would organize)</span></h4>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${answer[3]}"><div class="cell190 <g:if test='${answer[1]}'>cg-bold </g:if><g:if test='${answer[2]}'>cg-italic</g:if>">${answer[4]} ${answer[5]}</div></g:link>
                            <div class="cell120">${answer[7]}</div>
                            <div class="cell300"><a href="mailto:${answer[8]}">${answer[8]}</a></div>
                            <div class="cell250">${answer[9]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>
