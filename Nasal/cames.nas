# ***********************************************
# ****                                       ****
# **** Forcer les rpm à 0 si moteur arrêté   ****
# **** BARANGER Emmanuel                2012 ****
# ****                                       ****
# **** Animation des cames des vieux moteurs ****
# **** BARANGER Emmanuel                2012 ****
# **** Milles merci à XIII                   ****
# ****                                       ****
# ***********************************************
var sin = func(a) { math.sin(a * math.pi / 180.0) };

var running = props.globals.getNode("/engines/engine[0]/running",1);
var starter = props.globals.getNode("/controls/engines/engine[0]/starter",1);
var enginerpm = props.globals.getNode("/engines/engine[0]/rpm");

var update_rpm = func 
{
  if (!(running.getBoolValue()) and !(starter.getBoolValue())) {
    enginerpm.setValue(0);
  }
};

var update_cames = func
{
  secondes = getprop("/sim/time/utc/day-seconds");
  var rpm = enginerpm.getValue();
  var cames = sin( secondes * ( rpm / 60 ) );
  setprop("/engines/engine[0]/cames", cames);
};

var main_loop = func {
  update_rpm();
  update_cames();
  settimer(main_loop, 0);
};

setlistener("/sim/signals/fdm-initialized", func {
  main_loop();
});
