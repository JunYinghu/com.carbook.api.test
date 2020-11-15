import java.util.logging.Logger;

public class UnitTimeCalculator {
    private static int locationX;
    private static int locationY;


    public static long getUnitTime(String fromLocation, String toLocation) {
        Logger logger = Logger.getLogger("getTotalTime");
        logger.info("fromLocation:" + fromLocation + "toLocation:" + toLocation );

        getLocation(fromLocation);
        long fromLocationX = locationX;
        long fromLocationY = locationY;

        getLocation(toLocation);
        long toLocationX = locationX;
        long toLocationY = locationY;

        long total_unitTime_X = toLocationX - fromLocationX;
        long total_unitTime_y = toLocationY - fromLocationY;
        return Math.abs(total_unitTime_X) + Math.abs(total_unitTime_y);

    }

    public static void getLocation(String location) {
        int index = location.indexOf("=");
        locationX = Integer.parseInt(location.substring(index + 1, location.indexOf(",")));
        index = location.indexOf("=", index + 1);
        locationY = Integer.parseInt(location.substring(index + 1, location.indexOf("}")));

    }

}



