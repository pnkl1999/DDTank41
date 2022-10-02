using Game.Server.LittleGame.Objects;

namespace Game.Server.LittleGame.Data
{
    public class PlayerLittleGameInfo
    {
        public TriggeredQueue<string, GamePlayer> Actions { get; set; }

        public int ID { get; set; }

        public int X { get; set; }

        public int Y { get; set; }

        public bool IsBack { get; set; }

        public string Direction { get; set; }

        public Bogu Bogu { get; set; }
    }
}
