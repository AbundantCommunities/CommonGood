<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Common Good - Advanced Search</title>
        <script type="text/javascript">

            function criteriaStatus() {
                var searchText = document.getElementById('qInput').value;
                var fromAgeValue = document.getElementById('fromAgeInput').value;
                var toAgeValue = document.getElementById('toAgeInput').value;

                var searchTextPresent = searchText.length>0;
                var fromAgePresent = fromAgeValue.length>0;
                var fromAgeValid = isValidAge(fromAgeValue);
                var toAgePresent = toAgeValue.length>0;
                var toAgeValid = isValidAge(toAgeValue);

                if (!searchTextPresent && !fromAgePresent && !toAgePresent) {
                    return "Please enter something to search for.";
                } else {
                    if (fromAgePresent && !fromAgeValid) {
                        return "Please enter a valid 'from age'.";
                    }
                    if (toAgePresent && !toAgeValid) {
                        return "Please enter a valid 'to age'.";
                    }
                    if (fromAgePresent && toAgePresent && parseInt(toAgeValue) < parseInt(fromAgeValue)) {
                        return "The 'to' age must be the same or greater than the 'from' age.";
                    }
                }

                return "";

            }

            function doAdvancedSearch() {

                var currentCriteriaStatus = criteriaStatus();

                if (currentCriteriaStatus.length > 0) {
                    alert(currentCriteriaStatus);
                } else {
                    document.getElementById("advanced-form").submit();
                }
            }

            function isValidAge(someAge) {
                minAge = 0;
                maxAge = 130;

                if (someAge.length > 0) {
                    var pattern = /^([1-9]\d*|0)$/;

                    if (pattern.test(someAge)) {
                        if(someAge >= minAge && someAge <= maxAge) {
                           //Got a number in range - do something with it
                           return true;
                        } else {
                           //It's a number but out of range
                           return false;
                        }
                    } else {
                       //Non numeric some where in input
                       return false;
                    }
                } else {
                    return true;
                }
            }

            function constructAgeRangeDescription(fromAge,toAge) {
                if (fromAge.length == 0 && toAge.length == 0) {
                    return "";
                } else {
                    if (fromAge.length > 0 && toAge.length > 0) {
                        if (fromAge == toAge) {
                            return ' '+fromAge+' years old';
                        } else {
                            return ' aged '+fromAge+' to '+toAge;
                        }
                    } else if (fromAge.length > 0) {
                        return ' age '+fromAge+' or older';
                    } else {
                        return ' age '+toAge+' or younger';
                    }
                }
            }


            function updateSearchStatus() {
                var searchText = document.getElementById('qInput').value;
                var fromAgeValue = document.getElementById('fromAgeInput').value;
                var toAgeValue = document.getElementById('toAgeInput').value;

                var searchTextPresent = searchText.length>0;
                var fromAgePresent = fromAgeValue.length>0;
                var fromAgeValid = isValidAge(fromAgeValue);
                var toAgePresent = toAgeValue.length>0;
                var toAgeValid = isValidAge(toAgeValue);

                if (fromAgeValid) {
                    document.getElementById('fromValidImg').setAttribute("style","display:none;");
                } else {
                    document.getElementById('fromValidImg').setAttribute("style","display:default;");
                }
                if (toAgeValid) {
                    document.getElementById('toValidImg').setAttribute("style","display:none;");
                } else {
                    document.getElementById('toValidImg').setAttribute("style","display:default;");
                }

                if (fromAgeValid && toAgeValid) {
                    // valid input values, check if toAge is >= fromAge
                    if (fromAgePresent && toAgePresent && parseInt(toAgeValue) < parseInt(fromAgeValue)) {
                        document.getElementById('searchDescription').innerHTML = "The 'to' age must be the same or greater than the 'from' age.";
                    } else {
                        if (searchTextPresent || fromAgePresent || toAgePresent) {
                            var newSearchDescription;
                            if (searchTextPresent) {
                                newSearchDescription = 'Search answers and people';
                                if (fromAgePresent || toAgePresent) {
                                    newSearchDescription = newSearchDescription+constructAgeRangeDescription(fromAgeValue,toAgeValue);
                                }
                                newSearchDescription = newSearchDescription+' for "'+searchText+'"'
                            } else {
                                newSearchDescription = 'Search for people'+constructAgeRangeDescription(fromAgeValue,toAgeValue);
                            }
                            document.getElementById('searchDescription').innerHTML = newSearchDescription;
                        } else {
                            document.getElementById('searchDescription').innerHTML = "";
                        }
                    }


                } else if (!fromAgeValid) {
                    document.getElementById('searchDescription').innerHTML = "Please enter a valid 'from age'.";
                } else {
                    document.getElementById('searchDescription').innerHTML = "Please enter a valid 'to age'.";
                }
            }

            function checkAdvancedEnter(e) {
                var characterCode;

                if(e && e.which) { //if which property of event object is supported (NN4)
                    e = e;
                    characterCode = e.which; //character code is contained in NN4's which property
                }
                else{
                    e = event;
                    characterCode = e.keyCode; //character code is contained in IE's keyCode property
                }

                if(characterCode == 13) { //if generated character code is equal to ascii 13 (if enter key)
                    doAdvancedSearch(); //submit the form
                } else {
                    updateSearchStatus();
                }
            }

            window.onload = function onWindowLoad() {
                document.getElementById("qInput").focus();
                document.getElementById("qInput").select();
            }

        </script>

        <style type="text/css">
            .criteria-container {
                width: 100%;
                height:30px;
            }
            .criteria-label {
                width: 30%;
                display: inline-block;
                text-align: right;
            }
            .criteria-value {
                width: 45%;
                display: inline-block;
                text-align: left;
            }

        </style>

    </head>
    <body>
            <div class="content-section content-container content-centered">
                <div class="content-section-embedded" style="width:360px">
                    <div style="margin-top:-15px;"><h3>Advanced Search</h3></div>
                    <div style="font-size:smaller;margin-top:-10px;margin-bottom:10px;">Enter one or more values</div>
                    <form id="advanced-form" action="index" method="GET">
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>Search text</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="qInput" type="text" name="q" value="" onKeyUp="checkAdvancedEnter(event);" size="18"/></div>
                            </div>
                        </div>
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>From age</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="fromAgeInput" type="text" name="fromAge" value="" onKeyUp="checkAdvancedEnter(event);" size="10"/><span id="fromValidImg" style="display:none;">&nbsp;<asset:image style="vertical-align:middle;" src="invalid.png" width="16px" height="16px" /></span></div>
                            </div>
                        </div>
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>To age</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="toAgeInput" type="text" name="toAge" value="" onKeyUp="checkAdvancedEnter(event);" size="10"/><span id="toValidImg" style="display:none;">&nbsp;<asset:image style="vertical-align:middle;" src="invalid.png" width="16px" height="16px" /></span></div>
                            </div>
                        </div>
                        <input type="hidden" name="contactInfo" value="no"/>
                    </form>
                    <div id="searchDescription" style="font-size:smaller;margin-bottom:15px;margin-top:15px;min-height:30px;"></div>
                    <div class="button bold" onclick="doAdvancedSearch();">Search</div>
                </div>
            </div>
    </body>
</html>