import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TransportDataService {
  final String _apiKey = dotenv.env["API_Transport_Key"] ?? '';

  String prepareQuery((double, double) startLocation, (double, double, String) arrivalLocation) {
    var utcTime = DateTime.now().toUtc().toString().replaceAll(RegExp(r' '), 'T');
    var localTime = DateTime.now().toString().replaceAll(RegExp(r' '), 'T');

    var template = '''
    <?xml version="1.0" encoding="utf-8"?>
    <OJP xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.siri.org.uk/siri" version="1.0" xmlns:ojp="http://www.vdv.de/ojp" xsi:schemaLocation="http://www.siri.org.uk/siri ../ojp-xsd-v1.0/OJP.xsd">
        <OJPRequest>
            <ServiceRequest>
                <RequestTimestamp>TTT</RequestTimestamp>
                <RequestorRef>API-Explorer</RequestorRef>
                <ojp:OJPTripRequest>
                    <RequestTimestamp>TTT</RequestTimestamp>
                    <ojp:Origin>
                        <ojp:PlaceRef>
                            <ojp:GeoPosition>
                                <Longitude>LONS</Longitude>
                                <Latitude>LATS</Latitude>
                            </ojp:GeoPosition>
                            <ojp:LocationName>
                                <ojp:Text>STARTNAME</ojp:Text>
                            </ojp:LocationName>
                        </ojp:PlaceRef>
                        <ojp:DepArrTime>TTTT</ojp:DepArrTime>
                    </ojp:Origin>
                    <ojp:Destination>
                        <ojp:PlaceRef>
                            <ojp:GeoPosition>
                                <Longitude>LONA</Longitude>
                                <Latitude>LATA</Latitude>
                            </ojp:GeoPosition>
                            <ojp:LocationName>
                                <ojp:Text>DESTNAME</ojp:Text>
                            </ojp:LocationName>
                        </ojp:PlaceRef>
                    </ojp:Destination>
                    <ojp:Params>
                        <ojp:IncludeTrackSections></ojp:IncludeTrackSections>
                        <ojp:IncludeTurnDescription></ojp:IncludeTurnDescription>
                        <ojp:IncludeIntermediateStops></ojp:IncludeIntermediateStops>
                    </ojp:Params>
                </ojp:OJPTripRequest>
            </ServiceRequest>
        </OJPRequest>
    </OJP>
    ''';

    return template
        .replaceAll('TTTT', localTime)
        .replaceAll('LONS', startLocation.$1.toString())
        .replaceAll('LATS', startLocation.$2.toString())
        .replaceAll('LONA', arrivalLocation.$1.toString())
        .replaceAll('LATA', arrivalLocation.$2.toString())
        .replaceAll('STARTNAME', 'start')
        .replaceAll('DESTNAME', arrivalLocation.$3.toString())
        .replaceAll('TTT', utcTime);
  }

  Future<String> query(String doc) async {
    final response = await http.post(
      Uri.parse('https://api.opentransportdata.swiss/ojp2020'),
      headers: {
        'Content-Type': 'application/xml; charset=UTF-8',
        "Authorization": _apiKey,
      },
      body: doc,
    );
    return response.body;
  }

  Future<List<List<String>>> parsedQuery(String doc) async {
    final response = await http.post(
      Uri.parse('https://api.opentransportdata.swiss/ojp2020'),
      headers: {
        'Content-Type': 'application/xml; charset=UTF-8',
        "Authorization": _apiKey,
      },
      body: doc,
    );

    var resp = XmlDocument.parse(response.body.replaceAll(RegExp(r'PT'), ""));
    var trips = resp.findAllElements("ojp:Trip");
    var tripsText = <List<String>>[];

    for (var trip in trips) {
      if (DateTime.parse(trip.findElements("ojp:StartTime").first.innerText).millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
        var tripText = <String>[];
        tripText.add("Trip duration: ${trip.findElements("ojp:Duration").first.innerText.toLowerCase()}");
        var legs = trip.findAllElements("ojp:TripLeg");

        for (var leg in legs) {
          if (leg.getElement("ojp:ContinuousLeg") != null) {
            //tripText.add("Leg ${leg.findElements("ojp:LegId").first.innerText} has a duration of ${leg.findAllElements("ojp:Duration").first.innerText}");
          } 
          else if (leg.getElement("ojp:TimedLeg") != null) {
            var startStation = leg.findAllElements("ojp:LegBoard").first.findAllElements("ojp:StopPointName").first.findElements("ojp:Text").first.innerText;
            var stopStation = leg.findAllElements("ojp:LegAlight").first.findAllElements("ojp:StopPointName").first.findElements("ojp:Text").first.innerText;
            var startQuay = leg.findAllElements("ojp:LegBoard").first.findAllElements("ojp:PlannedQuay").isNotEmpty
                ? leg.findAllElements("ojp:LegBoard").first.findAllElements("ojp:PlannedQuay").first.findElements("ojp:Text").first.innerText
                : "NA";
            var endQuay = leg.findAllElements("ojp:LegAlight").first.findAllElements("ojp:PlannedQuay").isNotEmpty
                ? leg.findAllElements("ojp:LegAlight").first.findAllElements("ojp:PlannedQuay").first.findElements("ojp:Text").first.innerText
                : "NA";
            var startTime = leg.findAllElements("ojp:LegBoard").first.findAllElements("ojp:ServiceDeparture").first.findElements("ojp:TimetabledTime").first.innerText;
            var endTime = leg.findAllElements("ojp:LegAlight").first.findAllElements("ojp:ServiceArrival").first.findElements("ojp:TimetabledTime").first.innerText;

            final startT = DateTime.parse(startTime).toLocal();
            final (startH, startM) = (startT.hour.toString().padLeft(2, '0'), startT.minute.toString().padLeft(2, '0'));
            final endT = DateTime.parse(endTime).toLocal();
            final (endH, endM) = (endT.hour.toString().padLeft(2, '0'), endT.minute.toString().padLeft(2, '0'));
            //tripText.add("Leg ${leg.findElements("ojp:LegId").first.innerText} ${startStation} (Quay ${startQuay}) ${startH}:${startM} ↦ ${stopStation} (Quay ${endQuay}) ${endH}:${endM}");
            tripText.add("● ${startStation} (Quay ${startQuay}) ${startH}:${startM} ⇨ ${stopStation} (Quay ${endQuay}) ${endH}:${endM}");
          } 
          else {
            var transportMethod = leg.findAllElements("ojp:TransferMode").first.innerText;
            var length = leg.findAllElements("ojp:WalkDuration").first.innerText;
            var traj = leg.findAllElements("ojp:Text");
            //tripText.add("Leg ${leg.findElements("ojp:LegId").first.innerText} will take you from ${traj.elementAt(0).innerText} to ${traj.elementAt(1).innerText} in ${length}");
          }
        }

        tripsText.add(tripText);
      }
    }

    return tripsText;
  }
}