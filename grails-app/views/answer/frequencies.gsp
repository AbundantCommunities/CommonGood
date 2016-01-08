<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton"/>
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
        <style type="text/css">

            .bar-graph {
                display: inline-block;
                background-color: #6F6048;
            }

        </style>
    </head>
    <body>
        <div id="pagecontainer" style="width:970px;">
            <div style="margin-left:15px;padding-top:5px;"><h2>Answer Ranking for Question id ${questionId}</h2></div>
            <div id="content-children" style="width:930px;padding-bottom:10px;">
                <div id="content-children-heading">
                    <div class="cell450">Answer</div>
                    <div class="cell150"># Occurences</div>
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
            <br/>
        </div>
    </body>
</html>