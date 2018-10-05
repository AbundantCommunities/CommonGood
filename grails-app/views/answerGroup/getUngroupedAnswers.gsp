<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ungrouped Answers</title>


        <script type="text/javascript">

            var checkboxInputDivs = [];
            var selectDivs = [];
            var answers = [];


            function groupAnswers() {
                document.getElementById('group-form').submit();
            }



            function selectClicked(whichIndex) {
                var theAnswer = answers[whichIndex];
                var startIndex = whichIndex;
                var endIndex = whichIndex;
                while (endIndex+1 < answers.length && answers[endIndex+1]==theAnswer) {
                    endIndex++;
                }

                for (var i=startIndex; i<=endIndex; i++) {
                    checkboxInputDivs[i].checked=true;
                }
            }


            window.onload = function onWindowLoad() {

                var lastAnswer = "";

                for (i=0;i<checkboxInputDivs.length;i++) {

                    if (answers[i] != lastAnswer) {
                        // Now a different answer. Check if next answer is the same.
                        if (i+1 < checkboxInputDivs.length) {
                            if (answers[i] == answers[i+1]) {
                                // next answer is the same, so inject 'select same' link
                                document.getElementById('sd-'+i).innerHTML = '<a href="javascript:void(0)" onclick="selectClicked('+i+');">select<br/>same</a>';
                            }
                        }
                    }

                    lastAnswer = answers[i];
                }
            }


        </script>

        <style type="text/css">

            #group-button {
                left:50px;
                height: 22px;
                width: 80px;
                font-weight: bold;
                color: #B48B6A;
                margin-top:10px;
                padding-top: 4px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                cursor: pointer;
            }


            #done-button {
                left:20px;
                height: 22px;
                width: 80px;
                color: #B48B6A;
                padding-top: 4px;
                margin-left:5px;
                margin-top:10px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }

            div.sticky {
                position: -webkit-sticky;
                position: sticky;
                margin-top:-30px;
                top: 0;
                margin-bottom:10px;
            }


        </style>

    </head>
    <body>
            <div class="content-section">
                <div style="margin-top:-10px;"><h3>Ungrouped Answers</h3></div>

                <div>To assist in identifying related answers, answers with more than one term may appear more than once in the list below.</div>
                <div>&nbsp;</div>
                <div>Select answers you would like to group then click the Group button.</div>

                <div class="sticky">
                    <div style="display:inline-block;width:730px;"></div>
                    <div id="group-button" style="display:inline-block;" onclick="groupAnswers();">Group</div>
                    <g:link><div id="done-button" style="display:inline-block;">Done</div></g:link>
                </div>

                <div class="content-row bold">
                    <div class="cell20"></div>
                    <div class="cell40"></div>
                    <div class="cell450">Answer</div>
                    <div class="cell190">Question</div>
                    <div class="cell170">Person</div>
                </div>

                <form id="group-form" action="<g:createLink action='getGroupsForAnswers' />" method="POST">

                <script type="text/javascript">
                    var divBgColorIsGray = true;
                    var currentAnswer = "";
                </script>

                <g:each in="${result}" var="permutation" status="i">
                    <script type="text/javascript">
                        if (currentAnswer != '${permutation.permutedText}') {
                            divBgColorIsGray = !divBgColorIsGray;
                        }
                        currentAnswer = '${permutation.permutedText}';
                        if (divBgColorIsGray) {
                            document.write('<div class="content-children-row" style="background-color:#ebf2f2">');
                        } else {
                            document.write('<div class="content-children-row">');
                        }
                    </script>

                        <div class="cell20"><input id="cb-${i}" type="checkbox" name="cga-${permutation.answerId}"/></div>
                        <div id="sd-${i}" class="cell40" style="font-size:10px;"></div>
                        <div id="ad-${i}" class="cell450">${permutation.permutedText}</div>
                        <div class="cell190">${permutation.shortQuestion}</div>
                        <div class="cell170">${permutation.personName}</div>
                        <script type="text/javascript">
                            checkboxInputDivs[${i}]=document.getElementById('cb-${i}');
                            selectDivs[${i}]=document.getElementById('sd-${i}');
                            answers[${i}]="${permutation.permutedText}";
                        </script>
                    </div>
                </g:each>
                </form>
    </body>
</html>
