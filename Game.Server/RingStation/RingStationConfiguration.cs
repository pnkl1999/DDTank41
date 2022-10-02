using System.Threading;

namespace Game.Server.RingStation
{
    public class RingStationConfiguration
    {
        public static int ServerID = 4;
        public static string ServerName = "AutoBot";
        private static int roomID = 3000;
        private static int PlayerID = 3000;

        public static int NextRoomId()
        {
            return Interlocked.Increment(ref roomID);
        }

        public static int NextPlayerID()
        {
            return Interlocked.Increment(ref PlayerID);
        }
    }
}