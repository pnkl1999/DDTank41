using System;

namespace SqlDataProvider.Data
{
    public class MarryRoomInfo
    {
        public int AvailTime { get; set; }

        public DateTime BeginTime { get; set; }

        public DateTime BreakTime { get; set; }

        public int BrideID { get; set; }

        public string BrideName { get; set; }

        public int GroomID { get; set; }

        public string GroomName { get; set; }

        public bool GuestInvite { get; set; }

        public int ID { get; set; }

        public bool IsGunsaluteUsed { get; set; }

        public bool IsHymeneal { get; set; }

        public int MapIndex { get; set; }

        public int MaxCount { get; set; }

        public string Name { get; set; }

        public int PlayerID { get; set; }

        public string PlayerName { get; set; }

        public string Pwd { get; set; }

        public string RoomIntroduction { get; set; }

        public int ServerID { get; set; }
    }
}
