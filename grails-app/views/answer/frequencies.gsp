<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report"/>
        <title>Abundant Communities - Edmonton</title>
        <style type="text/css">
            .bar-graph {
                display: inline-block;
                background-color: #6F6048;
            }
        </style>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">
                <div style="margin-top:-10px;"><h3>Answer Ranking for Question ${question.code}: ${question.text}</h2></div>
                <div id="content-children-heading">
                    <div class="cell450">Answer</div>
                    <div class="cell150"># Occurrences</div>
                </div>
                <g:each in="${frequencies}" var="answer">
                    <div class="content-children-row">
                        <div class="cell450" style="height:18px;overflow:auto;">${answer[0]}</div>
                        <div class="cell150">${answer[1]}</div>
                        <script type="text/javascript">
                            document.write('<div class="bar-graph" style="width:');
                            var graphWidth = (${answer[1]} / ${frequencies[0][1]}) * 300;
                            document.write(graphWidth);
                            document.write('px">&nbsp;</div>');
                        </script>
                    </div>
                </g:each>
            </div>
    </body>
</html>