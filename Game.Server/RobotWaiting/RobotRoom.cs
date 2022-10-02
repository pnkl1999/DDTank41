using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.RobotWaiting
{
    public class RobotRoom
    {
        public int PlayerCount { get; set; }

        public int MaxPlayerCount { get; set; }

        public string RoomName { get; set; } = "Robot Room Name";

        public int RoomType { get; set; }
    }
}
