namespace Game.Base.Events
{
    public class GameServerEvent : RoadEvent
    {
        public static readonly GameServerEvent Started = new GameServerEvent("Server.Started");

        public static readonly GameServerEvent Stopped = new GameServerEvent("Server.Stopped");

        public static readonly GameServerEvent WorldSave = new GameServerEvent("Server.WorldSave");

        protected GameServerEvent(string name)
			: base(name)
        {
        }
    }
}
