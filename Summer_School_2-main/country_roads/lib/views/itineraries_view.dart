import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/geoloc_provider.dart';
import 'package:task_manager/providers/transport_data_provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';
import 'package:task_manager/providers/weather_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ItinerariesView extends StatefulWidget {
  const ItinerariesView({super.key});
  @override
  _ItinerariesViewState createState() => _ItinerariesViewState();
}

class _ItinerariesViewState extends State<ItinerariesView> {
  bool tripLoaded = false;

  @override
  void initState() {
    tripLoaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    var weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final userProfile = userProfileProvider.userProfile;
    final tripsHandler = Provider.of<TransportDataProvider>(context);
    var texts = <Card>[];
    var id = 1;
    final geolocProvider = Provider.of<GeolocProvider>(context);

    late Position position;

    void textsFiller() {
      for (var trip in tripsHandler.trips) {
        var col=<Text>[];
        col.add(Text("Option #${id}",
            style: TextStyle(fontWeight: FontWeight.bold)));
        id++;
        for (var leg in trip) {
          col.add(Text(leg));
        }
        texts.add(Card(child: Padding(child: Column(children: col,mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,),padding: EdgeInsets.all(16),)));
        //texts.add(Text(""));
      }
    }

    weatherProvider.getWeather(userProfile.addressCity);

    // WTF is this
    if(!geolocProvider.isLoading) {
      if (!tripLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_){
          tripsHandler
              .getTrips(
                (geolocProvider.position!.longitude, geolocProvider.position!.latitude), 
                (userProfile.addressLongitude, userProfile.addressLatitude, userProfile.addressCity), 
              );
          tripLoaded = true;
        });
      } 
      else {
        textsFiller();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your itineraries'),
      ),
      body: 
      (geolocProvider.hasError) ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("An error occured while trying to get your location."),
          ],
        ),
      ) 
      :(tripsHandler.isLoading || geolocProvider.isLoading)
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  LoadingAnimationWidget.inkDrop(
                    color: Colors.black,
                    size: 50,
                  ),
                ],
              ),
            )
          : tripsHandler.trips.length == 0
              ? Center(child: Text("Sorry, we couldn't find any itineraries to your home..."))
              : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                                "Hello ${userProfile.fullName}! Here are your itineraries to ${userProfile.addressCity}:",
                                style: TextStyle(fontSize: 20)
                              ),
                              const SizedBox(height: 10),
                              weatherProvider.weatherCode.isEmpty
                                ? Text("Weather: Loading...")
                                : Row(
                                    children: [
                                      Text(
                                          "Expected weather in ${userProfile.addressCity}: ${weatherProvider.weatherType}"),
                                      SvgPicture.asset(
                                        weatherProvider.weatherIcon,
                                        width: 50,
                                        height: 50,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${weatherProvider.temperature} ',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 10),
                            ...texts
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                  )),
            ),
    );
  }
}
