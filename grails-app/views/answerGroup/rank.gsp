<!DOCTYPE html>

<html>
    
    <head>
        <meta name="layout" content="basic">
        <title>Answer Group Ranking</title>
    </head>

    <body>

        <div class="content-section">
            <div><g:link action="index">Back</g:link></div>
            <div style="margin-top:-10px;"><h3>Found ${groups.size()} groups (including any ungrouped answers)</h3></div>
            <div class="content-row bold">
                <div class="cell450">Answer</div>
                <div class="cell150"># Occurrences</div>
            </div>
            <g:each in="${groups}" var="group">
                <div class="content-children-row">
                    <div class="cell450" style="height:18px;overflow:auto;">${group.name}</div>
                    <div class="cell150">${group.count}</div>
                </div>
            </g:each>
        </div>

    </body>

</html>
