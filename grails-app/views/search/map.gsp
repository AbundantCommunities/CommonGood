<!DOCTYPE html>

<head>
    <meta name="layout" content="basic">
    <title>CommonGood Map of Search Results</title>

    <style>
      /* Always set the map height explicitly to define the size of the div element that contains the map. */
        #mapOfSearchResults {
          height: 600px;
        }
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
</head>

<body>
    <div id="blockResults"></div>
    <div id="mapOfSearchResults"></div>

    <script>
    function initMap() {
        var posn = {lat: 53.52496, lng: -113.46569};
        var gMap = new google.maps.Map(document.getElementById('mapOfSearchResults'), {
            zoom: 15,
            center: posn
        } );

        var marker;
        <g:each in="${answersByBlock}" var="block">
            posn = {lat: ${block.key.latitude}, lng: ${block.key.longitude}};
            marker = new google.maps.Marker( {
                                position: posn,
                                map: gMap,
                                title: 'SHOW THIS'
            } );
            {
                function blockPeople( ) {
                    return function( ) {
                        var peeps = '';
                        <g:each in="${block.value}" var="peep">
                            peeps = peeps + '${peep.firstnames} ${peep.lastname} answered ${peep.text}<br/>';
                        </g:each>
                        document.getElementById("blockResults").innerHTML = 'Block ' + ${block.key.id} + '<br/>' + peeps;
                    };
                }
                marker.addListener('click', blockPeople( ) );
            }
        </g:each>
    }
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCny53JB24X8b7DXQ4N-ucF2JBiA1t5rmI&callback=initMap">
    </script>
</body>

